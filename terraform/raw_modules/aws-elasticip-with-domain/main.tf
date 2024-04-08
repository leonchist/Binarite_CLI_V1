data "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_eip" "elastic_ip" {
  domain = "vpc"
  tags = merge(var.env.tags, {
    Name = lower("${var.env.tags.Project}-${var.env.tags.Role}-${var.subdomain}-${var.env.tags.Owner}")
  })
}

resource "aws_route53_record" "hostname" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${var.subdomain}.${data.aws_route53_zone.main.name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.elastic_ip.public_ip]
}
