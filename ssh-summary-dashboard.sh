#!/bin/bash
# SSH Summary Dashboard
# Works offline, shows OS, RAM, Hostname, IPv4/IPv6, Disk, Memory, Load, Top processes
# Logs all SSH logins

RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; CYAN="\e[36m"; MAGENTA="\e[35m"; RESET="\e[0m"

IP=$(echo $SSH_CLIENT | awk '{print $1}')
HOSTNAME=$(hostname -f)
NOW=$(date)
UPTIME=$(uptime -p)
KERNEL=$(uname -r)
LOAD=$(cut -d ' ' -f1-3 /proc/loadavg)

# OS info
if [ -f /etc/os-release ]; then
  OS=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2- | tr -d '"')
else
  OS=$(uname -o)
fi

# RAM
TOTAL_RAM=$(free -h | awk '/^Mem:/ {print $2}')

# Network usage
RX=$(awk '/eth|ens|enp/ {rx+=$2} END{print rx}' /proc/net/dev)
TX=$(awk '/eth|ens|enp/ {tx+=$10} END{print tx}' /proc/net/dev)
NET_USAGE="IN: $((RX/1024/1024)) MB, OUT: $((TX/1024/1024)) MB"

# All IPs
ALL_IPS=$(ip -o addr show | awk '/inet / {print $4}' | paste -sd ", " -)
ALL_IP6S=$(ip -o addr show | awk '/inet6 / {print $4}' | paste -sd ", " -)

# Header
echo -e "${CYAN}============================================================${RESET}"
echo -e "${MAGENTA}   🚀 Welcome, ${GREEN}$(whoami)${MAGENTA}! You are logged into ${YELLOW}$HOSTNAME ${RESET}"
echo -e "${CYAN}============================================================${RESET}"
echo -e "${GREEN}Date       :${RESET} $NOW"
echo -e "${GREEN}OS         :${RESET} $OS"
echo -e "${GREEN}Hostname   :${RESET} $HOSTNAME"
echo -e "${GREEN}Kernel     :${RESET} $KERNEL"
echo -e "${GREEN}Uptime     :${RESET} $UPTIME"
echo -e "${GREEN}Load Avg   :${RESET} $LOAD"
echo -e "${GREEN}Total RAM  :${RESET} $TOTAL_RAM"
echo -e "${GREEN}IPv4       :${RESET} $ALL_IPS"
echo -e "${GREEN}IPv6       :${RESET} $ALL_IP6S"
echo -e "${GREEN}Bandwidth  :${RESET} $NET_USAGE"
echo -e "${CYAN}------------------------------------------------------------${RESET}"

# Login IP
if [ -n "$IP" ]; then
  echo -e "${YELLOW}Login From :${RESET} $IP"
fi

# System resources
echo -e "${CYAN}------------------------------------------------------------${RESET}"
echo -e "${GREEN}Memory Usage:${RESET}"
free -h | awk 'NR==1{print $0} NR==2{print $0} NR==3{print $0}'

echo -e "${GREEN}Disk Usage:${RESET}"
df -hT | grep -E "Filesystem|/"

echo -e "${GREEN}Top 5 Processes:${RESET}"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6

echo -e "${CYAN}============================================================${RESET}"

# Log login
LOGFILE="/var/log/ssh-summary-dashboard.log"
mkdir -p $(dirname "$LOGFILE")
touch "$LOGFILE"
chmod 600 "$LOGFILE"
echo "[$NOW] User: $(whoami) from $IP (IPv4: $ALL_IPS, IPv6: $ALL_IP6S)" >> "$LOGFILE"
