variable "vip_subnet_id" {
  type        = string
  nullable    = false
  description = <<DESCRIPTION
* `vip_subnet_id` - (Required) The network on which to allocate the
  loadbalancer's address. A tenant can only create loadalancers on networks
  authorized by policy (e.g. networks that belong to them or networks that
  are shared). Changing this creates a new loadbalancer.

-> When used with `opentelekomcloud_vpc_subnet_v1`, not `id` but
`subnet_id`needs to be used

Example input:
```
vip_subnet_id = opentelekomcloud_vpc_subnet_v1.example.subnet_id
```
DESCRIPTION
}

variable "name" {
  type        = string
  default     = null
  description = <<DESCRIPTION
* `name` - (Optional) Human-readable name for the loadbalancer. Does not have
  to be unique.

Example input:
```
name = elb-example
```
DESCRIPTION
}

variable "description" {
  type        = string
  default     = null
  description = <<DESCRIPTION
* `description` - (Optional) Human-readable description for the loadbalancer.

Example input:
```
description = "description"
```
DESCRIPTION
}

variable "tenant_id" {
  type        = string
  default     = null
  description = <<DESCRIPTION
* `tenant_id` - (Optional) Required for admins. The UUID of the tenant who owns
  the Loadbalancer.  Only administrative users can specify a tenant UUID
  other than their own. Changing this creates a new loadbalancer.

Example input:
```
tenant_id = data.opentelekomcloud_identity_project_v3.example.id
```
DESCRIPTION
}


variable "loadbalancer_provider" {
  type        = string
  default     = null
  description = <<DESCRIPTION
* `loadbalancer_provider` - (Optional) The name of the provider. Changing this
  creates a new loadbalancer.

Example input:
```
loadbalancer_provider = "vlb"
```
DESCRIPTION
}

variable "vip_address" {
  type        = string
  default     = null
  description = <<DESCRIPTION
* `vip_address` - (Optional) The ip address of the load balancer.
  Changing this creates a new loadbalancer.

Example input:
```
vip_address = 10.0.0.1
```
DESCRIPTION
}

variable "admin_state_up" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
* `admin_state_up` - (Optional) The administrative state of the loadbalancer.
  A valid value is only true (UP).

Example input:
```
admin_state_up = false
```
DESCRIPTION
}

variable "tags" {
  type        = map(string)
  default     = null
  description = <<DESCRIPTION
* `tags` - (Optional) The key/value pairs to associate with the subnet.

Example input:
```
tags = {
  foo = "bar"
  key = "value"
}
```
DESCRIPTION
}
