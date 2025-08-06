# Domain Sources Configuration

This document explains how to configure and use multiple domain sources for ad-blocking with Cloudflare Zero Trust Gateway.

## Quick Start

### Current Configuration (Default)
The system is configured with remote sources enabled by default:
```hcl
use_remote_sources = true  # Enabled by default

domain_sources = {
  adaway = {
    url         = "https://adaway.org/hosts.txt"
    enabled     = true   # ✅ Active
    description = "AdAway mobile ad blocking hosts"
    format      = "hosts"
  }
  easylist = {
    url         = "https://someonewhocares.org/hosts/zero/hosts"
    enabled     = true   # ✅ Active  
    description = "Dan Pollock's EasyList hosts (someonewhocares.org)"
    format      = "hosts"
  }
  # Additional sources available but disabled by default
}
```

### Enable Additional Sources
To enable more blocklists, modify the `domain_sources` in `variables.tf`:
```hcl
domain_sources = {
  adaway = {
    url         = "https://adaway.org/hosts.txt"
    enabled     = true
    description = "AdAway mobile ad blocking hosts"
    format      = "hosts"
  }
  easylist = {
    url         = "https://someonewhocares.org/hosts/zero/hosts"
    enabled     = true
    description = "Dan Pollock's EasyList hosts"
    format      = "hosts"
  }
  stevenblack = {
    url         = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
    enabled     = true  # Enable StevenBlack's unified hosts
    description = "StevenBlack unified hosts file"
    format      = "hosts"
  }
}
```

## Available Sources

| Source | Domains | Format | Description | Default |
|--------|---------|--------|-------------|---------|
| `adaway` | ~6,500 | `127.0.0.1` | AdAway mobile ad blocking hosts | ✅ Enabled |
| `easylist` | ~11,800 | `0.0.0.0` | Dan Pollock's hosts (someonewhocares.org) | ✅ Enabled |
| `stevenblack` | ~100,000+ | `0.0.0.0` | StevenBlack unified hosts file | ❌ Disabled |
| `malwaredomainlist` | ~2,000 | `127.0.0.1` | Malware Domain List | ❌ Disabled |
| `yoyo` | ~2,500 | `127.0.0.1` | Peter Lowe's Ad and tracking server list | ❌ Disabled |

### Supported Host File Formats
- **127.0.0.1 Format**: `127.0.0.1 ads.example.com` (AdAway style)
- **0.0.0.0 Format**: `0.0.0.0 ads.example.com` (EasyList/someonewhocares.org style)

Both formats are automatically processed and converted to domain lists.

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
1. Go to **Actions** → **Update Domain Lists**
2. Click **Run workflow**
3. Choose sources: `adaway,easylist,stevenblack,malware,yoyo` or `all`
4. Click **Run workflow**

### Automated Updates
The workflow runs monthly on the 15th, fetching from `adaway,easylist` sources by default.

### Workflow Features
- Supports both `127.0.0.1` and `0.0.0.0` host file formats
- Automatically combines and deduplicates domains
- Creates PR with updated domain list
- Processes multiple sources in parallel

## Monitoring

After deployment, check outputs:
```bash
terraform output configuration_summary
terraform output domain_sources_status
```

Example output:
```json
{
  "total_domains": 18234,
  "local_file_domains": 6500,
  "remote_domains": 11500,
  "additional_domains": 234,
  "remote_sources_enabled": true,
  "active_sources": ["adaway", "easylist"]
}
```

### Domain Source Status
Check individual source status:
```bash
terraform output domain_sources_status
```

Example:
```json
{
  "adaway": {
    "url": "https://adaway.org/hosts.txt",
    "description": "AdAway mobile ad blocking hosts",
    "format": "hosts",
    "status": 200,
    "domains_found": 6543
  },
  "easylist": {
    "url": "https://someonewhocares.org/hosts/zero/hosts", 
    "description": "Dan Pollock's EasyList hosts",
    "format": "hosts",
    "status": 200,
    "domains_found": 11805
  }
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