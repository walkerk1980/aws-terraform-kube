provider "aws" {
    region = "${var.aws_region}"
    profile = "${var.aws_profile}"
}

# Grab the availability zones in this region and save it for later use
data "aws_availability_zones" "available" {}

# Create new Internet Gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = "${aws_vpc.vpc1.id}"
}

# Give the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.vpc1.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet-gateway.id}"
}

# Create new VPC
resource "aws_vpc" "vpc1" {
  cidr_block = "192.168.0.0/16"
  tags {
    Name = "kubernetes"
  }
}

# Subnet in in AZ1
resource "aws_subnet" "subnet0" {
  vpc_id = "${aws_vpc.vpc1.id}"
  cidr_block = "192.168.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "kube-public-subnet-0"
  }
}

# Subnet in in AZ2
resource "aws_subnet" "subnet1" {
  vpc_id = "${aws_vpc.vpc1.id}"
  cidr_block = "192.168.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "kube-public-subnet-1"
  }
}

# Create new Route Table
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc1.id}"
  route {
        cidr_block = "0.0.0.0/0"
	gateway_id = "${aws_internet_gateway.internet-gateway.id}"
	}
  tags {
    Name = "kube-public-rt"
  }
}

# master security group
resource "aws_security_group" "master" {
  name = "kube_master"
  description = "Used for kubernetes master nodes"
  vpc_id = "${aws_vpc.vpc1.id}"

  #SSH 
  ingress {
    from_port 	= 22
    to_port 	= 22
    protocol 	= "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound internet access
  egress {
    from_port	= 0
    to_port 	= 0
    protocol	= "-1"
    cidr_blocks	= ["0.0.0.0/0"]
  }
}

# worker security group
resource "aws_security_group" "worker" {
  name = "kube_worker"
  description = "Used for kubernetes worker nodes"
  vpc_id = "${aws_vpc.vpc1.id}"

  #HTTP 
  ingress {
    from_port 	= 80
    to_port 	= 80
    protocol 	= "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }

  #SSH from master nodes
  ingress {
    from_port 	= 22
    to_port 	= 22
    protocol 	= "tcp"
    security_groups = ["${aws_security_group.master.id}"]
  }

  #Outbound internet access
  egress {
    from_port	= 0
    to_port 	= 0
    protocol	= "-1"
    cidr_blocks	= ["0.0.0.0/0"]
  }
}
