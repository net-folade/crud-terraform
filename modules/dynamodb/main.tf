# prevent_destroy needs a literal, not a variable, so count picks one of two copies — keep them in sync.

resource "aws_dynamodb_table" "this" {
  count = var.prevent_destroy ? 0 : 1

  name                        = var.table_name
  billing_mode                = "PAY_PER_REQUEST"
  hash_key                    = "device_id"
  range_key                   = "recorded_at"
  deletion_protection_enabled = var.deletion_protection_enabled

  attribute {
    name = "device_id"
    type = "S"
  }

  attribute {
    name = "recorded_at"
    type = "S"
  }

  tags = var.tags
}

# Mirror of aws_dynamodb_table.this, with the destroy guardrail.
resource "aws_dynamodb_table" "protected" {
  count = var.prevent_destroy ? 1 : 0

  name                        = var.table_name
  billing_mode                = "PAY_PER_REQUEST"
  hash_key                    = "device_id"
  range_key                   = "recorded_at"
  deletion_protection_enabled = var.deletion_protection_enabled

  attribute {
    name = "device_id"
    type = "S"
  }

  attribute {
    name = "recorded_at"
    type = "S"
  }

  tags = var.tags

  lifecycle {
    prevent_destroy = true
  }
}
