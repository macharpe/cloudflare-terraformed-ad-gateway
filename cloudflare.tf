terraform {
  cloud {
    organization = "Terraform-macharpe"

    workspaces {
      name = "terraform-cloudflare-macharpe"
    }
  }
  required_version = ">= 1.12.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.5.0"
    }
  }
}

provider "cloudflare" {
}
