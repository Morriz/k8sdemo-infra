resource "aws_iam_role" "controller-acc" {
  name = "kube-controller-acc-role"
  path = "/"
  assume_role_policy = "${trimspace(file("./iam/role-policy.json"))}"
}

resource "aws_iam_role" "controller-prod" {
  name = "kube-controller-prod-role"
  path = "/"
  assume_role_policy = "${trimspace(file("./iam/role-policy.json"))}"
}

resource "aws_iam_role" "worker-acc" {
  name = "kube-worker-acc-role"
  path = "/"
  assume_role_policy = "${trimspace(file("./iam/role-policy.json"))}"
}

resource "aws_iam_role" "worker-prod" {
  name = "kube-worker-prod-role"
  path = "/"
  assume_role_policy = "${trimspace(file("./iam/role-policy.json"))}"
}
