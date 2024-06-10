/*resource "aws_subnet" "private_subnet_1a" {
  vpc_id = aws_vpc.cluster_vpc.id
  cidr_block = "10.0.32.0/20"

  availability_zone = format("%sa", var.aws_region)

  tags = {
    Name = format("%s-private-1a", var.cluster_name),
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id = aws_vpc.cluster_vpc.id
  cidr_block = "10.0.48.0/20"

  availability_zone = format("%sc", var.aws_region)

  tags = {
    Name = format("%s-private-1c", var.cluster_name),
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
 */

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id = aws_vpc.cluster_vpc.id
  cidr_block = var.private_subnet_cidr_blocks[count.index]

  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = format("%s-private-%s", var.cluster_name, substr(var.availability_zones[count.index], -1))
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}


resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.nat.id
}