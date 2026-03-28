# Fetching subnet details for CIDRS
data "aws_subnet" "details" {
  for_each = toset(var.subnet_ids)
  id       = each.value
}
