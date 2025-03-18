# ==============================================================================
# POLICY: Block Ads
# ==============================================================================
locals {
  # Iterate through each pihole_domain_list resource and extract its ID
  pihole_domain_lists = [for k, v in cloudflare_zero_trust_list.pihole_domain_lists : v.id]

  # Format the values: remove dashes and prepend $
  pihole_domain_lists_formatted = [for v in local.pihole_domain_lists : format("$%s", replace(v, "-", ""))]

  # Create filters to use in the policy
  pihole_ad_filters = formatlist("any(dns.domains[*] in %s)", local.pihole_domain_lists_formatted)
  pihole_ad_filter  = join(" or ", local.pihole_ad_filters)
}

resource "cloudflare_zero_trust_gateway_policy" "block_ads" {
  account_id = var.cloudflare_account_id

  name        = "Block Ads"
  description = "Block Ads domains"

  enabled    = true
  precedence = 11

  # Block domain belonging to lists (defined below)
  filters = ["dns"]
  action  = "block"
  traffic = local.pihole_ad_filter

  #  rule_settings {
  #    block_page_enabled = false
  #  }
}


# ==============================================================================
# LISTS: AD Blocking domain list
#
# Remote source:
#   - https://firebog.net/
#   - https://adaway.org/hosts.txt
# Local file:
#   - ./cloudflare/lists/pihole_domain_list.txt
#   - the file can be updated periodically via Github Actions (see README)
# ==============================================================================
locals {
  # The full path of the list holding the domain list
  pihole_domain_list_file = "${path.module}/lists/pihole_domain_list.txt"

  # Parse the file and create a list, one item per line
  pihole_domain_list = split("\n", file(local.pihole_domain_list_file))

  # Remove empty lines and lines starting with '#'
  pihole_domain_list_clean = [
    for line in local.pihole_domain_list :
    line if line != "" && !startswith(line, "#")
  ]

  # Filter out invalid domain names
  pihole_domain_list_valid = [
    for x in local.pihole_domain_list_clean :
    x if can(regex("^(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]$", x))
  ]

  # Use chunklist to split a list into fixed-size chunks
  # It returns a list of lists
  pihole_aggregated_lists = chunklist(local.pihole_domain_list_clean, 1000)

  # Get the number of lists (chunks) created
  pihole_list_count = length(local.pihole_aggregated_lists)
}

variable "cloudflare_account_id" {
  type        = string
  description = "The ID of the Cloudflare account"
}


resource "cloudflare_zero_trust_list" "pihole_domain_lists" {
  account_id = var.cloudflare_account_id

  for_each = {
    for i in range(0, local.pihole_list_count) :
    i => element(local.pihole_aggregated_lists, i)
  }

  name = "pihole_domain_list_${each.key}"
  type = "DOMAIN"

  # Transform the list of strings into a list of objects
  items = [
    for domain in each.value :
    {
      value       = domain
      description = "Pi-hole blocked domain"
    }
  ]
}

output "valid_domains" {
  value = local.pihole_domain_list_valid
}
