




variable "github_repo" {
  description = "Public GitHub HTTPS URL of your Strapi project"
  type        = string
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg"
  description = "Allow SSH and Strapi"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "strapi" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install docker -y
    service docker start
    usermod -a -G docker ec2-user
    yum install -y git
    curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
    yum install -y nodejs
    cd /home/ec2-user
    git clone ${var.github_repo} strapi-app
    cd strapi-app
    docker build -t strapi-app .
    docker run -d --name strapi -p 1337:1337 --restart unless-stopped strapi-app
  EOF

  tags = {
    Name = "StrapiServer"
  }
}

output "strapi_url" {
  value = "http://${aws_instance.strapi.public_ip}:1337"
}