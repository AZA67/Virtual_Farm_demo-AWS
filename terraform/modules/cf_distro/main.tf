# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution


# S3 BUCKET POLICY
# See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
data "aws_iam_policy_document" "origin_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${var.bucket_arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "b" {
  bucket = var.bucket_name
  policy = data.aws_iam_policy_document.origin_bucket_policy.json
}
#----End PoliCY----#



#-----CloudFront Distro pre-config----#
resource "aws_cloudfront_origin_access_control" "default" {
    name = "default"
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol = "sigv4"
}


#define orgin_id varable for ORIGINS#
locals {
  s3_origin_id = "s3-origin"
  api_origin_id = "api-origin"
}

#HARCODED cache policy IDs to avoid "ERROR: Provider produced incosistent final plan"
## REF: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html
locals {
  s3_cache = "658327ea-f89d-4fab-a63d-7e88639e58f6" #Managed-CachingOptimized
  no_cache = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" #Managed-CachingDisabled
}

#HARCODED origin request policy ID
## REF: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-origin-request-policies.html
locals {
  all_viewer_except_host = "b689b0a8-53d0-40ab-baf2-68738e2966ac" #Managed-AllViewerExceptHostHeader
}


##---Cloud Front Distribution---##
resource "aws_cloudfront_distribution" "cdn" {
    enabled = true
    is_ipv6_enabled = true
    comment = "${var.project_name}-cloud_front_distribution"
    default_root_object = "index.html"
    aliases = [var.domain_name, "www.${var.domain_name}"] #add more if necessary

    #s3-bucket (static_site) Origin#
    origin {
        domain_name = var.bucket_regional_domain_name
        origin_access_control_id = aws_cloudfront_origin_access_control.default.id
        origin_id = local.s3_origin_id
    }

    default_cache_behavior {
      target_origin_id = local.s3_origin_id
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods = ["GET", "HEAD"]
      cached_methods = ["GET", "HEAD"]
      compress = true

      cache_policy_id = local.s3_cache
    }
    #----------------------------#



    #---API gateway ORIGIN---#
    origin {
      domain_name = "${var.http_api_id}.execute-api.${var.region}.amazonaws.com"
      origin_id = local.api_origin_id

      custom_origin_config {
        origin_protocol_policy = "https-only"
        http_port              = 80
        https_port             = 443
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }

    ordered_cache_behavior {
      path_pattern           = "/api/*"
      target_origin_id       = local.api_origin_id
      viewer_protocol_policy = "https-only"

      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD", "OPTIONS"]

      cache_policy_id            = local.no_cache
      origin_request_policy_id   = local.all_viewer_except_host
    }
    #------------------------#

    viewer_certificate {
      acm_certificate_arn = var.acm_certificate_arn
      ssl_support_method = "sni-only"
      minimum_protocol_version = "TLSv1.2_2021"
    }

    restrictions {
      geo_restriction {
        restriction_type = "blacklist"
        locations = ["RU", "CN"]
      }
    }
}
