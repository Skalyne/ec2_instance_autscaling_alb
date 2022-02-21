data "aws_availability_zones" "available" {}
# Define AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}
resource "aws_key_pair" "my_aws_key" {
  key_name   = "my_aws_key"
  public_key = var.PUBLIC_KEY
}

# autoscaling launch configuration
resource "aws_launch_configuration" "custom-launch-config" {
  name          = "custom-launch-config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.custom-elb-sg.id]
  key_name = aws_key_pair.my_aws_key.key_name
  user_data = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYDATA=$(ifconfig)\necho '<h2> Webserver with autoscaling in a Load Balancer IP</h2><br>made by Theo Kratz <br>It is beeing fun<br> data:'$MYDATA > /var/www/html/index.html"

  lifecycle {
    create_before_destroy = true
  }
}
# auto scaling group
resource "aws_autoscaling_group" "custom-ASG" {
  name                      = "custom-ASG"
  vpc_zone_identifier       = [aws_subnet.customvpc-public-1.id,aws_subnet.customvpc-public-2.id]
  launch_configuration      = aws_launch_configuration.custom-launch-config.name
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "ELB"
  load_balancers = [aws_elb.custom-elb.name]
  force_delete              = true
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "Custom_ec2_instance"
    propagate_at_launch = true
  }
}

output "elb" {
  value = aws_elb.custom-elb.dns_name
}
# autoscaling_policy

resource "aws_autoscaling_policy" "custom-autoscaling-policy" {
  name                   = "custom-autoscaling-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.custom-ASG.name
  policy_type = "SimpleScaling"
}

# cloud wach monitoring
resource "aws_cloudwatch_metric_alarm" "custom-cpu-alarm" {
  alarm_name                = "custom-cpu-alarm"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "80"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.custom-ASG.name
  }

  alarm_actions     = [aws_autoscaling_policy.custom-autoscaling-policy.arn]
}

# auto_descaling_policy
resource "aws_autoscaling_policy" "custom-autoscaling-policy-scaledown" {
  name                   = "custom-autoscaling-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 40
  autoscaling_group_name = aws_autoscaling_group.custom-ASG.name
  policy_type = "SimpleScaling"
}
# cloud descaling wach monitoring

resource "aws_cloudwatch_metric_alarm" "custom-cpu-alarm-scaledown" {
  alarm_name                = "custom-cpu-alarm"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "60"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.custom-ASG.name
  }
  alarm_actions     = [aws_autoscaling_policy.custom-autoscaling-policy-scaledown.arn]
}