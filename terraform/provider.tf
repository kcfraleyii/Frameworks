# Amazon Web Services Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "latest"
    }
    helm = {
      source = "hashicorp/helm"
      version = "latest"
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

# Configure Helm Provider
provider "helm" {
  config_paths = [
    "/path/to/config_helm.yaml"
  ]
}