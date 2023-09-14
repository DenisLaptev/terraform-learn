# It is a good practice to put required_providers in separate file providers.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.2"
    }

    linode = {
      source  = "linode/linode"
      version = "2.7.1"
    }
  }
}
