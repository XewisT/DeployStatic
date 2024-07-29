# Launch another EC2 instance
resource "aws_instance" "backend_prod" {
  ami                    = "ami-07652eda1fbad7432"  # Replace with your desired AMI
  instance_type          = "t3.small"
  key_name = "ForEC"
  user_data = "${file("user_data.sh")}"
  subnet_id              = aws_subnet.public_subnet_2.id
  security_groups        = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "Backend Prod"
  }
}
resource "aws_instance" "backend_dev" {
  ami                    = "ami-07652eda1fbad7432"  # Replace with your desired AMI
  instance_type          = "t3.micro"
  key_name = "ForEC"
  user_data = "${file("user_data.sh")}"
  subnet_id              = aws_subnet.public_subnet_2.id
  security_groups        = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "Backend Dev"
  }
}


# Create an Elastic IP for the production instance
resource "aws_eip" "eip_prod" {
  instance = aws_instance.backend_prod.id

  tags = {
    Name = "EIP Backend Prod"
  }
}

# Create an Elastic IP for the development instance
resource "aws_eip" "eip_dev" {
  instance = aws_instance.backend_dev.id

  tags = {
    Name = "EIP Backend Dev"
  }
}