#!/bin/bash

set -e

OVERLAY_NAME="megapi_pw_io"
BOOT_CONFIG="/boot/config.txt"
OVERLAY_PATH="/boot/overlays/${OVERLAY_NAME}.dtbo"
SERVICE_NAME="megapi-safe-shutdown"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

echo "Uninstalling MegaPi Safe Shutdown..."

# 1. Desativar o serviço
if systemctl list-unit-files | grep -q "${SERVICE_NAME}"; then
    echo "Stopping and disabling service..."
    systemctl stop "${SERVICE_NAME}" || true
    systemctl disable "${SERVICE_NAME}" || true
fi

# 2️. Remover o service file
if [ -f "$SERVICE_FILE" ]; then
    echo "Removing systemd service file..."
    rm "$SERVICE_FILE"
    systemctl daemon-reload
fi

# 3️. Remover dtoverlay do config.txt
if grep -q "$OVERLAY_NAME" "$BOOT_CONFIG"; then
    echo "Removing dtoverlay from config.txt..."
    sed -i "/dtoverlay=${OVERLAY_NAME}/d" "$BOOT_CONFIG"
fi

# 4️. Remover o dtbo
if [ -f "$OVERLAY_PATH" ]; then
    echo "Removing device tree overlay..."
    rm "$OVERLAY_PATH"
fi

echo "Uninstall completed. System will reboot after 3 seconds."
sleep 3
sudo reboot