terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.54.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region

  assume_role {
    role_arn = var.role_arn
  }
}

provider "aws" {
  profile = "default"
  alias   = "us-east-1"
  region  = "us-east-1"

  assume_role {
    role_arn = var.role_arn
  }
}

module "resources" {
  source = "./module"

  account_id = var.account_id
}
