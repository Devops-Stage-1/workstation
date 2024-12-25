terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
}
resource "aws_instance" "main" {
  ami           = data.aws_ami.image.id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "work"
    monitor = "yes"
  }
}

resource "null_resource" "shell" {

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.main.public_ip
  }

  provisioner "file" {
    source      = "${path.module}/setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash /tmp/setup.sh"
    ]
  }
}