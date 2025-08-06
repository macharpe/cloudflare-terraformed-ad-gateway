variable "cloudflare_account_id" {
  type        = string
  description = "The ID of the Cloudflare account"
  validation {
    condition     = can(regex("^[a-f0-9]{32}$", var.cloudflare_account_id))
    error_message = "Account ID must be a 32-character hexadecimal string."
  }
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
