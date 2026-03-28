# Retrieving detail about the current AWS region and caller identity
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Get VPC details based on VPC ID by tag
data "aws_vpc" "dev-vpc" {
  tags = {
    Env = "dev"
  }
}
# Get availability zones in the current region

data "aws_availability_zones" "available" {
  state = "available"
}
# Filtering availability zones based availability in the current region.

locals {
  filtered_azs = [for az in data.aws_availability_zones.available.names : az if startswith(az, "us-east-1")]
}
# Get all subnets id based on filtered availability zones.

data "aws_subnet" "filtered" {
  for_each = toset(local.filtered_azs)
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.dev-vpc.id]
  }
  filter {
    name   = "availability-zone"
    values = [each.key]
  }
}
# Filtering subnet IDs based on availability zones.

locals {
  filtered_subnets = [for s in values(data.aws_subnet.filtered) : s.id]
}

