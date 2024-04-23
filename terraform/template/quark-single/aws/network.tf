module "aws_net" {
  source = "../../../raw_modules/aws-network"
  env = merge(var.env, {
    tags = merge(var.env.tags, { Name = "demo_vpc" })
  })
  availability_zone = "eu-west-2a"
  providers = {
    aws = aws
  }
}