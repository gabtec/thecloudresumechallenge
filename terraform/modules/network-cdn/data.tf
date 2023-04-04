data "aws_route53_zone" "my-zone" {
  name          = "gabtec.fun."
  private_zone = false
}

output "my-zone-id" {
  # this both are equal
  # value = data.aws_route53_zone.my-zone.id
  value = data.aws_route53_zone.my-zone.zone_id
}