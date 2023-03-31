# ------------------------------------------------
# Create a IAM Role for my lambda func
# ------------------------------------------------
resource "aws_iam_role" "lambda-role" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

# ------------------------------------------------
# Allow lambda to use dynamoDB (will enhance existing role)
# ------------------------------------------------
resource "aws_iam_policy" "lambda-dynamo-policy" {
  name = "lambda-dynamo-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
      ],
      "Resource" : "*"
      }
    ]
  })
}

# # ------------------------------------------------
# # Attach a policy to lambda role, allowing lambda to write to cloudwatch logs
# # This is done by default
# # ------------------------------------------------
# resource "aws_iam_role_policy_attachment" "lambda_basic_execution_attach" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#   role       = aws_iam_role.lambda-role.name
# }

# ------------------------------------------------
# Attach the policy to lambda role, allowing lambda to use dynamoDB
# ------------------------------------------------
resource "aws_iam_role_policy_attachment" "lambda_role_add_dynamo" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = aws_iam_policy.lambda-dynamo-policy.arn
}

# ------------------------------------------------
# Allow api to execute lambdas
# ------------------------------------------------
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.visits-api.function_name
  source_arn    = "${aws_apigatewayv2_api.api-gw.execution_arn}/*"
}
