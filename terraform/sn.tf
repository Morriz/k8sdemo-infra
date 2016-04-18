resource "aws_subnet" "main-acc" {
  vpc_id = "${aws_vpc.vpc-acc.id}"
  cidr_block = "${var.az-main-cidr-acc}"
  availability_zone = "${var.az-main}"
  map_public_ip_on_launch = true

  tags {
    "Name" = "subnet-main-acc"
    "KubernetesCluster" = "yourcom-acc"
  }
}

resource "aws_subnet" "failover-acc" {
  vpc_id = "${aws_vpc.vpc-acc.id}"
  cidr_block = "${var.az-failover-cidr-acc}"
  availability_zone = "${var.az-failover}"
  map_public_ip_on_launch = true

  tags {
    "Name" = "subnet-failover-acc"
    "KubernetesCluster" = "yourcom-acc"
  }
}

resource "aws_subnet" "main-prod" {
  vpc_id = "${aws_vpc.vpc-prod.id}"
  cidr_block = "${var.az-main-cidr-prod}"
  availability_zone = "${var.az-main}"
  map_public_ip_on_launch = true

  tags {
    "Name" = "subnet-main-prod"
    "KubernetesCluster" = "yourcom-prod"
  }
}

resource "aws_subnet" "failover-prod" {
  vpc_id = "${aws_vpc.vpc-prod.id}"
  cidr_block = "${var.az-failover-cidr-prod}"
  availability_zone = "${var.az-failover}"
  map_public_ip_on_launch = true

  tags {
    "Name" = "subnet-failover-prod"
    "KubernetesCluster" = "yourcom-prod"
  }
}
