resource "aws_iam_policy" "dev" {
  name = "dev"
  path = "/"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:ListAllMyBuckets",
        "s3:ListBucket",
        "s3:PutObject",
        "s3:RestoreObject"
      ],
      "Resource": ["arn:aws:s3:::yourcom-dev/*"]
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "instance-shared" {
  name = "instance-policy"
  path = "/"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:::${var.account-id}:log-group:*"
      ]
    }
  ]
}
POLICY
}

// developers need to be able to access the dev stuff, like queues and s3
resource "aws_iam_policy_attachment" "kube-developers" {
  name = "kube-developers-policy-att"
  groups = ["Developers"]
  policy_arn = "${aws_iam_policy.dev.arn}"
}

resource "aws_iam_policy_attachment" "kube-instances" {
  name = "kube-instances-policy-att"
  roles = ["kube-controller-acc-role", "kube-worker-acc-role", "kube-controller-prod-role", "kube-worker-prod-role"]
  policy_arn = "${aws_iam_policy.instance-shared.arn}"
}
