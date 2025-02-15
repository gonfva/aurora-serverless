# Aurora-serverless Terraform module

This project aims to create a terraform module to deploy an Aurora Serverless database.

It will also create some users in the database. I have implemented it using a lambda function.

Instead of having a lot of options, the module is opinionated. Opinions are mainly in locals.tf. A different alternative obviously would be to allow a lot of variables but have them as default.

It has some validations and some testing.

## Limitations

+ Testing is not exhaustive.

+ Implementation is not production ready. It should use AWS secret manager (or SSM Parameter store secure string) instead of passing the passwords around. Similarly, we should return ARNs instead of passwords directly.

+ It doesn't support MYSQL user creation. It doesn't support if the users are already created.

+ It assumes aws and python are installed
