#! /bin/bash

echo 'configuring services...'
. /usr/bin/consul-setup
. /usr/bin/nomad-setup

systemctl enable nomad
systemctl enable consul
systemctl enable fabio

echo 'starting services...'
systemctl start docker
systemctl start dnsmasq
systemctl start consul
systemctl start nomad
systemctl start fabio
