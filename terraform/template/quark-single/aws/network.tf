module "aws_net" {
  source            = "../../../raw_modules/aws-network"
  env               = { tags = merge(var.metadata, { Name = "${var.metadata.Project}_${var.metadata.Role}_Vpc_${var.metadata.Owner}", Source = "Terraform" }) }
  availability_zone = "${var.server_region}a"
  providers = {
    aws = aws
  }
}