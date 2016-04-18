resource "aws_autoscaling_notification" "scaling-notifications" {
  group_names = [
    "${aws_autoscaling_group.worker-acc.name}",
    "${aws_autoscaling_group.worker-prod.name}"
  ]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"
  ]
  topic_arn = "${aws_sns_topic.infra.arn}"
}

resource "aws_sns_topic" "infra" {
  name = "infra-topic"
}
