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
  # 1. Read the AdAway hosts file
  adaway_hosts_file = "${path.module}/lists/pihole_domain_list.txt" # Path to your downloaded hosts.txt
  adaway_hosts      = file(local.adaway_hosts_file)

  # 2. Split into lines, remove empty lines, and comments
  adaway_lines = [
    for line in split("\n", local.adaway_hosts) : line
    if length(trimspace(line)) > 0 && !startswith(line, "#")
  ]

  # 3. Filter out lines starting with "localhost" or "::1 localhost"
  adaway_lines_filtered = [
    for line in local.adaway_lines :
    line if !startswith(line, "localhost") && !startswith(line, "::1 localhost")
  ]

  # 4. Extract domain names (remove "127.0.0.1 " prefix)
  adaway_domains = [
    for line in local.adaway_lines_filtered :
    trim(replace(line, "127.0.0.1 ", ""), " \t\r\n")
  ]

  # 5. Chunk the list into smaller lists of 1000 entries each
  chunk_size           = 1000
  adaway_domain_chunks = chunklist(local.adaway_domains, local.chunk_size)

  # 6. Get the number of chunks created
  adaway_chunk_count = length(local.adaway_domain_chunks)
}

variable "cloudflare_account_id" {
  type        = string
  description = "The ID of the Cloudflare account"
}


resource "cloudflare_zero_trust_list" "pihole_domain_lists" {
  account_id = var.cloudflare_account_id

  for_each = {
    for i in range(0, local.adaway_chunk_count) :
    i => element(local.adaway_domain_chunks, i)
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

output "adaway_domain_chunks" {
  value = local.adaway_domain_chunks
}

output "adaway_chunk_count" {
  value = local.adaway_chunk_count
}
