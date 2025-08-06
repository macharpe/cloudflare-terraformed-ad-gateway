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
  value       = length(local.all_raw_domains) - length(local.clean_domains)
}

output "configuration_summary" {
  description = "Summary of the ad-blocking configuration"
  value = {
    total_domains          = length(local.clean_domains)
    chunks_created         = length(local.domain_chunks)
    domains_per_chunk      = var.chunk_size
    policy_enabled         = var.enable_ad_blocking
    policy_precedence      = var.policy_precedence
    local_file_domains     = length(local.local_file_domains)
    remote_domains         = length(local.remote_domains)
    additional_domains     = length(var.additional_domains)
    remote_sources_enabled = var.use_remote_sources
    active_sources         = var.use_remote_sources ? keys(local.enabled_sources) : []
  }
}

output "domain_sources_status" {
  description = "Status of all domain sources"
  value = var.use_remote_sources ? {
    for name, config in local.enabled_sources :
    name => {
      url         = config.url
      description = config.description
      format      = config.format
      status      = try(data.http.domain_sources[name].status_code, "not_fetched")
      domains_found = length([
        for line in split("\n", try(chomp(data.http.domain_sources[name].response_body), "")) :
        line if config.format == "hosts" ?
        ((can(regex("^127\\.0\\.0\\.1\\s+[^\\s]+", line)) || can(regex("^0\\.0\\.0\\.0\\s+[^\\s]+", line))) &&
          !strcontains(line, "localhost") &&
          !startswith(trimspace(line), "#") &&
        trimspace(line) != "") :
        (can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*[a-zA-Z0-9]$", trimspace(line))) &&
          !startswith(trimspace(line), "#") &&
        trimspace(line) != "")
      ])
    }
  } : {}
}