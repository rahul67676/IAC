resource "aws_vpc" "vcube150" {
  cidr_block       = "10.0.0.0/16"
  region      = "us-east-1"

  tags = {
    Name = "vcube150"
  }
}
resource "aws_subnet" "public_subnet" {
    vpc_id      = aws_vpc.vcube150.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "public_subnet"
    }
}
resource "aws_subnet" "private_subnet" {
    vpc_id   = aws_vpc.vcube150.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "private_subnet"
    }
}
 resource "aws_internet_gateway" "igw" {
     vpc_id = aws_vpc.vcube150.id
    tags = {
        Name = "igw"
    }
}
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vcube150.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "public_rt"
    }
}
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.vcube150.id
    tags = {
        Name = "private_rt"
    }
}
resource "aws_route_table_association" "public_subnet" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id

}
resource "aws_route_table_association" "private_subnet" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
}
resource "aws_instance" "servers" {
  for_each = {
    web1 = aws_subnet.public_subnet.id
    web2 = aws_subnet.public_subnet.id
    web3 = aws_subnet.private_subnet.id
  }

  ami           = "ami-0152204c1a187337c"
  instance_type = "t3.micro"
  subnet_id     = each.value
  key_name      = "vcube150efs"

  tags = {
    Name = each.key
  }
}
