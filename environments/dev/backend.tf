terraform {
  backend "s3" {
    bucket         = "omari-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
