#! /bin/ash

envsubst < /etc/nomad/nomad-base.tpl > /etc/nomad/nomad-base.hcl
rm /etc/nomad/nomad-base.tpl

case $ROLE in
    'client')
        rm /etc/nomad/nomad-server.hcl
        ;;
    'server')
        rm /etc/nomad/nomad-client.hcl
        ;;
    *)
        echo '$ROLE was not specified; aborting.'
        exit 1
        ;;
esac

nomad agent -config=/etc/nomad
