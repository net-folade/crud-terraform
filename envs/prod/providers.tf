terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.8"
    }
  }

  # Local state for now. Uncomment once the bucket exists; the key is per-environment so dev and prod never share a file.
  #
  # backend "s3" {
  #   bucket       = "iot-tracker-tfstate"
  #   key          = "envs/prod/terraform.tfstate"
  #   region       = "us-east-1"
  #   encrypt      = true
  #   use_lockfile = true
  # }
}

provider "aws" {
  region = var.region
}
