resource "aws_vpc" "airflow_vpc" {
  cidr_block = "172.0.0.0/16"
  tags       = var.tags
}

resource "aws_subnet" "airflow_subnet" {
  vpc_id     = "${aws_vpc.airflow_vpc.id}"
  cidr_block = "172.0.0.0/32"
  tags       = var.tags
}