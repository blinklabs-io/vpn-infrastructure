variable "users" {
  description = "List of users to manage"
  type = list(object({
    name = string
    path = optional(string)
    permissions_boundary = optional(string)
    force_destroy = optional(bool)
    tags = optional(map(any))
    policy_arns = optional(list(string), [])
    access_keys = optional(list(object({
      id = string
      status = optional(string, "Active")
    })), [])
  }))
}

variable "policies" {
  description = "List of policies to manage"
  type = list(object({
    name = string
    path = optional(string)
    description = optional(string)
    tags = optional(map(any))
    statements = list(object({
      sid = optional(string)
      effect = optional(string, "Allow")
      actions = optional(list(string), [])
      resources = optional(list(string), ["*"])
      principals = optional(list(object({
        type = string
        identifiers = list(string)
      })), [])
    }))
  }))
}
