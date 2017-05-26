
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
|core  |management ui & api |l5s-core-api  |custom      |
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

### Infrastructure

Only configured for us-east-1 for now.
You must have an SSL certificate for your ELB.
You must have an existing SSH key pair for EC2.

1. Setup an S3 bucket, enable versioning
2. Run `source infrastructure/export-credentials`
3. Modify `infrastructure/environments/<env>/backend.hcl` as needed
4. `cd` into `infrastructure/environments/<env>`
5. Run `terraform init -backend-config=backend.hcl`
6. Generate a terraform plan:
    - `terraform plan -var "foo-bar"`
