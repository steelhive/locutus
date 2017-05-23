{
    "log_level": "INFO",
    "datacenter": "locutus",
    "rejoin_after_leave": true,
    "leave_on_terminate": true,
    "data_dir": "/var/lib/consul",
    "bind_addr": "0.0.0.0",
    "advertise_addr": "${HOST_IP}",
    "retry_join": ${JOIN_IPS},
    "addresses": {
        "dns": "0.0.0.0:8600",
        "http": "0.0.0.0:8500"
    }
}
