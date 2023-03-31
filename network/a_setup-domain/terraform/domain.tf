# -----------------------------------
# Create DNS Zone
# -----------------------------------
resource "aws_route53_zone" "main" {
  name = "gabtec.fun"

  tags = {
    Name    = "gabtec.fun"
    Project = var.MY_TAG
  }
}

# # -----------------------------------
# # Add Records to Zone
# # - Simple Routing Policy
# # -----------------------------------
# resource "aws_route53_record" "www" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "www.gabtec.fun"
#   type    = "A"

#   # use "alias", because "A" record --> points to --> cloudfront url (e.g. 'xpto.cloudfront.net')
#   alias {
#     name                   = data.aws_cloudfront_distribution.b_cdn.domain_name
#     zone_id                = data.aws_cloudfront_distribution.b_cdn.hosted_zone_id
#     evaluate_target_health = true
#   }

#   # use "records", if "A" record --> points to --> ip addr
#   # records = [aws_cloudfront_distribution.b_cdn.domain_name]
#   # ttl     = 300
# }
