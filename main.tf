module "snapshot_cleanup_lambda" {
  source = "./modules/lambda"

  name_prefix          = "prod-snapshot-cleanup"
  lambda_function_name = "prod-ec2-snapshot-cleanup"
  vpc_id               = data.aws_vpc.dev-vpc.id
  subnet_ids           = local.filtered_subnets
  security_group_ids   = [module.securitygroup.securitygroup_id]
  iam_role_arn        = module.iam.iam_role_arn
  schedule_expression = "cron(0 1 * * ? *)" # Every day at 1 AM UTC
  lambda_time_out      = 300
  lambda_memory_size   = 256
  dry_run              = true
  

  tags = {
    Project     = "SnapshotCleanup"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
  
  depends_on = [module.iam, module.securitygroup]
}

module "iam" {
  source = "./modules/iam"
  name_prefix = "prod-snapshot-cleanup"
  tags = {
    Project     = "SnapshotCleanup"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "securitygroup" {
  source = "./modules/securitygroup"
  name_prefix = "prod-snapshot-cleanup"
  vpc_id = data.aws_vpc.dev-vpc.id
  subnet_ids = local.filtered_subnets
  tags = {
    Project     = "SnapshotCleanup"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
} 