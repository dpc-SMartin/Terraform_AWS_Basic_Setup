resource "aws_vpc" "main_vpc" {
    cidr_block = "10.11.0.0/24"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "Main VPC"
    }
}

resource "aws_subnet" "main_vpc_public_1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.11.0.0/27"
    map_public_ip_on_launch = true
    availability_zone = "eu-central-1a"

    tags = {
        Name = "Main VPC Public 1"
    }
}

resource "aws_subnet" "main_vpc_routable_1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.11.0.32/27"
    map_public_ip_on_launch = false
    availability_zone = "eu-central-1a"  

    tags = {
        Name = "Main VPC Routable 1"
    }  
}

resource "aws_subnet" "main_vpc_private_1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.11.0.64/27"
    map_public_ip_on_launch = false
    availability_zone = "eu-central-1a"    

    tags = {
        Name = "Main VPC Private 1"
    }
}

resource "aws_internet_gateway" "main_vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main internet gateway"
  }
}

resource "aws_route_table" "public_main_vpc" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_vpc_igw.id
  }

  route {
    cidr_block = "10.11.0.0/24"
    gateway_id = "local"
  }

  tags = {
    Name = "Public Main VPC Route Table"
  }
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.main_vpc_public_1.id
  route_table_id = aws_route_table.public_main_vpc.id
}

resource "aws_route_table_association" "routable_subnet" {
  subnet_id      = aws_subnet.main_vpc_routable_1.id
  route_table_id = aws_route_table.public_main_vpc.id
}

resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.main_vpc_private_1.id
  route_table_id = aws_route_table.public_main_vpc.id
}