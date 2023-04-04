terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60.0"
      configuration_aliases = [ aws.n-virginia ]
    }
  }
}

provider "aws" {
  region                   = var.REGION
  profile                  = var.PROFILE_NAME
  shared_credentials_files = [var.CREDENTIALS_FILE]
}

provider "aws" {
  alias                    = "n-virginia"
  region                   = "us-east-1"
  profile                  = var.PROFILE_NAME
  shared_credentials_files = [var.CREDENTIALS_FILE]
}

module "backend" {
  source = "./modules/backend"


  # module input
  API_GW_NAME       = "gabtec-api-gw"
  API_GW_STAGE_NAME = "api_stage_learning"
  DB_TABLE_NAME     = "t_visits"
  LAMBDAS_SRC_DIR   = "../my-api/"
  LAMBDA_FUNC_NAME  = "lambda-api"
  LAMBDAS_RUNTIME   = "nodejs18.x"
}

module "frontend" {
  source = "./modules/frontend"


  # module input
  BUCKET_NAME   = "gabtec-cv"
  S3_SRC_FOLDER = "../website"
  API_BASE_URL  = module.backend.api_base_url
}

module "network-cdn" {
  source = "./modules/network-cdn"

  providers = {
    aws.oem      = aws
    aws.virginia = aws.n-virginia
  }

  # module input
  BUCKET_WEBSITE_URL   = split("//", module.frontend.bucket_url)[1]
  BUCKET_REGIONAL_NAME = module.frontend.bucket_regional_name
  CDN_IN_COUNTRIES     = ["PT"]
  # ROUTE53_ZONE_ID      = var.ROUTE53_ZONE_ID
}