terraform {
  required_version = " 1.12.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.47.0"

    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "splunk" {
  default = "8088"
}
resource "aws_security_group" "security_group_payment_app" {
  name        = "payment_app"
  description = "Application Security Group"
  depends_on  = [aws_eip.example]

}

# Below ingress allows HTTPS  from DEV VPC
resource "aws_vpc_security_group_ingress_rule" "payment_app_outbound_http_dev" {
  security_group_id = aws_security_group.security_group_payment_app.id

  from_port   = var.https_port
  to_port     = var.https_port
  ip_protocol = "tcp"
  cidr_ipv4   = "172.31.0.0/16"
}

# Below ingress allows APIs access from DEV VPC
resource "aws_vpc_security_group_ingress_rule" "payment_app_outbound_api_dev" {
  security_group_id = aws_security_group.security_group_payment_app.id


  from_port   = var.api_port
  to_port     = var.api_port
  ip_protocol = var.ip_protocol
  cidr_ipv4   = "172.31.0.0/16"
}

# Below ingress allows APIs access from Prod App Public IP.
resource "aws_vpc_security_group_ingress_rule" "payment_app_outbound_api_prod" {
  security_group_id = aws_security_group.security_group_payment_app.id

  from_port   = var.api_prod_port
  to_port     = var.api_prod_port
  ip_protocol = var.ip_protocol
  cidr_ipv4   = "${aws_eip.example.public_ip}/32"
}

resource "aws_vpc_security_group_egress_rule" "security_group_payment_app_inbound_dev" {
 security_group_id = aws_security_group.security_group_payment_app.id

  from_port   = var.splunk
  to_port     = var.splunk
  ip_protocol = var.ip_protocol
  cidr_ipv4   = "0.0.0.0/0"
}





resource "aws_eip" "example" {
  domain = "vpc"
}