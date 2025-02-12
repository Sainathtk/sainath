resource "aws_subnet" "private_subnet" {
  vpc_id                  = "vpc-06b326e20d7db55f9"  # Replace with your actual VPC ID
  cidr_block              = "10.0.1.0/24"  # You can change this CIDR block if needed
  availability_zone       = "ap-south-1a"  # Select the availability zone
  map_public_ip_on_launch = false
  tags = {
    Name = "Private-Subnet"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "vpc-06b326e20d7db55f9"  # Replace with your actual VPC ID

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "nat-0a34a8efd5e420945"  # Replace with your NAT Gateway ID
  }

  tags = {
    Name = "Private-Route-Table"
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}






resource "aws_security_group" "lambda_sg" {
  vpc_id = "vpc-06b326e20d7db55f9"  # Replace with your actual VPC ID

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    cidr_blocks = ["10.0.0.0/16"]  # Allow inbound traffic from the VPC
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  tags = {
    Name = "Lambda-Security-Group"
  }
}

resource "aws_lambda_function" "my_lambda" {
  filename         = "lambda_function.zip"  # Ensure you zip the Python code before uploading
  function_name    = "my_lambda_function"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  security_group_ids = [aws_security_group.lambda_sg.id]
  subnet_ids       = [aws_subnet.private_subnet.id]

  environment {
    variables = {
      SUBNET_ID = aws_subnet.private_subnet.id
    }
  }

  tags = {
    Name = "MyLambda"
  }
}
