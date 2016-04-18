resource "aws_network_acl" "acl-acc" {
  vpc_id = "${aws_vpc.vpc-acc.id}"
  subnet_ids = ["${aws_subnet.main-acc.id}"]//, "${aws_subnet.failover-acc.id}"]

  ingress {
    from_port = 0
    to_port = 0
    rule_no = 100
    action = "allow"
    protocol = "-1"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    from_port = 0
    to_port = 0
    rule_no = 100
    action = "allow"
    protocol = "-1"
    cidr_block = "0.0.0.0/0"
  }

  tags {
  }
}

resource "aws_network_acl" "acl-prod" {
  vpc_id = "${aws_vpc.vpc-prod.id}"
  subnet_ids = ["${aws_subnet.main-prod.id}"]//, "${aws_subnet.failover-prod.id}"]

  ingress {
    from_port = 0
    to_port = 0
    rule_no = 100
    action = "allow"
    protocol = "-1"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    from_port = 0
    to_port = 0
    rule_no = 100
    action = "allow"
    protocol = "-1"
    cidr_block = "0.0.0.0/0"
  }

  tags {
  }
}
