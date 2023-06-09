terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 2.7.0"
      configuration_aliases = [aws.oem, aws.virginia]
    }
  }
}

# -----------------------------------
# Add Records to Zone
# - Simple Routing Policy
# -----------------------------------
resource "aws_route53_record" "www" {
  provider = aws.oem
  # zone_id  = var.ROUTE53_ZONE_ID
  zone_id  = data.aws_route53_zone.my-zone.zone_id
  name     = "www.gabtec.fun"
  type     = "A"

  # use "alias", because "A" record --> points to --> cloudfront url (e.g. 'xpto.cloudfront.net')
  alias {
    name    = aws_cloudfront_distribution.b_cdn.domain_name
    zone_id = aws_cloudfront_distribution.b_cdn.hosted_zone_id
    # name                   = data.aws_cloudfront_distribution.b_cdn.domain_name
    # zone_id                = data.aws_cloudfront_distribution.b_cdn.hosted_zone_id
    evaluate_target_health = true
  }

  # use "records", if "A" record --> points to --> ip addr
  # records = [aws_cloudfront_distribution.b_cdn.domain_name]
  # ttl     = 300
}

# --------------------------------------------
# Setup a ACL for CloudFront
# --------------------------------------------
resource "aws_cloudfront_origin_access_control" "default" {
  provider                          = aws.oem
  name                              = "cdn_default_acl"
  description                       = "CDN default access policy"
  origin_access_control_origin_type = "s3"    # just "s3" value allowed
  signing_protocol                  = "sigv4" # just "s3" value allowed
  signing_behavior                  = "always"
}

# --------------------------------------------
# Setup a Cache Policy for CloudFront
# --------------------------------------------
resource "aws_cloudfront_cache_policy" "cdn-cache-policy" {
  provider    = aws.oem
  name        = "gabtec-cdn-cache-policy"
  comment     = "cdn-cache-comment"
  min_ttl     = 0 # 1   # in seconds
  max_ttl     = 0 # 100 # in seconds
  default_ttl = 0 # 50  # in seconds
  # to avoid cache erros, in learning path, I set this to zero

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
      # cookie_behavior = "whitelist"
      # cookies {
      #   items = ["example"]
      # }
    }
    headers_config {
      header_behavior = "none"
      # header_behavior = "whitelist"
      # headers {
      #   items = ["example"]
      # }
    }
    query_strings_config {
      query_string_behavior = "none"
      # query_string_behavior = "whitelist"
      # query_strings {
      #   items = ["example"]
      # }
    }
  }
}

# --------------------------------------------
# Setup a CDN - w/ CloudFront
# --------------------------------------------
resource "aws_cloudfront_distribution" "b_cdn" {
  provider            = aws.oem
  enabled             = true # required
  is_ipv6_enabled     = false
  comment             = "Cloud Challenge CDN"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  # Optional, with possible values:
  #- "PriceClass_All" = all edge locations
  #- "PriceClass_200" = excludes South Africa and Australia
  #- "PriceClass_100" = North America and Europe

  origin {
    domain_name              = var.BUCKET_REGIONAL_NAME # S3 bucket dns OR my custom domain
    origin_id                = var.BUCKET_WEBSITE_URL
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"          # or "blacklist"
      locations        = var.CDN_IN_COUNTRIES # CND replicas e.g ["PT"]
    }
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https" # opts: "allow-all" | "https-only" | "redirect-to-https"
    target_origin_id       = var.BUCKET_WEBSITE_URL
    default_ttl            = 0 #3600

    # methods that will be forwarded to S3 bucket (1 of 3 options)
    # allowed_methods  = ["HEAD", "GET", "OPTIONS"]
    # allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    allowed_methods = ["HEAD", "GET"]
    cached_methods  = ["GET", "HEAD"]
    cache_policy_id = aws_cloudfront_cache_policy.cdn-cache-policy.id
  }

  aliases = ["www.gabtec.fun"]

  viewer_certificate {
    cloudfront_default_certificate = false

    # when using my custom domain certificate:
    acm_certificate_arn = aws_acm_certificate.gabtec-cert.arn
    # acm_certificate_arn = aws_acm_certificate.gabtec-cert.arn

    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021" # default
  }

  tags = {
    Project = var.MY_TAG
  }
}
