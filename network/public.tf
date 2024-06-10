/*resource "aws_subnet" "public_subnet_1a" {
  vpc_id = aws_vpc.cluster_vpc.id

  cidr_block                = "10.0.0.0/20"
  map_public_ip_on_launch   = true
  availability_zone     = format("%sa", var.aws_region)

  tags = {
    "Name" = format("%s-public-1a", var.cluster_name),
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id = aws_vpc.cluster_vpc.id

  cidr_block                = "10.0.16.0/20"
  map_public_ip_on_launch   = true
  availability_zone     = format("%sc", var.aws_region)

  tags = {
    "Name" = format("%s-public-1c", var.cluster_name),
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
 */

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id = aws_vpc.cluster_vpc.id
  cidr_block = var.public_subnet_cidr_blocks[count.index]

  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = format("%s-public-%s", var.cluster_name, substr(var.availability_zones[count.index], length(var.availability_zones[count.index]) - 1, 1))
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.nat.id
}