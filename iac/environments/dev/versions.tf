terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
    cloud {
    hostname     = "app.terraform.io"
    organization = "trf-ansible-cmdb"

    workspaces {
      name = "dev"
    }
  }
}