resource "opentelekomcloud_lb_pool_v2" "this" {
  for_each = var.pools != null ? var.pools : {}

  tenant_id       = each.value.tenant_id
  name            = each.value.name
  description     = each.value.description
  protocol        = each.value.protocol
  loadbalancer_id = each.value.listener_key == null ? opentelekomcloud_lb_loadbalancer_v2.this.id : null
  listener_id     = each.value.listener_id != null ? each.value.listener_id : each.value.listener_key != null ? opentelekomcloud_lb_listener_v2.this[each.value.listener_key].id : null
  lb_method       = each.value.lb_method
  admin_state_up  = each.value.admin_state_up

  dynamic "persistence" {
    for_each = each.value.persistence != null ? each.value.persistence : {}

    content {
      type        = persistence.value.type
      cookie_name = persistence.value.cookie_name
    }
  }
}

resource "opentelekomcloud_lb_member_v2" "this" {
  for_each = local.members != null ? local.members : null

  pool_id        = each.value.pool_id != null ? each.value.pool_id : opentelekomcloud_lb_pool_v2.this[each.value.parent_key].id
  subnet_id      = each.value.subnet_id != null ? each.value.subnet_id : var.vip_subnet_id
  name           = each.value.name
  address        = each.value.address
  protocol_port  = each.value.protocol_port
  weight         = each.value.weight
  admin_state_up = each.value.admin_state_up
}

resource "opentelekomcloud_lb_monitor_v2" "this" {
  for_each = local.monitors != null ? local.monitors : {}

  pool_id        = each.value.pool_id != null ? each.value.pool_id : opentelekomcloud_lb_pool_v2.this[each.value.parent_key].id
  name           = each.value.name
  tenant_id      = each.value.tenand_id
  type           = each.value.type
  delay          = each.value.delay
  timeout        = each.value.timeout
  max_retries    = each.value.max_retries
  admin_state_up = each.value.admin_state_up
  http_method    = each.value.http_method
  domain_name    = each.value.domain_name
  url_path       = each.value.url_path
  expected_codes = each.value.expected_codes
  monitor_port   = each.value.monitor_port
}
