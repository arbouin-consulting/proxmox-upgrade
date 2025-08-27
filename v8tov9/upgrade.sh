#!/bin/bash

test () {
    pve8to9 --full
}

upgrade () {
  echo "Should the package be removed systemd-boot y/n"
  read reponse
  if [[ "$reponse" == "y" ]]
  then
      apt remove --purge systemd-boot
  fi
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
