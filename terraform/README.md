# Virtual-Farm IaC via Terraform
(*constantly improving*)

This directory is a terraform configuration that will provision an architecture identical to the [live site](https://qmgnyc.dev)

---

## Pre-Requisites
- [awscliv2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    - *also valid aws access keys, you can find a guide for that [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/security-creds.html)
- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) *version 1.13 or higher*
- **TLD** that is rented or owned by you


---
## Setup
I created a [bash-script](https://github.com/AZA67/Virtual_Farm_demo-AWS/tree/main/terraform/setup.sh) to auto-configure the entire infrastructure if your into that sort of thing. *If not, then you probably already know what you're doing and wont need this walkthrough anyway.*

1) Make script executable if not already
`chmod u+x setup.sh`

run `./setup.sh`

2) After sucessful completion of the script; you should be able to see all of the resources planned to be provisioned by terraform after running `terraform plan`

3) If all looks good then run `terraform apply`

*I purchased a domain outside of AWS, so you must take the Name Servers outputed from [Route53-main.tf](https://github.com/AZA67/Virtual_Farm_demo-AWS/tree/main/terraform/modules/route53)  and add them to the DNS config of your chosen domain registrar*

---
**ISSUES TO FIX**
- I havent had time to finish configuring the [WAF] module. Ill get to that...
- I want to re-configure the [Route53] module to use a route53 managed domain so DNS doesnt get in the way of the "easy setup"
