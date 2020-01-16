resource "aws_vpc" "airflow_vpc" {
  cidr_block = "172.16.0.0/20"
  tags       = var.tags
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "airflow_gateway" {
  vpc_id = aws_vpc.airflow_vpc.id
  tags = var.tags
}

resource "aws_route_table" "airflow_route_table" {
  vpc_id = aws_vpc.airflow_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.airflow_gateway.id
  }
  tags = var.tags
}

resource "aws_subnet" "airflow_subnet_a" {
  vpc_id     = aws_vpc.airflow_vpc.id
  cidr_block = "172.16.0.0/27"
  tags       = var.tags
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "airflow_subnet_b" {
  vpc_id     = aws_vpc.airflow_vpc.id
  cidr_block = "172.16.0.32/27"
  tags       = var.tags
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "airflow_subnet_a_route_table" {
  subnet_id      = aws_subnet.airflow_subnet_a.id
  route_table_id = aws_route_table.airflow_route_table.id
}

resource "aws_route_table_association" "airflow_subnet_b_route_table" {
  subnet_id      = aws_subnet.airflow_subnet_b.id
  route_table_id = aws_route_table.airflow_route_table.id
}
