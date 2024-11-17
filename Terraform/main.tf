
# Configure the AWS provider block. This tells Terraform which cloud provider to use and 
# how to authenticate (access key, secret key, and region) when provisioning resources.
# Note: Hardcoding credentials is not recommended for production use. Instead, use environment variables
# or IAM roles to manage credentials securely.

# - 1x Custom VPC in us-east-1
# - 2x Availability zones in us-east-1a and us-east-1b
# - A private and public subnet in EACH AZ
# - An EC2 in each subnet (EC2s in the public subnets are for the bastion host, 
# the EC2s in the private subnets are for the front AND backend containers of the application) 
# Name the EC2's: "ecommerce_bastion_az1", "ecommerce_app_az1", "ecommerce_bastion_az2", "ecommerce_app_az2"
# - A load balancer that will direct the inbound traffic to either of the public subnets.
# - An RDS databse


provider "aws" {
  region     = var.region          # Specify the AWS region where resources will be created (e.g., us-east-1, us-west-2)
}

module "VPC" {
  source = "./VPC"
  backend_sg_id = module.EC2.backend_sg_id
}

module "EC2"{
  source = "./EC2"
  vpc_id = module.VPC.vpc_id
  private_subnet_1a_id = module.VPC.private_subnet_1a_id
  private_subnet_1b_id = module.VPC.private_subnet_1b_id
  public_subnet_1a_id  = module.VPC.public_subnet_1a_id
  public_subnet_1b_id  = module.VPC.public_subnet_1b_id
  dockerhub_username = var.dockerhub_username
  dockerhub_password = var.dockerhub_password
  rds_endpoint = module.RDS.rds_endpoint
  rds_id = module.RDS.rds_id
  nat_id = module.VPC.nat_id
 
}

module "LB" {
  source = "./LB"
  vpc_id = module.VPC.vpc_id
  public_subnet_1a_id = module.VPC.public_subnet_1a_id
  public_subnet_1b_id = module.VPC.public_subnet_1b_id
  frontend_sg_id = module.EC2.frontend_sg_id
  eecommerce_bastion_az1_id = module.EC2.eecommerce_bastion_az1_id
  ecommerce_bastion_az2_id = module.EC2.ecommerce_bastion_az2_id
}

module "RDS"{
  source = "./RDS"
  vpc_id = module.VPC.vpc_id
  private_subnet_1a_id = module.VPC.private_subnet_1a_id
  private_subnet_1b_id = module.VPC.private_subnet_1b_id
  backend_sg_id = module.EC2.backend_sg_id
  # default_vpc_cidr = module.VPC.default_vpc_cidr

}




