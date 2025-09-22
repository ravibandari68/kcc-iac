##Remote Backend
terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "terraform-state-bucket-5430"   
    key            = "nonprod/terraform.tfstate" 
    region         = "us-east-1"                  
    dynamodb_table = "terraform-locks"             
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

##Provider Block
provider "aws" {
  region  = "us-east-1"
}
