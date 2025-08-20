module "aws_s3" {
  source = "git::https://github.com/blinklabs-io/terraform-modules.git//aws_s3"

  buckets = try(local.env_vars.aws.s3.buckets, [])
}
