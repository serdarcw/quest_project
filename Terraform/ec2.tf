resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  key_name               = module.ssh_key_pair.key_name
  vpc_security_group_ids = [ aws_security_group.ec2_sec_group.id ]
  user_data              = file("userdata.sh")
  tags = {
    Environment = var.stack_tag
  }
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

