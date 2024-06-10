variable "aws_region" {}

variable "cluster_name" {}

variable "k8s_version" {}

variable "cluster_vpc" {}

#variable "private_subnet_1a" {}

#variable "private_subnet_1c" {}

#variable "eks_cluster" {}

#variable "eks_cluster_sg" {}

variable "nodes_instances_types" {}

variable "auto_scale_options" {
  type = map(number)
  default = {
    desired = 1
    min     = 1
    max     = 3
  }
}

variable "auto_scale_cpu" {
  type = map(number)
  default = {
    scale_up_cooldown     = 300
    scale_up_add          = 1
    scale_up_evaluation   = 1
    scale_up_period       = 300
    scale_up_threshold    = 60
    scale_down_cooldown   = 300
    scale_down_remove     = -1
    scale_down_evaluation = 1
    scale_down_period     = 300
    scale_down_threshold  = 40
  }
}




