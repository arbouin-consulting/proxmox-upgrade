#!/bin/bash

test () {
    pve8to9 --full
}

upgrade () {
  echo "Remove package systemd-boot"
  apt-get remove --purge systemd-boot linux-image-amd64 -y
  apt-get update
  apt-get dist-upgrade -y
  apt-get autoremove -y
  pveversion

  echo "Change and create new repository of bookworm to trixie"
  sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
  cat > /etc/apt/sources.list.d/ceph.sources << EOF
Types: deb
URIs: http://download.proxmox.com/debian/ceph-squid
Suites: trixie
Components: no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF
  cat > /etc/apt/sources.list.d/ceph-enterprise.sources << EOF
Types: deb
URIs: https://enterprise.proxmox.com/debian/ceph-squid
Suites: trixie
Components: enterprise
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
Enabled: false
EOF
  cat > /etc/apt/sources.list.d/pve-enterprise.sources << EOF
Types: deb
URIs: https://enterprise.proxmox.com/debian/pve
Suites: trixie
Components: pve-enterprise
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
Enabled: false
EOF
  cat > /etc/apt/sources.list.d/proxmox.sources << EOF
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF
  cat > /etc/apt/sources.list.d/debian.sources << EOF
# Modernized from /etc/apt/sources.list
Types: deb
URIs: http://ftp.fr.debian.org/debian/
Suites: trixie
Components: main contrib
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

# Modernized from /etc/apt/sources.list
Types: deb
URIs: http://ftp.fr.debian.org/debian/
Suites: trixie-updates
Components: main contrib
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

# Modernized from /etc/apt/sources.list
Types: deb
URIs: http://security.debian.org/
Suites: trixie-security
Components: main contrib
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF

  echo "Clean old repository"
  rm -f /etc/apt/sources.list.d/ceph.list
  rm -f /etc/apt/sources.list.d/pve-install-repo.list
  rm -f /etc/apt/sources.list.d/pve-enterprise.list
  rm -f /etc/apt/sources.list

  apt-get update
  apt-get policy
  apt-get dist-upgrade -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y
}

post-upgrade () {
  apt modernize-sources
  apt-get update
  apt-get dist-upgrade
}

case $1 in
    test) "$@"; exit;;
    upgrade) "$@"; exit;;
    post-upgrade) "$@"; exit;;
    *) test; exit;;
esac
