resource "cloudflare_zero_trust_list" "ad_block_lists" {
  account_id = var.cloudflare_account_id

  for_each = local.domain_list_map

  name = "ad-block-domains-${each.key}"
  type = "DOMAIN"

  # Transform the list of strings into a list of objects
  items = [
    for domain in each.value : {
      value       = domain
      description = "Blocked advertising domain"
    }
  ]

  lifecycle {
    create_before_destroy = true
  }
}