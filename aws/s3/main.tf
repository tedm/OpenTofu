    provider "aws" {
      region = "us-west-2" # Specify your desired AWS region
    }

    resource "aws_s3_bucket" "my_first_bucket" {
      bucket = "seagl-opentofu-bucket-2025" # Choose a globally unique bucket name
      # Optional: Add other configurations like versioning, ACLs, policies, etc.
      # For example, to enable versioning:
      # versioning {
      #   enabled = true
      # }
      # To block public access:
      # acl = "private"
      # block_public_acls       = true
      # block_public_policy     = true
      # ignore_public_acls      = true
      # restrict_public_buckets = true

      tags = {
        Name        = "My First OpenTofu Bucket"
        Environment = "SeaGL Demo"
      }
    }