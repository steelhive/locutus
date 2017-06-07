
bind_addr   = "0.0.0.0"

data_dir    = "/var/lib/nomad"

datacenter  = "locutus"

advertise {
    http = "${HOST_IP}:4646"
    rpc  = "${HOST_IP}:4647"
    serf = "${HOST_IP}:4648"
}

consul {
    address = "${HOST_IP}:8500"
}
