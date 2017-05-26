resource "aws_internet_gateway" "gateway" {
    vpc_id                      = "${var.vpc_id}"
    lifecycle { create_before_destroy = true }
    tags { Name = "${var.name}-igw" }
}

resource "aws_route_table" "table" {
    vpc_id                      = "${var.vpc_id}"
    route {
        cidr_block              = "0.0.0.0/0"
        gateway_id              = "${aws_internet_gateway.gateway.id}"
    }
    lifecycle { create_before_destroy = true }
    tags { Name = "${var.name}-igw-rt" }
}

resource "aws_route_table_association" "association" {
    route_table_id              = "${aws_route_table.table.id}"
    subnet_id                   = "${element(var.subnet_ids, count.index)}"
    count                       = "${length(var.subnet_ids)}" // needs number or known quantity or depends on?
    lifecycle { create_before_destroy = true }
}

output "id" { value = "${aws_internet_gateway.gateway.id}" }
