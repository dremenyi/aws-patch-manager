// Terraform block manipulates the behavior of TF..
// by enforement of version control 
terraform {
  required_version = "~> 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20"
    }


  }


}
/*

provider "aws" {
  region = "us-east-1"
  # Current expectation is to use enviornment variables
}
*/