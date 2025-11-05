provider "aws" {
  region = "us-east-1"   
}

resource "aws_instance" "server" {
  ami           = "ami-0bdd88bd06d16ba03"
  instance_type = "t3.micro"
  key_name      = "devprodtest"     

  tags = {
    Name = "terraform-server"
  }
}
