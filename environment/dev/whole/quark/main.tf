terraform {
  backend "local" {
    path = "../tf-states/quark.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "../tf-states/network.tfstate"
  }
}