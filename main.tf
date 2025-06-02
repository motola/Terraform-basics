# terraform {
#   required_providers {
#     aws = { source = "hashicorp/aws", version = "~> 6.0" }
#   }
# }

# provider "aws" {
#   region = "eu-west-2"
# }

# # OIDC provider — one per AWS account
# resource "aws_iam_openid_connect_provider" "github" {
#   url             = "https://token.actions.githubusercontent.com"
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = ["2B18947A6A9FC7764FD8B5FB18A863B0C6DAC24F"]
# }

# resource "aws_iam_role" "github_actions_terraform" {
#   name = "github-actions-terraform"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Federated = aws_iam_openid_connect_provider.github.arn
#       }
#       Action = "sts:AssumeRoleWithWebIdentity"
#       Condition = {
#         StringEquals = {
#           "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
#         }
#         StringLike = {
#           "token.actions.githubusercontent.com:sub" = "repo:motola/Terraform-basics:*"
#         }
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "power_user" {
#   role       = aws_iam_role.github_actions_terraform.name
#   policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
# }


# resource "aws_s3_bucket" "tfstate" {
#   bucket = "test-tfstate-${data.aws_caller_identity.current.account_id}"
# }

# resource "aws_s3_bucket_versioning" "tfstate" {
#   bucket = aws_s3_bucket.tfstate.id
#   versioning_configuration { status = "Enabled" }
# }


# resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
#   bucket = aws_s3_bucket.tfstate.id
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# resource "aws_s3_bucket_public_access_block" "tfstate" {
#   bucket                  = aws_s3_bucket.tfstate.id
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# data "aws_caller_identity" "current" {}


# output "github_actions_role_arn" {
#      value = aws_iam_role.github_actions_terraform.arn
#    }

#    output "tfstate_bucket" {
#      value = aws_s3_bucket.tfstate.bucket
#    }

#    output "aws_account_id" {
#      value = data.aws_caller_identity.current.account_id
#    }