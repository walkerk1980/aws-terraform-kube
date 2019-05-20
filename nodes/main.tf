# kubernetes master node
resource "aws_instance" "master" {
    ami = "${var.master_ami_id}"
    instance_type = "${var.master_instance_type}"
    count = "${var.master_node_count}"

    key_name = "${var.key_name}"
    vpc_security_group_ids = ["${var.master_sg_id}"]

    private_ip = "${element(var.master_ips, count.index)}"

    subnet_id = "${var.public_subnet_id0}"
    

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
  count = "${var.master_node_count}"
  instance                  = "${element(aws_instance.master.*.id, count.index)}"
  associate_with_private_ip = "${element(var.master_ips, count.index)}"
}


# worker nodes
resource "aws_instance" "worker" {
    ami = "${var.worker_ami_id}"
    instance_type = "t2.micro"
    count = "${var.worker_node_count}"
    key_name = "${var.key_name}"
    vpc_security_group_ids = ["${var.worker_sg_id}"]

    private_ip = "${element(var.worker_ips, count.index)}"

    subnet_id = "${var.public_subnet_id0}"
    
    tags = {
        Name = "KubeWorker${count.index}"
    }

    # The connection block tells our provisioner how to
    # communicate with the instance
    connection {
        user = "ubuntu"
    }
}

