#! /bin/bash

# general variables
export L5SCLI_ROOT='https://github.com/steelhive/locutus-cli/releases/download'
export L5SINF_ROOT='https://raw.githubusercontent.com/steelhive/locutus/master/'
export FABIO_ROOT='https://github.com/fabiolb/fabio/releases/download'
export HASHI_ROOT='https://releases.hashicorp.com'

export L5SCLI_VER='0.1.0'
export FABIO_VER='1.4.4'
export NOMAD_VER='0.5.6'
export CONSUL_VER='0.8.3'

export L5SCLI_URL="${L5SCLI_ROOT}/v${L5SCLI_VER}/l5s"
export L5SSVC_URL="${L5SINF_ROOT}/infrastructure/baseline/services"
export FABIO_URL="${FABIO_ROOT}/v${FABIO_VER}/fabio-${FABIO_VER}-go1.8.3-linux_amd64"
export NOMAD_URL="${HASHI_ROOT}/nomad/${NOMAD_VER}/nomad_${NOMAD_VER}_linux_amd64.zip"
export CONSUL_URL="${HASHI_ROOT}/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip"


echo 'installing baseline packages'
apt-get -y -qq update
apt-get -y -qq install \
    jq \
    wget \
    unzip \
    dnsmasq \
    openssl \
    gettext \
    ca-certificates
echo 'done'


echo 'configuring dnsmasq'
echo server=/locutus/127.0.0.1#8600 > /etc/dnsmasq.d/10-consul
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
echo 'done'


echo 'installing locutus cli'
cd /usr/bin
wget -q "$L5SCLI_URL"
chmod +x ./l5s
echo 'done'


echo 'installing consul...'
cd /usr/bin
wget -qO consul.zip "$CONSUL_URL"
unzip consul.zip
rm consul.zip
wget -q "$L5SSVC_URL/consul/consul-start"

mkdir /etc/consul
cd /etc/consul
wget -q "$L5SSVC_URL/consul/consul-base.tpl"
wget -q "$L5SSVC_URL/consul/consul-client.json"
wget -q "$L5SSVC_URL/consul/consul-server.json"

cd /lib/systemd/system
wget -q "$L5SSVC_URL/consul/consul.service"
echo 'done'


echo 'installing nomad...'
cd /usr/bin
wget -qO nomad.zip "$NOMAD_URL"
unzip nomad.zip
rm nomad.zip
wget -q "$L5SSVC_URL/nomad/nomad-start"

mkdir /etc/nomad
cd /etc/nomad
wget -q "$L5SSVC_URL/nomad/nomad-base.tpl"
wget -q "$L5SSVC_URL/nomad/consul-client.hcl"
wget -q "$L5SSVC_URL/nomad/consul-server.hcl"

cd /lib/systemd/system
wget -q "$L5SSVC_URL/nomad/nomad.service"
echo 'done'


echo 'installing fabio'
cd /usr/bin
wget -qO fabio "$FABIO_URL"
chmod +x ./fabio

cd /lib/systemd/system
wget -q "$L5SSVC_URL/fabio/fabio.service"
echo 'done'

echo 'installing docker'
if [ "$(which docker)" == '' ]; then
    wget -qO- https://get.docker.com/ | sh
fi


echo 'ensuring services are running'
systemctl enable nomad
systemctl enable consul
systemctl enable fabio

systemctl start docker
systemctl start dnsmasq
systemctl start consul
systemctl start nomad
systemctl start fabio
