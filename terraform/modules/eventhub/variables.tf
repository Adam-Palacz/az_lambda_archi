variable "rg_name" {
  type = string
}

variable "sa_name" {
  type = string
}

variable "sc_name" {
  type = string
}

variable "postfix" {
  type    = string
  default = "ap-dev-westeurope"
}

variable "eh_name" {
  type    = string
  default = "ehRawData"
}

variable "eh_cg_stream_name" {
  type    = string
  default = "stream"
}

variable "eh_cg_tw_name" {
  type    = string
  default = "tw"
}

variable "encoding" {
  type    = string
  default = "Avro"
}

