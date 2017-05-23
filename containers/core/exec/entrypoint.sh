#! /bin/ash

envsubst < /etc/nomad/nomad-base.tpl > /etc/nomad/nomad-base.hcl
rm /etc/nomad/nomad-base.tpl

case $ROLE in
    'minion')
        rm /etc/nomad/nomad-server.hcl
        ;;
    'master')
        rm /etc/nomad/nomad-client.hcl
        ;;
    *)
        echo '$ROLE was not specified; aborting.'
        exit 1
        ;;
esac

nomad agent -config=/etc/nomad
