resource "opentelekomcloud_lb_l7policy_v2" "this" {
  for_each = var.policies != null ? var.policies : {}

  region               = each.value.region
  tenant_id            = each.value.tenant_id
  name                 = each.value.name
  description          = each.value.description
  action               = each.value.action
  listener_id          = opentelekomcloud_lb_listener_v2.this[each.value.listener_key].id
  position             = each.value.position
  redirect_pool_id     = each.value.redirect_pool_id != null ? each.value.redirect_pool_id : each.value.redirect_pool_key != null ? opentelekomcloud_lb_pool_v2.this[each.value.redirect_pool_key].id : null
  redirect_listener_id = each.value.redirect_listener_id != null ? each.value.redirect_listener_id : each.value.redirect_listener_key != null ? opentelekomcloud_lb_listener_v2.this[each.value.redirect_listener_key].id : null
  admin_state_up       = each.value.admin_state_up
}

resource "opentelekomcloud_lb_l7rule_v2" "this" {
  for_each = local.rules != null ? local.rules : {}

  region         = each.value.region
  type           = each.value.type
  compare_type   = each.value.compare_type
  l7policy_id    = each.value.l7policy_id != null ? each.value.l7policy_id : opentelekomcloud_lb_l7policy_v2.this[each.value.parent_key].id
  value          = each.value.value
  key            = each.value.key
  admin_state_up = each.value.admin_state_up
}
