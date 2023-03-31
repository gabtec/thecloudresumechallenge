variable "REGION" {
  type    = string
  default = "eu-west-1"
}

variable "PROFILE_NAME" {
  type    = string
  default = ""
}

# full file path
variable "CREDENTIALS_FILE" {
  type    = string
  default = ""
}

# ----------------------------

variable "MY_TAG" {
  type    = string
  default = "gabtec"
}

variable "CDN_IN_COUNTRIES" {
  type    = set(string)
  default = ["PT"]
}

variable "BUCKET_WEBSITE_URL" {
  type    = string
  default = ""
}

variable "BUCKET_REGIONAL_NAME" {
  type    = string
  default = ""
}


variable "ROUTE53_ZONE_ID" {
  type    = string
  default = ""
}

variable "CERTIFICATE_ARN" {
  type    = string
  default = ""
}

variable "API_BASE_URL" {
  type    = string
  default = ""
}