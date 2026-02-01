provider "aws" {
  region = "us-east-1"   # North Virginia
}

data "aws_vpc" "default" {
  default = true
}
data "aws_subnet" "subnet_a" {
  availability_zone = "us-east-1a"
  vpc_id            = data.aws_vpc.default.id
}

data "aws_subnet" "subnet_b" {
  availability_zone = "us-east-1b"
  vpc_id            = data.aws_vpc.default.id
}

data "aws_subnet" "subnet_c" {
  availability_zone = "us-east-1c"
  vpc_id            = data.aws_vpc.default.id
}

resource "aws_security_group" "ec2_sg" {
  name        = "simple-ec2-sg"
  description = "Allow SSH and application ports"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_1" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.small"
  key_name      = "devops-key"

  subnet_id = data.aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "EC2-Jenkins"
  }
}
resource "aws_instance" "ec2_2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.small"
  key_name      = "devops-key"

  subnet_id = data.aws_subnet.subnet_b.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "EC2-K8s-Master"
  }
}
resource "aws_instance" "ec2_3" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.small"
  key_name      = "devops-key"

  subnet_id = data.aws_subnet.subnet_c.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "EC2-K8s-Worker"
  }
}

