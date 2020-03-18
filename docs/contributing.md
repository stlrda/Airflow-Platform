# How to contribute
Thanks for taking time to contribute!

This document outlines the contribution guidelines for Saint Louis Regional Data Alliance's projects. These are mostly guidelines; feel free to reach out to one of the STLRDA staff if you have questions, or  you'd like to contribute in ways unrelated to code.

Please note that this is a living document, and subject to frequent expansion and change.

## Table of Contents
* Code of Conduct
* Important Resources
* Project Overviews
* How Can I Contribute?
* Style Guides

## Code of Conduct
This is under construction, and will be updated when ready. For now, be respectful and do right by your community.

## Important Resources
* [stldata.org](https://stldata.org) tells you about our organization
* [This google drive folder](https://drive.google.com/drive/folders/1dBwWpALR4q5Z_3X-S5O00uWi9SEGmgJO?usp=sharing) contains powerpoint pitch decks about our projects.


## Project Overview
### General
While availability is a critical first step in using data to impact communities, it is just as important, if not more so, that the data be _useable_. Data that is highly fragmented, lacks standardization, in difficult to use formats, and/or lacking context and documentation is extremely difficult to build tools and analysis off of.

To address this need, the Saint Louis Regional Data Alliance is building the Regional Entity Database (REDB), a unified database of land parcel data. Pulling data from numerous local government departments and with a schema designed to be understandable by the average citizen, REDB will serve as single source of truth for parcel data.

REDB is being built entirely in AWS, with an eye on being reproducible by other organizations and municipalities. To that end, all code associated with this project is being made available on Github, in three repositories.
* [REDB-Platform](https://github.com/stlrda/REDB-Platform) contains a Terraform module that builds an Airflow cluster that will run and manage the ETL processes that will create, maintain, and update REDB. Run in isolation, this will create a functioning Airflow cluster and nothing mroe.
* [REDB-Infrastructure](https://github.com/stlrda/REDB-Infrastructure) builds on the above. It contains Terraform code that pulls in the module above, and adds an S3 bucket (for the Airflow workers to use in their processes) and an Aurora PostGreSQL database (REDB). Run in isolation, this will creating everything an organization needs to start building out their own data workflows.
* [REDB-Workflows](https://github.com/stlrda/REDB-Workflows) contains the DAGs, scripts, and other files that the Airflow cluster will run. This piece is the most Saint Louis specific, but is being provided to serve as an example for other municipalities, and to provide visibility into REDB's working processes.
### This Repository
This repository contains a [Terraform](https://www.terraform.io/) module that builds an [Airflow](https://airflow.apache.org/) cluster in AWS.


## How Can I Contribute?

## Style Guides
### Terraform
### Python
