module "aws_iam" {
  source = "./modules/aws_iam"

  users    = try(local.env_vars.aws.iam.users, [])
  policies = try(local.env_vars.aws.iam.policies, [])
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
