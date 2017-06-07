#! /bin/bash

vagrant destroy -f
vagrant box remove locutus
vagrant up

export SCRIPT="sudo apt-get clean
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
exit"

vagrant ssh -- -t "$SCRIPT"
vagrant package --output out.box
vagrant box add locutus out.box
vagrant destroy -f
rm out.box
