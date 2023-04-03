# ------------------------------------------------
# Create API Endpoints
# ------------------------------------------------
resource "aws_apigatewayv2_route" "get_visits_count" {
  api_id = aws_apigatewayv2_api.api-gw.id

  route_key = "GET /visits"
  target    = "integrations/${aws_apigatewayv2_integration.api-gwi.id}"
}

resource "aws_apigatewayv2_route" "update_visits_count" {
  api_id = aws_apigatewayv2_api.api-gw.id

  route_key = "PUT /visits"
  target    = "integrations/${aws_apigatewayv2_integration.api-gwi.id}"
}