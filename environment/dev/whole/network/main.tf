terraform {
  backend "local" {
    path = "../tf-states/network.tfstate"
  }
}