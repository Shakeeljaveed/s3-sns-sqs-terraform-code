provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "aws" {
  region = var.region
  alias  = "terra-sqs"

  access_key = var.access_key
  secret_key = var.secret_key

  assume_role = [{
    role_arn = "arn:aws:iam::ACCOUNT-B:role/shakil"
  }]
}
