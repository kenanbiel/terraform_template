output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "subnet1" {
  value = "${aws_subnet.subnet1.id}"
}

output "subnet2" {
  value = "${aws_subnet.subnet2.id}"
}

output "cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}
