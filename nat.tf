# PRivate subnets configuration
resource "aws_eip" "customvpc-nat" {
    vpc = true
}
resource "aws_nat_gateway" "customvpc-nat-gw" {
    allocation_id = aws_eip.customvpc-nat.id
    subnet_id = aws_subnet.customvpc-public-1.id
    depends_on = [aws_internet_gateway.customvpc-gw]
}

# route table
resource "aws_route_table" "customvpc-rt-private" {
  vpc_id = aws_vpc.custom-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.customvpc-nat-gw.id
  }
  tags = {
    Name = "customvpc-rt-private"
  }
}

# route table association
resource "aws_route_table_association" "customvpc-private-1-a" {
  subnet_id      = aws_subnet.customvpc-private-1.id
  route_table_id = aws_route_table.customvpc-rt-private.id
}
