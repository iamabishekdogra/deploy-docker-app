provider "aws" {
  region = var.aws_region
}


resource "aws_key_pair" "deployer" {
  key_name =  var.key_name
  public_key = file(var.public_key_path)
}

# Creating a security group
resource "aws_security_group" "web_sqgp" {
  name        = "web_sqgp"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 instance
resource "aws_instance" "web" {

  ami = "ami-0e86e20dae9224db8" # ubuntu

  instance_type = var.instance_type

  key_name = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.web_sqgp.id]

  associate_public_ip_address = true

  tags = {
    Name = "DockerWebServer"
  }
}

