provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["$HOME/.aws/config"]
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile                  = "lolcatbolt"
}

resource "aws_default_vpc" "default_vpc" {}

resource "aws_security_group" "servers" {
  name = "Security group"
  description = "My security group"
  vpc_id = aws_default_vpc.default_vpc.id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "Servers security group"
    Owner = "vintobot"
  }
}

resource "aws_instance" "webserver" {
    instance_type = "t2.micro"
    ami           = "ami-090fa75af13c156b4"

}
