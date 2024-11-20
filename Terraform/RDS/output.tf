output "rds_id" {
  value = aws_db_instance.main.id
}
output "rds_endpoint" {
  value = aws_db_instance.main.address
}

output "rds_db_name" {
  value = aws_db_instance.main.db_name
}

output "rds_username" {
  value = aws_db_instance.main.username
}

output "rds_password" {
  value = aws_db_instance.main.password
  sensitive = true
}
