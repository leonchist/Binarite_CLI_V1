data "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_eip" "elastic_ip" {
  domain = "vpc"
}

resource "aws_route53_record" "hostname" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${var.subdomain}.${data.aws_route53_zone.main.name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.elastic_ip.public_ip]
}