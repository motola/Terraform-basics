terraform {
    required_version = " 1.12.2"
    
    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.47.0"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.87.0"
    }
  }
}

provider digitalocean {}

provider "aws" {
    region  = "eu-west-2"
}

resource "aws_instance" "web" {
  ami           = "ami-0150189e4c09ffab5" # eu-west-2
  instance_type = "t2.micro"
}

resource "aws_eip" "lb" {
    instance = aws_instance.web.id
    domain   = "vpc"
}