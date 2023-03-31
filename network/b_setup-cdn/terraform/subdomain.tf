# -----------------------------------
# Add Records to Zone
# - Simple Routing Policy
# - www.gabtec.fun
# -----------------------------------
resource "aws_route53_record" "www" {
  zone_id = var.ROUTE53_ZONE_ID
  name    = "www.gabtec.fun"
  type    = "A"

  # use "alias", because "A" record --> points to --> cloudfront url (e.g. 'xpto.cloudfront.net')
  alias {
    name                   = aws_cloudfront_distribution.b_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.b_cdn.hosted_zone_id
    evaluate_target_health = true
  }

  # use "records", if "A" record --> points to --> ip addr
  # records = [aws_cloudfront_distribution.b_cdn.domain_name]
  # ttl     = 300
}
