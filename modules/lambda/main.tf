# Storing the current region and account ID in local variables for use in resource definitions


resource "aws_lambda_function" "snapshot_cleanup" {
  function_name = var.lambda_function_name
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = var.iam_role_arn
  timeout       = var.lambda_time_out
  memory_size   = var.lambda_memory_size

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
  environment {
    variables = {
      aws_region     = data.aws_region.current.region
      retention_days = tostring(var.retention_days)
    }
  }
  tags = var.tags
}
# Creating a CloudWatch Event Rule to trigger the Lambda function on a schedule for snapshot cleanup.

resource "aws_cloudwatch_event_rule" "snapshot_cleanup_schedule" {
  name                = "${var.name_prefix}-snapshot-cleanup-schedule"
  description         = "Schedule to trigger Lambda function for snapshot cleanup"
  schedule_expression = var.schedule_expression
  tags                = var.tags
}

# Adding the Lambda function as a target for the CloudWatch Event Rule.

resource "aws_cloudwatch_event_target" "snapshot_cleanup_target" {
  rule      = aws_cloudwatch_event_rule.snapshot_cleanup_schedule.name
  target_id = "${var.name_prefix}-snapshot-cleanup-target"
  arn       = aws_lambda_function.snapshot_cleanup.arn
}

# Granting permission for CloudWatch Events to invoke the Lambda function.

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_lambda" {
  statement_id  = "${var.name_prefix}-allow-cloudwatch-invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.snapshot_cleanup.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.snapshot_cleanup_schedule.arn
}
# Creating a CloudWatch Log Group.

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.snapshot_cleanup.function_name}"
  retention_in_days = var.log_retention_in_days
  tags              = var.tags
}
