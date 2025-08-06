locals {
  # Process local domain list file
  local_file_content = fileexists("${path.module}/lists/pihole_domain_list.txt") ? file("${path.module}/lists/pihole_domain_list.txt") : ""
  
  local_file_domains = local.local_file_content != "" ? compact([
    for line in split("\n", local.local_file_content) :
    trimspace(replace(line, "127.0.0.1 ", ""))
    if can(regex("^127\\.0\\.0\\.1\\s+[^\\s]+", line)) &&
    !strcontains(line, "localhost") &&
    !startswith(trimspace(line), "#") &&
    trimspace(line) != ""
  ]) : []

  # Process remote domain sources (when enabled)
  enabled_sources = var.use_remote_sources ? {
    for name, config in var.domain_sources :
    name => config if config.enabled
  } : {}

  # Fetch and process remote sources
  remote_domains = var.use_remote_sources ? flatten(compact([
    for name, config in local.enabled_sources : [
      for line in split("\n", try(chomp(data.http.domain_sources[name].response_body), "")) :
      config.format == "hosts" ? 
        # Process hosts file format (127.0.0.1 domain.com)
        (can(regex("^127\\.0\\.0\\.1\\s+[^\\s]+", line)) && 
         !strcontains(line, "localhost") && 
         !startswith(trimspace(line), "#") && 
         trimspace(line) != "" ? 
         trimspace(replace(line, "127.0.0.1 ", "")) : null) :
        # Process plain domain list format
        (can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*[a-zA-Z0-9]$", trimspace(line))) && 
         !startswith(trimspace(line), "#") && 
         trimspace(line) != "" ? 
         trimspace(line) : null)
    ] if try(data.http.domain_sources[name].response_body, null) != null
  ])) : []

  # Combine all domain sources
  all_raw_domains = concat(
    local.local_file_domains,
    compact(local.remote_domains),
    var.additional_domains
  )
  
  # Remove duplicates and validate domains
  clean_domains = distinct([
    for domain in local.all_raw_domains :
    domain if can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*[a-zA-Z0-9]$", domain)) &&
              length(domain) > 3 && 
              length(domain) < 255
  ])
  
  # Chunk domains into manageable lists
  domain_chunks = chunklist(local.clean_domains, var.chunk_size)
  
  # Create mapping for domain list resources
  domain_list_map = {
    for i, chunk in local.domain_chunks :
    format("chunk_%02d", i) => chunk
  }
  
  # Pre-compute list references for gateway policy
  list_references = [
    for k, v in cloudflare_zero_trust_list.ad_block_lists :
    format("$%s", replace(v.id, "-", ""))
  ]
  
  # Create optimized traffic filter
  traffic_filter = join(" or ", [
    for ref in local.list_references :
    "any(dns.domains[*] in ${ref})"
  ])
}