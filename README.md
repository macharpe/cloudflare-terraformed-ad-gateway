# Cloudflare Ad-Blocking Gateway

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Cloudflare](https://img.shields.io/badge/Cloudflare-F38020?style=flat&logo=Cloudflare&logoColor=white)](https://www.cloudflare.com/)
[![Zero Trust](https://img.shields.io/badge/Zero%20Trust-Gateway-blue)](https://developers.cloudflare.com/cloudflare-one/)
[![Ad Blocking](https://img.shields.io/badge/Ad%20Blocking-DNS%20Level-green)](https://github.com/macharpe/cloudflare-terraformed-ad-gateway)

A Terraform-managed ad-blocking solution using Cloudflare Zero Trust Gateway that blocks DNS requests to advertising and tracking domains from multiple sources.

## Overview

This project implements DNS-based ad filtering by leveraging Cloudflare's Zero Trust Gateway policies. It automatically processes ad-blocking domain lists (like those used by Pi-hole) and creates Cloudflare policies that block DNS queries to these domains at the network level.

## Features

- **Multiple Domain Sources**: Supports AdAway, EasyList, StevenBlack, and more domain sources
- **Remote Source Fetching**: Automatically fetches and processes domain lists from HTTP sources
- **Local File Support**: Process local domain lists in hosts format
- **Large Scale Support**: Handles thousands of domains by automatically chunking lists into manageable sizes
- **Zero Trust Integration**: Uses Cloudflare's Zero Trust Gateway for enterprise-grade DNS filtering  
- **Format Compatibility**: Processes both `127.0.0.1` and `0.0.0.0` hosts file formats
- **Terraform Managed**: Infrastructure as code with state management via Terraform Cloud
- **Automated Updates**: GitHub Actions workflow for regular domain list updates

## Architecture

The solution consists of:

- **Domain Sources**: Multiple remote and local domain sources (AdAway, EasyList, etc.)
- **Domain Processing**: Automated fetching and processing of hosts files from HTTP sources
- **Zero Trust Lists**: Creates multiple Cloudflare lists (chunked to 1000 domains each)
- **Gateway Policy**: Implements a blocking policy that matches against all domain lists
- **GitHub Actions**: Automated workflow for updating domain lists
- **Terraform Cloud**: Manages state and execution remotely

## How It Works

1. **Source Configuration**: Configure domain sources in `variables.tf` (remote HTTP sources and local files)
2. **Remote Fetching**: HTTP data sources automatically fetch domain lists from configured URLs
3. **Domain Processing**: Processes both local (`lists/pihole_domain_list.txt`) and remote sources
4. **Format Support**: Handles both `127.0.0.1` and `0.0.0.0` hosts file formats
5. **List Chunking**: Automatically splits domains into groups of 1000 (Cloudflare's limit)
6. **Zero Trust Lists**: Creates multiple `cloudflare_zero_trust_list` resources
7. **Gateway Policy**: Deploys a policy that blocks DNS queries matching any listed domain
8. **DNS Filtering**: Cloudflare Gateway blocks requests to advertising domains network-wide

## Usage

### Prerequisites

- Cloudflare account with Zero Trust enabled
- Terraform Cloud account
- Domain lists in AdAway/Pi-hole hosts format

### Setup

1. **Configure Terraform Cloud**:
   - Create or use workspace: `terraform-dns-ad-gateway`
   - Set up workspace variables:
   ```bash
   # Terraform Variables (TF_VAR_ prefix)
   TF_VAR_cloudflare_account_id=your_account_id
   
   # Cloudflare Provider Variables (for authentication)
   TF_VAR_cloudflare_email=your_cloudflare_email
   TF_VAR_cloudflare_api_key=your_api_key
   ```
   
   **Note**: You'll need to rename existing variables in Terraform Cloud:
   - `CLOUDFLARE_EMAIL` → `TF_VAR_cloudflare_email`
   - `CLOUDFLARE_API_KEY` → `TF_VAR_cloudflare_api_key`

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

#### Domain Sources

Configure domain sources in `variables.tf`:

```hcl
variable "domain_sources" {
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
      description = "Dan Pollock's EasyList hosts"
      format      = "hosts"
    }
  }
}
```

#### Policy Customization

The policy can be customized by modifying `main.tf`:

- **Policy Priority**: Adjust `precedence` value
- **Action**: Change from `block` to `allow` or other actions  
- **Filters**: Modify DNS filtering logic
- **Chunk Size**: Adjust domain list chunking (default: 1000)

### Updating Domain Lists

#### Automatic Updates (Recommended)

Use the GitHub Actions workflow:
1. Go to Actions tab in your repository
2. Run "Update Domain Lists" workflow
3. Choose sources to update (or use default: AdAway + EasyList)
4. Workflow creates a PR with updated domain lists

#### Manual Updates

To manually update blocked domains:

1. Update `lists/pihole_domain_list.txt` with new domains
2. Run `terraform apply` to update the lists and policy
3. Changes are applied automatically to your Gateway policy

## Domain List Format

The system supports multiple hosts file formats:

### Supported Formats

**127.0.0.1 Format (AdAway):**
```
# Comments start with #
127.0.0.1 ads.example.com
127.0.0.1 tracker.example.com
```

**0.0.0.0 Format (EasyList/someonewhocares.org):**
```
# Comments start with #
0.0.0.0 ads.example.com
0.0.0.0 tracker.example.com
```

### Processing Rules

- Lines starting with `#` are ignored
- Empty lines are ignored  
- `localhost` entries are filtered out
- Only the domain portion is extracted and used
- Both `127.0.0.1` and `0.0.0.0` formats are supported

## Project Structure

```
cloudflare-terraformed-ad-gateway/
├── README.md                     # This file
├── CLAUDE.md                     # Development documentation
├── DOMAIN_SOURCES.md            # Domain source information
├── LICENSE                      # MIT License
├── lists/                       # Domain lists
│   └── pihole_domain_list.txt   # Combined domain list (127.0.0.1 format)
├── .github/workflows/           # GitHub Actions
│   └── update-domain-lists.yml  # Automated domain list updates
└── Terraform files:             # Infrastructure as Code
    ├── data-sources.tf          # HTTP data sources for remote lists
    ├── domain-lists.tf          # Zero Trust list resources
    ├── gateway-policy.tf        # Gateway policy configuration
    ├── locals.tf               # Local values and domain processing
    ├── outputs.tf              # Output values and monitoring
    ├── provider.tf             # Provider configuration
    └── variables.tf            # Input variables and validation
```

## Monitoring

Monitor your ad-blocking effectiveness through:

- **Cloudflare Dashboard**: Zero Trust > Gateway > Analytics
- **DNS Logs**: View blocked/allowed queries
- **Policy Metrics**: Track policy effectiveness
- **Terraform Outputs**: View domain counts and source status

## Inspiration

This project was inspired by:
- [Serverless Ad Blocking with Cloudflare Gateway](https://blog.marcolancini.it/2022/blog-serverless-ad-blocking-with-cloudflare-gateway/)
- [YouTube: Cloudflare Zero Trust Tutorial](https://www.youtube.com/watch?v=FmYvrxYvBP0&t=900s)

## License

MIT License - feel free to use and modify for your own ad-blocking needs.
