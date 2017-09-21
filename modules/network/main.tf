resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "true"
   
  tags {
    Name        = "${var.client_name}-vpc"
    stackname   = "${var.client_name}-vpc"
    vpclocation = "${var.region}"
  }
}

resource "aws_internet_gateway" "internetgateway" {
  vpc_id = "${aws_vpc.vpc.id}"
  
  tags {
    Name = "${var.client_name}-igw"
  }
}

resource "aws_route_table" "routetable" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internetgateway.id}"
  }
  
  tags {
    Name = "${var.client_name}-routetable"
  }  
}

resource "aws_subnet" "subnet1" {
  cidr_block        = "${element(var.subnet, 0)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.availability_zone, 0)}"

  tags {
    Name        = "${var.client_name}-subnet1"
    vpc         = "vpc"
    vpclocation = "${var.region}"
  }
}

resource "aws_route_table_association" "subnet1pub" {
  subnet_id = "${aws_subnet.subnet1.id}"
  route_table_id = "${aws_route_table.routetable.id}"
}

resource "aws_subnet" "subnet2" {
  cidr_block        = "${element(var.subnet, 1)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.availability_zone, 1)}"

  tags {
    Name        = "${var.client_name}-subnet2"
    vpc         = "vpc"
    vpclocation = "${var.region}"
  }
}

resource "aws_route_table_association" "subnet2pub" {
  subnet_id = "${aws_subnet.subnet2.id}"
  route_table_id = "${aws_route_table.routetable.id}"
}
