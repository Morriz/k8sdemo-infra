resource "aws_ebs_volume" "mongo-acc" {
  availability_zone = "${var.az-main}"
  size = 1
  type = "gp2"
  tags {
    Name = "mongo-acc"
  }
}

resource "aws_ebs_volume" "mongo-prod" {
  availability_zone = "${var.az-main}"
  size = 5
  type = "gp2"
  tags {
    Name = "mongo-prod"
  }
}

resource "aws_ebs_volume" "registry-acc-v1" {
  availability_zone = "${var.az-main}"
  size = 1
  type = "gp2"
  tags {
    Name = "registry-acc-v1"
  }
}

resource "aws_ebs_volume" "registry-acc-v2" {
  availability_zone = "${var.az-main}"
  size = 50
  type = "gp2"
  tags {
    Name = "registry-acc-v2"
  }
}

resource "aws_ebs_volume" "registry-prod-v1" {
  availability_zone = "${var.az-main}"
  size = 1
  type = "gp2"
  tags {
    Name = "registry-prod-v1"
  }
}

resource "aws_ebs_volume" "registry-prod-v2" {
  availability_zone = "${var.az-main}"
  size = 50
  type = "gp2"
  tags {
    Name = "registry-prod-v2"
  }
}
