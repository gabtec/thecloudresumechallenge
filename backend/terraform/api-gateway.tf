# ------------------------------------------------
# Create API Gateway to expose lambdas to internet
# ------------------------------------------------
resource "aws_apigatewayv2_api" "api-gw" {
  name          = "gabtec-api-gw"
  protocol_type = "HTTP" # HTTP or WEBSOCKET

  cors_configuration {
    allow_origins = ["*"]
    allow_headers = ["*"]
    allow_methods = ["*"]
  }
}

# ------------------------------------------------
# Create integration between API Gateway and Lambda
# ------------------------------------------------
resource "aws_apigatewayv2_integration" "api-gwi" {
  api_id = aws_apigatewayv2_api.api-gw.id

  integration_uri    = aws_lambda_function.visits-api.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST" # not related with my API endpoints verbs
}

# ------------------------------------------------
# Create API Gateway stage (1 or N)
# ------------------------------------------------
resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.api-gw.id

  name        = "api_stage_learning"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api-logs.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}