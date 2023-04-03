# -----------------------------------
# CloudFront infos
# -----------------------------------
output "cloudfront_distro_id" {
  value = aws_cloudfront_distribution.b_cdn.id
}

# output "cdn_domain_name" {
#   value = aws_cloudfront_distribution.b_cdn.domain_name
# }

# output "cdn_hosted_zone_id" {
#   value = aws_cloudfront_distribution.b_cdn.hosted_zone_id
# }
