variable "MY_TAG" {
  type    = string
  default = "gabtec"
}

variable "API_GW_NAME" {
  type    = string
  default = ""
}

variable "API_GW_STAGE_NAME" {
  type    = string
  default = ""
}

variable "DB_TABLE_NAME" {
  type    = string
  default = ""
}

variable "LAMBDAS_SRC_DIR" {
  type    = string
  default = ""
}

variable "LAMBDA_FUNC_NAME" {
  type    = string
  default = "lambda-api"
}

variable "LAMBDAS_RUNTIME" {
  type    = string
  default = "nodejs18.x"
}

variable "LAMBDAS_LOGS_RETENTION_DAYS" {
  type    = number
  default = 7
}