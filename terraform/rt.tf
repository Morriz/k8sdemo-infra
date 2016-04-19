resource "aws_route_table" "rtb-acc" {
  vpc_id = "${aws_vpc.vpc-acc.id}"
//  propagating_vgws = []

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-acc.id}"
  }

  tags {
    "Name" = "rtb-acc"
    "KubernetesCluster" = "yourcom-acc"
  }
}

resource "aws_route_table" "rtb-prod" {
  vpc_id = "${aws_vpc.vpc-prod.id}"
//  propagating_vgws = []

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-prod.id}"
  }

  tags {
    "Name" = "rtb-prod"
    "KubernetesCluster" = "yourcom-prod"
  }
}
