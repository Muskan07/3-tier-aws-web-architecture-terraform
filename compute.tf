module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "example-asg"

  min_size            = 2
  max_size            = 5
  desired_capacity    = 2
  health_check_type   = "EC2"
  vpc_zone_identifier = module.vpc.private_subnets

  launch_template_name        = "ec2-lauch-template"
  launch_template_description = "ec2 launch template"
  user_data                   = base64encode(templatefile("userdata.tftpl", { db_name = module.db.db_instance_address }))
  instance_type               = var.inst_type
  image_id                    = data.aws_ami.ami_id.id
  security_groups             = [aws_security_group.example-app-sg.id]

  create_iam_instance_profile = true
  iam_role_name               = "example-asg-role"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role example"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = local.tags

  tag_specifications = [{
    resource_type = "instance"
    tags          = local.tags
  }]
}

resource "aws_autoscaling_attachment" "asg_attachment_elb" {
  autoscaling_group_name = module.asg.autoscaling_group_id
  lb_target_group_arn    = module.alb.target_group_arns[0]
}