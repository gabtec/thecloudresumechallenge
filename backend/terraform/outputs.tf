# -----------------------------------
# API base url
# -----------------------------------
output "api_base_url" {
  value = aws_apigatewayv2_stage.lambda.invoke_url
}