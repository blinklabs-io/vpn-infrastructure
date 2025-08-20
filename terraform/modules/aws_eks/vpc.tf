module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  create_vpc = true

  name = "${var.cluster_name}-eks-vpc"
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  enable_nat_gateway = false

  tags = var.tags
}
