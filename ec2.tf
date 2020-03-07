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
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port = 5555
    to_port = 5555
    protocol = "tcp"
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

  instance_type = var.webserver_instance_type
  ami = var.ami
  key_name = var.ec2_keypair_name
  vpc_security_group_ids = [
    "${aws_security_group.ec2-sg.id}"]
  subnet_id = aws_subnet.airflow_subnet_a.id
  iam_instance_profile = aws_iam_instance_profile.airflow_profile.name
  associate_public_ip_address = true
  volume_tags = var.tags
  tags = merge(var.tags, {
    "Name" = "airflow_webserver"
  })

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
  }

  user_data = data.template_file.webserver_provisioner.rendered

//  provisioner "file" {
//    content = data.template_file.config_provisioner.rendered
//    destination = "/tmp/airflow.cfg"
//
//    connection {
//      host = self.public_ip
//      agent = false
//      type = "ssh"
//      user = "ubuntu"
//      private_key = file(var.private_key_path)
//    }
//  }
//
//  provisioner "remote-exec" {
//    inline = [
//      "sleep 5m",
//      "sudo mv -f /tmp/airflow.cfg /usr/local/airflow/"]
//
//    connection {
//      host = self.public_ip
//      agent = false
//      type = "ssh"
//      user = "ubuntu"
//      private_key = file(var.private_key_path)
//    }
//  }
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

  user_data= data.template_file.scheduler_provisioner.rendered

//  provisioner "file" {
//    content = data.template_file.config_provisioner.rendered
//    destination = "/tmp/airflow.cfg"
//
//    connection {
//      host = self.public_ip
//      agent = false
//      type = "ssh"
//      user = "ubuntu"
//      private_key = file(var.private_key_path)
//    }
//  }
//
////  provisioner "remote-exec" {
////    inline = [
////      "sleep 5m",
////      "sudo mv -f /tmp/airflow.cfg /usr/local/airflow/"]
////
////    connection {
////      host = self.public_ip
////      agent = false
////      type = "ssh"
////      user = "ubuntu"
////      private_key = file(var.private_key_path)
////    }
////  }

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

  user_data= data.template_file.worker_provisioner.rendered

//  provisioner "file" {
//    content = data.template_file.config_provisioner.rendered
//    destination = "/tmp/airflow.cfg"
//
//    connection {
//      host = self.public_ip
//      agent = false
//      type = "ssh"
//      user = "ubuntu"
//      private_key = file(var.private_key_path)
//    }
//  }
//
//  provisioner "remote-exec" {
//    inline = [
//      "sleep 5m",
//      "sudo mv -f /tmp/airflow.cfg /usr/local/airflow/"]
//
//    connection {
//      host = self.public_ip
//      agent = false
//      type = "ssh"
//      user = "ubuntu"
//      private_key = file(var.private_key_path)
//    }
//  }
}