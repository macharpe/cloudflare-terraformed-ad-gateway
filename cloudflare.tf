# This is my Terraform project

terraform {
  cloud {
    organization = "Terraform-macharpe"

    workspaces {
      name = "terraform-cloudflare-macharpe"
    }
  }
  required_version = ">= 1.11.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

provider "cloudflare" {
}

# Create a DNS record
#resource "cloudflare_dns_record" "test" {
#  content  = "hermes-wpbmcktmmc.dynamic-m.com"
#  name     = "test.macharpe.com"
#  proxied  = true
#  ttl      = 1
#  type     = "CNAME"
#  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
#  settings = {}
#}


resource "cloudflare_dns_record" "terraform_managed_resource_0e2cedc6ee2f641fe335dca9177e6ae6" {
  content  = "macharpe.com.aa22386c00bcc9ec.dcv.cloudflare.com"
  name     = "_acme-challenge.macharpe.com"
  proxied  = true
  ttl      = 1
  type     = "CNAME"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_2a56c092d6bf7fc7581b474cd89c2fa5" {
  content  = "hermes-wpbmcktmmc.dynamic-m.com"
  name     = "alpina.macharpe.com"
  proxied  = true
  ttl      = 1
  type     = "CNAME"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_da8e2f05776a00e9c998c9630172bee9" {
  content  = "hermes-wpbmcktmmc.dynamic-m.com"
  name     = "fallback.macharpe.com"
  proxied  = true
  ttl      = 1
  type     = "CNAME"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_9187dc666ddde1c2e78a69d500b31444" {
  comment  = "box"
  content  = "hermes-wpbmcktmmc.dynamic-m.com"
  name     = "jabba.macharpe.com"
  proxied  = true
  ttl      = 1
  type     = "CNAME"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_14c724c647dc3514304818dbc46969ed" {
  comment  = "apex"
  content  = "hermes-wpbmcktmmc.dynamic-m.com"
  name     = "macharpe.com"
  proxied  = true
  ttl      = 1
  type     = "CNAME"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_1eeb6b183075380ed2a1482627038fb8" {
  content  = "hermes-wpbmcktmmc.dynamic-m.com"
  name     = "ourea.macharpe.com"
  proxied  = true
  ttl      = 1
  type     = "CNAME"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_19b1f776cd3687c23ec90393ab2920f5" {
  comment  = "DKIM2"
  content  = "protonmail2.domainkey.dtgsyyffxpaij4bmeeokmlnx4ryjy2z6yovtopp4qti7m7tzbtonq.domains.proton.ch"
  name     = "protonmail2._domainkey.macharpe.com"
  proxied  = false
  ttl      = 1
  type     = "CNAME"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_ef43b819c7ccbf467b669190b0499b21" {
  comment  = "DKIM3"
  content  = "protonmail3.domainkey.dtgsyyffxpaij4bmeeokmlnx4ryjy2z6yovtopp4qti7m7tzbtonq.domains.proton.ch"
  name     = "protonmail3._domainkey.macharpe.com"
  proxied  = false
  ttl      = 1
  type     = "CNAME"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_55ee1f7918a2efb327599996eb639510" {
  comment  = "DKIM1"
  content  = "protonmail.domainkey.dtgsyyffxpaij4bmeeokmlnx4ryjy2z6yovtopp4qti7m7tzbtonq.domains.proton.ch"
  name     = "protonmail._domainkey.macharpe.com"
  proxied  = false
  ttl      = 1
  type     = "CNAME"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_e413588e05cce0c5fdbbbf089579dbb1" {
  comment  = "Tautulli"
  content  = "hermes-wpbmcktmmc.dynamic-m.com"
  name     = "rogue1.macharpe.com"
  proxied  = true
  ttl      = 1
  type     = "CNAME"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_079ccbf93827525568323251b093cb00" {
  comment  = "FTP"
  content  = "hermes-wpbmcktmmc.dynamic-m.com"
  name     = "solo.macharpe.com"
  proxied  = true
  ttl      = 1
  type     = "CNAME"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_9b57e5616b50434731bf7ce98f0b3dea" {
  comment  = "Download"
  content  = "hermes-wpbmcktmmc.dynamic-m.com"
  name     = "windu.macharpe.com"
  proxied  = true
  ttl      = 1
  type     = "CNAME"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_485a2116b8fdaf2028a486c915ede860" {
  content  = "hermes-wpbmcktmmc.dynamic-m.com"
  name     = "www.macharpe.com"
  proxied  = true
  ttl      = 1
  type     = "CNAME"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_d7a2add232afa3aa1789c4f4d951b96c" {
  comment  = "Mail with protonmail 2"
  content  = "mailsec.protonmail.ch"
  name     = "macharpe.com"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_0319b96d4e58cbb23efe82bc53210277" {
  comment  = "Mail with protonmail 1"
  content  = "mail.protonmail.ch"
  name     = "macharpe.com"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_7624ce88c4edb52bea943647e8f0c79d" {
  content  = "\"v=DMARC1; p=quarantine; rua=mailto:05653a66293d49c5a8a74f1ccce3ad61@dmarc-reports.cloudflare.net;\""
  name     = "_dmarc.macharpe.com"
  proxied  = false
  ttl      = 1
  type     = "TXT"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_89f68ee99b5e9c6816e07e48c8822a6a" {
  comment  = "Alias Generation"
  content  = "\"pm-verification=udrpywiombrpoqpryuttncstcpnmtp\""
  name     = "macharpe.com"
  proxied  = false
  ttl      = 1
  type     = "TXT"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_f5bbec58c2923c431deeb511ef7cf61a" {
  comment  = "connection to Protonmail"
  content  = "\"protonmail-verification=5588c25cecf70ad82d07d1e95ecc51fd9252e00d\""
  name     = "macharpe.com"
  proxied  = false
  ttl      = 1
  type     = "TXT"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_a50a35d232859499b30037faa1ad8749" {
  comment  = "SPF Setup"
  content  = "\"v=spf1 include:_spf.protonmail.ch ~all\""
  name     = "macharpe.com"
  proxied  = false
  ttl      = 1
  type     = "TXT"
  zone_id  = "c4f7bafc6fbeb59e591d017dbaf910ba"
  settings = {}
}
