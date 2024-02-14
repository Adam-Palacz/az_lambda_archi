variable "project" {
  type    = string
  default = "ap"
}

variable "environment" {
  type = string
  validation {
    condition = contains(
      ["dev", "test", "stg", "prod"],
      var.environment
    )
    error_message = "Environment is not: dev, test or prod."
  }
  default = "dev"
}

variable "location" {
  type = string
  validation {
    condition = contains(
      ["westeurope", "northeurope", "West Europe", "North Europe"],
      var.location
    )
    error_message = "Location is not: westeurope or northeurope."
  }
  default = "westeurope"
}

variable "postfix" {
  type    = string
  default = "ap-dev-westeurope"
}