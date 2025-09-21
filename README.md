# SSH Summary Dashboard

A self-contained SSH login dashboard for Linux servers.  
Displays OS, hostname, kernel, RAM, uptime, IPv4/IPv6 addresses, disk usage, memory usage, top processes, and network bandwidth.  
Logs every SSH login to `/var/log/ssh-summary-dashboard.log`.

## Features

- Fully offline (no dependencies required)  
- Shows all IPv4 & IPv6 addresses of the server  
- Displays memory, disk, top processes, uptime, load average  
- Logs SSH logins to `/var/log/ssh-summary-dashboard.log`  

## Installation

### 1. Using Git Clone (traditional)
```
git clone https://github.com/TheRabbiRifat/SSH-Summary-Dashboard.git
cd SSH-Summary-Dashboard
sudo bash installer.sh
```

### 2. Using one-line `curl | bash` (recommended)
```
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/TheRabbiRifat/SSH-Summary-Dashboard/main/installer.sh || wget -qO- https://raw.githubusercontent.com/TheRabbiRifat/SSH-Summary-Dashboard/main/installer.sh)"

```
Then log out and SSH back in to see the dashboard.

## Log File

All SSH logins are saved in:

/var/log/ssh-summary-dashboard.log

## Notes

- Works on most Linux distributions (Ubuntu, Debian, CentOS, CloudLinux)  
- No external tools required  
- Can be customized by editing `/etc/profile.d/ssh-summary-dashboard.sh`
