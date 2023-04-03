# -----------------------------------
# Because CloufFront requires certificate issued
# at us-east-1 (N. Virginia) region
# -----------------------------------

# -----------------------------------
# Create wildcard certificate
# -----------------------------------
resource "aws_acm_certificate" "gabtec-cert" {
  provider                  = aws.virginia
  domain_name               = "gabtec.fun"
  validation_method         = "DNS"
  # subject_alternative_names = ["*.gabtec.fun", "gabtec.fun"]
  subject_alternative_names = ["*.gabtec.fun"]

  # validation_option {
  #   domain_name       = "gabtec.fun"
  #   validation_domain = "gabtec.fun"
  # }

  # this is recommended to replace a certificate which is currently in use
  # in case of tf code updates
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Project = var.MY_TAG
  }
}

# -----------------------------------
# Add DNS validation CNAMES to Route53
# in order to validate we have to create
# CNAME records with values provided by validation request
# -----------------------------------
resource "aws_route53_record" "validation_records" {
  provider                  = aws.oem
  for_each = {
    for dvo in aws_acm_certificate.gabtec-cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.ROUTE53_ZONE_ID
}

# -----------------------------------
# Validate you own the certificate
# -----------------------------------
resource "aws_acm_certificate_validation" "gabtec-cert-validation-challenge" {
  provider = aws.virginia
  # certificate_arn = aws_acm_certificate.gabtec-cert.arn
  certificate_arn = aws_acm_certificate.gabtec-cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_records : record.fqdn]
}