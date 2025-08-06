# HTTP data sources for fetching remote domain lists
data "http" "domain_sources" {
  for_each = local.enabled_sources

  url = each.value.url

  # Add headers for better compatibility
  request_headers = {
    Accept    = "text/plain"
    User-Agent = "Terraform-Cloudflare-AdBlock/1.0"
  }

  # Retry configuration
  retry {
    attempts      = 3
    wait_ms       = 1000
    max_wait_ms   = 30000
  }

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to fetch domain list from ${each.value.url}: HTTP ${self.status_code}"
    }
  }
}