# Creating a security group for the Lambda function to allow outbound access to the subnets for API calls

resource "aws_security_group" "lambda_snapshot_cleanup_sg" {
  name        = "${var.name_prefix}-lambda-snapshot-cleanup-sg"
  description = "Security group for Lambda function to access EC2 snapshots"
  vpc_id      = var.vpc_id
  tags        = var.tags
}
resource "aws_security_group_rule" "lambda_outbound_https" {
  for_each          = data.aws_subnet.details
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.lambda_snapshot_cleanup_sg.id
  cidr_blocks       = [each.value.cidr_block]
  description       = "Allow outbound HTTPS traffic to subnets for API calls"

}
