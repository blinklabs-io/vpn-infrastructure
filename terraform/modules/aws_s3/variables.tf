variable "buckets" {
  description = "List of S3 buckets to manage"
  type = list(object({
    name = string
    acl = optional(string)
    tags = optional(map(any))
    policy = optional(object({
      statements = list(object({
        sid = optional(string)
        effect = optional(string, "Allow")
        actions = optional(list(string), [])
        resources = optional(list(string))
        principals = optional(list(object({
          type = string
          identifiers = list(string)
        })), [])
      }))
    }))
    cors_rules = optional(list(object({
      allowed_headers = optional(list(string))
      allowed_methods = optional(list(string))
      allowed_origins = optional(list(string))
      expose_headers  = optional(list(string))
      max_age_seconds = optional(number)
    })))
  }))
}
