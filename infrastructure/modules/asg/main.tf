
resource "aws_iam_role" "role" {
    name                        = "${var.name}-read-only-role"
    path                        = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "profile" {
    name                        = "${var.name}-read-only-profile"
    role                        = "${aws_iam_role.role.name}"
}

resource "aws_launch_configuration" "lc" {
    name                        = "${var.name}-lc"
    key_name                    = "${var.ssh_key_name}"
    image_id                    = "${lookup(var.amis, var.region)}"
    user_data                   = "${file(var.user_data_file)}"
    instance_type               = "${var.instance_type}"
    security_groups             = ["${var.security_group_id}"]
    iam_instance_profile        = "${aws_iam_instance_profile.profile.name}"
    root_block_device {
        volume_size             = "${var.disk_size}"
    }
}

resource "aws_autoscaling_group" "asg" {
    name                        = "${var.name}-asg"
    availability_zones          = ["${var.azs}"]
    min_size                    = "${var.min_size}"
    max_size                    = "${var.max_size}"
    desired_capacity            = "${var.desired_size}"
    default_cooldown            = 30
    health_check_grace_period   = 300
    health_check_type           = "${var.elb_name != "" ? "ELB" : "EC2"}"
    load_balancers              = ["${var.elb_name}"]
    launch_configuration        = "${aws_launch_configuration.lc.name}"
    tag {
        key                     = "${var.tag_key}"
        value                   = "${var.tag_value}"
        propagate_at_launch     = true
    }
}
