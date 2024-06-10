resource "aws_eip" "vpc_iep" {
  tags = {
    Name = format("%s-eip", var.cluster_name)
  }
}

resource "aws_nat_gateway" "nat" {
  count = length(var.public_subnet_cidr_blocks)

  allocation_id = aws_eip.vpc_iep.id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = format("%s-nat-gateway-%s", var.cluster_name, substr(var.availability_zones[count.index], -1, 1))
  }
}


resource "aws_route_table" "nat" {
  vpc_id = aws_vpc.cluster_vpc.id

  tags = {
    Name = format("%s-private-route", var.cluster_name)
  }
}

resource "aws_route" "nat_access" {
  route_table_id = aws_route_table.nat.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}
