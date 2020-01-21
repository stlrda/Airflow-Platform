#----------------------------------
#Create security group for ec2 instances
#----------------------------------
resource "aws_security_group" "ec2-sg" {
  name        = "${var.cluster_name}-sg"
#  count       = 1
  description = "Security group for airflow ec2 instances"
  vpc_id      = "${aws_vpc.airflow_vpc.id}"
  tags        = var.tags
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

#----------------------------------
#Create ec2 instances
#----------------------------------
resource "aws_instance" "airflow_webserver" {
  count = 1

  instance_type               = var.webserver_instance_type
  ami                         = var.ami
  key_name                    = var.ec2_keypair_name
  vpc_security_group_ids      = ["${aws_security_group.ec2-sg.id}"]
  subnet_id                   = aws_subnet.airflow_subnet_a.id
  iam_instance_profile        = aws_iam_instance_profile.airflow_profile.name
  associate_public_ip_address = true
  volume_tags                 = var.tags
  tags                        = merge(var.tags, {"Name" = "airflow_webserver"})

  lifecycle { create_before_destroy = true }

  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
  }

//  provisioner "remote-exec" {
//    inline = [
//      "echo AIRFLOW__CORE__DEFAULT_TIMEZONE=America/Chicago | sudo tee -a /tmp/custom_env",
//      "echo psycopg2-binary | sudo tee -a /tmp/requirements.txt",
//      "echo AWS_DEFAULT_REGION=${var.aws_region} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW_HOME=/usr/local/airflow | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__EXECUTOR=CeleryExecutor | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__FERNET_KEY=${var.fernet_key} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__LOAD_EXAMPLES=true | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__LOAD_DEFAULTS=false | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://${var.db_username}:${var.db_password}@${aws_db_instance.airflow_database.endpoint}/${var.db_dbname} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__REMOTE_BASE_LOG_FOLDER=s3://${aws_s3_bucket.airflow_logs.id} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__REMOTE_LOGGING=True | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__WEBSERVER__WEB_SERVER_PORT=8080 | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__WEBSERVER__RBAC=True | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CELERY__BROKER_URL=sqs:// | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CELERY__DEFAULT_QUEUE=${var.cluster_name}-queue | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CELERY__RESULT_BACKEND=db+postgresql://${var.db_dbname}:${var.db_password}@${aws_db_instance.airflow_database.endpoint}/${var.db_dbname} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CELERY__BROKER_TRANSPORT_OPTIONS__REGION=${var.aws_region} | sudo tee -a /tmp/airflow_environment",
//      "echo [Unit] | sudo tee -a /tmp/airflow.service",
//      "echo Description=Airflow daemon | sudo tee -a /tmp/airflow.service",
//      "echo After=network.target | sudo tee -a /tmp/airflow.service",
//      "echo [Service] | sudo tee -a /tmp/airflow.service",
//      "echo EnvironmentFile=/etc/sysconfig/airflow | sudo tee -a /tmp/airflow.service",
//      "echo User=ubuntu | sudo tee -a /tmp/airflow.service",
//      "echo Group=ubuntu | sudo tee -a /tmp/airflow.service",
//      "echo Type=simple | sudo tee -a /tmp/airflow.service",
//      "echo Restart=always | sudo tee -a /tmp/airflow.service",
//      "echo ExecStart=/usr/bin/terraform-aws-airflow | sudo tee -a /tmp/airflow.service",
//      "echo RestartSec=5s | sudo tee -a /tmp/airflow.service",
//      "echo PrivateTmp=true | sudo tee -a /tmp/airflow.service",
//      "echo [Install] | sudo tee -a /tmp/airflow.service",
//      "echo WantedBy=multi-user.target | sudo tee -a /tmp/airflow.service",
//      "echo AIRFLOW_ROLE=WEBSERVER | sudo tee -a /etc/environment",
//    ]
//
//    connection {
//      host        = self.public_ip
//      agent       = false
//      type        = "ssh"
//      user        = "ubuntu"
//      private_key = file(var.private_key_path)
//    }
//  }

  user_data= data.template_file.provisioner.rendered

}

resource "aws_instance" "airflow_scheduler" {
  count                       = 1
  instance_type               = var.scheduler_instance_type
  ami                         = var.ami
  key_name                    = var.ec2_keypair_name
  vpc_security_group_ids      = ["${aws_security_group.ec2-sg.id}"]
  subnet_id                   = aws_subnet.airflow_subnet_a.id
  iam_instance_profile        = aws_iam_instance_profile.airflow_profile.name
  associate_public_ip_address = true
  volume_tags                 = var.tags
  tags                        = merge(var.tags, {"Name" = "airflow_scheduler"})

  lifecycle { create_before_destroy = true }

  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
  }

