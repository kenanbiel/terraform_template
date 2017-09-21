data "terraform_remote_state" "vpc" {
  backend = "s3" 
  config {
    bucket = "<name_of_bucket>"
    key = "<path_inside_bucket>"
    region = "<region>"
  }
}

data "terraform_remote_state" "frontend" {
  backend = "s3"
  config {
    bucket = "<name_of_bucket>"
    key = "<path_inside_bucket>"
    region = "<region>"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

module "backend" {
  source              = "../../../modules/services/backend/"
  customer_name       = "${var.customer_name}"
  region              = "${var.region}"
  vpc_id              = "${data.terraform_remote_state.vpc.vpc_id}"
  subnet1             = "${data.terraform_remote_state.vpc.subnet1}"
  subnet2             = "${data.terraform_remote_state.vpc.subnet2}"
  client_cidr         = "${data.terraform_remote_state.vpc.client_cidr}"
  asg_max_size        = "${var.asg_max_size}"
  asg_min_size        = "${var.asg_min_size}"
  image_id            = "${var.image_id}"
  instance_type       = "${var.instance_type}"
  keyname             = "${var.keyname}"
  ssl_certificate_arn = "${var.ssl_certificate_arn}"
  frontend_sg         = "${data.terraform_remote_state.frontend.frontend_sg}"
}
