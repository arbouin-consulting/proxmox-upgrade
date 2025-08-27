#!/bin/bash

test () {
    pve8to9 --full
}

upgrade () {
  echo "Remove package systemd-boot"
  apt remove --purge systemd-boot linux-image-amd64 -y
  apt update
  apt dist-upgrade -y
  apt autoremove -y
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
  cat > /etc/apt/sources.list.d/pve-enterprise.sources << EOF
Types: deb
URIs: https://enterprise.proxmox.com/debian/pve
Suites: trixie
Components: pve-enterprise
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF
  cat > /etc/apt/sources.list.d/proxmox.sources << EOF
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF

  echo "Clean old repository"
  rm -f /etc/apt/sources.list.d/ceph.list
  rm -f /etc/apt/sources.list.d/pve-install-repo.list
  rm -f /etc/apt/sources.list.d/pve-enterprise.list

  apt update

  apt dist-upgrade -y
}

post-upgrade () {
  apt modernize-sources
  apt update
  apt dist-upgrade
}

case $1 in
    test) "$@"; exit;;
    upgrade) "$@"; exit;;
    post-upgrade) "$@"; exit;;
    *) test; exit;;
esac
