resource "aws_security_group" "sg" {
    name                        = "${var.name}"
    description                 = "${var.description}"
    lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "ingress" {
    type                        = "ingress"
    cidr_blocks                 = ["${var.cidr}"]
    security_group_id           = "${aws_security_group.sg.id}"
    from_port                   = "${element(keys(var.ports), count.index)}"
    to_port                     = "${element(keys(var.ports), count.index)}"
    protocol                    = "${element(values(var.ports), count.index)}"
    count                       = "${length(var.ports)}"
    lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "inter" {
    type                        = "ingress"
    source_security_group_id    = "${aws_security_group.sg.id}"
    security_group_id           = "${aws_security_group.sg.id}"
    from_port                   = 0
    to_port                     = 0
    protocol                    = "-1"
    lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "egress" {
    type                        = "egress"
    cidr_blocks                 = ["0.0.0.0/0"]
    security_group_id           = "${aws_security_group.sg.id}"
    from_port                   = 0
    to_port                     = 0
    protocol                    = "-1"
    lifecycle { create_before_destroy = true }
}

output "id" { value = "${aws_security_group.sg.id}" }
