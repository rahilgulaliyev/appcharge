provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

locals {
  app_name = "appcharge"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${local.app_name}-vpc"
  }
}

# Subnets
resource "aws_subnet" "public" {
  count = 2

  cidr_block = "10.0.${count.index + 1}.0/24"
  vpc_id     = aws_vpc.main.id

  tags = {
    Name = "${local.app_name}-subnet-public-${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.app_name}-igw"
  }
}

# Routing table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${local.app_name}-route-public"
  }
}

# Associate subnets with routing table
resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Security group for ALB
resource "aws_security_group" "alb" {
  name        = "${local.app_name}-alb-sg"
  description = "Allow inbound traffic for ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB
resource "aws_lb" "alb" {
  name               = "${local.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public.*.id
}

# ALB Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group.arn
  }
}

# ALB Target Group
resource "aws_lb_target_group" "group" {
  name     = "${local.app_name}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# ECS cluster
resource "aws_ecs_cluster" "cluster" {
  name = "${local.app_name}-cluster"
}

# Launch configuration for ECS nodes
resource "aws_launch_configuration" "ecs" {
  name                 = "${local.app_name}-ecs-lc"
  instance_type        = "c5.medium"
  image_id             = var.ecs_optimized_ami_id
  key_name             = var.key_pair_name
}