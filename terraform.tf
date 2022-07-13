terraform {
  backend "s3" {
    bucket = "dylans-test-bucket20220713132437333600000001"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}