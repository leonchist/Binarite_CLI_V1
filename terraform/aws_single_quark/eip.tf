resource "aws_eip" "elastic_ip" {
  count  = 3
  domain = "vpc"
  tags   = merge(var.env.tags, { Name = "${var.services[count.index]}_eip-${random_uuid.uuid.result}" })
}

resource "aws_eip_association" "eip_assoc_quark" {
  instance_id   = module.quark.instance_id
  allocation_id = aws_eip.elastic_ip[0].allocation_id
  provider      = aws
}

resource "aws_eip_association" "eip_assoc_grafana" {
  instance_id   = module.grafana-prometheus.instance_id
  allocation_id = aws_eip.elastic_ip[1].allocation_id
  provider      = aws
}

resource "aws_eip_association" "eip_assoc_bastion" {
  instance_id   = module.bastion.instance_id
  allocation_id = aws_eip.elastic_ip[2].allocation_id
  provider      = aws
}