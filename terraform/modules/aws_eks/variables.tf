variable "cluster_name" {
  type = string
}
variable "cluster_version" {
  default = "1.32"
  type    = string
}
variable "cidr" {
  default = "10.10.0.0/16"
  type    = string
}
variable "azs" {
  default = ["us-east-1a", "us-east-1b", "us-east-1d"]
  type    = list(string)
}
variable "private_subnets" {
  default = ["10.20.0.0/20"]
  type    = list(string)
}
variable "public_subnets" {
  default = ["10.30.0.0/20", "10.30.16.0/20", "10.30.32.0/20"]
  type    = list(string)
}
variable "tags" {
  default = []
}
variable "node_groups" {
  default = {}
}
