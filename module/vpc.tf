resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "handson"
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id = aws_vpc.main.id

  availability_zone = "ap-northeast-1a"

  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "handson-public-1a"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id = aws_vpc.main.id

  availability_zone = "ap-northeast-1a"

  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "handson-private-1a"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "handson"
  }
}

resource "aws_route_table" "handson" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "public table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.handson.id
  }

  tags = {
    Name = "private table"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "handson" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.handson.id
}

resource "aws_security_group" "handson-public" {
  name   = "handson-public"
  vpc_id = aws_vpc.main.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    description      = ""
    from_port        = 443
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 443
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    description      = ""
    from_port        = -1
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "icmp"
    security_groups  = []
    self             = false
    to_port          = -1
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "handson-public"
  }
}

resource "aws_security_group" "handson-private" {
  name   = "handson-private"
  vpc_id = aws_vpc.main.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    description      = ""
    from_port        = 3306
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 3306
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    description      = ""
    from_port        = -1
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "icmp"
    security_groups  = []
    self             = false
    to_port          = -1
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "handson-private"
  }
}

resource "aws_network_interface" "handson" {
  subnet_id  = aws_subnet.public_1a.id
  private_ip = "10.0.1.10"
}

resource "aws_eip" "handson" {
}

resource "aws_nat_gateway" "handson" {
  allocation_id = aws_eip.handson.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.gateway]
}
