#!/bin/bash
# SSH Summary Dashboard Installer
# Author: Rabbi Rifat
# GitHub: https://github.com/TheRabbiRifat/SSH-Summary-Dashboard

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo bash $0"
    exit 1
fi

echo "Installing SSH Summary Dashboard..."

# Define GitHub raw URL
DASHBOARD_URL="https://raw.githubusercontent.com/TheRabbiRifat/SSH-Summary-Dashboard/main/ssh-summary-dashboard.sh"

# Check if curl or wget exists
if command -v curl >/dev/null 2>&1; then
    DOWNLOADER="curl -fsSL -o"
elif command -v wget >/dev/null 2>&1; then
    DOWNLOADER="wget -qO"
else
    echo "Neither curl nor wget found. Installing curl..."
    if [ -f /etc/debian_version ]; then
        apt update && apt install -y curl
    elif [ -f /etc/redhat-release ]; then
        yum install -y curl
    else
        echo "Cannot determine OS. Please install curl manually."
        exit 1
    fi
    DOWNLOADER="curl -fsSL -o"
fi

# Always download the latest dashboard script
echo "Downloading the latest ssh-summary-dashboard.sh from GitHub..."
$DOWNLOADER ssh-summary-dashboard.sh "$DASHBOARD_URL"

# Copy dashboard script to profile.d
cp ssh-summary-dashboard.sh /etc/profile.d/ssh-summary-dashboard.sh
chmod +x /etc/profile.d/ssh-summary-dashboard.sh

# Create log file
touch /var/log/ssh-summary-dashboard.log
chmod 600 /var/log/ssh-summary-dashboard.log

echo "Installation complete!"
echo "Log out and SSH back in to see your dashboard."
echo "Logs will be stored in /var/log/ssh-summary-dashboard.log"
