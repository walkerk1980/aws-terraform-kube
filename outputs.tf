output "vpc_id" {
    value = "${module.vpc.vpc_id}"
}
output "master_node_ids" {
    value = ["${module.nodes.master_node_ids}"]
}
output "master_node_ips" {
    value = ["${module.nodes.master_node_ips}"]
}
output "worker_node_ids" {
    value = ["${module.nodes.worker_node_ids}"]
}
output "worker_node_ips" {
    value = ["${module.nodes.worker_node_ips}"]
}
