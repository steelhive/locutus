data "terraform_remote_state" "state" {
    backend = "s3"
    config {
        region  = "${var.region}"
        bucket  = "${var.state_bucket}"
        key     = "${var.environment}/${var.environment}.tfstate"
    }
}
