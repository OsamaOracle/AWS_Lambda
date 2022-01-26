terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  backend "s3" {
    bucket = "myterraform-state-s3-github-actions"
    key    = "state"
    region = "us-east-2"
  }

}

provider "aws" {
  region  = var.region
}
