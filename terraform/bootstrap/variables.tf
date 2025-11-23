variable "project_name" {
  type = string
  description = "name of the project"
}

variable "region" {
  type = string
  description = "default region for the project"
}

variable "domain_name" {
  type = string
}

resource "local_file" "name_servers" {
  content  = join("\n", aws_route53_zone.main.name_servers)
  filename = "./nameservers.txt"
}