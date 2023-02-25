data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "handson-public" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public_1a.id

  key_name = aws_key_pair.key_pair.id

  associate_public_ip_address = true

  private_ip = "10.0.1.10"

  vpc_security_group_ids = [aws_security_group.handson-public.id]
}

resource "aws_instance" "handson-private" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.private_1a.id

  associate_public_ip_address = false

  private_ip = "10.0.2.10"

  vpc_security_group_ids = [aws_security_group.handson-private.id]
}
