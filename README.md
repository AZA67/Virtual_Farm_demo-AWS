# Virtual Farm web-app via AWS
[Live Site](https://qmgnyc.dev)

**TLDR;**
This serverless micro-architecture design implements several AWS services in order to construct a scalable, cost-friendly architecture; ideal for demoing web applications or lightweight backend application logic.

### IaC terraform configuration added [HERE](https://github.com/AZA67/Virtual_Farm_demo-AWS/tree/main/terraform)

**AWS services utilized**:
- Route53
- Lambda
- Cloudfront
- Web Application Firewall 
- S3 standard bucket
- Cloudwatch
- DynamoDB
- Amazon Certificate Manager
- API Gateway (HTTP API)

**TO BE ADDED SOON**
- yaml configuration files
- bash scripts for aws-cli
- full walkthrough
- future considerations

---
### Pricing 
[total =~ $10/month]
*WAF accounts for 99% of monthly costs* - (consider opting out for testing environments)

| Service                           | Free-tier usage / price                                                                                                          | Usage                                                                            | Source                                                                                                                                       |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| (**Route 53**)                    | **$0.50** / hosted zone / month                                                                                                  | **1 public hosted zone**                                                         | [Route53 docs](https://aws.amazon.com/route53/pricing/)                                                                                      |
| **AWS Certificate Manager (ACM)** | **$0** for **non-exportable public certificates** used on ACM-integrated services (e.g., *CloudFront*).                          | **1 Certificate**                                                                | [ACM docs](https://www.amazonaws.cn/en/certificate-manager/pricing/)                                                                         |
| **Amazon S3**                     | **5 GB** S3 Standard storage, **20,000 GET** + **2,000 PUT** requests per month                                                  | **>1 mb** of assets. **GET/PUT** varies on cloudfront cache invalidations        | [S3 docs](https://aws.amazon.com/s3/pricing/)                                                                                                |
| **Amazon CloudFront**             | **Always-free**: **1 TB data transfer out** + **10,000,000 HTTP(S) requests** + **2,000,000 CF Function invocations** per month. | **< 1TB data transfer.** // **<10k HTTPS req.** //**0 CF functions**             | [CF docs](https://aws.amazon.com/cloudfront/pricing/)                                                                                        |
| **API Gateway (HTTP APIs)**       | **1,000,000 requests / month for 12 months** (new accounts).                                                                     | **>1 mil** requests/month                                                        | [API docs](https://aws.amazon.com/api-gateway/pricing/)                                                                                      |
| **AWS Lambda**                    | **1,000,000 requests** + **400,000 GB-seconds** / month.                                                                         | **~12ms** avg. runtime per invokation                                            | [lambda docs](https://aws.amazon.com/lambda/pricing/)                                                                                        |
| **Amazon DynamoDB**               | **25 GB** storage free (per region) on **Standard** table class.                                                                 | **~107 bytes** avg. item size with **on-demand** thoughput in **standard table** | [DynamoDB docs.](https://aws.amazon.com/dynamodb/pricing/on-demand/?utm_source=chatgpt.com "Amazon DynamoDB pricing for on-demand capacity") |
| (**AWS WAF (v2)**)                | **$5/month** per Web ACL // **$1/month** per Rule // **$0.60** per 1 million requests                                            | **1 Web ACL // 4 Rules // <1mil requests**                                       | [WAF docs](https://aws.amazon.com/waf/pricing/)                                                                                              |
() *not free tier eligible*

---
### Overview
![architecture overview](AWS-serverless-static-webapp.svg)




