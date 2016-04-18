resource "aws_security_group" "controller-acc" {
  name = "kube-controller-acc"
  vpc_id = "${aws_vpc.vpc-acc.id}"

  tags {
    "KubernetesCluster" = "yourcom-acc"
  }
}

resource "aws_security_group" "worker-acc" {
  name = "kube-worker-acc"
  vpc_id = "${aws_vpc.vpc-acc.id}"

  tags {
    "KubernetesCluster" = "yourcom-acc"
  }
}

resource "aws_security_group_rule" "ingress-worker-to-icmp-acc" {
  type = "ingress"
  from_port = 3
  to_port = -1
  protocol = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.controller-acc.id}"
}

resource "aws_security_group_rule" "ingress-worker-to-ssh-acc" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.controller-acc.id}"
}

resource "aws_security_group_rule" "ingress-to-controller-https-acc" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.controller-acc.id}"
}

resource "aws_security_group_rule" "ingress-worker-to-etcd-acc" {
  type = "ingress"
  from_port = 2379
  to_port = 2379
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.worker-acc.id}"
  security_group_id = "${aws_security_group.controller-acc.id}"
}

resource "aws_security_group_rule" "egress-controller-to-world-tcp-acc" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.controller-acc.id}"
}

resource "aws_security_group_rule" "egress-controller-to-world-udp-acc" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.controller-acc.id}"
}

resource "aws_security_group_rule" "ingress-controller-to-icmp-acc" {
  type = "ingress"
  from_port = 3
  to_port = -1
  protocol = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.worker-acc.id}"
}

resource "aws_security_group_rule" "ingress-to-worker-ssh-acc" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.worker-acc.id}"
}

resource "aws_security_group_rule" "ingress-controller-to-cadvisor-acc" {
  type = "ingress"
  from_port = 4194
  to_port = 4194
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.controller-acc.id}"
  security_group_id = "${aws_security_group.worker-acc.id}"
}

resource "aws_security_group_rule" "ingress-worker-to-self-flannel-acc" {
  type = "ingress"
  from_port = 8285
  to_port = 8285
  protocol = "udp"
  source_security_group_id = "${aws_security_group.worker-acc.id}"
  security_group_id = "${aws_security_group.worker-acc.id}"
}

resource "aws_security_group_rule" "ingress-controller-to-flannel-acc" {
  type = "ingress"
  from_port = 8285
  to_port = 8285
  protocol = "udp"
  source_security_group_id = "${aws_security_group.controller-acc.id}"
  security_group_id = "${aws_security_group.worker-acc.id}"
}

resource "aws_security_group_rule" "ingress-controller-to-kubelet-acc" {
  type = "ingress"
  from_port = 10250
  to_port = 10250
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.controller-acc.id}"
  security_group_id = "${aws_security_group.worker-acc.id}"
}

resource "aws_security_group_rule" "ingress-worker-to-self-kubelet-readonly-acc" {
  type = "ingress"
  from_port = 10255
  to_port = 10255
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.worker-acc.id}"
  security_group_id = "${aws_security_group.worker-acc.id}"
}

resource "aws_security_group_rule" "egress-worker-to-world-tcp-acc" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.worker-acc.id}"
}

resource "aws_security_group_rule" "egress-worker-to-world-udp-acc" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.worker-acc.id}"
}
