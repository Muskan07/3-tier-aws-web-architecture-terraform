resource "aws_security_group" "example-alb-sg" {
  name        = "example-alb-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.example-app-sg.id]
  }

  tags = {
    "Name" = "example-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "example-app-sg" {
  security_group_id            = aws_security_group.example-app-sg.id
  referenced_security_group_id = aws_security_group.example-alb-sg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}


resource "aws_security_group" "example-app-sg" {
  name        = "example-app-sg"
  description = "Allow HTTP traffic from alb to PHP servers"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "example-app-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "example-db-sg" {
  security_group_id            = aws_security_group.example-db-sg.id
  referenced_security_group_id = aws_security_group.example-app-sg.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}

resource "aws_security_group" "example-db-sg" {
  name        = "example-db-sg"
  description = "Allow MySQL traffic from app instances"
  vpc_id      = module.vpc.vpc_id

  tags = {
    "Name" = "example-db-sg"
  }
}