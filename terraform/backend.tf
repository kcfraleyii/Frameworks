terraform {
  backend "s3" {
    bucket = "tf-backend"
    key    = "path/to/my/key"
    region = "us-central-1"
  }
}