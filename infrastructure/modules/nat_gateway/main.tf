resource "aws_eip" "eip" {
    vpc                         = true
    count                       = "${length(var.public_subnet_ids)}"
    lifecycle { create_before_destroy = true }
}

resource "aws_nat_gateway" "gateway" {
    allocation_id               = "${element(aws_eip.eip.*.id, count.index)}"
    subnet_id                   = "${element(var.public_subnet_ids, count.index)}"
    count                       = "${length(var.public_subnet_ids)}"
    lifecycle { create_before_destroy = true }
}

resource "aws_route_table" "table" {
    vpc_id                      = "${var.vpc_id}"
    count                       = "${length(var.public_subnet_ids)}"
    lifecycle { create_before_destroy = true }
    tags { Name = "${var.name}-ngw-rt-${count.index}" }
}

resource "aws_route" "route" {
    destination_cidr_block      = "0.0.0.0/0"
    route_table_id              = "${element(aws_route_table.table.*.id, count.index)}"
    nat_gateway_id              = "${element(aws_nat_gateway.gateway.*.id, count.index)}"
    count                       = "${length(var.public_subnet_ids)}"
}

resource "aws_route_table_association" "association" {
    route_table_id              = "${element(aws_route_table.table.*.id, count.index)}"
    subnet_id                   = "${element(var.private_subnet_ids, count.index)}"
    count                       = "${length(var.public_subnet_ids)}"
    lifecycle { create_before_destroy = true }
}

output "ids"  { value = ["${aws_nat_gateway.gateway.*.id}"] }
