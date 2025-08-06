variable "cloudflare_account_id" {
  type        = string
  description = "The ID of the Cloudflare account"
  validation {
    condition     = can(regex("^[a-f0-9]{32}$", var.cloudflare_account_id))
    error_message = "Account ID must be a 32-character hexadecimal string."
  }
}

variable "cloudflare_email" {
  type        = string
  description = "The email address associated with the Cloudflare account"
  sensitive   = true
}

variable "cloudflare_api_key" {
  type        = string
  description = "The API key for the Cloudflare account"
  sensitive   = true
}

variable "chunk_size" {
  type        = number
  description = "Number of domains per list chunk"
  default     = 1000
  validation {
    condition     = var.chunk_size > 0 && var.chunk_size <= 1000
    error_message = "Chunk size must be between 1 and 1000."
  }
}

variable "policy_precedence" {
  type        = number
  description = "Gateway policy precedence (lower = higher priority)"
  default     = 11
  validation {
    condition     = var.policy_precedence >= 1 && var.policy_precedence <= 1000
    error_message = "Policy precedence must be between 1 and 1000."
  }
}

variable "enable_ad_blocking" {
  type        = bool
  description = "Enable ad-blocking policy"
  default     = true
}

variable "policy_name" {
  type        = string
  description = "Name for the ad-blocking policy"
  default     = "DNS-Block: Ads Gateway Terraform"
}

variable "policy_description" {
  type        = string
  description = "Description for the ad-blocking policy"
  default     = "Block advertising domains managed via Terraform"
}

variable "domain_sources" {
  type = map(object({
    url         = string
    enabled     = bool
    description = string
    format      = optional(string, "hosts") # "hosts" or "domains"
  }))
  description = "Map of domain sources to fetch and process"
  default = {
    adaway = {
      url         = "https://adaway.org/hosts.txt"
      enabled     = true
      description = "AdAway mobile ad blocking hosts"
      format      = "hosts"
    }
    easylist = {
      url         = "https://someonewhocares.org/hosts/zero/hosts"
      enabled     = true
      description = "Dan Pollock's EasyList hosts (someonewhocares.org)"
      format      = "hosts"
    }
    stevenblack = {
      url         = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
      enabled     = false
      description = "StevenBlack unified hosts file"
      format      = "hosts"
    }
    malwaredomainlist = {
      url         = "https://www.malwaredomainlist.com/hostslist/hosts.txt"
      enabled     = false
      description = "Malware Domain List"
      format      = "hosts"
    }
    yoyo = {
      url         = "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
      enabled     = false
      description = "Peter Lowe's Ad and tracking server list"
      format      = "hosts"
    }
  }
}

variable "use_remote_sources" {
  type        = bool
  description = "Enable fetching from remote domain sources defined in domain_sources"
  default     = true
}

variable "additional_domains" {
  type        = list(string)
  description = "Additional domains to block (manually specified)"
  default     = []
  validation {
    condition = alltrue([
      for domain in var.additional_domains :
      can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*[a-zA-Z0-9]$", domain))
    ])
    error_message = "All additional domains must be valid domain names."
  }
}
