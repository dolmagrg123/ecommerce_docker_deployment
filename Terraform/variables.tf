variable aws_access_key{
    type=string
    sensitive = true
}

variable aws_secret_key{
    type=string
    sensitive = true
}

variable region{
    default = "us-east-1"

}

variable "dockerhub_username" {
  description = "DockerHub username"
  type        = string
}

variable "dockerhub_password" {
  description = "DockerHub password"
  type        = string
  sensitive   = true
}



