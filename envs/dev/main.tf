locals {
  # Names are composed here and passed down complete; dev and prod share one account.
  name_prefix = "${var.project}-${var.environment}"

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  # Computed from path.root (envs/dev) so the lambda module never has to guess its depth.
  lambda_source_file = "${path.root}/../../src/lambda_function.py"
  lambda_build_path  = "${path.root}/build/function.zip"
}

module "dynamodb" {
  source = "../../modules/dynamodb"

  table_name                  = local.name_prefix
  deletion_protection_enabled = false
  prevent_destroy             = false
  tags                        = local.tags
}

module "iam" {
  source = "../../modules/iam"

  role_name   = "${local.name_prefix}-lambda-role"
  policy_name = "${local.name_prefix}-lambda-policy"
  table_arn   = module.dynamodb.table_arn
  tags        = local.tags
}

module "lambda" {
  source = "../../modules/lambda"

  function_name     = "${local.name_prefix}-lambda"
  role_arn          = module.iam.role_arn
  table_name        = module.dynamodb.table_name
  source_file       = local.lambda_source_file
  build_output_path = local.lambda_build_path

  log_retention_days = var.log_retention_days

  reserved_concurrent_executions = null # unreserved in dev

  tags = local.tags
}

module "api" {
  source = "../../modules/api"

  api_name             = "${local.name_prefix}-api"
  stage_name           = var.environment
  lambda_function_name = module.lambda.function_name
  lambda_invoke_arn    = module.lambda.invoke_arn

  # Provider defaults in dev — no explicit throttle.
  throttling_rate_limit  = null
  throttling_burst_limit = null

  tags = local.tags
}
