variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

#s3-resources#
variable "bucket_regional_domain_name" {
    type = string
    description = "s3-bucket regional endpoint (output of ./modules/s3_static_site)"
}

variable "bucket_arn" {
  type = string
  description = "output from s3 module"
}

variable "bucket_name" {
    type = string
    description = "output from s3 module"
}

variable "domain_name" {
  type = string
  description = "defined in root"
}

#http api resources#
variable "http_api_id" {
  type = string
  description = "used for the `id` portion of apigateway origin.domain_name"
}

variable "acm_certificate_arn" {
  type = string
  description = "provisioned in route53 module"
}