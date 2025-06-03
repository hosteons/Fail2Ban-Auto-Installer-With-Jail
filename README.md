# Fail2Ban Auto-Installer Script

This is a simple script that installs and configures Fail2Ban with auto-detection of common services like SSH, Apache, and Nginx.

## Features
- Automatically installs Fail2Ban (if not already installed)
- Adds SSH jail by default
- Detects and configures Apache or Nginx jails if those services are installed
- Skips unnecessary jails if services are not detected
- Ensures idempotent setup

## Usage
```bash
chmod +x fail2ban_auto_installer.sh
./fail2ban_auto_installer.sh
```

## Maintained By

**Hosteons.com**  
- Website: https://hosteons.com  
- Customer Portal: https://my.hosteons.com  
- Blog: https://blog.hosteons.com  
- Twitter: https://x.com/hosteonscom  
- Facebook: https://facebook.com/HostEons

