resource "aws_dynamodb_table" "cart" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "customerId"
  range_key    = "itemId"

  attribute {
    name = "customerId"
    type = "S"
  }

  attribute {
    name = "itemId"
    type = "S"
  }

  tags = {
    Name = var.dynamodb_table_name
  }
}
