#! /bin/bash
set -e

# export FABIO_URL='https://github.com/fabiolb/fabio'
# export FABIO_VER='1.4.4'
# wget -qO fabio "${FABIO_URL}/releases/download/v${FABIO_VER}/fabio-${FABIO_VER}-go1.8.3-linux_amd64"
# chmod +x fabio
# mv fabio /usr/bin/

export L5S_CORE_EXEC='steelhive/l5s-core-exec'
export L5S_CORE_SVC='steelhive/l5s-core-svc'
export L5S_UTIL_AWS='steelhive/l5s-util-aws'

function get-host-ip () {
    # get the IP of this instance from EC2 metadata
    docker run --rm $L5S_UTIL_AWS self -i | jq . -r
}

function get-master-ips () {
    # gets the IPs of all nodes with a tag of 'locutus:role'
    # and a key of 'master'
    docker run --rm $L5S_UTIL_AWS nodes -k locutus:role -v master
}

function get-join-ips () {
    # gets the IPs of all nodes with a tag of 'locutus:role'
    # and a key of 'master' that aren't us
    docker run --rm $L5S_UTIL_AWS nodes -k locutus:role -v master -x
}

function get-role () {
    # if our ip is in the list of masters, then we're a master.
    # otherwise, we're a minion
    local host_ip=$1
    local masters=$(get-master-ips)
    local master=$(echo $masters | jq . | jq "contains([\"$host_ip\"])")
    if [ "$master" == 'true' ]; then
        echo 'master'
    else
        echo 'minion'
    fi
}

function provision-baseline () {
    # install the basics
    echo 'installing baseline packages'
    apt-get -y update
    apt-get -y install jq dnsmasq wget openssl unzip gettext ca-certificates

    # configure dnsmasq
    echo 'configuring dnsmasq'
    echo server=/locutus/127.0.0.1#8600 > /etc/dnsmasq.d/10-consul
    sysctl -w net.ipv6.conf.lo.disable_ipv6=1
    sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sysctl -w net.ipv6.conf.default.disable_ipv6=1

    # configure docker
    echo 'installing docker'
    if [ "$(which docker)" == '' ]; then
        wget -qO- https://get.docker.com/ | sh
    fi

    # restart services
    echo 'ensuring services are running'
    systemctl restart dnsmasq
    systemctl restart docker
}

function provision-services () {
    # get all the data and fire up the services
    local HOST_IP=${HOST_IP:-$(get-host-ip)}
    local JOIN_IPS=${JOIN_IPS:-$(get-join-ips)}
    local ROLE=${ROLE:-$(get-role $HOST_IP)}

    echo "our role is: $ROLE"
    echo "our ip is:   $HOST_IP"
    echo "joining:     $JOIN_IPS"
    echo 'starting services...'
    # if [ "$ROLE" == 'master' ]; ... may start some things and not others
    docker run -d \
        --net=host \
        -e ROLE=$ROLE \
        -e HOST_IP=$HOST_IP \
        -e JOIN_IPS="$JOIN_IPS" \
        $L5S_CORE_SVC

    docker run -d \
        --net=host \
        --privileged \
        --volume /tmp:/tmp \
        --volume /var/run/docker.sock:/var/run/docker.sock \
        -e ROLE=$ROLE \
        -e HOST_IP=$HOST_IP \
        $L5S_CORE_EXEC
}

function main () {
    provision-baseline
    if [[ -z "DEV" ]]; then
        provision-services
    fi
}

main
