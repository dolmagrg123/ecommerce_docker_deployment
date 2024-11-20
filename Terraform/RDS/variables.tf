variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  default     = "ecommerce"
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "userdb"
}

variable "db_password" {
  description = "Password for the master DB user"
  type        = string
  default     = "abcd1234"
}

variable "private_subnet_1a_id" {}
variable "private_subnet_1b_id" {}
variable "vpc_id" {}
variable "backend_sg_id" {}
# variable default_vpc_cidr{}


