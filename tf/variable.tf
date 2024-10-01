variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "public_key_path" {
  description = "Path to your public SSH key"
}

variable "key_name" {
  description = "Name for the SSH key pair"
}

