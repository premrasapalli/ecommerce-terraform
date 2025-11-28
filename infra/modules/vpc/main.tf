#####################
# VPC
#####################

resource "aws_vpc" "this" {
  cidr_block = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({
    Name = "${var.name}-vpc"
  }, var.tags)
}

#####################
# Public Subnets
#####################

resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr, 8, 100 + count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge({
    Name = "${var.name}-public-${count.index}"
  }, var.tags)
}

#####################
# Private Subnets
#####################

resource "aws_subnet" "private" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr, 8, count.index + 1)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = merge({
    Name = "${var.name}-private-${count.index}"
  }, var.tags)
}

#####################
# Internet Gateway
#####################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge({
    Name = "${var.name}-igw"
  }, var.tags)
}

#####################
# Public Route Table
#####################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge({
    Name = "${var.name}-public-rt"
  }, var.tags)
}

resource "aws_route_table_association" "public" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#####################
# Outputs
#####################

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "default_sg" {
  value = aws_vpc.this.default_security_group_id
}

