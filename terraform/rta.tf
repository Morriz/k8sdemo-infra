resource "aws_route_table_association" "rta-subnet-main-acc" {
  subnet_id = "${aws_subnet.main-acc.id}"
  route_table_id = "${aws_route_table.rtb-acc.id}"
}

resource "aws_route_table_association" "rta-subnet-failover-acc" {
  subnet_id = "${aws_subnet.failover-acc.id}"
  route_table_id = "${aws_route_table.rtb-acc.id}"
}

resource "aws_route_table_association" "rta-subnet-main-prod" {
  subnet_id = "${aws_subnet.main-prod.id}"
  route_table_id = "${aws_route_table.rtb-prod.id}"
}

resource "aws_route_table_association" "rta-subnet-failover-prod" {
  subnet_id = "${aws_subnet.failover-prod.id}"
  route_table_id = "${aws_route_table.rtb-prod.id}"
}
