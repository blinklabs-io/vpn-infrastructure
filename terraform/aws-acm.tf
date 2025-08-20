module "aws_acm" {
  source = "./modules/aws_acm"

  certificates = try(local.env_vars.aws.acm.certificates, [])
}
