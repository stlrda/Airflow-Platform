#----------------------------------
#Create S3 Bucket for Airflow logs
#----------------------------------

resource "aws_s3_bucket" "airflow_logs" {
  bucket = "${var.cluster_name}-logs"
  acl = "private"
  force_destroy = true
  region = var.aws_region
  tags = var.tags
}