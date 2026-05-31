terraform {
  backend "s3" {
    bucket       = "project-bedrock-tf-state-alt-soe-025-3702"
    key          = "project-bedrock/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
