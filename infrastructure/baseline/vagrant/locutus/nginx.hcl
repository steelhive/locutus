job "web" { # top level container
    datacenters = ["locutus"]
    type = "service" # service || system || batch
    // periodic {
    //     cron = "*/15 * * * * *"
    //     prohibit_overlap = true
    // }
    update {
        stagger = "15s"
        max_parallel = 1
    }

    group "frontend" { # scheduled per host (k8s pod)
        count = 1
        restart {
            interval = "5m"
            attempts = 5
            delay = "25s"
            mode = "delay"
        }
        task "ui" { # executable units; co-located
            driver = "docker"
            config {
                image = "hashidemo/nginx:latest"
            }
            service {
                name = "nginx"
                tags = ["global"]
                port = "http"
                check {
                    type = "http"
                    path = "/"
                    interval = "15s"
                    timeout = "2s"
                }
            }
            env {}
            resources {
                cpu = 500 # mhz
                memory = 256 # mb
                network {
                    mbits = 10
                    port "http" {}
                }
            }
        }
    }

}
