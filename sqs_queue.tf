#----------------------------------
#Creates an SQS queue # TODO Is this used to communicate with workers?
#----------------------------------
resource "aws_sqs_queue" "airflow_queue" {
  name             = "${var.cluster_name}-queue"
  max_message_size = 262144
  tags             = var.tags
}
