#----------------------------------
#Creates IAM Roles
#----------------------------------
# TODO Need to create roles
resource "aws_iam_role" iam_role {
  name = "${var.cluster_name}-profile"
}

#----------------------------------
#Assigns IAM policies
#----------------------------------

#EC2 Profile
resource "aws_iam_instance_profile" "airflow_profile" { #TODO does this serve all ec2 instances, or just the workers?
  name = "${var.cluster_name}-profile"
  path = "/instance-profile/"
}

resource "aws_iam_role_policy_attachment" "s3_policy" {
  role       = "${var.cluster_name}-s3-policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "sqs_policy" {
  role       = "${var.cluster_name}-sqs-policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_sqs_queue_policy" "sqs_permission" {
  queue_url = aws_sqs_queue.airflow_queue.id
  policy    = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "SQS:*",
      "Resource": "${aws_sqs_queue.airflow_queue.arn}"
    }
  ]
}
POLICY
}