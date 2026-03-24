module "aws_iam" {
  source = "git::https://github.com/blinklabs-io/terraform-modules.git//aws_iam"

  users    = try(local.env_vars.aws.iam.users, [])
  policies = try(local.env_vars.aws.iam.policies, [])
}

data "aws_eks_cluster" "this" {
  for_each = { for c in try(local.env_vars.aws.clusters, {}) : c.name => c }
  name     = each.value.name

  depends_on = [module.eks]
}

data "aws_iam_openid_connect_provider" "eks" {
  for_each = { for c in try(local.env_vars.aws.clusters, {}) : c.name => c }
  url      = data.aws_eks_cluster.this[each.key].identity[0].oidc[0].issuer
}

resource "aws_iam_policy" "external_dns" {
  name        = "external-dns-route53-access"
  description = "Allows external-dns to manage Route53 records in b7s.services zone"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
        ]
        Resource = "arn:aws:route53:::hostedzone/*"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource",
        ]
        Resource = "*"
      },
    ]
  })
}

module "external_dns_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  for_each = { for c in try(local.env_vars.aws.clusters, {}) : c.name => c }

  role_name = "${each.value.name}-external-dns"

  oidc_providers = {
    main = {
      provider_arn               = data.aws_iam_openid_connect_provider.eks[each.key].arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }

  role_policy_arns = {
    external_dns = aws_iam_policy.external_dns.arn
  }
}

# Automatically import IAM user access keys by ID
# This can't be in the module, so we put it here
import {
  for_each = merge(flatten([
    for user in try(local.env_vars.aws.iam.users, []) : [
      for access_key in user.access_keys : {
        "${user.name}-${access_key.id}" = {
          user   = user.name
          key_id = access_key.id
        }
      }
    ]
  ])...)

  id = each.value.key_id
  to = module.aws_iam.aws_iam_access_key.iam_user[each.key]
}
