resource "aws_internet_gateway" "igw-acc" {
  vpc_id = "${aws_vpc.vpc-acc.id}"

  tags {
    "Name" = "igw-acc"
    "KubernetesCluster" = "yourcom-acc"
  }
}

resource "aws_internet_gateway" "igw-prod" {
  vpc_id = "${aws_vpc.vpc-prod.id}"

  tags {
    "Name" = "igw-prod"
    "KubernetesCluster" = "yourcom-prod"
  }
}
