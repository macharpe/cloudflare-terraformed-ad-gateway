# Cloudflare Ad-Blocking Gateway

A Terraform-managed ad-blocking solution using Cloudflare Zero Trust Gateway that blocks DNS requests to advertising and tracking domains.

## Overview

This project implements DNS-based ad filtering by leveraging Cloudflare's Zero Trust Gateway policies. It automatically processes ad-blocking domain lists (like those used by Pi-hole) and creates Cloudflare policies that block DNS queries to these domains at the network level.

## Features

- **Automated Ad Blocking**: Blocks DNS requests to advertising and tracking domains
- **Large Scale Support**: Handles thousands of domains by automatically chunking lists into manageable sizes
- **Zero Trust Integration**: Uses Cloudflare's Zero Trust Gateway for enterprise-grade DNS filtering  
- **AdAway Compatible**: Processes domain lists in AdAway/Pi-hole hosts file format
- **Terraform Managed**: Infrastructure as code with state management via Terraform Cloud

## Architecture

The solution consists of:

- **Domain Lists**: Processes AdAway hosts format files containing blocked domains
- **Zero Trust Lists**: Creates multiple Cloudflare lists (chunked to 1000 domains each)
- **Gateway Policy**: Implements a blocking policy that matches against all domain lists
- **Terraform Cloud**: Manages state and execution remotely

## How It Works

1. **Domain Processing**: Reads `lists/pihole_domain_list.txt` containing domains in hosts format
2. **List Chunking**: Automatically splits domains into groups of 1000 (Cloudflare's limit)
3. **Zero Trust Lists**: Creates multiple `cloudflare_zero_trust_list` resources
4. **Gateway Policy**: Deploys a policy that blocks DNS queries matching any listed domain
5. **DNS Filtering**: Cloudflare Gateway blocks requests to advertising domains network-wide

## Usage

### Prerequisites

- Cloudflare account with Zero Trust enabled
- Terraform Cloud account
- Domain lists in AdAway/Pi-hole hosts format

### Setup

1. **Configure Terraform Cloud**:
   ```bash
   # Set up workspace variables
   CLOUDFLARE_API_TOKEN=your_api_token
   cloudflare_account_id=your_account_id
   ```

2. **Update Domain Lists**:
   - Place your ad-blocking domains in `lists/pihole_domain_list.txt`
   - Format: `127.0.0.1 domain.com` (one per line)

3. **Deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### Configuration

The policy can be customized by modifying `gateway-policy.tf`:

- **Policy Priority**: Adjust `precedence` value
- **Action**: Change from `block` to `allow` or other actions  
- **Filters**: Modify DNS filtering logic
- **Chunk Size**: Adjust domain list chunking (default: 1000)

### Updating Domain Lists

To update blocked domains:

1. Update `lists/pihole_domain_list.txt` with new domains
2. Run `terraform apply` to update the lists and policy
3. Changes are applied automatically to your Gateway policy

## Domain List Format

The system expects domains in AdAway hosts format:
```
# Comments start with #
127.0.0.1 ads.example.com
127.0.0.1 tracker.example.com
```

- Lines starting with `#` are ignored
- Empty lines are ignored  
- `localhost` entries are filtered out
- Only the domain portion is extracted and used

## Monitoring

Monitor your ad-blocking effectiveness through:

- **Cloudflare Dashboard**: Zero Trust > Gateway > Analytics
- **DNS Logs**: View blocked/allowed queries
- **Policy Metrics**: Track policy effectiveness

## Inspiration

This project was inspired by:
- [Serverless Ad Blocking with Cloudflare Gateway](https://blog.marcolancini.it/2022/blog-serverless-ad-blocking-with-cloudflare-gateway/)
- [YouTube: Cloudflare Zero Trust Tutorial](https://www.youtube.com/watch?v=FmYvrxYvBP0&t=900s)

## License

MIT License - feel free to use and modify for your own ad-blocking needs.
