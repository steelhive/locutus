terraform {
    backend "s3" {}
}

provider "aws" {
    region              = "${var.region}"
}

module "core" {
    source              = "../../modules/core"
    region              = "${var.region}"
    environment         = "${var.environment}"
    state_bucket        = "${var.state_bucket}"
}

module "vpc" {
    source              = "../../modules/vpc"
    name                = "${var.system_name}"
    cidr                = "${var.cidr}"
}

module "public_subnets" {
    source              = "../../modules/subnet"
    name                = "${var.system_name}"
    azs                 = "${var.azs}"
    cidrs               = "${var.public_subnets}"
    vpc_id              = "${module.vpc.id}"
    is_public           = true
}

module "private_subnets" {
    source              = "../../modules/subnet"
    name                = "${var.system_name}"
    azs                 = "${var.azs}"
    cidrs               = "${var.private_subnets}"
    vpc_id              = "${module.vpc.id}"
    is_public           = false
}

module "gateway" {
    source              = "../../modules/internet_gateway"
    name                = "${var.system_name}"
    vpc_id              = "${module.vpc.id}"
    subnet_ids          = "${module.public_subnets.ids}"
}

module "nat" {
    source              = "../../modules/nat_gateway"
    name                = "${var.system_name}"
    vpc_id              = "${module.vpc.id}"
    public_subnet_ids   = "${module.public_subnets.ids}"
    private_subnet_ids  = "${module.private_subnets.ids}"
}

module "security_group" {
    source              = "../../modules/security_group"
    name                = "${var.system_name}-sg"
    description         = "${title(var.system_name)} Security Group"
    cidr                = "0.0.0.0/0"
    ports               = {
        "22"  = "tcp"
        "443" = "tcp"
    }
}

module "elb" {
    source              = "../../modules/elb"
    azs                 = "${var.azs}"
    name                = "${var.system_name}"
    domain              = "${var.apex_domain}"
    certificate_domain  = "${var.certificate_domain}"
}

module "master_cluster" {
    source              = "../../modules/asg"
    azs                 = "${var.azs}"
    amis                = "${var.amis}"
    name                = "${var.system_name}-master"
    region              = "${var.region}"
    elb_name            = ""
    min_size            = "${lookup(var.master_cluster, "min_size")}"
    max_size            = "${lookup(var.master_cluster, "max_size")}"
    disk_size           = "${lookup(var.master_cluster, "disk_size")}"
    desired_size        = "${lookup(var.master_cluster, "desired_size")}"
    ssh_key_name        = "${lookup(var.master_cluster, "ssh_key_name")}"
    instance_type       = "${lookup(var.master_cluster, "instance_type")}"
    user_data_file      = "${lookup(var.master_cluster, "user_data_file")}"
    security_group_id   = "${module.security_group.id}"
    tag_key             = "locutus:role"
    tag_value           = "master"
}

module "minion_cluster" {
    source              = "../../modules/asg"
    azs                 = "${var.azs}"
    amis                = "${var.amis}"
    name                = "${var.system_name}-minion"
    region              = "${var.region}"
    elb_name            = "${module.elb.name}"
    min_size            = "${lookup(var.minion_cluster, "min_size")}"
    max_size            = "${lookup(var.minion_cluster, "max_size")}"
    disk_size           = "${lookup(var.minion_cluster, "disk_size")}"
    desired_size        = "${lookup(var.minion_cluster, "desired_size")}"
    ssh_key_name        = "${lookup(var.minion_cluster, "ssh_key_name")}"
    instance_type       = "${lookup(var.minion_cluster, "instance_type")}"
    user_data_file      = "${lookup(var.minion_cluster, "user_data_file")}"
    security_group_id   = "${module.security_group.id}"
    tag_key             = "locutus:role"
    tag_value           = "minion"
}
