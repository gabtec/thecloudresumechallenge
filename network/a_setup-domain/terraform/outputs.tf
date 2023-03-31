# -----------------------------------
# Route 53 Name Servers list
# -----------------------------------
output "route53_zone_id" {
  value = aws_route53_zone.main.zone_id
}

# -----------------------------------
# Route 53 Name Servers list
# -----------------------------------
output "aws_ns" {
  value = aws_route53_zone.main.name_servers
}