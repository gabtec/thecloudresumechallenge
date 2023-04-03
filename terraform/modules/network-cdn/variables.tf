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
