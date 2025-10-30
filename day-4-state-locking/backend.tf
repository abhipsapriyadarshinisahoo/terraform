terraform {
  backend "s3" {
    bucket = "mybucket30thoctober2025"
    key    = "terraform.tfstate"
    use_lockfile = true 
    region = "us-east-1"
     dynamodb_table = "abhipsa"
    encrypt = true
  }
}