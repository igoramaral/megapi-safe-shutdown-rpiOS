# MegaPi Safe Shutdown for Raspberry Pi OS

## Overview

This repository provides a **safe shutdown and reset implementation** for the **RetroFlag MegaPi Case**, specifically designed for **Raspberry Pi OS** running on a **Raspberry Pi 3 Model B**.

The original RetroFlag safe shutdown scripts were designed for RetroPie and Recalbox and do not work correctly on Raspberry Pi OS.  
This project reimplements the same functionality using modern tools (Python + systemd), ensuring proper behavior on the official Raspberry Pi operating system.

## Original RetroFlag Project

This project is inspired by, and based on the behavior of, the original RetroFlag implementation:

🔗 https://github.com/RetroFlag/retroflag-picase

## Features

- Safe shutdown when the power switch is turned off
- Immediate power cut when safe shutdown is disabled (hardware behavior)
- Reset button support (reboot)
- Power LED blinking during shutdown
- Automatic startup on boot via systemd
- Designed specifically for **Raspberry Pi OS + Raspberry Pi 3B**

## Installation

Installation is fully automatic and requires only a single command.

Run the following command on your Raspberry Pi:

```bash
wget -O - https://raw.githubusercontent.com/igoramaral/megapi-safe-shutdown-rpiOS/master/install.sh | sudo bash