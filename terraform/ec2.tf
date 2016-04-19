resource "aws_instance" "controller-acc" {
  ami = "${var.ami}"
  availability_zone = "${var.az-main}"
  ebs_optimized = false
  instance_type = "${var.controller-size-acc}"
  monitoring = false
  // key_name not needed, since they're baked into cloud config user_data,
  // but you can set it if you're the one
  // key_name                    = ""
  subnet_id = "${aws_subnet.main-acc.id}"
  vpc_security_group_ids = ["${aws_security_group.controller-acc.id}"]
  associate_public_ip_address = false
  private_ip = "${var.controller-ip-acc}"
  source_dest_check = true
  iam_instance_profile = "controller-acc-profile"
  user_data = "${template_file.controller-acc-user-data.rendered}"

  root_block_device {
    volume_type = "standard"
    volume_size = 30
    delete_on_termination = true
  }

  tags {
    "Name" = "kube-controller-acc"
    "KubernetesCluster" = "acc"
  }
}

resource "aws_instance" "controller-prod" {
  ami = "${var.ami}"
  availability_zone = "${var.az-main}"
  ebs_optimized = false
  instance_type = "${var.controller-size-prod}"
  monitoring = false
  // key_name not needed, since they're baked into cloud config user_data,
  // but you can set it if you're the one
  // key_name                    = ""
  subnet_id = "${aws_subnet.main-prod.id}"
  vpc_security_group_ids = ["${aws_security_group.controller-prod.id}"]
  associate_public_ip_address = false
  private_ip = "${var.controller-ip-prod}"
  source_dest_check = true
  iam_instance_profile = "controller-prod-profile"
  user_data = "${template_file.controller-prod-user-data.rendered}"

  root_block_device {
    volume_type = "standard"
    volume_size = 30
    delete_on_termination = true
  }

  tags {
    "Name" = "kube-controller-prod"
    "KubernetesCluster" = "prod"
  }
}

resource "aws_launch_configuration" "worker-acc" {
  name_prefix = "kube-worker-acc-"
  image_id = "${var.ami}"
  ebs_optimized = false
  instance_type = "${var.worker-size-acc}"
  security_groups = ["${aws_security_group.worker-acc.id}"]
  associate_public_ip_address = true
  iam_instance_profile = "worker-acc-profile"
  user_data = "${template_file.worker-acc-user-data.rendered}"

  root_block_device {
    volume_type = "standard"
    volume_size = 200
    delete_on_termination = true
  }
}

resource "aws_launch_configuration" "worker-prod" {
  name_prefix = "kube-worker-prod-"
  image_id = "${var.ami}"
  ebs_optimized = false
  instance_type = "${var.worker-size-prod}"
  security_groups = ["${aws_security_group.worker-prod.id}"]
  associate_public_ip_address = true
  iam_instance_profile = "worker-prod-profile"
  user_data = "${template_file.worker-prod-user-data.rendered}"

  root_block_device {
    volume_type = "standard"
    volume_size = 200
    delete_on_termination = true
  }
}
