# Set the default region and the profile to use with access keys
provider "aws" {
    region = "${var.aws_region}"
    profile = "${var.aws_profile}"
}

# Create VPC infrastructure
module "vpc" {
    source = "./vpc"
    aws_region = "${var.aws_region}"
    aws_profile = "${var.aws_profile}"
}

# Create K8N nodes
module "nodes" {
    source = "./nodes"
    key_name = "${var.aws_ec2_keypair}"
    master_node_count = "${var.master_node_count}"
    worker_node_count = "${var.worker_node_count}"
    master_ami_id = "${var.master_ami_id}"
    worker_ami_id = "${var.worker_ami_id}"
    master_instance_type = "${var.master_instance_type}"
    worker_instance_type = "${var.worker_instance_type}"
    master_ips = "${var.master_ips}"
    worker_ips = "${var.worker_ips}"
    vpc_id = "${module.vpc.vpc_id}"
    worker_sg_id = "${module.vpc.worker_sg_id}"
    master_sg_id = "${module.vpc.master_sg_id}"
    public_subnet_id0 = "${module.vpc.public_subnet_id0}"
    public_subnet_id1 = "${module.vpc.public_subnet_id1}"
}
