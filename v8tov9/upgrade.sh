#!/bin/bash

test () {
    pve8to9 --full
}

upgrade () {
  apt update
  apt dist-upgrade
  apt autoremove -y

  echo "Should the package be removed systemd-boot y/n"
  read reponse
  if [[ "$reponse" == "y" ]]
  then
      apt remove --purge systemd-boot
  fi
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
