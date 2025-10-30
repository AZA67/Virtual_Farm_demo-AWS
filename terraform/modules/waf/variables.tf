variable "project_name" {
  type = string
  description = "naming prefix"
}

variable "cloudfront_distribution_arn" {
  type = string
  description = "arn of cf distro to associate w/ waf"
}