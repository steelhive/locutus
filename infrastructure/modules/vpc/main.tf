resource "aws_vpc" "vpc" {
    cidr_block                  = "${var.cidr}"
    enable_dns_support          = true
    enable_dns_hostnames        = true
    lifecycle { create_before_destroy = true }
    tags { Name = "${var.name}-vpc" }
}

output "id" { value = "${aws_vpc.vpc.id}" }
