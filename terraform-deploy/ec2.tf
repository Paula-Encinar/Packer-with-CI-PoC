resource "aws_instance" "app_server" {
  ami           = "ami-01f74a38cda37faa2"
  instance_type = "t2.micro"
  key_name = "AWS"

  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id
  ]

  tags = {
    Name = var.instance_name
  }

  depends_on = [ aws_security_group.sg ]
  
}
