terraform {
  cloud {
    organization = "Terraform-macharpe"

    workspaces {
      name = "terraform-dns-ad-gateway"
    }
  }
  required_version = ">= 1.12.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}
