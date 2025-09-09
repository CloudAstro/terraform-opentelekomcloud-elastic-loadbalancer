resource "opentelekomcloud_lb_listener_v2" "this" {
  for_each = var.listeners != null ? var.listeners : {}

  protocol                     = each.value.protocol
  protocol_port                = each.value.protocol_port
  tenant_id                    = each.value.tenant_id
  loadbalancer_id              = each.value.loadbalancer_id != null ? each.value.loadbalancer_id : opentelekomcloud_lb_loadbalancer_v2.this.id
  name                         = each.value.name
  default_pool_id              = each.value.default_pool_id
  description                  = each.value.description
  http2_enable                 = each.value.http2_enable
  default_tls_container_ref    = each.value.default_tls_container_ref != null ? each.value.default_tls_container_ref : each.value.certificates != null ? try(opentelekomcloud_lb_certificate_v2.server[each.value.name].id, null) : null
  client_ca_tls_container_ref  = each.value.client_ca_tls_container_ref != null ? each.value.client_ca_tls_container_ref : each.value.certificates != null ? try(opentelekomcloud_lb_certificate_v2.client[each.value.name].id, null) : null
  sni_container_refs           = each.value.sni_container_refs != null ? each.value.sni_container_refs : each.value.certificates != null ? toset([for k, val in local.listener_cert_sni : opentelekomcloud_lb_certificate_v2.sni[k].id]) : null
  tls_ciphers_policy           = each.value.tls_ciphers_policy
  transparent_client_ip_enable = each.value.transparent_client_ip_enable
  admin_state_up               = each.value.admin_state_up
  tags                         = each.value.tags

  dynamic "ip_group" {
    for_each = each.value.ip_group != null ? each.value.ip_group : {}

    content {
      id     = ip_group.value.id
      enable = ip_group.value.enable
      type   = ip_group.value.type
    }
  }
}

resource "opentelekomcloud_lb_certificate_v2" "server" {
  for_each = local.listener_cert_server != null ? local.listener_cert_server : null

  region      = each.value.region
  name        = each.value.name
  description = each.value.description
  domain      = each.value.domain
  private_key = each.value.private_key
  certificate = each.value.certificate
  type        = each.value.type
}

resource "opentelekomcloud_lb_certificate_v2" "client" {
  for_each = local.listener_cert_client != null ? local.listener_cert_client : null

  region      = each.value.region
  name        = each.value.name
  description = each.value.description
  domain      = each.value.domain
  private_key = each.value.private_key
  certificate = each.value.certificate
  type        = each.value.type
}

resource "opentelekomcloud_lb_certificate_v2" "sni" {
  for_each = local.listener_cert_sni != null ? local.listener_cert_sni : null

  region      = each.value.region
  name        = each.value.name
  description = each.value.description
  domain      = each.value.domain
  private_key = each.value.private_key
  certificate = each.value.certificate
  type        = each.value.type
}

resource "opentelekomcloud_lb_whitelist_v2" "this" {
  for_each = local.whitelists != null ? local.whitelists : {}

  enable_whitelist = each.value.enable_whitelist
  listener_id      = each.value.listener_id != null ? each.value.listener_id : opentelekomcloud_lb_listener_v2.this[each.value.parent_key].id
  whitelist        = each.value.whitelist
}
