output "iam_role_arn" {
  description = "The ARN of the IAM role used by the Lambda function."
  value       = aws_iam_role.lambda_execution_role.arn
}