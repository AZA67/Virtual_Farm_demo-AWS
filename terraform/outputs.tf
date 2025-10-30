output "cloudfront_domain_name" {
  value = module.cf_distro.domain_name
  description = "domain of cloudfront distro to test against"
}
