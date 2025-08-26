module "aws_kms" {
  source = "git::https://github.com/blinklabs-io/terraform-modules.git//aws_kms"

  for_each    = { for k in try(local.env_vars.aws.kms.keys, {}) : k.name => k }
  admins      = try(each.value.admins, [])
  aliases     = try(each.value.aliases, [])
  description = each.value.description # required
}
