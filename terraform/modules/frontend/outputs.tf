# -----------------------------------
# S3 Bucket url
# -----------------------------------
# TIP: if browser downloads file instead of open page, clear cache
output "bucket_url" {
  value       = join("", ["http://", aws_s3_bucket_website_configuration.b_is_webserver.website_endpoint])
  description = "The bucket website endpoint, if website is enabled"
}

output "bucket_regional_name" {
  value = aws_s3_bucket.b.bucket_regional_domain_name
}