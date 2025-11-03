# TERRAFORM CONFIGURATION FOR VIRTUAL FARM
(*under construction*)

This directory is a terraform configuration that will provision an architecture identical to the [live site](https://qmgnyc.dev)

**NOTE**
- the current configuration does not account for uploading the `../S3_assets/*` required to build the static site
- I purchased a domain outside of AWS, so you must take the Name Servers outputed from [Route53-main.tf](https://github.com/AZA67/Virtual_Farm_demo-AWS/tree/main/terraform/modules/route53)  and add them to the DNS config of your chosen domain registrar 

---
## Backend State File Configuration [backend.tf](https://github.com/AZA67/Virtual_Farm_demo-AWS/blob/main/terraform/bootstrap/backend.tf)

This setup requires you to run `terraform init` two seperate times while inside of the `bootstrap/`  directory;

**First time**
-  Initializes the local backend and;
-  provisions the cloud resources needed to host the remote state file

**Second time**
-  uncomment lines 3-9 in `backend.tf`  and run `terraform init` a second time

This setup will ensure that the resources provisioned for the remote backend (S3 bucket and DynamoDB Table) will also be tracked in the remote backend.

---
## Root module
this setup is fairly straight forward 
**ensure backend S3-bucket remains the same** but feel free to edit the `key`
- `terraform init`
- `terraform plan` *you will run into issues here (see below)*
- `terraform apply`

---
**ISSUES TO FIX**
- Add a lambda function locally that can be used to configure the `aws_lambda resource` 
    - *if you use your own* be sure to edit the `[handler]` attribute on `line 32` in [lambda-main.tf](https://github.com/AZA67/Virtual_Farm_demo-AWS/blob/main/terraform/modules/lambda/main.tf)  to reference a valid entry point for the api requests.
- I havent had time to finish configuring the [WAF] module. Ill get to that...
