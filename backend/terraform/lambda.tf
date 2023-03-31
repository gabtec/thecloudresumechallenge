# -------------------------------------------------------
# local vars
# -------------------------------------------------------
locals {
  zip-file = "./temp/lambda-files.zip"
}

# -------------------------------------------------------
# Compresses all files that will compose the lambda func
# -------------------------------------------------------
data "archive_file" "lambda-zip" {
  type = "zip"

  source_file = "../my-api/lambda-api.js"
  output_path = local.zip-file
}

# -------------------------------------------------------
# Create lambda resource
# -------------------------------------------------------
resource "aws_lambda_function" "visits-api" {
  function_name = "lambda-api" # match the filename

  runtime = "nodejs18.x"         # python3.7
  handler = "lambda-api.handler" # the module.exports.handler function

  source_code_hash = data.archive_file.lambda-zip.output_base64sha256

  role        = aws_iam_role.lambda-role.arn
  description = "A small rest api for cloud resume challenge, as aws lambda style"

  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename = local.zip-file
}

# ------------------------------------------------
# Logs - SOS (also used by api-gw)
# ------------------------------------------------
resource "aws_cloudwatch_log_group" "api-logs" {
  name = "/aws/lambda/${aws_lambda_function.visits-api.function_name}"

  retention_in_days = 7
}
