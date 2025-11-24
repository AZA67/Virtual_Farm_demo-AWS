# Virtual-Farm IaC via Terraform

This directory is a terraform configuration that will provision an architecture identical to the [live site](https://qmgnyc.dev)

**Provisioning Time** [~5 min]
**Domain Propagation** [~10 min - 24 hrs]

*immediatly after successful `terraform apply`; the site is viewable at the URL produced from `cf-distro` module [outputs](https://github.com/AZA67/AWS-serverless_web_app/tree/main/terraform/modules/cf_distro)*

---

## Pre-Requisites
- [awscliv2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    - *also valid aws access keys, you can find a guide for that [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/security-creds.html)
- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) *version 1.13 or higher*
- **TLD** that is rented or owned by you


---
## Setup
This [bash-script](https://github.com/AZA67/AWS-serverless_web_app/tree/main/terraform/setup.sh) to auto-configure the entire infrastructure if your into that sort of thing. *If not, then you probably already know what you're doing and wont need this walkthrough anyway.*

1) Make script executable if not already
`chmod u+x setup.sh`

run `./setup.sh`

2) the script will pause and give you time to add Route53 Nameservers to the Domain Nameservers configuration in the web UI of your chosen domain registrar
- **Do this before conitnuing** or else the ACM Certificate issued for the domain will not be approved
    -  *Most external domain providers **do not** allow users to update Nameservers via API, so I had to take this route*
    - *In the future, ill offer a seperate configuration for obtaining a domain through Route53, allowing for complete automation of this process*

***side note: after some more research it seems that some domain registrars like cloudflare offer an API to update nameservers programatically, but only for enterprise accounts***


---
**ISSUES TO FIX**
- I havent had time to finish configuring the [WAF] module. Ill get to that...
