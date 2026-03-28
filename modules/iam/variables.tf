variable "name_prefix" {
  description = "The prefix for the names of the resources."
  type        = string
  default     = "snapshot-cleanup"
}

variable "tags" {
  description = "IAM role tags."
  type        = map(string)
  default     = {}
}
