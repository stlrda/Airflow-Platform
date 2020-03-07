# Airflow Explanation
Automating the processing of data from wildly different government sources into a format that can be added to this database involves many steps. These steps can be saved in script files to be run on new data, but the running of these script files is still a complex task. To effectively import the data, these steps must applied to the data periodically and in sequences. Task scheduling services such as chron, which are provided with operating systems, are very limited. Apache Airflow provides a flexible and effective method to automate this workflow of menial data processing tasks.
Apache Airflow is a workflow manager based on DAGs, directed acyclic graphs. In plain English, these are structures akin to flow charts which define the tasks that must be performed and specifically map out the path of flow from one task to another within the process. The entire workflow's DAG, though it is also called a Pipeline in Airflow terminology, is defined within a Python script file. You can learn to make this file with Apache's tutorial here:

[https://airflow.apache.org/docs/stable/tutorial.html](https://airflow.apache.org/docs/stable/tutorial.html)

# REDB-Platform
A module for creating an Apache Airflow cluster in AWS. This Airflow cluster will be used to power the data pipelines for the Saint Louis Regional Entity Database.

# Backend Setup
Terraform state (the canonical terraform.tfstate file) is stored remotely in S3 so multiple developers can apply using different computers.

An S3 bucket (per region) is manually created and referenced in backend.tf (name format is below)
a DynamoDB Table is created (per region) and referenced in backend.tf (table name is terraform and the table's Partiton Key must be set as LockID)
Only one bucket and table is used for multiple environments

# TFVARS
The .tfvars file overrides other variables, and serves as the user's way to configure their unique version of their cluster. terraform.tfvars.example is included to help the user create their own version. IF YOU ARE FORKING THIS REPO, MAKE SURE TO IGNORE YOUR .tfvars FILE SO YOU DON'T SHARE YOU AWS CREDENTIALS.
