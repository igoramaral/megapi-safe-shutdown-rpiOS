#!/bin/bash
set -e

REPO_RAW="https://raw.githubusercontent.com/igoramaral/megapi-safe-shutdown-rpiOS/master"

SCRIPT_NAME="safeshutdown.py"
SERVICE_NAME="megapi-safe-shutdown"

SCRIPT_DST="/usr/local/bin/${SCRIPT_NAME}"
SERVICE_DST="/etc/systemd/system/${SERVICE_NAME}.service"

OVERLAY_NAME="megapi_pw_io"
BOOT_CONFIG="/boot/config.txt"
OVERLAY_DIR="/boot/overlays"
OVERLAY_PATH="${OVERLAY_DIR}/${OVERLAY_NAME}.dtbo"

echo "== MegaPi Safe Shutdown installer =="
echo

# 1. root check
if [ "$EUID" -ne 0 ]; then
  echo "ERROR: Please run as root."
  echo "Use: wget -O - <url> | sudo bash"
  exit 1
fi

# already installed?
if [ -f "$SERVICE_DST" ]; then
  echo "MegaPi Safe Shutdown is already installed."
  echo
  systemctl --no-pager status "$SERVICE_NAME" || true
  exit 0
fi

echo "Installing MegaPi Power IO overlay..."

mkdir -p "$OVERLAY_DIR"

wget -O "$OVERLAY_PATH" "$REPO_RAW/${OVERLAY_NAME}.dtbo"

if grep -q "$OVERLAY_NAME" "$BOOT_CONFIG"; then
    sed -i "/${OVERLAY_NAME}/c dtoverlay=${OVERLAY_NAME}" "$BOOT_CONFIG"
    echo "dtoverlay fixed."
else
    echo "dtoverlay=${OVERLAY_NAME}" >> "$BOOT_CONFIG"
    echo "dtoverlay enabled."
fi

if grep -q "enable_uart" "$BOOT_CONFIG"; then
    sed -i '/enable_uart/c enable_uart=1' "$BOOT_CONFIG"
else
    echo "enable_uart=1" >> "$BOOT_CONFIG"
fi

echo "Installing MegaPiCase Safe Shutdown for Raspberry Pi OS..."

# 2. download python script
echo "Downloading safeshutdown script..."
curl -fsSL "${REPO_RAW}/${SCRIPT_NAME}" -o "$SCRIPT_DST"

chmod +x "$SCRIPT_DST"

# 3. create systemd service
echo "Creating systemd service..."
cat <<EOF > "$SERVICE_DST"
[Unit]
Description=MegaPi Case Safe Shutdown (Raspberry Pi OS)
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 $SCRIPT_DST
Restart=always
RestartSec=2
User=root

[Install]
WantedBy=multi-user.target
EOF

# 4. reload systemd
echo "Reloading systemd..."
systemctl daemon-reload

# 5. enable + start service
echo "Enabling service..."
systemctl enable "$SERVICE_NAME"

echo "Starting service..."
systemctl start "$SERVICE_NAME"

echo
echo "Installation completed successfully! System will reboot after 3 seconds"
sleep 3
reboot