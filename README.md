# proxmox-upgrade

Upgrade Proxmox server

## Usage
```
# Run test
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/arbouin-consulting/proxmox-upgrade/refs/heads/main/<version-of-upgrade>/upgrade.sh)"
# Run update process with question if remove package
curl -fsSL https://raw.githubusercontent.com/arbouin-consulting/proxmox-upgrade/refs/heads/main/<version-of-upgrade>/upgrade.sh | bash -s upgrade
# Run post-upgrade process
curl -fsSL https://raw.githubusercontent.com/arbouin-consulting/proxmox-upgrade/refs/heads/main/<version-of-upgrade>/upgrade.sh | bash -s post-upgrade
```

