resource "aws_s3_bucket" "yourcom-dev" {
  bucket = "yourcom-dev"
  acl = "private"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "AWS": "*"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::yourcom-dev/*"
    }]
}
POLICY
}

resource "aws_s3_bucket" "yourcom-acc" {
  bucket = "yourcom-acc"
  acl = "private"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity XXXXXX"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::yourcom-acc/*"
    }]
}
POLICY
}

resource "aws_s3_bucket" "yourcom-prod" {
  bucket = "yourcom-prod"
  acl = "private"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "2",
        "Effect": "Allow",
        "Principal": {
            "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity XXXXXX"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::yourcom-prod/*"
    }]
}
POLICY
}

resource "aws_s3_bucket" "yourcom-infra" {
  bucket = "yourcom-infra"
  acl = "private"
}
