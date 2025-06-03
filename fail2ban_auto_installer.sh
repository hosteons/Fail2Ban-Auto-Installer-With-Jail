#!/bin/bash
# Fail2Ban Auto-Installer Script
# Created by Hosteons.com - https://hosteons.com
# Customer Portal: https://my.hosteons.com
# Blog: https://blog.hosteons.com

set -e

echo "=== Fail2Ban Auto-Installer with Smart Jail Detection ==="

# Install fail2ban if not already installed
if ! command -v fail2ban-client &>/dev/null; then
    echo "Installing Fail2Ban..."
    if command -v dnf &>/dev/null; then
        dnf install -y fail2ban
    elif command -v yum &>/dev/null; then
        yum install -y epel-release && yum install -y fail2ban
    elif command -v apt &>/dev/null; then
        apt update && apt install -y fail2ban
    else
        echo "Unsupported package manager. Install Fail2Ban manually."
        exit 1
    fi
else
    echo "Fail2Ban is already installed."
fi

mkdir -p /etc/fail2ban/jail.d

# Remove legacy Apache jails if any
rm -f /etc/fail2ban/jail.d/apache-badbots.conf /etc/fail2ban/jail.d/apache-404.conf

# SSH Jail
echo "[sshd]
enabled = true
logpath = /var/log/secure
" > /etc/fail2ban/jail.d/sshd.conf

# Detect and add Apache jail if Apache exists
if command -v apache2ctl &>/dev/null || command -v httpd &>/dev/null; then
    echo "[apache-auth]
enabled = true
port = http,https
filter = apache-auth
logpath = /var/log/httpd/*access_log
maxretry = 3
" > /etc/fail2ban/jail.d/apache-auth.conf
else
    echo "Apache not detected. Skipping Apache jails."
    rm -f /etc/fail2ban/jail.d/apache-auth.conf
fi

# Detect and add Nginx jail if Nginx exists
if command -v nginx &>/dev/null; then
    echo "[nginx-http-auth]
enabled = true
filter = nginx-http-auth
port = http,https
logpath = /var/log/nginx/error.log
" > /etc/fail2ban/jail.d/nginx-http-auth.conf
else
    echo "Nginx not detected. Skipping Nginx jail."
    rm -f /etc/fail2ban/jail.d/nginx-http-auth.conf
fi

echo "Restarting Fail2Ban..."
systemctl restart fail2ban || true

echo -e "\nFail2Ban installation and jail setup complete."
echo "Active jails:"
fail2ban-client status || echo "Unable to fetch Fail2Ban status."
