# Set the default region and the profile to use with access keys
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

# Create a new Subnet 
resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.vpc1.id}"
  cidr_block = "192.168.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "kube-public-subnet"
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

# kubernetes master node
resource "aws_instance" "master" {
    ami = "ami-005bdb005fb00e791"
    instance_type = "t2.micro"

    key_name = "${var.aws_ec2_keypair}"
    vpc_security_group_ids = ["${aws_security_group.master.id}"]

    private_ip = "192.168.0.100"

    subnet_id = "${aws_subnet.public.id}"
    

    # The connection block tells our provisioner how to
    # communicate with the instance
    connection {
        user = "ubuntu"
    }
    tags = {
        Name = "KubeMaster1"
    }
}

# Assign Elastic IP to Instance "master"
resource "aws_eip" "kube_eip" {
  vpc = true

  instance                  = "${aws_instance.master.id}"
  associate_with_private_ip = "192.168.0.100"
  depends_on                = ["aws_internet_gateway.internet-gateway"]
}


# worker node 1
resource "aws_instance" "worker1" {
    ami = "ami-005bdb005fb00e791"
    instance_type = "t2.micro"

    key_name = "${var.aws_ec2_keypair}"
    vpc_security_group_ids = ["${aws_security_group.worker.id}"]

    private_ip = "192.168.0.101"

    subnet_id = "${aws_subnet.public.id}"
    
    tags = {
        Name = "KubeWorker1"
    }

    # The connection block tells our provisioner how to
    # communicate with the instance
    connection {
        user = "ubuntu"
    }
}

# worker node 2
resource "aws_instance" "worker2" {
    ami = "ami-005bdb005fb00e791"
    instance_type = "t2.micro"

    key_name = "${var.aws_ec2_keypair}"
    vpc_security_group_ids = ["${aws_security_group.worker.id}"]

    private_ip = "192.168.0.102"

    subnet_id = "${aws_subnet.public.id}"
    
    tags = {
        Name = "KubeWorker2"
    }

    # The connection block tells our provisioner how to
    # communicate with the instance
    connection {
        user = "ubuntu"
    }
}

