# Domain Sources Configuration

This document explains how to configure and use multiple domain sources for ad-blocking.

## Quick Start

### Option 1: Use Local File (Current Method)
Keep using the existing `lists/pihole_domain_list.txt` file:
```hcl
# No changes needed - works as before
```

### Option 2: Enable Remote Sources
Add this to your Terraform variables:
```hcl
use_remote_sources = true
```

### Option 3: Enable Additional Sources
Enable more blocklists by modifying `domain_sources`:
```hcl
domain_sources = {
  adaway = {
    url         = "https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt"
    enabled     = true
    description = "AdAway default blocklist"
    format      = "hosts"
  }
  stevenblack = {
    url         = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
    enabled     = true  # Enable StevenBlack's unified hosts
    description = "StevenBlack unified hosts file"
    format      = "hosts"
  }
}
use_remote_sources = true
```

## Available Sources

| Source | Domains | Description | Default |
|--------|---------|-------------|---------|
| `adaway` | ~6,500 | AdAway mobile ad blocklist | ✅ Enabled |
| `stevenblack` | ~100,000+ | Unified hosts (ads + malware) | ❌ Disabled |
| `malwaredomainlist` | ~2,000 | Malware domains only | ❌ Disabled |
| `easylist` | ~50,000+ | Dan Pollock's hosts file | ❌ Disabled |

## Configuration Options

### Add Custom Domains
```hcl
additional_domains = [
  "example-ad.com",
  "tracker.example.com"
]
```

### Add Custom Source
```hcl
domain_sources = {
  # ... existing sources ...
  custom = {
    url         = "https://your-custom-source.com/hosts.txt"
    enabled     = true
    description = "Custom domain list"
    format      = "hosts"  # or "domains" for plain list
  }
}
```

### Configure Chunk Size
```hcl
chunk_size = 500  # Smaller chunks for faster updates
```

## GitHub Actions Integration

### Manual Update
1. Go to **Actions** → **Update Domain Lists (Enhanced)**
2. Click **Run workflow**
3. Choose sources: `adaway,stevenblack` or `all`
4. Click **Run workflow**

### Automated Updates
The workflow runs monthly on the 15th, fetching from the `adaway` source by default.

## Monitoring

After deployment, check outputs:
```bash
terraform output configuration_summary
terraform output domain_sources_status
```

Example output:
```json
{
  "total_domains": 8234,
  "local_file_domains": 6500,
  "remote_domains": 1500,
  "additional_domains": 234,
  "active_sources": ["adaway", "stevenblack"]
}
```

## Performance Considerations

- **More sources = more domains = more lists**
- Each 1000 domains creates one Cloudflare list
- Consider your Cloudflare Zero Trust limits
- Remote fetching adds ~30-60 seconds to plan/apply time

## Troubleshooting

### Remote Source Failed
```hcl
# Disable problematic source temporarily
domain_sources = {
  problematic_source = {
    enabled = false  # Disable until fixed
    # ... rest of config
  }
}
```

### Too Many Domains
```hcl
# Reduce chunk size or disable some sources
chunk_size = 1000
domain_sources = {
  stevenblack = {
    enabled = false  # Disable large source
    # ... rest of config
  }
}
```

### Plan Takes Too Long
```hcl
# Disable remote sources and use GitHub Action instead
use_remote_sources = false
```

## Best Practices

1. **Start small**: Enable one additional source at a time
2. **Monitor performance**: Check plan/apply times
3. **Use GitHub Actions**: For regular updates without slow plans
4. **Test changes**: Verify blocking effectiveness
5. **Document custom sources**: Add descriptions for team clarity