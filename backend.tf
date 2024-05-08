
terraform {
  backend "s3" {
    bucket         = "obed-90"
    key            = "week10/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = false
    dynamodb_table = "state-log"

  }
}

