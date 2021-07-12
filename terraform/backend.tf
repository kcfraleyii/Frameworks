terraform {
  backend "s3" {
    bucket = "tf-backend-bucket"
    key    = "path/to/my/key"
    region = "us-central-1"
  }
}