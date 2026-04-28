module "aws_acm" {
  source = "git::https://github.com/blinklabs-io/terraform-modules.git?ref=aws_acm/v0.1.0"

  certificates = try(local.env_vars.aws.acm.certificates, [])
}
