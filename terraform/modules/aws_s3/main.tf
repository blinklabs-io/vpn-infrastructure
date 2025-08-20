resource "aws_s3_bucket" "this" {
  for_each = { for b in var.buckets : b.name => b }

  bucket = each.value.name

  tags = each.value.tags
}

resource "aws_s3_bucket_ownership_controls" "this" {
  for_each = { for b in var.buckets : b.name => b
    if b.acl != null }

  bucket = each.value.name

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  depends_on = [aws_s3_bucket.this]
}

resource "aws_s3_bucket_acl" "this" {
  for_each = { for b in var.buckets : b.name => b
    if b.acl != null }

  bucket = each.value.name
  acl    = each.value.acl

  depends_on = [aws_s3_bucket_ownership_controls.this]
}

data "aws_iam_policy_document" "this" {
  for_each = { for b in var.buckets : b.name => b
    if b.policy != null }

  dynamic "statement" {
    for_each = each.value.policy.statements
    
    content {
      sid        = statement.value.sid
      effect     = statement.value.effect
      actions    = statement.value.actions
      resources  = statement.value.resources == null ? ["arn:aws:s3:::${each.value.name}", "arn:aws:s3:::${each.value.name}/*"] : statement.value.resources

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

resource "aws_s3_bucket_policy" "this" {
  for_each = { for b in var.buckets : b.name => b
    if b.policy != null }

  bucket = each.value.name
  policy = data.aws_iam_policy_document.this[each.key].json
}

resource "aws_s3_bucket_cors_configuration" "this" {
  for_each = { for b in var.buckets : b.name => b
    if length(b.cors_rules) > 0 }

  bucket = each.value.name

  dynamic "cors_rule" {
    for_each = each.value.cors_rules

    content {
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      allowed_methods = try(cors_rule.value.allowed_methods, null)
      allowed_origins = try(cors_rule.value.allowed_origins, null)
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }
}
