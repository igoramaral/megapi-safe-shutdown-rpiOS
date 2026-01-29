#!/bin/bash

set -e

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

echo "Uninstall completed. System will reboot after 3 seconds."
sleep 3
sudo reboot