resource "aws_cloudwatch_metric_alarm" "controller-acc" {
  alarm_name = "controller-acc-health"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "2"
  metric_name = "StatusCheckFailed_System"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Minimum"
  threshold = "0"
  dimensions {
    Instance = "${aws_instance.controller-acc.id}"
  }
  alarm_description = "This cloudwatch checks for a running controller"
  alarm_actions = ["arn:aws:automate:${var.region}:ec2:recover"]
}

resource "aws_cloudwatch_metric_alarm" "controller-prod" {
  alarm_name = "controller-prod-health"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "2"
  metric_name = "StatusCheckFailed_System"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Minimum"
  threshold = "0"
  dimensions {
    Instance = "${aws_instance.controller-prod.id}"
  }
  alarm_description = "This cloudwatch checks for a running controller"
  alarm_actions = ["arn:aws:automate:${var.region}:ec2:recover"]
}

// resource "aws_cloudwatch_metric_alarm" "worker-acc" {
//     alarm_name = "kube-worker-acc-cpu"
//     comparison_operator = "GreaterThanOrEqualToThreshold"
//     evaluation_periods = "2"
//     metric_name = "CPUUtilization"
//     namespace = "AWS/EC2"
//     period = "60"
//     statistic = "Average"
//     threshold = "80"
//     dimensions {
//         AutoScalingGroupName = "${aws_autoscaling_group.worker-acc.name}"
//     }
//     alarm_description = "This cloudwatch metric monitors ec2 cpu utilization"
//     alarm_actions = ["${aws_autoscaling_policy.worker-acc.arn}"]
// }
