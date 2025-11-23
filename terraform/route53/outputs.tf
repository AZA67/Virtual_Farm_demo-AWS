output "hosted_zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "name_servers" {
  value = aws_route53_zone.main.name_servers
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.acm-cert.arn
}

resource "local_file" "name_servers" {
  content  = join("\n", aws_route53_zone.main.name_servers)
  filename = "${path.module}/nameservers.txt"
}