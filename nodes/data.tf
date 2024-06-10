data "aws_subnets" "private_subnets" {
#  filter {
#    name   = "vpc-id"
#    values = [var.cluster_vpc]
#  }

  filter {
    name   = "tag:Name"
    values = ["*-private-*"]
  }
}
