resource "aws_security_group" "controller-prod" {
  name = "kube-controller-prod"
  vpc_id = "${aws_vpc.vpc-prod.id}"

  tags {
    "KubernetesCluster" = "yourcom-prod"
  }
}

resource "aws_security_group" "worker-prod" {
  name = "kube-worker-prod"
  vpc_id = "${aws_vpc.vpc-prod.id}"

  tags {
    "KubernetesCluster" = "yourcom-prod"
  }
}

resource "aws_security_group_rule" "ingress-worker-to-icmp-prod" {
  type = "ingress"
  from_port = 3
  to_port = -1
  protocol = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.controller-prod.id}"
}

resource "aws_security_group_rule" "ingress-worker-to-ssh-prod" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.controller-prod.id}"
}

resource "aws_security_group_rule" "ingress-to-controller-https-prod" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.controller-prod.id}"
}

resource "aws_security_group_rule" "ingress-worker-to-etcd-prod" {
  type = "ingress"
  from_port = 2379
  to_port = 2379
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.worker-prod.id}"
  security_group_id = "${aws_security_group.controller-prod.id}"
}

resource "aws_security_group_rule" "egress-controller-to-world-tcp-prod" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.controller-prod.id}"
}

resource "aws_security_group_rule" "egress-controller-to-world-udp-prod" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.controller-prod.id}"
}

resource "aws_security_group_rule" "ingress-controller-to-icmp-prod" {
  type = "ingress"
  from_port = 3
  to_port = -1
  protocol = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.worker-prod.id}"
}

resource "aws_security_group_rule" "ingress-to-worker-ssh-prod" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.worker-prod.id}"
}

resource "aws_security_group_rule" "ingress-controller-to-cadvisor-prod" {
  type = "ingress"
  from_port = 4194
  to_port = 4194
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.controller-prod.id}"
  security_group_id = "${aws_security_group.worker-prod.id}"
}

resource "aws_security_group_rule" "ingress-worker-to-self-flannel-prod" {
  type = "ingress"
  from_port = 8285
  to_port = 8285
  protocol = "udp"
  source_security_group_id = "${aws_security_group.worker-prod.id}"
  security_group_id = "${aws_security_group.worker-prod.id}"
}

resource "aws_security_group_rule" "ingress-controller-to-flannel-prod" {
  type = "ingress"
  from_port = 8285
  to_port = 8285
  protocol = "udp"
  source_security_group_id = "${aws_security_group.controller-prod.id}"
  security_group_id = "${aws_security_group.worker-prod.id}"
}

resource "aws_security_group_rule" "ingress-controller-to-kubelet-prod" {
  type = "ingress"
  from_port = 10250
  to_port = 10250
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.controller-prod.id}"
  security_group_id = "${aws_security_group.worker-prod.id}"
}

resource "aws_security_group_rule" "ingress-worker-to-self-kubelet-readonly-prod" {
  type = "ingress"
  from_port = 10255
  to_port = 10255
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.worker-prod.id}"
  security_group_id = "${aws_security_group.worker-prod.id}"
}

resource "aws_security_group_rule" "egress-worker-to-world-tcp-prod" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.worker-prod.id}"
}

resource "aws_security_group_rule" "egress-worker-to-world-udp-prod" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.worker-prod.id}"
}
