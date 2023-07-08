variable "region" {
  type        = string
  description = "Region of VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDR blocks"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet CIDR blocks"
}

variable "database_subnets" {
  type        = list(string)
  description = "List of database subnet CIDR blocks"
}

variable "inst_type" {
  type        = string
  description = "Type of EC2 Instance"
  default     = "t2.micro"
}

variable "database_name" {
  type        = string
  description = "Name of the database"
}

variable "username" {
  type        = string
  description = "PhpMyAdmin login credentials Username"
}

variable "password" {
  type        = string
  description = "PhpMyAdmin login credentials Password"
}