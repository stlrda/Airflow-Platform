# REDB-Platform
A module for creating an Apache Airflow cluster in AWS. This Airflow cluster will be used to power the data pipelines for the Saint Louis Regional Entity Database.

#Backend Setup
Terraform state (the cannonical terraform.tfstate file) is stored remotely in S3 so multiple developers can apply using different computers.

An S3 bucket (per region) is manually created and referenced in backend.tf (name format is below)
a DynamoDB Table is created (per region) and referenced in backend.tf (table name is terraform and the table's Partiton Key must be set as LockID)
Only one bucket and table is used for multiple environments
