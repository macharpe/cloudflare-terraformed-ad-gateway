locals {
  # Read and process domain list file
  domain_file_content = file("${path.module}/lists/pihole_domain_list.txt")

  # More efficient domain processing - extract domains in one pass
  raw_domains = compact([
    for line in split("\n", local.domain_file_content) :
    trimspace(replace(line, "127.0.0.1 ", ""))
    if can(regex("^127\\.0\\.0\\.1\\s+[^\\s]+", line)) &&
    !strcontains(line, "localhost") &&
    !startswith(trimspace(line), "#") &&
    trimspace(line) != ""
  ])

  # Remove duplicates and validate domains
  clean_domains = distinct([
    for domain in local.raw_domains :
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