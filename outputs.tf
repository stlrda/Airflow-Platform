output "login_url" {
  description = "Login page for the cluster"
  value = "${aws_instance.airflow_webserver.public_ip}:8080"
}

output "cluster_vpc_id"{
  description = "AWS VPC the cluster resides in"
  value = aws_vpc.airflow_vpc.id
}

output "cluster_nodes_sg_id" {
  description = "AWS Security group id for the cluster nodes"
  value = aws_security_group.ec2-sg.id
}

output "db_subnet_group" {
  description = "AWS subnet group db resides in"
  value = aws_db_subnet_group.rds_subnet_group.id
}