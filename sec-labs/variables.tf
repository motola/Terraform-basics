variable "https_port" {
  type        = number
  description = "Port for https request"
  default     = 443
}


variable "api_port" {
  type        = number
  description = "port for apis"
  default     = 8080

}

variable "api_prod_port" {
  type        = number
  description = "port for api prod"
  default     = 8443

}

variable "ip_protocol" {
  type    = string
  default = "tcp"

}