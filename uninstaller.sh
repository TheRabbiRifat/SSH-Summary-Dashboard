#!/bin/bash
# SSH Summary Dashboard Uninstaller
# Author: Rabbi Rifat
# GitHub: https://github.com/TheRabbiRifat/SSH-Summary-Dashboard

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo bash $0"
    exit 1
fi

echo "Uninstalling SSH Summary Dashboard..."

# Remove the dashboard script
if [ -f "/etc/profile.d/ssh-summary-dashboard.sh" ]; then
    rm -f /etc/profile.d/ssh-summary-dashboard.sh
    echo "Removed /etc/profile.d/ssh-summary-dashboard.sh"
else
    echo "Dashboard script not found in /etc/profile.d/"
fi

# Remove the log file
if [ -f "/var/log/ssh-summary-dashboard.log" ]; then
    rm -f /var/log/ssh-summary-dashboard.log
    echo "Removed /var/log/ssh-summary-dashboard.log"
else
    echo "Log file not found at /var/log/ssh-summary-dashboard.log"
fi

echo "Uninstallation complete!"
echo "Log out and SSH back in to see default shell behavior restored."
