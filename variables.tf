#METADATA VARIABLES----------------------
variable "cluster_name" {
  description = "Used to name resources created throughout AWS"
  type        = string
}

variable "tags" {
  description = "Tags applied to all Airflow related objects"
  type        = map
  default = {
    "Project" = "Airflow"
  }
}

#ADMINISTRATION AND CREDENTIAL VARIABLES------------------
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Profile from AWS credential file to be used"
  type        = string
  default     = "default"
}

variable "ec2_keypair_name" {
  description = "Name of keypair used to access ec2 instances"
  type        = string
  default     = "Airflow_key"
}

variable "public_key_path" {
  description = "Enter the path to the SSH Public Key to use for ec2 instances."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Enter the path to the SSH Private Key to use for ec2 instances."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "admin_name" {
  description = "Name of the administrator for the airflow cluster"
  type = string
  default = "admin"
}

variable "admin_lastname" {
  description = "Last name of the adminstrator for the airflow cluster"
  type = string
  default = "admin"
}

variable "admin_email" {
  description = "Email address for the administrator for the airflow cluster"
  type = string
}

variable "admin_username" {
  description = "Username for the administrator for the airflow cluster"
  type = string
}

variable "admin_password" {
  description = "Password for teh adminstrator for the airflow cluster"
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
  type        = string
  default     = 1
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
  type        = string
  default     = "db.t2.micro"
}

variable "db_dbname" {
  description = "PostgreSQL database name"
  type        = string
  default     = "airflow"
}

variable "db_username" {
  description = "PostgreSQL database username"
  type        = string
  default     = "airflow"
}

variable "db_password" {
  description = "PostgreSQL database password"
  type        = string
}

variable "fernet_key" {
  description = "Key for encrypting data in the database - see Airflow docs."
  type = string
}

#GIT VARIABLES------------------------------------
variable "dag_git_repository_url" {
  description = "Publicly available github repository url of dag repository."
  type = string
}

variable "dag_git_repository_directory" {
  description = "Sub directory of folder in repository containing DAGs."
  type = string
}

variable "dag_git_repository_branch" {
  description = "Branch of repository to pull every 5 minutes."
  type = string
}

#EC2 Provisioner Variables-----------------------
data "template_file" "webserver_provisioner" {
  template = file("${path.module}/Startup Scripts/cloud-init.sh")

  vars = {
    AWS_REGION = var.aws_region
    FERNET_KEY = var.fernet_key
    LOAD_EXAMPLE_DAGS = true
    LOAD_DEFAULT_CONNS = true
    RBAC = true
    ADMIN_NAME = var.admin_name
    ADMIN_LASTNAME = var.admin_lastname
    ADMIN_EMAIL = var.admin_email
    ADMIN_USERNAME = var.admin_username
    ADMIN_PASSWORD = var.admin_password
    DB_USERNAME = var.db_username
    DB_PASSWORD = var.db_password
    DB_ENDPOINT = aws_db_instance.airflow_database.endpoint
    DB_DBNAME = var.db_dbname
    S3_BUCKET = aws_s3_bucket.airflow_logs.id
    # WEBSERVER_HOST     = "${aws_instance.airflow_webserver.public_dns}"
    WEBSERVER_PORT = 8080
    QUEUE_NAME = "${var.cluster_name}-queue"
    AIRFLOW_ROLE = "WEBSERVER"
    DAG_GIT_REPOSITORY_URL = var.dag_git_repository_url
    DAG_GIT_REPOSITORY_DIRECTORY = var.dag_git_repository_directory
    DAG_GIT_REPOSITORY_BRANCH = var.dag_git_repository_branch
  }
}

data "template_file" "scheduler_provisioner" {
  template = file("${path.module}/Startup Scripts/cloud-init.sh")

  vars = {
    AWS_REGION = var.aws_region
    FERNET_KEY = var.fernet_key
    LOAD_EXAMPLE_DAGS = true
    LOAD_DEFAULT_CONNS = true
    RBAC = true
    ADMIN_NAME = var.admin_name
    ADMIN_LASTNAME = var.admin_lastname
    ADMIN_EMAIL = var.admin_email
    ADMIN_USERNAME = var.admin_username
    ADMIN_PASSWORD = var.admin_password
    DB_USERNAME = var.db_username
    DB_PASSWORD = var.db_password
    DB_ENDPOINT = aws_db_instance.airflow_database.endpoint
    DB_DBNAME = var.db_dbname
    S3_BUCKET = aws_s3_bucket.airflow_logs.id
    # WEBSERVER_HOST     = "${aws_instance.airflow_webserver.public_dns}"
    WEBSERVER_PORT = 8080
    QUEUE_NAME = "${var.cluster_name}-queue"
    AIRFLOW_ROLE = "SCHEDULER"
    DAG_GIT_REPOSITORY_URL = var.dag_git_repository_url
    DAG_GIT_REPOSITORY_DIRECTORY = var.dag_git_repository_directory
    DAG_GIT_REPOSITORY_BRANCH = var.dag_git_repository_branch
  }
}

data "template_file" "worker_provisioner" {
  template = file("${path.module}/Startup Scripts/cloud-init.sh")

  vars = {
    AWS_REGION = var.aws_region
    FERNET_KEY = var.fernet_key
    LOAD_EXAMPLE_DAGS = true
    LOAD_DEFAULT_CONNS = true
    RBAC = true
    ADMIN_NAME = var.admin_name
    ADMIN_LASTNAME = var.admin_lastname
    ADMIN_EMAIL = var.admin_email
    ADMIN_USERNAME = var.admin_username
    ADMIN_PASSWORD = var.admin_password
    DB_USERNAME = var.db_username
    DB_PASSWORD = var.db_password
    DB_ENDPOINT = aws_db_instance.airflow_database.endpoint
    DB_DBNAME = var.db_dbname
    S3_BUCKET = aws_s3_bucket.airflow_logs.id
    # WEBSERVER_HOST     = "${aws_instance.airflow_webserver.public_dns}"
    WEBSERVER_PORT = 8080
    QUEUE_NAME = "${var.cluster_name}-queue"
    AIRFLOW_ROLE = "WORKER"
    DAG_GIT_REPOSITORY_URL = var.dag_git_repository_url
    DAG_GIT_REPOSITORY_DIRECTORY = var.dag_git_repository_directory
    DAG_GIT_REPOSITORY_BRANCH = var.dag_git_repository_branch
  }
}