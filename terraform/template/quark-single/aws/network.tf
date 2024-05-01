data "aws_availability_zones" "available" {}
module "aws_net" {
  source            = "../../../raw_modules/aws-network"
  env               = { tags = merge(local.metadata, { Name = "${local.metadata.Project}_${local.metadata.Role}_Vpc_${local.metadata.Owner}", Source = "Terraform" }) }
  availability_zone = data.aws_availability_zones.available.names[0]
  providers = {
    aws = aws
  }
}
