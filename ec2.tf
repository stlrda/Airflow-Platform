#----------------------------------
#Create security group for ec2 instances
#----------------------------------
resource "aws_security_group" "ec2-sg" {
  name = "${var.cluster_name}-sg"
  count = 1
  description = "Security group for airflow ec2 instances"
  vpc_id = var.vpc_id
  tags = var.tags

  ingress {  #TODO Figure out cidr blocks?
    from_port = 80
    to_port =80
    protocol = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "HTTPS
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

#----------------------------------
#Create ec2 instances
#----------------------------------
resource "aws_instance" "airflow_webserver" { #TODO need to add provisioners (see PowerDataHub-terraform-aws-airflow/main.tf, line 121)
  count = 1

  instance_type = var.webserver_instance_type
  ami = var.ami
  key_name = var.ec2_keypair_name
  vpc_security_group_ids = aws_security_group.ec2-sg.id
  iam_instance_profile = aws_iam_instance_profile.airflow_profile.name
  associate_public_ip_address = true
  volume_tags = var.tags

  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.
  }
}