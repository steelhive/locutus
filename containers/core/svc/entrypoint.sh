#! /bin/ash

envsubst < /etc/consul/consul-base.tpl > /etc/consul/consul-base.json
rm /etc/consul/consul-base.tpl

case $ROLE in
    'minion')
        rm /etc/consul/consul-server.json
        ;;
    'master')
        rm /etc/consul/consul-client.json
        ;;
    *)
        echo '$ROLE was not specified; aborting.'
        exit 1
        ;;
esac

consul agent -config-dir=/etc/consul
