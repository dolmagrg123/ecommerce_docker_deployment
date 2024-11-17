 output "vpc_id"{
   value = aws_vpc.vpc.id
 }
 
 output "private_subnet_1a_id"{
    value = aws_subnet.private_subnet_1a.id
 }

 output "private_subnet_1b_id"{
    value = aws_subnet.private_subnet_1b.id
 }

 output "public_subnet_1a_id"{
    value = aws_subnet.public_subnet_1a.id
 }

 output "public_subnet_1b_id"{
    value = aws_subnet.public_subnet_1b.id
 }

  output "nat_id"{
     value = aws_nat_gateway.nat_gw.id
 }



#   output "default_vpc_cidr"{
#     value = data.aws_vpc.default.cidr_block
#  }


 


