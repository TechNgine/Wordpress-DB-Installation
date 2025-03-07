provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {
  cidr_block = "172.31.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "main"
  }
}


#Create security group with firewall rules
resource "aws_security_group" "new-terraform-sg" {
  name        = "new-terraform-sg"
  description = "security group for jenkins"
                                        
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


 # outbound from Jenkins server
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = "wordpress_instance"
  }
}

resource "aws_instance" "terraform-ec2" {
  ami           = "ami-0cb91c7de36eed2cb"
  key_name = "my-new-key"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.new-terraform-sg.id]
  tags= {
    Name = var.tag_name
  }
}

output "public_ip" {
  value = aws_instance.terraform-ec2.public_ip
}
