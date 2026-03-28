output "lambda_function_name" {
  description = "The name of the Lambda function."
  value       = aws_lambda_function.snapshot_cleanup.function_name
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function."
  value       = aws_lambda_function.snapshot_cleanup.arn
}

output "cloudwatch_rule_name" {
  description = "The name of the EventBridge rule."
  value       = aws_cloudwatch_event_rule.snapshot_cleanup_schedule.name
}

output "cloudwatch_rule_arn" {
  description = "The ARN of the EventBridge rule."
  value       = aws_cloudwatch_event_rule.snapshot_cleanup_schedule.arn
}

