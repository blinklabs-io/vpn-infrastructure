module "aws_s3" {
  source = "git::https://github.com/blinklabs-io/terraform-modules.git?ref=aws_s3/v0.1.0"

  buckets = try(local.env_vars.aws.s3.buckets, [])
}
