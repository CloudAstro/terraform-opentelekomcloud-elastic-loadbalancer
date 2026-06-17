resource "opentelekomcloud_lb_listener_v2" "this" {
  for_each = toset(keys(var.listeners))

  protocol                     = var.listeners[each.key].protocol
  protocol_port                = var.listeners[each.key].protocol_port
  tenant_id                    = var.listeners[each.key].tenant_id
  loadbalancer_id              = var.listeners[each.key].loadbalancer_id != null ? var.listeners[each.key].loadbalancer_id : opentelekomcloud_lb_loadbalancer_v2.this.id
  name                         = var.listeners[each.key].name
  default_pool_id              = var.listeners[each.key].default_pool_id
  description                  = var.listeners[each.key].description
  http2_enable                 = var.listeners[each.key].http2_enable
  default_tls_container_ref    = var.listeners[each.key].default_tls_container_ref != null ? var.listeners[each.key].default_tls_container_ref : var.listeners[each.key].certificates != null ? try(opentelekomcloud_lb_certificate_v2.server[each.key].id, null) : null
  client_ca_tls_container_ref  = var.listeners[each.key].client_ca_tls_container_ref != null ? var.listeners[each.key].client_ca_tls_container_ref : var.listeners[each.key].certificates != null ? try(opentelekomcloud_lb_certificate_v2.client[each.key].id, null) : null
  sni_container_refs           = var.listeners[each.key].sni_container_refs != null ? var.listeners[each.key].sni_container_refs : var.listeners[each.key].certificates != null ? toset([for k, val in local.listener_cert_sni : opentelekomcloud_lb_certificate_v2.sni[k].id if val.listener_key == each.key]) : null
  tls_ciphers_policy           = var.listeners[each.key].tls_ciphers_policy
  transparent_client_ip_enable = var.listeners[each.key].transparent_client_ip_enable
  admin_state_up               = var.listeners[each.key].admin_state_up
  tags                         = var.listeners[each.key].tags

  dynamic "ip_group" {
    for_each = var.listeners[each.key].ip_group != null ? [var.listeners[each.key].ip_group] : []

    content {
      id     = ip_group.value.id
      enable = ip_group.value.enable
      type   = ip_group.value.type
    }
  }
}

resource "opentelekomcloud_lb_certificate_v2" "server" {
  for_each = local.listener_cert_server

  region      = var.listeners[each.key].certificates[each.value].region
  name        = var.listeners[each.key].certificates[each.value].name
  description = var.listeners[each.key].certificates[each.value].description
  domain      = var.listeners[each.key].certificates[each.value].domain
  private_key = var.listeners[each.key].certificates[each.value].private_key
  certificate = var.listeners[each.key].certificates[each.value].certificate
  type        = var.listeners[each.key].certificates[each.value].type
}

resource "opentelekomcloud_lb_certificate_v2" "client" {
  for_each = local.listener_cert_client

  region      = var.listeners[each.key].certificates[each.value].region
  name        = var.listeners[each.key].certificates[each.value].name
  description = var.listeners[each.key].certificates[each.value].description
  domain      = var.listeners[each.key].certificates[each.value].domain
  private_key = var.listeners[each.key].certificates[each.value].private_key
  certificate = var.listeners[each.key].certificates[each.value].certificate
  type        = var.listeners[each.key].certificates[each.value].type
}

resource "opentelekomcloud_lb_certificate_v2" "sni" {
  for_each = local.listener_cert_sni

  region      = var.listeners[each.value.listener_key].certificates[each.value.cert_key].region
  name        = var.listeners[each.value.listener_key].certificates[each.value.cert_key].name
  description = var.listeners[each.value.listener_key].certificates[each.value.cert_key].description
  domain      = var.listeners[each.value.listener_key].certificates[each.value.cert_key].domain
  private_key = var.listeners[each.value.listener_key].certificates[each.value.cert_key].private_key
  certificate = var.listeners[each.value.listener_key].certificates[each.value.cert_key].certificate
  type        = var.listeners[each.value.listener_key].certificates[each.value.cert_key].type
}

resource "opentelekomcloud_lb_whitelist_v2" "this" {
  for_each = local.whitelists != null ? local.whitelists : {}

  enable_whitelist = each.value.enable_whitelist
  listener_id      = each.value.listener_id != null ? each.value.listener_id : opentelekomcloud_lb_listener_v2.this[each.value.parent_key].id
  whitelist        = each.value.whitelist
}
