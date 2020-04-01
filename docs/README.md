# REDB-Platform
A module for creating an Apache Airflow cluster in AWS. This Airflow cluster will be used to power the data pipelines for the Saint Louis Regional Entity Database.

# Using This Repo
In order to use this module, you will first need to install and configure [Terraform](terraform.io) for your machine.

## Backend Setup
Terraform state (the canonical terraform.tfstate file) is stored remotely in S3 so multiple developers can apply using different computers.

#Backend Setup
Terraform state (the cannonical terraform.tfstate file) is stored remotely in S3 so multiple developers can apply using different computers.

An S3 bucket (per region) is manually created and referenced in backend.tf (name format is below)
a DynamoDB Table is created (per region) and referenced in backend.tf (table name is terraform and the table's Partiton Key must be set as LockID)
Only one bucket and table is used for multiple environments

## TFVARS
The .tfvars file overrides other variables, and serves as the user's way to configure their unique version of their cluster. terraform.tfvars.example is included to help the user create their own version. IF YOU ARE FORKING THIS REPO, MAKE SURE TO IGNORE YOUR .tfvars FILE SO YOU DON'T SHARE YOU AWS CREDENTIALS.

