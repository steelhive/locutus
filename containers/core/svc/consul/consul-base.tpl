{
    "log_level": "INFO",
    "datacenter": "locutus",
    "rejoin_after_leave": true,
    "leave_on_terminate": true,
    "data_dir": "/var/lib/consul",
    "bind_addr": "0.0.0.0",
    "advertise_addr": "${HOST_IP}",
    "start_join": ${JOIN_IPS},
    "retry_join": ${JOIN_IPS},
    "addresses": {
        "dns": "0.0.0.0",
        "http": "0.0.0.0",
        "https": "0.0.0.0"
    }
}
