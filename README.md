# Aurora-serverless Terraform module

This project aims to create a terraform module to deploy an Aurora Serverless database.

It will also create some users in the database. I have implemented using a lambda function.

The proper way to do it with AWS secret manager (or SSM Parameter store secure string) instead of passing the passwords around. Similarly, we should return ARNs instead of passwords directly. However this repo is a test just for now.

It doesn't support MYSQL user creation.

It has some validations and some testing. I wanted to play with testing and this is a good reason.

Instead of having a lot of options, the module is opinionated. A different alternative obviously would be to allow a lot of variables but have them as default.
