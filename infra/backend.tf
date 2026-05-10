terraform {
  backend "s3" {
    region       = "eu-west-2"
    key          = "state"
    use_lockfile = true
  }
  required_version = ">= 1.11.0"
}
