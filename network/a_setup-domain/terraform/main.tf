terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60.0"
    }
  }
}

provider "aws" {
  region                   = var.REGION
  profile                  = var.PROFILE_NAME
  shared_credentials_files = [var.CREDENTIALS_FILE]
}

# # -----------------------------------
# # To use the cert with CloudFront it
# # MUST be generated in region N. Virginia
# # -----------------------------------
# provider "aws" {
#   alias                    = "N_Virginia"
#   region                   = "us-west-1"
#   profile                  = var.PROFILE_NAME
#   shared_credentials_files = [var.CREDENTIALS_FILE]
# }