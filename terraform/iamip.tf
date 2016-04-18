resource "aws_iam_instance_profile" "controller-acc" {
  name = "controller-acc-profile"
  path = "/"
  roles = ["${aws_iam_role.controller-acc.name}"]
}

resource "aws_iam_instance_profile" "worker-acc" {
  name = "worker-acc-profile"
  path = "/"
  roles = ["${aws_iam_role.worker-acc.name}"]
}

resource "aws_iam_instance_profile" "controller-prod" {
  name = "controller-prod-profile"
  path = "/"
  roles = ["${aws_iam_role.controller-prod.name}"]
}

resource "aws_iam_instance_profile" "worker-prod" {
  name = "worker-prod-profile"
  path = "/"
  roles = ["${aws_iam_role.worker-prod.name}"]
}
