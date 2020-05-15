# How to contribute
Thanks for taking time to contribute!

This document outlines the contribution guidelines for Saint Louis Regional Data Alliance's projects. These are mostly guidelines; feel free to reach out to one of the STLRDA staff if you have questions, or  you'd like to contribute in ways unrelated to code.

Please note that this is a living document, and subject to frequent expansion and change.

## Table of Contents
* [Code of Conduct](#code-of-conduct)
* [Important Resources](#important-resources)
* [How to Contribute](#how-to-contribute)
* [Style Guides](#style-guides)

## Code of Conduct
This is under construction, and will be updated when ready. For now, be respectful and do right by your community.

## Important Resources
* [stldata.org](https://stldata.org) tells you about our organization
* [This google drive folder](https://drive.google.com/drive/folders/1dBwWpALR4q5Z_3X-S5O00uWi9SEGmgJO?usp=sharing) contains powerpoint pitch decks about our projects.

## How Can I Contribute?
1. Check the issues to see what needs to be done. Feel free to add additional issues if you think of additional work that should be done.
2. Once you've identified an issue you would like to tackle, assign it to yourself.
3. Create a branch off of Development, and name it after your issue number (issues/16, for example). This branch is where you will do your work. WE WILL NOT ACCEPT PULL REQUESTS FROM FORKS.
4. Once you have completed your work, submit a pull request from your branch to the Release-Candidate branch. Pull requests will be reviewed and merged on a regular basis (at least once a week).
5. Once all pull requests are merged, Release-Candidate will be pulled and merged into Master and Development branches for the next cycle.

## Style Guides
### Terraform
The Saint Louis Regional Data Alliance follows some simple style rules when writing Terraform modules:

* Code is broken up into types of resources (EC2, IAM, etc), with files names after the resource type they are addressing. There is not a hard and fast system for what constitutes a resource type.

* If a resource can be tagged in AWS, it should be tagged with the Project and Organization

* All configurable options should be setup in the terraform.tfvars.example file. Variables should be clearly labeled and described.

* The assumption is that future users of all of our modules will not be proficient in AWS, Terraform, or the platforms we are building. As such, readability and clarity are paramount.
### Python
STLRDA follows [pep8](https://www.python.org/dev/peps/pep-0008/). There are many tools that will help with enforcement of this standard.