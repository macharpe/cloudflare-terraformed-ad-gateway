output "blocked_domains_count" {
  description = "Total number of blocked domains"
  value       = length(local.clean_domains)
}

output "list_chunks_created" {
  description = "Number of domain list chunks created"
  value       = length(cloudflare_zero_trust_list.ad_block_lists)
}

output "domain_list_names" {
  description = "Names of all created domain lists"
  value       = [for k, v in cloudflare_zero_trust_list.ad_block_lists : v.name]
}

output "policy_status" {
  description = "Gateway policy configuration"
  value = var.enable_ad_blocking ? {
    name       = cloudflare_zero_trust_gateway_policy.block_ads[0].name
    enabled    = cloudflare_zero_trust_gateway_policy.block_ads[0].enabled
    precedence = cloudflare_zero_trust_gateway_policy.block_ads[0].precedence
    id         = cloudflare_zero_trust_gateway_policy.block_ads[0].id
  } : null
}

output "duplicate_domains_removed" {
  description = "Number of duplicate domains that were removed"
  value       = length(local.raw_domains) - length(local.clean_domains)
}

output "configuration_summary" {
  description = "Summary of the ad-blocking configuration"
  value = {
    total_domains     = length(local.clean_domains)
    chunks_created    = length(local.domain_chunks)
    domains_per_chunk = var.chunk_size
    policy_enabled    = var.enable_ad_blocking
    policy_precedence = var.policy_precedence
  }
}