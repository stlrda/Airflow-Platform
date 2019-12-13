variable "cluster_name" {
  description = "Used to name resources created throughout AWS"
  type = string
}

variable "tags" {
  description = "Tags applied to all Airflow related objects"
  type = "map"
  default = {
    "Project" = "Airflow"
  }
}

variable "aws_region" {
  description = "AWS Region"
  type = string
  default = 'us-east-1'
}

variable "aws_profile" {
  description = "Profile from AWS credential file to be used"
  type = string
  default = "default"
}
