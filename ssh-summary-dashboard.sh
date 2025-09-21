#!/bin/bash
# SSH Summary Dashboard
# Author: Rabbi Rifat
# GitHub: https://github.com/TheRabbiRifat/SSH-Summary-Dashboard
# Works offline but fetches IP details if internet is available

RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; CYAN="\e[36m"; MAGENTA="\e[35m"; RESET="\e[0m"

# --- Basic server info ---
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

# Bandwidth
RX=$(awk '/eth|ens|enp/ {rx+=$2} END{print rx}' /proc/net/dev)
TX=$(awk '/eth|ens|enp/ {tx+=$10} END{print tx}' /proc/net/dev)
NET_USAGE="IN: $((RX/1024/1024)) MB, OUT: $((TX/1024/1024)) MB"

# --- IPs ---
# All server global/public IPv4/IPv6
ALL_IPV4=$(ip -4 addr show scope global | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | paste -sd ", " -)
ALL_IPV6=$(ip -6 addr show scope global | grep -oP '(?<=inet6\s)[0-9a-f:]+' | paste -sd ", " -)

# SSH client IP
SSH_CLIENT_IP=$(echo $SSH_CLIENT | awk '{print $1}')

# --- IP Geo/ASN info (for SSH client) ---
IP_COUNTRY="N/A"; IP_REGION="N/A"; IP_CITY="N/A"; IP_ASN="N/A"; IP_ISP="N/A"
if [ -n "$SSH_CLIENT_IP" ] && command -v curl >/dev/null 2>&1; then
    GEO_JSON=$(curl -s "http://ip-api.com/json/$SSH_CLIENT_IP")
    if [ "$GEO_JSON" != "" ]; then
        IP_COUNTRY=$(echo "$GEO_JSON" | grep -oP '"country":"\K[^"]+')
        IP_REGION=$(echo "$GEO_JSON" | grep -oP '"regionName":"\K[^"]+')
        IP_CITY=$(echo "$GEO_JSON" | grep -oP '"city":"\K[^"]+')
        IP_ASN=$(echo "$GEO_JSON" | grep -oP '"as":"\K[^"]+')
        IP_ISP=$(echo "$GEO_JSON" | grep -oP '"isp":"\K[^"]+')
    fi
fi

# --- HEADER ---
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
echo -e "${GREEN}Server IPv4(s):${RESET} $ALL_IPV4"
echo -e "${GREEN}Server IPv6(s):${RESET} $ALL_IPV6"
echo -e "${GREEN}Bandwidth  :${RESET} $NET_USAGE"
echo -e "${CYAN}------------------------------------------------------------${RESET}"

# --- Client login info ---
if [ -n "$SSH_CLIENT_IP" ]; then
  echo -e "${YELLOW}Client IP       :${RESET} $SSH_CLIENT_IP"
  echo -e "${YELLOW}Country         :${RESET} $IP_COUNTRY"
  echo -e "${YELLOW}Region          :${RESET} $IP_REGION"
  echo -e "${YELLOW}City            :${RESET} $IP_CITY"
  echo -e "${YELLOW}ASN             :${RESET} $IP_ASN"
  echo -e "${YELLOW}ISP             :${RESET} $IP_ISP"
fi

# --- System resources ---
echo -e "${CYAN}------------------------------------------------------------${RESET}"
echo -e "${GREEN}Memory Usage:${RESET}"
free -h | awk 'NR<=3{print $0}'

echo -e "${GREEN}Disk Usage:${RESET}"
df -hT | grep -E "Filesystem|/"

echo -e "${GREEN}Top 5 Processes:${RESET}"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6

echo -e "${CYAN}============================================================${RESET}"

# --- Log login ---
LOGFILE="/var/log/ssh-summary-dashboard.log"
mkdir -p $(dirname "$LOGFILE")
touch "$LOGFILE"
chmod 600 "$LOGFILE"
echo "[$NOW] User: $(whoami) from $SSH_CLIENT_IP (Country: $IP_COUNTRY, ASN: $IP_ASN, ISP: $IP_ISP) | Server IPv4: $ALL_IPV4 | Server IPv6: $ALL_IPV6" >> "$LOGFILE"

# --- Pause and clear ---
echo -e "${CYAN}This dashboard will disappear in 6 seconds...${RESET}"
sleep 6
tput reset
