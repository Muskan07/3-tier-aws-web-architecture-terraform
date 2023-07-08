locals {
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  tags = {
    Name        = "my-example-vpc"
    Owner       = "your-name"
    Environment = "dev"
  }
}