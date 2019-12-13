#----------------------------------
#Assigns user provided keypair for accessing EC2 instances
#----------------------------------
resource "aws_key_pair" "auth" {
  key_name = var.ec2_keypair_name
  public_key = file(var.public_key_path)
}