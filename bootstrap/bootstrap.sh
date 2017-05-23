#! /bin/bash

apt-get -y update
apt-get -y install jq dnsmasq

# configure dnsmasq
echo server=/locutus/127.0.0.1#8600 > /etc/dnsmasq.d/10-consul

# configure docker
wget -qO- https://get.docker.com/ | sh

# restart services
systemctl restart dnsmasq
systemctl restart docker

# setup node
function get-host-ip () {
    docker run --rm steelhive/l5s-util-aws self -i | jq -r
}

function get-master-ips () {
    docker run --rm steelhive/l5s-util-aws nodes -t locutus:role -k master
}

function get-join-ips () {
    docker run --rm steelhive/l5s-util-aws nodes -t locutus:role -k master -x
}

function get-role () {
    local host=$1
    local masters=$2
    local master=$(echo $masters | jq . | jq "contains([\"$host\"])")
    if [ "$master" == true ]; then
        echo master
    else
        echo client
    fi
}

export HOST_IP=$(get-host-ip)
export MASTERS=$(get-master-ips)
export ROLE=$(get-role $HOST_IP $MASTERS)
