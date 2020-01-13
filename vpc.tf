resource "aws_vpc" "airflow_vpc" {
  cidr_block = "172.16.0.0/20"
  tags       = var.tags
}

resource "aws_subnet" "airflow_subnet_a" {
  vpc_id     = "${aws_vpc.airflow_vpc.id}"
  cidr_block = "172.16.0.0/27"
  tags       = var.tags
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "airflow_subnet_b" {
  vpc_id     = "${aws_vpc.airflow_vpc.id}"
  cidr_block = "172.16.0.32/27"
  tags       = var.tags
  availability_zone = "${var.aws_region}b"
}