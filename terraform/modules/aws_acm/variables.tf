variable "certificates" {
  description = "List of ACM certificates to manage"
  type = list(object({
    name           = string
    route53_domain = string
  }))
}
