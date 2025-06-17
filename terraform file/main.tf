
terraform{
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}

provider "aws"{
    region ="ap-south-1"
    access_key = "AKIAQ37DIXL2MLAIBMMG"
    secret_key = "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" 
    }

resource "tls_private_key" "rsa_4096" {
    algorithm = "RSA"
    rsa_bits = 4096
}
variable "key_name" {}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
}

resource "aws_instance" "public_instance" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"
  key_name=aws_key_pair.key_pair.key_name

  tags = {
    Name = "HelloWorld"
  }
}

  
