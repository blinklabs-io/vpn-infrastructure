module "iam_aws_lb_controller" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "${var.cluster_name}-aws-lb-controller"
  version   = "~> 5.59"

  attach_load_balancer_controller_policy = true

  // We need StringLike to use * in the namespace_service_accounts
  assume_role_condition_test = "StringLike"

  oidc_providers = {
    one = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "kube-system:*",
      ]
    }
  }
}
