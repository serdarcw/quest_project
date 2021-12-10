provider "aws" {
  region = "us-east-1"
  profile = "default"
}

locals {
  name              = "quest_project"
  
  web_site_name     = "www.serkangumus.me"
  zone_id           = "Z021165810NKQPI7P7NEJ"
  certificate_arn   = "arn:aws:acm:us-east-1:080546698688:certificate/d7f69adb-9847-4ab5-a31c-95324ddb8336"
  # This certificate must be issued region in which we create ALB. 
  tags = {
    Name = local.name
  }
}


resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}


variable "serkan_dynamic_ports" {
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
