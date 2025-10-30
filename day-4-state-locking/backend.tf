terraform {
  backend "s3" {
    bucket = "mybucket30thoctober2025"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}