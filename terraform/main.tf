terraform {
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

#import acm cert for Cloudfront Configuration
data "terraform_remote_state" "route53" {
    backend = "s3"
    config = {
        bucket = "${var.project_name}-tf-state"
        key = "route53/terraform.tfstate"
        region = "${var.region}"
    }
}

module "s3_static_site" {
    source = "./modules/s3_static_site"
    project_name = var.project_name
    s3_assets_dir = abspath("../S3-assets/")
}

module "dynamodb" {
    source = "./modules/dynamodb"
    project_name = var.project_name
}

module "lambda" {
    source = "./modules/lambda"
    project_name = var.project_name
    lambda_dir = abspath("../lambda/")

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
    region = var.region 

    bucket_arn = module.s3_static_site.bucket_arn
    bucket_regional_domain_name = module.s3_static_site.bucket_regional_domain_name
    bucket_name = module.s3_static_site.bucket_name
    acm_certificate_arn = data.terraform_remote_state.route53.aws_acm_certificate.acm-cert.arn
    http_api_id = module.http-api.http_api_id
}

#WAF MODULE (unfinished)


