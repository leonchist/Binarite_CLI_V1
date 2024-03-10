terraform {
  backend "local" {
    path = "../tf-states/network.tfstate"
  }
}

module "network" {
    source = "../../../../modules/aws-network"
    availability_zone = "eu-west-3a"
}