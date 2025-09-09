resource "opentelekomcloud_lb_loadbalancer_v2" "this" {
  vip_subnet_id         = var.vip_subnet_id
  name                  = var.name
  description           = var.description
  tenant_id             = var.tenant_id
  vip_address           = var.vip_address
  admin_state_up        = var.admin_state_up
  loadbalancer_provider = var.loadbalancer_provider
  tags                  = var.tags
}
