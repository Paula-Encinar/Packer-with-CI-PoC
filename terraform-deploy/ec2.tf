resource "aws_instance" "app_server" {
  ami           = "ami-0f3e85854c7d44385"
  instance_type = "t2.micro"
  key_name = "AWS"

  vpc_security_group_ids = [
    aws_security_group.sg.id
  ]

  tags = {
    Name = var.instance_name
  }

  depends_on = [ aws_security_group.sg ]
  
}
