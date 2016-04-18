provider "aws" {
  region = "${var.region}"
}

variable "region" {
  default = "eu-central-1"
}

variable "account-id" {
  default = "309744584379"
}

variable "ami" {
  default = "ami-9db652f2"
}

variable "worker-size-acc" {
  default = "c4.large"
}

variable "worker-size-prod" {
  default = "c4.large"
}

variable "k8s-ver-acc" {
  default = "v1.2.2"
}

variable "k8s-ver-prod" {
  default = "v1.2.2"
}

variable "az-main" {
  default = "eu-central-1a"
}

variable "az-failover" {
  default = "eu-central-1b"
}

variable "az-main-cidr-acc" {
  default = "172.20.0.0/24"
}

variable "az-main-cidr-prod" {
  default = "172.21.0.0/24"
}

variable "az-failover-cidr-acc" {
  default = "172.20.1.0/24"
}

variable "az-failover-cidr-prod" {
  default = "172.21.1.0/24"
}

variable "vpc-cidr-acc" {
  default = "172.20.0.0/16"
}

variable "vpc-cidr-prod" {
  default = "172.21.0.0/16"
}

variable "controller-ip-acc" {
  default = "172.20.0.50"
}

variable "controller-ip-prod" {
  default = "172.21.0.50"
}

variable "pod-network-acc" {
  default = "172.22.0.0/16"
}

variable "pod-network-prod" {
  default = "172.24.0.0/16"
}

variable "service-network-acc" {
  default = "172.23.0.0/24"
}

variable "service-network-prod" {
  default = "172.25.0.0/24"
}

variable "k8s-service-ip-acc" {
  default = "172.23.0.1"
}

variable "k8s-service-ip-prod" {
  default = "172.25.0.1"
}

variable "dns-service-ip-acc" {
  default = "172.23.0.10"
}

variable "dns-service-ip-prod" {
  default = "172.25.0.10"
}

variable "artifact-url-acc" {
  default = "https://yourcom-infra.s3.amazonaws.com/acc"
}

variable "artifact-url-prod" {
  default = "https://yourcom-infra.s3.amazonaws.com/prod"
}