//  provisioner "remote-exec" {
//    inline = [
//      "echo AIRFLOW__CORE__DEFAULT_TIMEZONE=America/Chicago | sudo tee -a /tmp/custom_env",
//      "echo psycopg2-binary | sudo tee -a /tmp/requirements.txt",
//      "echo AWS_DEFAULT_REGION=${var.aws_region} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW_HOME=/usr/local/airflow | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__EXECUTOR=CeleryExecutor | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__FERNET_KEY=${var.fernet_key} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__LOAD_EXAMPLES=true | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__LOAD_DEFAULTS=false | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://${var.db_username}:${var.db_password}@${aws_db_instance.airflow_database.endpoint}/${var.db_dbname} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__REMOTE_BASE_LOG_FOLDER=s3://${aws_s3_bucket.airflow_logs.id} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__REMOTE_LOGGING=True | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__WEBSERVER__WEB_SERVER_PORT=8080 | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__WEBSERVER__RBAC=True | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CELERY__BROKER_URL=sqs:// | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CELERY__DEFAULT_QUEUE=${var.cluster_name}-queue | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CELERY__RESULT_BACKEND=db+postgresql://${var.db_dbname}:${var.db_password}@${aws_db_instance.airflow_database.endpoint}/${var.db_dbname} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CELERY__BROKER_TRANSPORT_OPTIONS__REGION=${var.aws_region} | sudo tee -a /tmp/airflow_environment",
//      "echo [Unit] | sudo tee -a /tmp/airflow.service",
//      "echo Description=Airflow daemon | sudo tee -a /tmp/airflow.service",
//      "echo After=network.target | sudo tee -a /tmp/airflow.service",
//      "echo [Service] | sudo tee -a /tmp/airflow.service",
//      "echo EnvironmentFile=/etc/sysconfig/airflow | sudo tee -a /tmp/airflow.service",
//      "echo User=ubuntu | sudo tee -a /tmp/airflow.service",
//      "echo Group=ubuntu | sudo tee -a /tmp/airflow.service",
//      "echo Type=simple | sudo tee -a /tmp/airflow.service",
//      "echo Restart=always | sudo tee -a /tmp/airflow.service",
//      "echo ExecStart=/usr/bin/terraform-aws-airflow | sudo tee -a /tmp/airflow.service",
//      "echo RestartSec=5s | sudo tee -a /tmp/airflow.service",
//      "echo PrivateTmp=true | sudo tee -a /tmp/airflow.service",
//      "echo [Install] | sudo tee -a /tmp/airflow.service",
//      "echo WantedBy=multi-user.target | sudo tee -a /tmp/airflow.service",
//      "echo AIRFLOW_ROLE=SCHEDULER | sudo tee -a /etc/environment",
//    ]
//
//    connection {
//      host        = self.public_ip
//      agent       = false
//      type        = "ssh"
//      user        = "ubuntu"
//      private_key = file(var.private_key_path)
//    }
//  }

  user_data= data.template_file.provisioner.rendered

}

resource "aws_instance" "airflow_worker" {
  count                       = var.number_of_workers
  instance_type               = var.worker_instance_type
  ami                         = var.ami
  key_name                    = var.ec2_keypair_name
  vpc_security_group_ids      = ["${aws_security_group.ec2-sg.id}"]
  subnet_id                   = aws_subnet.airflow_subnet_a.id
  iam_instance_profile        = aws_iam_instance_profile.airflow_profile.name
  associate_public_ip_address = true
  volume_tags                 = var.tags
  tags                        = merge(var.tags, {"Name" = "airflow_worker"})

  lifecycle { create_before_destroy = true }

  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
  }

//  provisioner "remote-exec" {
//    inline = [
//      "echo AIRFLOW__CORE__DEFAULT_TIMEZONE=America/Chicago | sudo tee -a /tmp/custom_env",
//      "echo psycopg2-binary | sudo tee -a /tmp/requirements.txt",
//      "echo AWS_DEFAULT_REGION=${var.aws_region} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW_HOME=/usr/local/airflow | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__EXECUTOR=CeleryExecutor | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__FERNET_KEY=${var.fernet_key} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__LOAD_EXAMPLES=true | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__LOAD_DEFAULTS=false | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://${var.db_username}:${var.db_password}@${aws_db_instance.airflow_database.endpoint}/${var.db_dbname} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__REMOTE_BASE_LOG_FOLDER=s3://${aws_s3_bucket.airflow_logs.id} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CORE__REMOTE_LOGGING=True | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__WEBSERVER__WEB_SERVER_PORT=8080 | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__WEBSERVER__RBAC=True | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CELERY__BROKER_URL=sqs:// | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CELERY__DEFAULT_QUEUE=${var.cluster_name}-queue | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CELERY__RESULT_BACKEND=db+postgresql://${var.db_dbname}:${var.db_password}@${aws_db_instance.airflow_database.endpoint}/${var.db_dbname} | sudo tee -a /tmp/airflow_environment",
//      "echo AIRFLOW__CELERY__BROKER_TRANSPORT_OPTIONS__REGION=${var.aws_region} | sudo tee -a /tmp/airflow_environment",
//      "echo [Unit] | sudo tee -a /tmp/airflow.service",
//      "echo Description=Airflow daemon | sudo tee -a /tmp/airflow.service",
//      "echo After=network.target | sudo tee -a /tmp/airflow.service",
//      "echo [Service] | sudo tee -a /tmp/airflow.service",
//      "echo EnvironmentFile=/etc/sysconfig/airflow | sudo tee -a /tmp/airflow.service",
//      "echo User=ubuntu | sudo tee -a /tmp/airflow.service",
//      "echo Group=ubuntu | sudo tee -a /tmp/airflow.service",
//      "echo Type=simple | sudo tee -a /tmp/airflow.service",
//      "echo Restart=always | sudo tee -a /tmp/airflow.service",
//      "echo ExecStart=/usr/bin/terraform-aws-airflow | sudo tee -a /tmp/airflow.service",
//      "echo RestartSec=5s | sudo tee -a /tmp/airflow.service",
//      "echo PrivateTmp=true | sudo tee -a /tmp/airflow.service",
//      "echo [Install] | sudo tee -a /tmp/airflow.service",
//      "echo WantedBy=multi-user.target | sudo tee -a /tmp/airflow.service",
//      "echo AIRFLOW_ROLE=WORKER | sudo tee -a /etc/environment",
//    ]
//
//    connection {
//      host        = self.public_ip
//      agent       = false
//      type        = "ssh"
//      user        = "ubuntu"
//      private_key = file(var.private_key_path)
//    }
//  }

  user_data= data.template_file.provisioner.rendered

}

