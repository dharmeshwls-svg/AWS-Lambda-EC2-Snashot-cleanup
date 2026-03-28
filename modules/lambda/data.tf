

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../src/lambda_function.py"
  output_path = local.lambda_zip_file
}

locals {
  lambda_zip_file = "${path.module}/../../src/lambda_function.zip"
}

# Retrieving detail about the current AWS region and caller identity
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Fecthing private subnet IDs based on VPC ID and tag
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  tags = {
    Tier = "Private"
  }
}
# Fechting subnet details for CIDRS
data "aws_subnet" "details" {
  for_each = toset(var.subnet_ids)
  id       = each.value
}
data "aws_vpc" "current" {
  id = var.vpc_id
}