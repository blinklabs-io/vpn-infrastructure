resource "aws_acm_certificate" "this" {
  for_each = { for c in var.certificates : c.name => c }

  domain_name       = each.value.name
  validation_method = "DNS"
}

data "aws_route53_zone" "this" {
  for_each = { for c in var.certificates : c.name => c }

  name         = each.value.route53_domain
  private_zone = false
}

resource "aws_route53_record" "this" {
  for_each = merge(flatten([
    for c in var.certificates : [
      for dvo in aws_acm_certificate.this[c.name].domain_validation_options : {
        "${c.name}-${dvo.domain_name}" = {
          cert_name = c.name
          name      = dvo.resource_record_name
          record    = dvo.resource_record_value
          type      = dvo.resource_record_type
        }
      }
    ]
  ])...)

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this[each.value.cert_name].zone_id
}

resource "aws_acm_certificate_validation" "this" {
  for_each = { for c in var.certificates : c.name => c }

  certificate_arn         = aws_acm_certificate.this[each.key].arn
  validation_record_fqdns = [for dvo in aws_acm_certificate.this[each.key].domain_validation_options : dvo.resource_record_name]
}
