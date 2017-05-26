resource "aws_subnet" "subnet" {
    vpc_id                      = "${var.vpc_id}"
    cidr_block                  = "${element(var.cidrs, count.index)}"
    availability_zone           = "${element(var.azs, count.index)}"
    map_public_ip_on_launch     = "${var.is_public}"
    count                       = "${length(var.cidrs)}"
    lifecycle { create_before_destroy = true }
    tags { Name = "${var.name}-sn-${var.is_public ? "public" : "private"}-${count.index}" }
}

output "ids" { value = ["${aws_subnet.subnet.*.id}"] }
