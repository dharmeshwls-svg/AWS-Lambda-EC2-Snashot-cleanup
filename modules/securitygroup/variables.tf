variable "name_prefix" {
  description = "The prefix for the names of the resources."
  type        = string
  default     = "snapshot-cleanup"
}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the security group rules"
  type        = list(string)
  default     = []
}
