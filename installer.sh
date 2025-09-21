#!/bin/bash
# SSH Summary Dashboard Installer
# Author: Rabbi Rifat
# GitHub: https://github.com/TheRabbiRifat/SSH-Summary-Dashboard

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo bash $0"
  exit 1
fi

echo "Installing SSH Summary Dashboard..."

# Copy dashboard script to profile.d
cp ssh-summary-dashboard.sh /etc/profile.d/ssh-summary-dashboard.sh
chmod +x /etc/profile.d/ssh-summary-dashboard.sh

# Create log file
touch /var/log/ssh-summary-dashboard.log
chmod 600 /var/log/ssh-summary-dashboard.log

echo "Installation complete!"
echo "Log out and SSH back in to see your dashboard."
echo "Logs will be stored in /var/log/ssh-summary-dashboard.log"
