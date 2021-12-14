provider "aws" {
  region = "us-east-1"
  profile = "default"
}

locals {
  zone_id           = "Z021165810NKQPI7P7NEJ"
  certificate_arn   = "arn:aws:acm:us-east-1:080546698688:certificate/d7f69adb-9847-4ab5-a31c-95324ddb8336"
  # This certificate must be issued region in which we create ALB. 
}


resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

data "aws_subnet_ids" "current" {
  vpc_id = aws_default_vpc.default.id
}

variable "ec2_dynamic_ports" {
}

variable "alb_dynamic_ports" {
}

variable "web_site_name" {
}

variable "stack_tag" {
}


data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners           = ["amazon"]

 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}


output "myec2_public_ip" {
  value = aws_instance.web.public_dns
}

output "myec2_private_ip" {
  value = aws_instance.web.private_dns
}

output "pem_key" {
  value = module.ssh_key_pair.private_key
  sensitive = true
}
