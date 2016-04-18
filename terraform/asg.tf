resource "aws_autoscaling_group" "worker-acc" {
  name = "kube-worker-acc"
  desired_capacity = 1
  health_check_grace_period = 600
  health_check_type = "EC2"
  launch_configuration = "${aws_launch_configuration.worker-acc.name}"
  max_size = 2
  min_size = 1
  name = "kube-worker-acc"
  vpc_zone_identifier = ["${aws_subnet.main-acc.id}"]

  tag {
    key = "KubernetesCluster"
    value = "acc"
    propagate_at_launch = true
  }
  tag {
    key = "Name"
    value = "kube-worker-acc"
    propagate_at_launch = true
  }
}

// resource "aws_autoscaling_policy" "worker-acc" {
//     name = "kube-worker-acc-capacity"
//     scaling_adjustment = 1
//     adjustment_type = "ChangeInCapacity"
//     cooldown = 300
//     autoscaling_group_name = "${aws_autoscaling_group.worker-acc.name}"
// }

resource "aws_autoscaling_group" "worker-prod" {
  name = "kube-worker-prod"
  desired_capacity = 1
  health_check_grace_period = 600
  health_check_type = "EC2"
  launch_configuration = "${aws_launch_configuration.worker-prod.name}"
  max_size = 2
  min_size = 1
  name = "kube-worker-prod"
  vpc_zone_identifier = ["${aws_subnet.main-prod.id}"]

  tag {
    key = "KubernetesCluster"
    value = "prod"
    propagate_at_launch = true
  }
  tag {
    key = "Name"
    value = "kube-worker-prod"
    propagate_at_launch = true
  }
}
