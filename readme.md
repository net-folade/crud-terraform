# IoT Readings API — Terraform Build

Serverless CRUD API for device sensor readings, defined entirely in Terraform.

## Problem

An IoT fleet needs to post temperature and humidity readings and query them back per device, in time order, without running any servers. 

## Architecture

![Architecture diagram](docs/architecture.png)

`Client → API Gateway (REST) → Lambda (Python 3.12) → DynamoDB`

Table `iot-tracker`: `device_id` (partition key), `recorded_at` (sort key)

## Key Tradeoffs

- **Why DynamoDB over RDS:** single-digit-ms key lookups, no server management, idles at $0. Access patterns must be known up front.
- **Why Lambda over ECS:** bursty, low-duty-cycle traffic.
- **Why REST API over HTTP API:** request validation and usage plans available when needed; HTTP API is ~70% cheaper and would be the production pick on cost alone.
- **Why `recorded_at` not `timestamp`:** `timestamp` is a DynamoDB reserved word and would need `ExpressionAttributeNames` aliasing on every query.
- **Why Terraform over CLI:** resource references replace manually captured IDs, the dependency graph replaces hand-ordered teardown, and applies are idempotent. Built the same architecture with the CLI first `(crud-cli)` to see the difference.

## Cost

- **Dev/test:** ~$0 (Free Tier + $1 budget alarm)
- **At scale:** API Gateway REST bills first — ~$3.50/million requests, no permanent free tier. Lambda's 1M requests/month free tier is permanent; DynamoDB on-demand is negligible at low volume.

## Build Process

CLI build first (understand each resource), then Terraform (declarative, repeatable). `terraform destroy` after each session.

## Tested / Monitored

- **Verified:** all five CRUD operations end-to-end via curl. See [test-cases.md](test-cases.md)
- **Not covered:** load testing, malformed JSON, pagination past DynamoDB's 1MB Query limit, authentication.
- **Monitoring:** CloudWatch Logs, 7-day retention. Not implemented: alarms, custom metrics.

## Stack

`API Gateway` `Lambda` `DynamoDB` `IAM` `CloudWatch` `Terraform` `Python`