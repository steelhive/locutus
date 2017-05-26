data "aws_route53_zone" "zone" {
        name                    = "${var.domain}."
}

data "aws_acm_certificate" "ssl" {
    domain                      = "${var.certificate_domain}"
    statuses                    = ["ISSUED"]
}

resource "aws_elb" "lb" {
    name                        = "${var.name}-elb"
    availability_zones          = "${var.azs}"
    cross_zone_load_balancing   = true
    idle_timeout                = 90
    connection_draining         = true
    connection_draining_timeout = 90

    listener {
        lb_port                 = 443
        lb_protocol             = "https"
        instance_port           = 80
        instance_protocol       = "http"
        ssl_certificate_id      = "${data.aws_acm_certificate.ssl.arn}"
    }

    health_check {
        target                  = "HTTP:80/health"
        timeout                 = 3
        interval                = 30
        healthy_threshold       = 2
        unhealthy_threshold     = 2
    }
}

resource "aws_route53_record" "cname" {
    ttl                         = 5
    type                        = "CNAME"
    name                        = "${var.name}.${var.domain}"
    zone_id                     = "${data.aws_route53_zone.zone.zone_id}"
    records                     = ["${aws_elb.lb.dns_name}"]
}

output "name" { value = "${aws_elb.lb.name}" }
