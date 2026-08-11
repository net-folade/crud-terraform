# Minimum constraints only; the environment roots own the actual version pin.
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# prevent_destroy needs a literal, not a variable, so count picks one of two copies — keep them in sync.
#
# Flipping prevent_destroy on an environment that already has a table is a state operation,
# not a config change. The table moves between resource addresses, so Terraform plans a
# destroy and a create against the same table name:
#
#   false -> true   this[0] carries no guard, so nothing blocks the destroy at plan time.
#                   deletion_protection_enabled makes AWS refuse it mid-apply instead.
#   true  -> false  protected[0] carries the guard, so plan hard-errors and cannot proceed.
#
# Move the resource first, then change the flag:
#
#   terraform state mv 'module.dynamodb.aws_dynamodb_table.this[0]' \
#                      'module.dynamodb.aws_dynamodb_table.protected[0]'

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
