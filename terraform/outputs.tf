# -----------------------------------
# Global outputs
# -----------------------------------

# -----------------------------------
# Module: BackEnd
# -----------------------------------
output "api_base_url" {
  # value = aws_apigatewayv2_stage.lambda.invoke_url
  value = module.backend.api_base_url
}

# -----------------------------------
# Module: FrontEnd
# -----------------------------------
# TIP: if browser downloads file instead of open page, clear cache
output "bucket_url" {
  value = module.frontend.bucket_url
}

output "bucket_regional_name" {
  value = module.frontend.bucket_regional_name
}