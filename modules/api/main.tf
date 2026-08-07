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

# REST API fronting the readings Lambda, including the permission that lets it invoke.

resource "aws_api_gateway_rest_api" "api" {
  name = var.api_name
  tags = var.tags
}

# /readings
resource "aws_api_gateway_resource" "readings" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "readings"
}

# /readings/{id}
resource "aws_api_gateway_resource" "reading" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.readings.id
  path_part   = "{id}"
}

locals {
  collection_methods = ["GET", "POST"]
  item_methods       = ["GET", "PUT", "DELETE"]
}

resource "aws_api_gateway_method" "collection" {
  for_each      = toset(local.collection_methods)
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.readings.id
  http_method   = each.value
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "collection" {
  for_each                = aws_api_gateway_method.collection
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.readings.id
  http_method             = each.value.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_method" "item" {
  for_each      = toset(local.item_methods)
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.reading.id
  http_method   = each.value
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "item" {
  for_each                = aws_api_gateway_method.item
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.reading.id
  http_method             = each.value.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeploy = sha1(jsonencode([
      aws_api_gateway_resource.readings,
      aws_api_gateway_resource.reading,
      aws_api_gateway_method.collection,
      aws_api_gateway_method.item,
      aws_api_gateway_integration.collection,
      aws_api_gateway_integration.item,
    ]))
  }

  # Hidden dependency: the deployment snapshots whatever integrations exist at creation time.
  depends_on = [
    aws_api_gateway_integration.collection,
    aws_api_gateway_integration.item,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.this.id
  stage_name    = var.stage_name
  tags          = var.tags
}

# Separate resource because aws_api_gateway_stage has no throttle arguments; skipped entirely when unset.
resource "aws_api_gateway_method_settings" "throttling" {
  count = var.throttling_rate_limit == null ? 0 : 1

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    throttling_rate_limit  = var.throttling_rate_limit
    throttling_burst_limit = var.throttling_burst_limit
  }
}
