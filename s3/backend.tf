terraform {
  backend "s3" {
    bucket = "s3-statebackend-01"
    key    = "global/devops/terraform"
    region = "us-east-1"
  }
}

