#! /bin/bash

export L5S_CORE_EXEC='steelhive/l5s-core-exec'
export L5S_CORE_SVC='steelhive/l5s-core-exec'
export L5S_UTIL_AWS='steelhive/l5s-util-aws'

function get-host-ip () {
    # get the IP of this instance from EC2 metadata
    docker run --rm $L5S_UTIL_AWS self -i | jq -r
}

function get-master-ips () {
    # gets the IPs of all nodes with a tag of 'locutus:role' and a key of 'master'
    docker run --rm $L5S_UTIL_AWS nodes -k locutus:role -t master
}

function get-join-ips () {
    docker run --rm $L5S_UTIL_AWS nodes -k locutus:role -t master -x
}

function get-role () {
    local host=$1
    local masters=$2
    local master=$(echo $masters | jq . | jq "contains([\"$host\"])")
    if [ "$master" == true ]; then
        echo 'master'
    else
        echo 'client'
    fi
}

function provision-baseline () {
    # install the basics
    apt-get -y update
    apt-get -y install jq dnsmasq

    # configure dnsmasq
    echo server=/locutus/127.0.0.1#8600 > /etc/dnsmasq.d/10-consul

    # configure docker
    wget -qO- https://get.docker.com/ | sh

    # restart services
    systemctl restart dnsmasq
    systemctl restart docker
}

function provision-node () {
    local HOST_IP=$(get-host-ip)
    local JOIN_IPS=$(get-join-ips)
    local MASTERS=$(get-master-ips)
    local ROLE=$(get-role $HOST_IP $MASTERS)

    # if [ "$ROLE" == 'master' ]; ... may start some things and not others
    docker run -d \
        -e ROLE=$ROLE \
        -e HOST_IP=$HOST_IP \
        -e JOIN_IPS=$JOIN_IPS \
        $L5S_CORE_SVC
    docker run -d \
        -e ROLE=$ROLE \
        -e HOST_IP=$HOST_IP \
        $L5S_CORE_EXEC

}

function main () {
    provision-baseline
    provision-node
}
