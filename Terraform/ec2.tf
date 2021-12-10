resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  key_name               = module.ssh_key_pair.key_name
  #security_groups       = ["my_sec_group1"]
  vpc_security_group_ids = [ aws_security_group.ec2_sec_group.id ]
  user_data              = file("userdata.sh")
  tags                   = local.tags
}

module "ssh_key_pair" {
  source = "cloudposse/key-pair/aws"
  namespace             = "eg"
  stage                 = "prod"
  name                  = "quest_project"
  ssh_public_key_path   = "./secrets"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
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
