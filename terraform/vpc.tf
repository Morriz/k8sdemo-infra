resource "aws_vpc" "vpc-acc" {
  cidr_block = "${var.vpc-cidr-acc}"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags {
    "Name" = "vpc-acc"
    "KubernetesCluster" = "yourcom-acc"
  }
}

resource "aws_vpc" "vpc-prod" {
  cidr_block = "${var.vpc-cidr-prod}"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags {
    "Name" = "vpc-prod"
    "KubernetesCluster" = "yourcom-prod"
  }
}
