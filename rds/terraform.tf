terraform {

  required_providers {
    aws = {
      source    = "hashicorp/aws"
      version   = "~>5.84.0"
    }

    random  = {
      source    = "hashicorp/random"
      version   = "~> 3.6.3"
    }

    tls     = {
      source    = "hashicorp/tls"
      version   = "~> 4.0.6"
    }
  }

  backend "s3" {
    bucket              = "ted-terraform-tfstate"
    key                 = "state/terraform.tfstate"
    region              = "us-west-2"
    encrypt             = true
    dynamodb_table      = "ted-tf-lockid"
  }

  required_version        = "~> 1.3"
}