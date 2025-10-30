# TERRAFORM CONFIGURATION FOR VIRTUAL FARM
(*under construction*)

This directory is a terraform configuration that will provision an architecture identical to [qmgnyc.dev](live site)

**NOTE**
- the current configuration does not account for uploading the [S3_assets] required to build the static site
- I purchased a domain outside of AWS, so you must take the Name Servers outputed from [[./modules/route53/main.tf]] and add them to the DNS config of your chosen domain registrar 

---
## Backend State File [[./bootstrap/backend.tf]]

This setup requires you to run `terraform init` twice inside the [bootstrap/] directory
1) Initialized the local backend and provisions the cloud resources needed to host the remote state file
2) uncomment lines 3-9 in [[bootstrap/backend.tf]] and run `terraform init` a second time

This setup will ensure that the resources provisioned in order to setup the remote backend (S3 bucket and DynamoDB Table) will also be tracked in the remote backend

---
## Root module
this setup is fairly straight forward 
**ensure backend S3-bucket remains the same** but feel free to edit the `key`
`terraform init`
`terraform plan` (*you will run into issues here*)
`terraform apply`

**ISSUES TO FIX**
- Add a lambda function locally that can be used to configure the aws_lambda resource 
    - *if you use your own* be sure to edit the [handler] attribute `line 32` in [[./module/lambda/main.tf]] to reference a valid entry point for the api requests.
- I havent had time to finish configuring the [WAF] module. Ill get to that...