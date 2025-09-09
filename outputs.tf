output "lb_loadbalancer" {
  value       = opentelekomcloud_lb_loadbalancer_v2.this
  description = <<DESCRIPTION
The following attributes are exported:
* `vip_subnet_id` - See Argument Reference above.
* `name` - See Argument Reference above.
* `description` - See Argument Reference above.
* `tenant_id` - See Argument Reference above.
* `vip_address` - See Argument Reference above.
* `admin_state_up` - See Argument Reference above.
* `loadbalancer_provider` - See Argument Reference above.
* `vip_port_id` - The Port ID of the Load Balancer IP.
* `tags` - See Argument Reference above.

Example output:
```
output "lb_name" {
  value = module.module_name.lb_loadbalancer.name
}
```
DESCRIPTION
}

output "lb_listener" {
  value       = opentelekomcloud_lb_listener_v2.this
  description = <<DESCRIPTION

The following attributes are exported:
* `id` - The unique ID for the Listener.
* `protocol` - See Argument Reference above.
* `protocol_port` - See Argument Reference above.
* `tenant_id` - See Argument Reference above.
* `name` - See Argument Reference above.
* `default_port_id` - See Argument Reference above.
* `description` - See Argument Reference above.
* `http2_enable` - See Argument Reference above.
* `default_tls_container_ref` - See Argument Reference above.
* `client_ca_tls_container_ref` - See Argument Reference above.
* `sni_container_refs` - See Argument Reference above.
* `tls_ciphers_policy` - See Argument Reference above.
* `admin_state_up` - See Argument Reference above.
* `tags` - See Argument Reference above.

Example output:
```
output "listener_name" {
  value = module.module_name.lb_listener.lb_listener_name.name
}
```
DESCRIPTION
}

output "lb_pool" {
  value       = opentelekomcloud_lb_pool_v2.this
  description = <<DESCRIPTION
## Attributes Reference
The following attributes are exported:
* `id` - The unique ID for the pool.
* `tenant_id` - See Argument Reference above.
* `name` - See Argument Reference above.
* `description` - See Argument Reference above.
* `protocol` - See Argument Reference above.
* `lb_method` - See Argument Reference above.
* `persistence` - See Argument Reference above.
* `admin_state_up` - See Argument Reference above.

Example output:
```
output "pool_name" {
  value = module.module_name.lb_pool.lb_pool_name.name
}
```
DESCRIPTION
}

output "lb_member" {
  value       = opentelekomcloud_lb_member_v2.this
  description = <<DESCRIPTION
The following attributes are exported:
* `id` - The unique ID for the member.
* `name` - See Argument Reference above.
* `weight` - See Argument Reference above.
* `admin_state_up` - See Argument Reference above.
* `tenant_id` - See Argument Reference above.
* `subnet_id` - See Argument Reference above.
* `pool_id` - See Argument Reference above.
* `address` - See Argument Reference above.
* `protocol_port` - See Argument Reference above.

Example output:
```
output "member_name" {
  value = module.module_name.lb_member.lb_member_name.name
}
```
DESCRIPTION
}

output "lb_l7policy" {
  value       = opentelekomcloud_lb_l7policy_v2.this
  description = <<DESCRIPTION
The following arguments are supported:
* `region` - (Optional) The region in which to obtain the V2 Networking client.
  If omitted, the `region` argument of the provider is used.
  Changing this creates a new L7 Policy.
* `tenant_id` - (Optional) Required for admins. The UUID of the tenant who owns
  the L7 Policy. Only administrative users can specify a tenant UUID
  other than their own. Changing this creates a new L7 Policy.
* `name` - (Optional) Human-readable name for the L7 Policy. Does not have
  to be unique.
* `description` - (Optional) Human-readable description for the L7 Policy.
* `action` - (Required) The L7 Policy action - can either be REDIRECT_TO_POOL,
  or REDIRECT_TO_LISTENER. Changing this creates a new L7 Policy.
* `listener_id` - (Required) The Listener on which the L7 Policy will be associated with.
  Changing this creates a new L7 Policy.
* `position` - (Optional) The position of this policy on the listener. Positions start at 1. Changing this creates a new L7 Policy.
* `redirect_pool_id` - (Optional) Requests matching this policy will be redirected to the pool with this ID.
  Only valid if action is REDIRECT_TO_POOL.
* `redirect_listener_id` - (Optional) Requests matching this policy will be redirected to the listener with this ID.
  Only valid if action is REDIRECT_TO_LISTENER.
* `admin_state_up` - (Optional) The administrative state of the L7 Policy.
  This value can only be true (UP).

Example output:
```
output "policy_name" {
  value = module.module_name.lb_l7policy.policy_name.name
}
```
DESCRIPTION
}

