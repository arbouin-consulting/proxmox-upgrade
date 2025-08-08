#!/bin/bash

test () {
    pve8to9 --full
}

upgrade () {
  apt update
  apt dist-upgrade
  apt autoremove -y
  pveversion

  sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
  sed -i 's/bookworm/trixie/g' /etc/apt/sources.list.d/pve-enterprise.list

  apt update

  apt dist-upgrade -y
}

postinstall () {
  apt modernize-sources
  apt update
  apt dist-upgrade
}

case $1 in
    test) "$@"; exit;;
    upgrade) "$@"; exit;;
    postinstall) "$@"; exit;;
    *) test; exit;;
esac
