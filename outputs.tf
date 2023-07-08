output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}
output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "VPC public subnets' IDs list"
}
output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "VPC private subnets' IDs list"
}
output "database_subnets" {
  value       = module.vpc.database_subnets
  description = "VPC database private subnets' IDs list"
}
output "rds-output" {
  value       = module.db.db_instance_endpoint
  description = "RDS database instance endpoint"
}