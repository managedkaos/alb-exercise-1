data "template_file" "ec2" {
  for_each = zipmap(var.servers, var.servers)
  template = file("${path.module}/bootstrap.sh")
  vars = {
    server = each.key
  }
}

resource "aws_security_group" "ec2" {
  name = "${var.name}: EC2 Security Group"
  ingress {
    from_port       = var.targets["http"].port
    to_port         = var.targets["http"].port
    protocol        = "6"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  for_each               = zipmap(var.servers, var.servers)
  ami                    = data.aws_ami.ubuntu.id
  user_data              = data.template_file.ec2[each.key].rendered
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2.id]
  tags = {
    Name = "${var.name}-${each.key}"
  }

  root_block_device {
    volume_size = 10
  }

  lifecycle {
    create_before_destroy = "true"
  }
}
