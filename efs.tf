resource "aws_efs_file_system" "git_dags" {
  creation_token = "${var.cluster_name}-git_dags"
  tags=var.tags
}

resource "aws_efs_mount_target" "git_dags" {
  file_system_id = "${aws_efs_file_system.git_dags.id}"
  subnet_id = aws_subnet.airflow_subnet_a.id
  security_groups = ["${aws_security_group.ec2-sg.id}"]
}