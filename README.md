
### Vision

A Nomad-ic version of Kubernetes focused on simplicity.

### Components

|Group |Role                |Container     |Application |
|------|--------------------|--------------|------------|
|core  |orchestration       |l5s-core-exec |nomad       |
|core  |service discovery   |l5s-core-svc  |consul      |
|core  |load balancing      |l5s-core-lb   |fabio       |
|core  |secret management   |l5s-core-sec  |vault       |
|core  |logging and metrics |l5s-core-log  |custom      |
|core  |management api      |l5s-core-api  |custom      |
|core  |frontend ui         |l5s-core-ui   |custom      |
|util  |aws utilities       |l5s-util-aws  |custom      |

### Requirements

- Master Cluster
    - Management UI
        - User Authenitication / Authorization
        - Log viewer
        - Metric viewer
        - Status viewer
        - Job management
        - Cluster management
    - Scheduler (nomad)
    - Service Discovery (consul)
    - Load Balancing (fabio)
    - Secret Management


- Minion Cluster
    - Scheduler (nomad)
    - Service Discovery (consul)
    - Load Balancing (fabio)
