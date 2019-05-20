output "master_node_ids" {
    value = ["${aws_eip.kube_eip.*.instance}"]
}
output "master_node_ips" {
    value = ["${aws_eip.kube_eip.*.public_ip}"]
}
output "worker_node_ids" {
    value = ["${aws_instance.worker.*.id}"]
}
output "worker_node_ips" {
    value = ["${aws_instance.worker.*.private_ip}"]
}
