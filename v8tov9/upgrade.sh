#!/bin/bash

test () {
    pve8to9 --full
}

upgrade () {
  echo "Remove package systemd-boot"
  apt remove --purge systemd-boot
  apt update
  apt dist-upgrade
  apt autoremove -y
  pveversion

  sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
  sed -i 's/bookworm/trixie/g' /etc/apt/sources.list.d/pve-enterprise.list

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
