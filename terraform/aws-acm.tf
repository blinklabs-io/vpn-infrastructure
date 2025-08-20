module "aws_acm" {
  source = "git::https://github.com/blinklabs-io/terraform-modules.git//aws_acm"

  certificates = try(local.env_vars.aws.acm.certificates, [])
}
