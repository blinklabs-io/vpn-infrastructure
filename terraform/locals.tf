locals {
  env_vars       = yamldecode(file("../config.yaml"))
  aws_account_id = "705913449309"
  aws_region     = "us-east-1"
}
