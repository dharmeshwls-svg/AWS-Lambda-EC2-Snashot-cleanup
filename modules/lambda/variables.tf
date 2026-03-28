variable "retention_days" {
  description = "Number of days to retain snapshots before deletion."
  type        = number
  default     = 365
}

variable "schedule_expression" {
  description = "The schedule expression for the Lambda function."
  type        = string
  default     = "rate(1 day)"
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}
variable "lambda_time_out" {
  description = "The timeout for the Lambda function in seconds."
  type        = number
  default     = 300
}
variable "lambda_memory_size" {
  description = "The memory size for the Lambda function in MB."
  type        = number
  default     = 128
}
variable "dry_run" {
  description = "Whether to perform a dry run (no actual deletion)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to apply to the snapshots."
  type        = map(string)
  default     = {}
}
variable "lambda_function_name" {
  description = "The name of the Lambda function."
  type        = string
  default     = "snapshot-cleanup-function"
}
variable "name_prefix" {
  description = "The prefix for the names of the resources."
  type        = string
  default     = "snapshot-cleanup"
}
variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}
variable "log_retention_in_days" {
  description = "The number of days to retain CloudWatch Logs."
  type        = number
  default     = 14
}

variable "iam_role_arn" {
  description = "ARN of the IAM role for Lambda execution"
  type        = string
}

