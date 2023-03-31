# --------------------------------------------
# Create DynamoDB
# --------------------------------------------
resource "aws_dynamodb_table" "t_visits" {
  name           = "t_visits"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Project = var.MY_TAG
  }
}

# --------------------------------------------
# Seed 1st and only row
# --------------------------------------------
resource "aws_dynamodb_table_item" "seed" {
  table_name = aws_dynamodb_table.t_visits.name
  hash_key   = aws_dynamodb_table.t_visits.hash_key

  item = <<ITEM
{
  "id": {"S": "gabtec.fun"},
  "visitsCount": {"N": "100"}
}
ITEM

}