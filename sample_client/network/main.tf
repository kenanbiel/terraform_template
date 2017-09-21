terraform {
  backend "s3" {
    bucket = "<name_of_bucket>"
    key = "<path_inside_bucket>"
    region = "<region>"
  }
}

provider "aws" {
  region = "${var.region}"
}

module "network" {
  source = "../../modules/network/"
  client_name       = "${var.client_name}"
  region            = "${var.region}"
  availability_zone = "${var.availability_zone}"
  cidr              = "${var.cidr}"
  subnet            = "${var.subnet}"
}

output "vpc_id" {
  value = "${module.network.vpc_id}"
}

output "subnet1" {
  value = "${module.network.subnet1}"
}

output "subnet2" {
  value = "${module.network.subnet2}"
}

output "client_cidr" {
  value = "${module.network.cidr}"
}
