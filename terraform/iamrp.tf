resource "aws_iam_role_policy" "controller-acc" {
  name = "kube-controller-acc-role-policy"
  role = "kube-controller-acc-role"
  policy = "${trimspace(file("./iam/role-policy-controller.json"))}"
}

resource "aws_iam_role_policy" "controller-prod" {
  name = "kube-controller-prod-role-policy"
  role = "kube-controller-prod-role"
  policy = "${trimspace(file("./iam/role-policy-controller.json"))}"
}

resource "aws_iam_role_policy" "worker-acc" {
  name = "kube-worker-acc-role-policy"
  role = "kube-worker-acc-role"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Resource": "*",
            "Action": "ec2:Describe*",
            "Effect": "Allow"
        },
        {
            "Resource": "*",
            "Action": "ec2:AttachVolume",
            "Effect": "Allow"
        },
        {
            "Resource": "*",
            "Action": "ec2:DetachVolume",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:BatchGetImage"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "route53:ListHostedZonesByName",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:DescribeLoadBalancers",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "route53:ChangeResourceRecordSets",
            "Resource": "*"
        },
        {
            "Resource": "arn:aws:s3:::yourcom-acc/*",
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:RestoreObject"
            ]
        },
        {
            "Resource": "arn:aws:s3:::yourcom-registry/*",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy" "worker-prod" {
  name = "kube-worker-prod-role-policy"
  role = "kube-worker-prod-role"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Resource": "*",
            "Action": "ec2:Describe*",
            "Effect": "Allow"
        },
        {
            "Resource": "*",
            "Action": "ec2:AttachVolume",
            "Effect": "Allow"
        },
        {
            "Resource": "*",
            "Action": "ec2:DetachVolume",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:BatchGetImage"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "route53:ListHostedZonesByName",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:DescribeLoadBalancers",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "route53:ChangeResourceRecordSets",
            "Resource": "*"
        },
        {
            "Resource": "arn:aws:s3:::yourcom-prod/*",
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:RestoreObject"
            ]
        },
        {
            "Resource": "arn:aws:s3:::yourcom-registry/*",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ]
        }
    ]
}
POLICY
}
