resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subnet_cidr_block[0]
}

resource "aws_subnet" "subnet_2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subnet_cidr_block[1]
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "my_route" {
  route_table_id         = aws_route_table.route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.route.id
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

data "tls_public_key" "pk" {
  private_key_pem = tls_private_key.pk.private_key_pem
}

resource "aws_key_pair" "kp" {
  key_name   = "mykey"
  public_key = data.tls_public_key.pk.public_key_openssh
}

resource "local_file" "kp" {
  content  = tls_private_key.pk.private_key_pem
  filename = "kp"
}

resource "aws_security_group" "my_sg" {
  name        = "allow-ssh"
  description = "allow SSH traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "web_server" {
  ami                         = var.ami
  instance_type               = var.instancetype
  key_name                    = aws_key_pair.kp.key_name
  subnet_id                   = aws_subnet.subnet_1.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.my_sg.id]

  tags = {
    Name = "terraformproject"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.pk.private_key_pem
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "Rakshitha Y C CV.pdf"
    destination = "/home/ec2-user/Rakshitha Y C CV.pdf"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo yum update -y",
      "sudo yum install -y python3-pip",
      "cd /home/ec2-user",
      "sudo pip3 install flask",
      "sudo systemctl start flask"

    ]
  }
}