
output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.rds.address
  sensitive   = false
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.rds.port
  sensitive   = false
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.rds.username
  sensitive   = false
}

output "random_pet_name" {
  description = "Value of random pet name in configuration"
  value = random_pet.name.id
}
