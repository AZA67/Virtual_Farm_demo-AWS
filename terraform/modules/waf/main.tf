resource "aws_wafv2_web_acl" "waf" {
    name = "${var.project_name}-acl"
    scope = "CLOUDFRONT"

    default_action {
      allow {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "${var.project_name}"
      sampled_requests_enabled = true
    }
}

resource "aws_wafv2_web_acl_association" "cf_waf" {
    resource_arn = var.cloudfront_distribution_arn
    web_acl_arn = aws_wafv2_web_acl.waf.arn
}