
### Vision

Somewhere between DCOS and Kubernetes.

Basic flow:

- log in
- see the cluster
- create a job
- deploy the job
- scale the job
- read job logs
- see job performance
- destroy the job

Basic components:

- compute cluster for containers
- catalog for repeatable services (databases, authentication, logging)

### Requirements

- Control cluster
    - Management UI
        - User Authenitication / Authorization
        - Log viewer
        - Perf viewer
        - Status viewer
        - Job management
        - Cluster management
    - Service Discovery (consul)
    - Scheduler (nomad)
    - Load balancing (fabio)
    - Configuration Management (terraform / ansible / packer)

- Worker cluster(s)
    - Applications: core line-of-business apps
    - Services: 1st or 3rd party, minimal config services
