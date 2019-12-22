provider "aws" {
  region     = "us-east-1"
  access_key = "MY-ACCESS-KEY"
  secret_key = "MY-Secret_KEY"
}

provider "aws" {
  region = "us-east-1"
  alias  = "terra-sqs"

  access_key = "MY-ACCESS-KEY"
  secret_key = "MY-Secret_KEY"

  assume_role = [{
    role_arn = "arn:aws:iam::ACCOUNT-B:role/shakil"
  }]
}