output "lb_l7rule" {
  value       = opentelekomcloud_lb_l7rule_v2.this
  description = <<DESCRIPTION
The following attributes are exported:
* `id` - The unique ID for the L7 Rule.
* `region` - See Argument Reference above.
* `tenant_id` - See Argument Reference above.
* `type` - See Argument Reference above.
* `compare_type` - See Argument Reference above.
* `l7policy_id` - See Argument Reference above.
* `value` - See Argument Reference above.
* `key` - See Argument Reference above.
* `invert` - See Argument Reference above.
* `admin_state_up` - See Argument Reference above.
* `listener_id` - The ID of the Listener owning this resource.

Example output:
```
output "rule_name" {
  value = module.module_name.lb_l7rule.rule_name.name
}
```
DESCRIPTION
}

output "lb_certificate" {
  value = merge([
    for key, val in {
      server = opentelekomcloud_lb_certificate_v2.server
      client = opentelekomcloud_lb_certificate_v2.client
      sni    = opentelekomcloud_lb_certificate_v2.sni
    } :
    {
      for k, v in val :
      "${key}_${k}" => {
        id     = v.id
        name   = v.name
        type   = v.type
        domain = v.domain
        region = v.region
      }
    }
  ]...)
  description = <<DESCRIPTION
## Attributes Reference

The following attributes are exported:
* `region` - See Argument Reference above.
* `name` - See Argument Reference above.
* `description` - See Argument Reference above.
* `domain` - See Argument Reference above.
* `private_key` - See Argument Reference above.
* `certificate` - See Argument Reference above.
* `type` - See Argument Reference above.
* `update_time` - Indicates the update time.
* `create_time` - Indicates the creation time.
* `expire_time` - Indicates certificate expiration time.

Example output:
```
output "certificate_name" {
  value = module.module_name.lb_certificate.type_name.name
}
```
DESCRIPTION
}

output "lb_monitor" {
  value       = opentelekomcloud_lb_monitor_v2.this
  description = <<DESCRIPTION
The following attributes are exported:
* `id` - The unique ID for the monitor.
* `tenant_id` - See Argument Reference above.
* `type` - See Argument Reference above.
* `delay` - See Argument Reference above.
* `timeout` - See Argument Reference above.
* `max_retries` - See Argument Reference above.
* `url_path` - See Argument Reference above.
* `domain_name` - See Argument Reference above.
* `http_method` - See Argument Reference above.
* `expected_codes` - See Argument Reference above.
* `admin_state_up` - See Argument Reference above.
* `monitor_port` - See Argument Reference above.

Example output:
```
output "monitor_name" {
  value = module.module_name.lb_monitor.monitor_name.name
}
```
DESCRIPTION
}

output "lb_whitelist" {
  value       = opentelekomcloud_lb_whitelist_v2.this
  description = <<DESCRIPTION
The following attributes are exported:
* `id` - The unique ID for the whitelist.
* `tenant_id` - See Argument Reference above.
* `listener_id` - See Argument Reference above.
* `enable_whitelist` - See Argument Reference above.
* `whitelist` - See Argument Reference above.

Example output:
```
output "whitelist_name" {
  value = module.module_name.lb_whitelist.whitelist_name.name
}
```
DESCRIPTION
}
