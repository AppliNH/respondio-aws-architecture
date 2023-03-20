
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"


  tags = {
    Name  = "${var.context_name}-vpc"
    APP   = "${var.context_name}"
    STAGE = "${var.stage}"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "internet_gtw" {
  vpc_id = aws_vpc.main_vpc.id
}


data "aws_availability_zones" "available" {}



resource "aws_subnet" "private_subnets" {
  for_each = {
    for index, subnet in var.private_subnets :
    index => subnet
  }


  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = false

  availability_zone = element(data.aws_availability_zones.available.names, each.key)

  tags = {
    Name  = "${var.context_name}-private-${each.key}"
    APP   = "${var.context_name}"
    STAGE = "${var.stage}"
  }

}

resource "aws_subnet" "public_subnets" {
  for_each = {
    for index, subnet in var.public_subnets :
    index => subnet
  }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = true

  availability_zone = element(data.aws_availability_zones.available.names, each.key)

  tags = {
    Name  = "${var.context_name}-public-${each.key}"
    APP   = "${var.context_name}"
    STAGE = "${var.stage}"
  }

}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gtw.id
  }

  tags = {
    APP   = "${var.context_name}"
    STAGE = "${var.stage}"
  }
}


resource "aws_route_table_association" "public_subnet_association" {

  for_each = {
    for index, item in aws_subnet.public_subnets :
    index => item
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id

}
