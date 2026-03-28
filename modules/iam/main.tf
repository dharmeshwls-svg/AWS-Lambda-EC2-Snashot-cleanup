# Creating an IAM role with trust policy for the Lambda function to manage EC2 snapshots and write logs to CloudWatch

resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.name_prefix}-lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}


# Creating an IAM policy for the Lambda function with permissions to manage EC2 snapshots and write logs to CloudWatch.
resource "aws_iam_role_policy" "lambda_execution_policy" {
  name = "${var.name_prefix}-lambda-execution-policy"
  role = aws_iam_role.lambda_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DeleteSnapshot"
        ]
        Resource = "*"
      },
      { Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}
# IAM role policy is attached inline to the role, no separate attachment needed