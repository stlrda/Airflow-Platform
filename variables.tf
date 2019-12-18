#METADATA VARIABLES----------------------
variable "cluster_name" {
  description = "Used to name resources created throughout AWS"
  type = string
}

variable "tags" {
  description = "Tags applied to all Airflow related objects"
  type = map
  default = {
    "Project" = "Airflow"
  }
}
#ADMINISTRATION AND CREDENTIAL VARIABLES------------------
variable "aws_region" {
  description = "AWS Region"
  type = string
  default = "us-east-1"
}

variable "aws_profile" {
  description = "Profile from AWS credential file to be used"
  type = string
  default = "default"
}

variable "ec2_keypair_name" {
  description = "Name of keypair used to access ec2 instances"
  type= string
  default = "Airflow_key"
}

variable "public_key_path" {
  description = "Enter the path to the SSH Public Key to use for ec2 instances."
  type = string
  default = "~/.ssh/id_rsa.pub"
}
#EC2 VARIABLES (APPLY TO ALL EC2 INSTANCES UNLESSS OTHERWISE SPECIFIED)--------------------------
variable "webserver_instance_type" {
  description = "Instance type for the Airflow Webserver."
  type        = string
  default     = "t3.micro"
}

variable "scheduler_instance_type" {
  description = "Instance type for the Airflow Scheduler."
  type        = string
  default     = "t3.micro"
}

variable "worker_instance_type" {
  description = "Instance type for the Airflow workers."
  type        = string
  default     = "t3.small"
}

variable "number_of_workers" {
  description = "Number of workers for Airflow Cluster"
  type = string
  default = 1
}

variable "ami" {
  description = "Default is `Ubuntu Server 18.04 LTS (HVM), SSD Volume Type.`"
  type        = string
  default     = "ami-0a313d6098716f372"
}

variable "root_volume_type" {
  description = "The type of volume. Must be one of: standard, gp2, or io1."
  type        = string
  default     = "gp2"
}

variable "root_volume_size" {
  description = "The size, in GB, of the root EBS volume."
  type        = string
  default     = 35
}

variable "root_volume_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination."
  default     = true
}

#DB VARIABLES------------------------------------
variable "db_instance_type" {
  description = "Instance type for PostgreSQL database"
  type = string
  default = "db.t2.micro"
}

variable "db_dbname" {
  description = "PostgreSQL database name"
  type = string
  default = "airflow"
}

variable "db_username" {
  description = "PostgreSQL database username"
  type = string
  default = "airflow"
}

variable "db_password" {
  description = "PostgreSQL database password"
  type = string
}