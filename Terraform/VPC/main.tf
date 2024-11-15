#Create a Custom VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/18"
  tags = {
    Name = "vpc"

  }
}

# Create a Public Subnet in us-east-1a

resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.az_a
  tags = {
    Name = "public_subnet_1a"
  }
}

# Create a Public Subnet in us-east-1b

resource "aws_subnet" "public_subnet_1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.az_b
  tags = {
    Name = "public_subnet_1b"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet_Gateway"
  }
}

resource "aws_route_table" "rt_pub" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "assoc_pub_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.rt_pub.id
}


resource "aws_route_table_association" "assoc_pub_1b" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.rt_pub.id
}



# Create a Private Subnet in us-east-1a

resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.az_a
  tags = {
    Name = "private_subnet_1a"
  }
}

# Create a Private Subnet in us-east-1b

resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.az_b
  tags = {
    Name = "private_subnet_1b"
  }
}

# Create an Elastic IP for the NAT Gateway

resource "aws_eip" "nat_eip" {
  # instance = aws_instance.web.id
  domain   = "vpc"
  tags = {
    Name = "NAT_EIP"
  }

  # depends_on = [ aws_internet_gateway.gw ]
}

# Create the NAT Gateway in the public subnet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1a.id
  tags = {
    Name = "NAT_Gateway"
  }
}


#private subnet route table
resource "aws_route_table" "rt_pri" {
  vpc_id = aws_vpc.vpc.id

  route {
  cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "private_route_table"
  }
}

#private subnet route association
resource "aws_route_table_association" "assoc_private_1a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.rt_pri.id
}



#private subnet route association
resource "aws_route_table_association" "assoc_private_1b" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.rt_pri.id
}


#pull the data to get default vpc id
data "aws_vpc" "default" {
  default = true
}

# Create the VPC peering connection
resource "aws_vpc_peering_connection" "peer_connection" {
  vpc_id        = data.aws_vpc.default.id            
  peer_vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = "VPC peering"
  }
}

#Accept VPC peering
resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_connection.id
  auto_accept               = true

  tags = {
    Name = "custom-to-default-peering-accepted"
  }
}

# Route from custom VPC to default VPC
resource "aws_route" "custom_vpc_to_default_vpc" {
  route_table_id         = aws_route_table.rt_pri.id  # Replace with custom VPC route table ID
  destination_cidr_block = data.aws_vpc.default.cidr_block            # Default VPC CIDR block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_connection.id
}

data "aws_route_table" "default" {
  vpc_id = data.aws_vpc.default.id
}
# Route from default VPC to custom VPC
resource "aws_route" "custom_to_default" {
  route_table_id         = data.aws_route_table.default.id            # Default VPC route table
  destination_cidr_block = "10.0.0.0/18"                  # Custom VPC CIDR block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_connection.id
}

resource "aws_security_group_rule" "allow_http_from_default_vpc" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.default.cidr_block]  # Allow traffic from the default VPC CIDR block
  security_group_id = var.backend_sg_id
}




