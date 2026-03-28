terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  # Configure the backend to store the Terraform state in an S3 bucket. Uncomment and provide the necessary values to enable remote state storage.
  # backend "s3" {
  #   bucket = var.s3_bucket
  #   key    = "terraform.tfstate"
  #   region = var.aws_region
  # }
}
provider "aws" {
  region = var.aws_region

}
