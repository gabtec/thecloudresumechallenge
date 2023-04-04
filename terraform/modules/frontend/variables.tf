# ------------------------------------------------
# FrontEnd Module Variables
# ------------------------------------------------
variable "MY_TAG" {
  type    = string
  default = "gabtec"
}

variable "BUCKET_NAME" {
  type    = string
  default = "gabtec-cv"
}

variable "S3_SRC_FOLDER" {
  type    = string
  default = ""
}

variable "API_BASE_URL" {
  type    = string
  default = ""
}