output "rds_endpoint" {
  value = aws_db_instance.postgres_db.endpoint
}

output "rds_db_name" {
  value = aws_db_instance.postgres_db.db_name
}

output "rds_username" {
  value = aws_db_instance.postgres_db.username
}

output "rds_password" {
  value = aws_db_instance.postgres_db.password
  sensitive = true
}
