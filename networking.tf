module "vpc" {
  source                       = "terraform-aws-modules/vpc/aws"
  name                         = "example-vpc"
  cidr                         = "10.0.0.0/16"
  azs                          = local.availability_zones
  private_subnets              = var.private_subnets
  public_subnets               = var.public_subnets
  database_subnets             = var.database_subnets
  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true

  public_subnet_tags        = { Name = "example-web-subnet" }
  database_subnet_tags      = { Name = "example-db-subnet" }
  private_subnet_tags       = { Name = "example-app-subnet" }
  public_route_table_tags   = { Name = "example-public-route-table" }
  private_route_table_tags  = { Name = "example-private-route-table" }
  database_route_table_tags = { Name = "example-database-route-table" }
  igw_tags                  = { Name = "example-igw" }
  nat_gateway_tags          = { Name = "example-nat" }
  tags                      = local.tags
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name = "example-alb"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets[*]
  security_groups = [aws_security_group.example-alb-sg.id]

  target_groups = [
    {
      name             = "example-lb-target"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"

      health_check = {
        enabled  = true
        interval = 30
        path     = "/phpinfo.php"
        port     = 443
        protocol = "HTTPS"
      }

      stickiness = {
        enabled = true
        type    = "lb_cookie"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:acm:us-east-1:00000000:certificate/00000000-0000-0000-0000-00000000" #Your certificate arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  tags = local.tags
}