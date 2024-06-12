# Blueprint Modules

## Descrição

Este repositório contém uma coleção de módulos de Terraform que podem ser usados como blocos de construção para a criação de infraestruturas na nuvem. Os módulos são projetados para serem reutilizáveis e fáceis de integrar em diferentes projetos.

## Estrutura do Repositório

- **eks/**: Módulos para configuração de clusters EKS (Elastic Kubernetes Service).
- **network/**: Módulos para configuração de redes, incluindo VPCs, subnets e regras de firewall.
- **nodes/**: Módulos para configuração de nós do eks.

## Instalação

Para usar esses módulos, clone o repositório e referencie os módulos nos seus arquivos de configuração do Terraform.

```bash
# Clone o repositório
git clone https://github.com/lguerrero-1807/blueprint-modules.git
```

## Uso

Exemplo de como utilizar os módulos `eks`, `nodes`, `prometheus` e `grafana` em seu arquivo de configuração do Terraform:

```hcl
module "network" {
  source = "git::https://github.com/lguerrero-1807/blueprint-modules.git//network"
  
  vpc_cidr = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "eks_teste" {
  depends_on = [module.network_teste]
  source = "git::https://github.com/lguerrero-1807/blueprint-modules.git//eks"

  cluster_name            = "meu-cluster-teste"
  aws_region              = "us-east-1"
  k8s_version             = "1.30"
  cluster_vpc             = module.network_teste.cluster_vpc
  private_subnet_ids      = module.network_teste.private_subnets
}

module "nodes_teste" {
  depends_on = [module.network_teste, module.eks_teste]
  source = "git::https://github.com/lguerrero-1807/blueprint-modules.git//nodes"

  cluster_name            = "meu-cluster-teste"
  aws_region              = "us-east-1"
  k8s_version             = "1.30"
  cluster_vpc             = module.network_teste.cluster_vpc
  private_subnet_ids      = module.network_teste.private_subnets
  nodes_instances_types   = ["t3a.small"]
  auto_scale_options      = {
    desired = 2
    min     = 1
    max     = 3
  }
  auto_scale_cpu = {
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

module "prometheus" {
  source                     = "git::https://github.com/lguerrero-1807/blueprint-modules.git//eks/prometheus"
  endpoint                   = module.eks_teste.endpoint
  certificate_authority_data = module.eks_teste.certificate_authority_data
  token                      = data.aws_eks_cluster_auth.cluster.token
}

module "grafana" {
  source = "git::https://github.com/lguerrero-1807/blueprint-modules.git//eks/grafana"
  endpoint                   = module.eks_teste.endpoint
  certificate_authority_data = module.eks_teste.certificate_authority_data
  token                      = data.aws_eks_cluster_auth.cluster.token
}
```