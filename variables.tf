variable "aws_region" {default = "us-west-2"}
variable "aws_profile" {default = "default"}
variable "aws_ec2_keypair" {default = "keith1"}
variable "master_node_count" {default = 2}
variable "worker_node_count" {default = 2}
variable "master_ips" {default = [ "192.168.0.100", "192.168.0.101" ]}
variable "worker_ips" {default = ["192.168.0.111", "192.168.0.112", "192.168.0.113"]}
variable "aws_orgs_role_name" {default = "OrganizationAccountAccessRole"}
