# AWS-Lambda-EC2-Snashot-cleanup
The project provides an aws lambda function to automatically delete EC2 snapshot that are older than one year to reduce storage cost and maintain clean resource management.

# Why Terraform is chosen
- Terraform uses human readable Hashicorp Configuration Language (HCL)
- It is cloud agonastic and ideal for multi cloud strategy
- It uses a local or remote state file to track resources and drift detation 
- It provides powerful terraform plan that shows what changes will be prior to deploying
- It foster collaborative and modular approach to infrastructure management. 

# Assumption made for this projet
- VPC exist with route table, NACL, both Public and Private subnets
- VPC endpoint avalable for API call
- There are no restriction to delete SnapShopt

# Architecture
- AWS Lambda fucntion : Python based Lambda fucniton to scan and deletes old snapshots
- VPC configuration : All components to run in Private subnets
- SecurityGrpoup : Acces  EC2 services API
- IAM role : Provide access to both EC2 and CloudWatch
- CloudWatch Events: Schedule daily exececution
- CloudWatch : Lambda function execution loggin

## Prerequisites
- AWS CLI configure with appropriate permisison 
- Python versin 12 or newer
- Terraform version >= 1.0  (For this project, Terraform versin 1.14.8 was used for infrastructure as code implementation)

# Features of Module
- Lambda inside exiting VPC/Subnets
- EventBridge scheduled trigger
- Deletes snapshots older than rention_years
- Tag-based exlusion support
- Dry-run mode support

# Required Inputs if not dynamicaaly pulled from AWS account
- vpc_id
- subnet_id
- AWS_REGION

# Infrastructure deployment step using Terraform CLI
- Terraform init  - Downloads necessary provider plugins and modules, and initialized backend
- Terraform fmt  -  Format code 
- Terraform validate - Validates code sysntex
- Terraform apply - Deploy code, this will require approval

# Deploying code to lambda function
- Package the Lambda code as ZIP with its dependencies and deploy it using Terraform and CI/CD automation
- AWS CLI can be used for quick update but not recommended for production

# Monitoring lambda execution 
- CloudWatch Metrics: Lambda invoation, duration, and error metrics
- Cloudwatch Logs: "aws/lambda/prod-ec2-snapshot-cleanup"
