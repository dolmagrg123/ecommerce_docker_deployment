 output "frontend_sg_id"{
   value = aws_security_group.frontend_sg.id
 }

 output "backend_sg_id"{
   value = aws_security_group.backend_sg.id
 }

#  output "eecommerce_bastion_az1_id"{
#    value = aws_instance.ecommerce_bastion_az1.id
#  }
#  output "ecommerce_bastion_az2_id"{
#    value = aws_instance.ecommerce_bastion_az2.id
#  }
 output "eecommerce_app_az1_id"{
   value = aws_instance.ecommerce_app_az1.id
 }
 output "ecommerce_app_az2_id"{
   value = aws_instance.ecommerce_app_az2.id
 }


 output "backend_private_ip" {
  value = aws_instance.ecommerce_app_az1.private_ip
}
 