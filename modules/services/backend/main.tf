resource "aws_autoscaling_group" "backend" {
  lifecycle { create_before_destroy = true }
  vpc_zone_identifier = [ "${var.subnet1}", "${var.subnet2}"]
  name = "${var.client_name}-backend"
  max_size = "${var.asg_max_size}"
  min_size = "${var.asg_min_size}"
  wait_for_elb_capacity = false
  force_delete = true
  health_check_type = "EC2"
  launch_configuration = "${aws_launch_configuration.backend.id}"
  load_balancers = ["${aws_elb.backend.id}"]
  tag = [{
    key = "environment"
    value = "production"
    propagate_at_launch = true
  }, {
    key = "role"
    value = "backend"
    propagate_at_launch = true
  }, {
    key = "location"
    value = "${var.region}"
    propagate_at_launch = true
  }, {
    key = "type"
    value = "app"
    propagate_at_launch = true
  }]
}

resource "aws_launch_configuration" "backend" {
  lifecycle { create_before_destroy = true }
  image_id = "${var.image_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.keyname}"
  associate_public_ip_address = true
  security_groups = [ "${aws_security_group.backend.id}" ]
  root_block_device {
    volume_type = "gp2"
    volume_size = 20
    delete_on_termination = true
  }
  user_data = <<-EOF
              #!/bin/bash
              wget -O - https://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -
              echo "deb http://repo.saltstack.com/apt/ubuntu/14.04/amd64/2016.11 trusty main" > /etc/apt/sources.list.d/saltstack.list
              apt-get update
              apt-get upgrade -y
              apt-get install -y salt-minion
              apt-get install -y python-pip
              pip install boto
              pip install awscli
              service salt-minion stop
              rm -f /etc/salt/minion_id
              EOF
}

resource "aws_elb" "backend" {
  name = "${var.client_name}-prod-backend-elb"
  subnets = [ "${var.subnet1}", "${var.subnet2}" ]
  security_groups = [ "${aws_security_group.backend_elb.id}" ]

  listener {
    lb_port = "80"
    lb_protocol = "HTTP"
    instance_port = "8443"
    instance_protocol = "HTTPS"
  }

  listener {
    lb_port = "443"
    lb_protocol = "HTTPS"
    instance_port = "8443"
    instance_protocol = "HTTPS"
    ssl_certificate_id = "${var.ssl_certificate_arn}"
  }

  health_check {
    healthy_threshold = "3"
    unhealthy_threshold = "2"
    interval = "6"
    timeout = "5"
    target = "TCP:8443"
  }

  tags {
    Name = "${var.client_name}-prod-backend-elb"
  }
}

resource "aws_security_group" "backend_elb" {
  name = "${var.client_name}-prod-backend-elb"
  description = "This is the default security group for Frontend ELB"

  ingress {
    from_port = 443
    to_port = 443
    security_groups = [ "${var.frontend_sg}" ]
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "-1"
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.client_name}-prod-backend-elb"
  }
}

resource "aws_security_group" "backend" {
  name = "${var.client_name}-prod-backend"
  description = "This is the default security group for Frontend App"

  ingress {
    from_port = 8443
    to_port = 8443
    security_groups = [ "${aws_security_group.backend_elb.id}" ]
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "-1"
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.client_name}-prod-backend"
  }
}
