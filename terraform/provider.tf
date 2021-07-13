# Amazon Web Services Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                  = "us-central-1"
  shared_credentials_file = "/Users/tf_user/.aws/creds"
  profile                 = "customprofile"
}

# Configure the Kubernetes Provider
provider "kubernetes" {
  config_paths = [
    "/path/to/config_1.yaml"
  ]
}