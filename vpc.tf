 # Creates a vcp resource
 resource "aws_vpc" "custom-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  enable_classiclink = false
  tags = {
    Name = "custom-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "customvpc-public-1" {
  vpc_id     = aws_vpc.custom-vpc.id
  cidr_block = "10.0.101.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-3a"
  tags = {
    Name = "customvpc-public-1"
  }
}

resource "aws_subnet" "customvpc-public-2" {
  vpc_id     = aws_vpc.custom-vpc.id
  cidr_block = "10.0.102.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-3b"
  tags = {
    Name = "customvpc-public-2"
  }
}

# Private Subnets
resource "aws_subnet" "customvpc-private-1" {
  vpc_id     = aws_vpc.custom-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone = "eu-west-3a"
  tags = {
    Name = "customvpc-private-1"
  }
}

resource "aws_subnet" "customvpc-private-2" {
  vpc_id     = aws_vpc.custom-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone = "eu-west-3b"
  tags = {
    Name = "customvpc-private-2"
  }
}
# internet gateway
resource "aws_internet_gateway" "customvpc-gw" {
  vpc_id = aws_vpc.custom-vpc.id

  tags = {
    Name = "customvpc-gw"
  }
}

# route table
resource "aws_route_table" "customvpc-rt-public" {
  vpc_id = aws_vpc.custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.customvpc-gw.id
  }
  tags = {
    Name = "customvpc-rt-public"
  }
}

# route table association
resource "aws_route_table_association" "customvpc-public-1-a" {
  subnet_id      = aws_subnet.customvpc-public-1.id
  route_table_id = aws_route_table.customvpc-rt-public.id
}

resource "aws_route_table_association" "customvpc-public-2-a" {
  subnet_id      = aws_subnet.customvpc-public-2.id
  route_table_id = aws_route_table.customvpc-rt-public.id
}
