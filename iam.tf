#----------------------------------
#Creates IAM Roles
#----------------------------------
resource "aws_iam_role" iam_role {
  name = "${var.cluster_name}-profile"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#----------------------------------
#Assigns IAM policies
#----------------------------------

#EC2 Profile
resource "aws_iam_instance_profile" "airflow_profile" {
  name = "${var.cluster_name}-profile"
  role = aws_iam_role.iam_role.name
}

resource "aws_iam_role_policy_attachment" "s3_policy" {
  role       = aws_iam_instance_profile.airflow_profile.name
//  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  policy_arn = aws_iam_policy.ec2_health_check_policy.arn
}

# Create Health Check Policy
resource "aws_iam_policy" "ec2_health_check_policy" {
  name = "ec2_health_check_policy"
  path = "/"
  description = "Allow EC2 to run health checks without errors"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SSMAction",
            "Effect": "Allow",
            "Action": [
                  "ssm:UpdateInstanceInformation",
                  "ssmmessages:CreateControlChannel",
                  "ssmmessages:CreateDataChannel",
                  "ssmmessages:OpenControlChannel",
                  "ssmmessages:OpenDataChannel"
              ],
            "Resource": "*"
        },
        {
            "Sid": "s3action",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        },
        {
            "Sid": "Messages",
            "Effect": "Allow",
            "Action": "ec2messages:*",
            "Resource": "*"
        }
    ]
}
EOF
}