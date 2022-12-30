resource "aws_instance" "app_server" {
  ami           = var.packer_ami_id
  instance_type = "t2.micro"
  key_name = "AWS"
  user_data = <<-EOF
    #!/bin/bash
    /bin/echo "Hello World" >> /tmp/testfile.txt
    node /home/ubuntu/nodetest/dist/main.js
    echo "Node ejecutado"
  EOF

  vpc_security_group_ids = [
    aws_security_group.sg.id
  ]

  tags = {
    Name = var.instance_name
  }

  depends_on = [ aws_security_group.sg ]
  
}
