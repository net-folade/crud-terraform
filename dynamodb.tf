resource "aws_dynamodb_table" "readings" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "device_id"
  range_key    = "recorded_at"

  attribute {
    name = "device_id"
    type = "S"
  }

  attribute {
    name = "recorded_at"
    type = "S"
  }

  tags = {
    Project = "iot-tracker"
  }
}