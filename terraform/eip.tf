resource "aws_eip" "eip-controller-acc" {
  instance = "${aws_instance.controller-acc.id}"
  vpc = true
}

resource "aws_eip" "eip-controller-prod" {
  instance = "${aws_instance.controller-prod.id}"
  vpc = true
}
