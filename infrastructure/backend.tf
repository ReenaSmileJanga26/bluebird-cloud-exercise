terraform {
  backend "s3" {
    bucket         = "REPLACE_ME_tfstate_bucket"
    key            = "bluebird/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "REPLACE_ME_tfstate_lock_table"
    encrypt        = true
  }
}