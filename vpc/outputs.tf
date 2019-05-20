output "vpc_id" {
    value = "${aws_vpc.vpc1.id}"
}
output "public_subnet_id0" {
    value = "${aws_subnet.subnet0.id}"
}
output "public_subnet_id1" {
    value = "${aws_subnet.subnet1.id}"
}
output "master_sg_id" {
    value = "${aws_security_group.master.id}"
}
output "worker_sg_id" {
    value = "${aws_security_group.worker.id}"
}
output "internet_gateway" {
    value = "$(aws_internet_gateway.internet-gateway}"
}
