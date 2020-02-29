#----------------------------------
#Creates an SQS queue
#----------------------------------
resource "aws_sqs_queue" "airflow_queue" {
  name             = "${var.cluster_name}-queue"
  max_message_size = 262144
  tags             = var.tags
}


#----------------------------------
#Creates a Redis queue
#----------------------------------
resource "aws_elasticache_cluster" "airflow_queue" {
  name             = "${var.cluster_name}-queue"
  max_message_size = 262144
  tags             = var.tags
  cluster_id = ""
}


