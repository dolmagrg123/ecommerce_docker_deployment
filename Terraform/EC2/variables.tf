variable instance_type{
    default = "t3.micro"
}

variable vpc_id{}
variable private_subnet_1a_id{}
variable private_subnet_1b_id{}
variable public_subnet_1a_id{}
variable public_subnet_1b_id{}

variable dockerhub_username{}
variable dockerhub_password{}

variable rds_endpoint{}
variable rds_id{}
variable nat_id{}

variable "latest_version" {
  description = "The latest version of the application"
  type        = string
  default = "1.0.0"
}
