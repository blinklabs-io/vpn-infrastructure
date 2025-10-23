module "eks" {
  source = "git::https://github.com/blinklabs-io/terraform-modules.git//aws_eks"

  for_each        = { for c in try(local.env_vars.aws.clusters, {}) : c.name => c }
  cluster_name    = each.value.name
  cluster_version = try(each.value.cluster_version, "1.34")
  cidr            = try(each.value.cidr, "10.10.0.0/16")
  azs             = try(each.value.azs, ["us-east-1a", "us-east-1b", "us-east-1d"])
  public_subnets  = try(each.value.public_subnets, ["10.10.0.0/20", "10.10.16.0/20", "10.10.32.0/20"])
  private_subnets = try(each.value.private_subnets, [])
  tags            = try(each.value.tags, null)
  node_groups     = try(each.value.node_groups, null)
}
