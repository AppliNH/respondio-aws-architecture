resource "aws_iam_instance_profile" "vm_instance_profile" {
  role = var.app_role_name
}

resource "aws_security_group" "vm_sg" {
  name_prefix = "${var.context_name}-vm-sg-"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = var.app_ingress.from_port
    to_port     = var.app_ingress.to_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    APP   = var.context_name
    STAGE = var.stage
  }
}

resource "aws_launch_template" "vm_template" {
  name_prefix   = "${var.context_name}-vm-"
  image_id      = var.image_id
  instance_type = var.instance_type



  vpc_security_group_ids = [aws_security_group.vm_sg.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.vm_instance_profile.arn
  }

  tags = {
    APP   = var.context_name
    STAGE = var.stage
  }
}



resource "aws_autoscaling_group" "vm_scale_group" {
  name = "${var.context_name}-vm-scale-group"

  max_size                  = var.sizes.max_size
  min_size                  = var.sizes.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.sizes.desired_capacity
  force_delete              = true
  vpc_zone_identifier       = var.subnet_ids


  launch_template {
    id      = aws_launch_template.vm_template.id
    version = "$Latest"
  }


  tag {
    key                 = "APP"
    value               = var.context_name
    propagate_at_launch = true
  }

  tag {
    key                 = "STAGE"
    value               = var.stage
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

}
