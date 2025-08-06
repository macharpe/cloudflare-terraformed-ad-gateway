# ==============================================================================
# GATEWAY POLICY: Block Ads
# ==============================================================================

resource "cloudflare_zero_trust_gateway_policy" "block_ads" {
  count = var.enable_ad_blocking ? 1 : 0

  account_id = var.cloudflare_account_id

  name        = var.policy_name
  description = var.policy_description

  enabled    = true
  precedence = var.policy_precedence

  # Block domains belonging to ad-blocking lists
  filters = ["dns"]
  action  = "block"
  traffic = local.traffic_filter

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [description]
  }

  depends_on = [cloudflare_zero_trust_list.ad_block_lists]
}
