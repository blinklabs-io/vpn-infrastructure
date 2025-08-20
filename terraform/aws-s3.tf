module "aws_s3" {
  source = "./modules/aws_s3"

  buckets = try(local.env_vars.aws.s3.buckets, [])
}
