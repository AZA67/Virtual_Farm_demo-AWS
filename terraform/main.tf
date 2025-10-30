terraform {
     backend "s3" {
        bucket = "tf-states"
        key = "prod/terraform.tfstate"
        region = "us-east-2"
        dynamodb_table = "tf-state-lock"
        encrypt = true
    }
    required_version = ">=1.13"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = ">6.0"
        }
    }
}

provider "aws" {
    region = var.region
}

module "route53" {
    source = "./modules/route53"
    domain_name = var.domain_name
    project_name = var.project_name

}

module "s3_static_site" {
    source = "./modules/s3_static_site"
    project_name = var.project_name
}

module "dynamodb" {
    source = "./modules/dynamodb"
    project_name = var.project_name
}

module "lambda" {
    source = "./modules/lambda"
    project_name = var.project_name

    table_name = module.dynamodb.table_name
}

module "http-api" {
    source = "./modules/http-api"
    project_name = var.project_name

    function_name = module.lambda.function_name
    invoke_arn = module.lambda.invoke_arn
}

module "cf_distro" {
    source = "./modules/cf_distro"
    project_name = var.project_name
    domain_name = var.domain_name

    bucket_arn = module.s3_static_site.bucket_arn
    bucket_regional_domain_name = module.s3_static_site.bucket_regional_domain_name
    bucket_name = module.s3_static_site.bucket_name
    acm_certificate_arn = module.route53.acm_certificate_arn
    http_api_endpoint = module.http-api.http_api_endpoint
}

#WAF MODULE (unfinished)


