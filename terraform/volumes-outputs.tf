output "volume-mongo-acc" {
  value = "${aws_ebs_volume.mongo-acc.id}"
}

output "volume-mongo-prod" {
  value = "${aws_ebs_volume.mongo-prod.id}"
}

output "volume-registry-acc-v1" {
  value = "${aws_ebs_volume.registry-acc-v1.id}"
}

output "volume-registry-acc-v2" {
  value = "${aws_ebs_volume.registry-acc-v2.id}"
}

output "volume-registry-prod-v1" {
  value = "${aws_ebs_volume.registry-prod-v1.id}"
}

output "volume-registry-prod-v2" {
  value = "${aws_ebs_volume.registry-prod-v2.id}"
}
