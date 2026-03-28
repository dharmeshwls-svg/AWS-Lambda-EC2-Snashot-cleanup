output "securitygroup_id" {
  value = aws_security_group.lambda_snapshot_cleanup_sg.id
}
output "securitygroup_name" {
  value = aws_security_group.lambda_snapshot_cleanup_sg.name

}