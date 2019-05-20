variable "key_name" {}
variable "master_node_count" {}
variable "master_instance_type" {}
variable "master_ami_id" {}
variable "worker_ami_id" {}
variable "worker_node_count" {}
variable "worker_instance_type" {}
variable "master_ips" {type = "list"}
variable "worker_ips" {type = "list"}
variable "vpc_id" {}
variable "master_sg_id" {}
variable "worker_sg_id" {}
variable "public_subnet_id0" {}
variable "public_subnet_id1" {}

