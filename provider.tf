#----------------------------------
#Defines AWS as cloud provider, sets credentials
#----------------------------------

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}