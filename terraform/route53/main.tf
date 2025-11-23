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

# Route 53 Public Hosted Zone
resource "aws_route53_zone" "main" {
  name = "${var.domain_name}"

  tags = {
    project_name = "${var.project_name}"
  }
}

# ACM Certificate (us-east-1)
provider "aws" {
  alias = "acm"
  region = "us-east-1"
}

resource "aws_acm_certificate" "acm-cert" {
  provider = aws.acm
  
  domain_name = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = ["*.${var.domain_name}", "www.${var.domain_name}"]

  lifecycle {
    create_before_destroy = true
  }
}

# Route 53 DNS Records validation
resource "aws_route53_record" "cert_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.acm-cert.domain_validation_options :
    dvo.domain_name => {
        name = dvo.resource_record_name
        type = dvo.resource_record_type
        value = dvo.resource_record_value
    }
  }
  zone_id = aws_route53_zone.main.zone_id
  name = each.value.name
  type = each.value.type
  ttl = 300
  records = [each.value.value]
}

# ACM cert validation (waits until DNS validation succeeds)
resource "aws_acm_certificate_validation" "acm-cert-validation" {
  provider = aws.acm

  certificate_arn = aws_acm_certificate.acm-cert.arn
  validation_record_fqdns = [
    for record in aws_route53_record.cert_validation_records :
    record.fqdn
   ]
}
