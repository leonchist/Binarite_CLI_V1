module "aws_net" {
  source            = "../../../raw_modules/aws-network"
  env               = { tags = merge(local.metadata, { Name = "${local.metadata.Project}_${local.metadata.Role}_Vpc_${local.metadata.Owner}", Source = "Terraform" }) }
  availability_zone = "${var.cloud_region}a"
  providers = {
    aws = aws
  }
}
