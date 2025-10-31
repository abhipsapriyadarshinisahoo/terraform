#create vpc

resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "cust_vpc"
    }
  
}

#create subnets

resource "aws_subnet" "name-1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "my-subnet-1-pub"
    }
  
}

resource "aws_subnet" "name-2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "my-subnet-2-pvt"
    }
  
}

#create IG & attach to vpc

resource "aws_internet_gateway" "name-1" {
    vpc_id = aws_vpc.name.id
  
}

#create route table & edit routes

resource "aws_route_table" "name-1" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name = "cust_rt"
    }

    route {

        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.name-1.id
    }
  
}

#create subnet association

resource "aws_route_table_association" "name-1" {
    subnet_id = aws_subnet.name-1.id
    route_table_id = aws_route_table.name-1.id
  
}

#create sg

resource "aws_security_group" "cust_sg" {
  name   = "allow_tls"
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "cust_sg"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create sevrers  

resource "aws_instance" "public" {
    ami = "ami-0bdd88bd06d16ba03"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.name-1.id
    vpc_security_group_ids = [ aws_security_group.cust_sg.id ]
    associate_public_ip_address = true
    tags = {
      Name = "public-instance"
    }
  
}

resource "aws_instance" "pvt" {
    ami = "ami-0bdd88bd06d16ba03"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.name-2.id
    vpc_security_group_ids = [ aws_security_group.cust_sg.id ]
    
    tags = {
      Name = "pvt-instance"
    }
}

#create elastic ip

resource "aws_eip" "nat_eip" {
  domain   = "vpc"
}

#create nat gateway

resource "aws_nat_gateway" "cust_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.name-1.id

  tags = {
    Name = "cust_nat"
  }
}

#create route table & edit routes for NAT-GATEWAY

resource "aws_route_table" "name-2" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name = "pvt_rt"
    }

    route {

        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.cust_nat.id
    }
  
}

#create subnet association for NAT-GATEWAY

resource "aws_route_table_association" "pvt-association" {
    subnet_id = aws_subnet.name-2.id
    route_table_id = aws_route_table.name-2.id
  
}
