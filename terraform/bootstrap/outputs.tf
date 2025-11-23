output "aws_route53_zone" {
  value = aws_route53_zone.main.zone_id
}

resource "local_file" "name_servers" {
  content  = join("\n", aws_route53_zone.main.name_servers)
  filename = "./nameservers.txt"
}
