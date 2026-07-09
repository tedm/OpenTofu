terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.33"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15"
    }
  }
  backend "s3" {
    bucket         = "ted-terraform-tfstate"
    key            = "state/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "ted-tf-lockid"
  }
  required_version = "~> 1.3"
}