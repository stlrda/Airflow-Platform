output "login_url" {
  description = "Login page for the cluster"
  value = "${aws_instance.airflow_webserver.public_ip}:8080"

}