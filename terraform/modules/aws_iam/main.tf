resource "aws_iam_user" "iam_user" {
  for_each = { for u in var.users : u.name => u }

  name = each.value.name
  path = each.value.path

  permissions_boundary = each.value.permissions_boundary
  force_destroy        = each.value.force_destroy

  tags = each.value.tags
}

resource "aws_iam_access_key" "iam_user" {
  for_each = merge(flatten([
    for user in var.users : [
      for access_key in user.access_keys : {
        "${user.name}-${access_key.id}" = {
          user   = user.name
          key_id = access_key.id
          status = access_key.status
        }
      }
    ]
  ])...)

  user   = each.value.user
  status = each.value.status
}

data "aws_iam_policy_document" "policy_doc" {
  for_each = { for p in var.policies : p.name => p }

  dynamic "statement" {
    for_each = each.value.statements
    
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = statement.value.principals

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
    }
  }
}

resource "aws_iam_policy" "iam_policy" {
  for_each = { for p in var.policies : p.name => p }

  name        = each.value.name
  path        = each.value.path
  description = each.value.description

  policy = data.aws_iam_policy_document.policy_doc[each.value.name].json

  tags = each.value.tags
}

resource "aws_iam_user_policy_attachment" "iam_user_policy_attachment" {
  for_each = merge(flatten([
    for user in var.users : [
      for policy_arn in user.policy_arns : {
        "${user.name}-${policy_arn}" = {
          user       = user.name
          policy_arn = policy_arn
        }
      }
    ]
  ])...)

  user       = each.value.user
  policy_arn = each.value.policy_arn
}
