
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}
variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
  default = ""
}
variable "subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
  default = [ "" ]
}
variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default = [""]
}
