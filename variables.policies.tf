variable "policies" {
  type = map(object({
    region                = optional(string)
    tenant_id             = optional(string)
    name                  = optional(string)
    description           = optional(string)
    action                = string
    listener_key          = string
    listener_id           = optional(string)
    position              = optional(number, 100)
    redirect_pool_key     = optional(string)
    redirect_pool_id      = optional(string)
    redirect_listener_key = optional(string)
    redirect_listener_id  = optional(string)
    admin_state_up        = optional(string, true)
    rules = optional(map(object({
      region         = optional(string)
      description    = optional(string)
      type           = string
      compare_type   = string
      l7policy_id    = optional(string)
      value          = string
      key            = optional(string)
      admin_state_up = optional(bool, true)
    })))
  }))
  default     = {}
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
* `listener_key` - (Required) The Listener key on which the L7 Policy will be associated with.
  Changing this creates a new L7 Policy.
* `listener_id` - (Optional) The Listener on which the L7 Policy will be associated with.
  Changing this creates a new L7 Policy.
* `position` - (Optional) The position of this policy on the listener. Positions start at 1. Changing this creates a new L7 Policy.
* `redirect_pool_key` - (Optional) Requests matching this policy will be redirected to the pool with this key.
  Only valid if action is REDIRECT_TO_POOL.
* `redirect_pool_id` - (Optional) Requests matching this policy will be redirected to the pool with this ID.
  Only valid if action is REDIRECT_TO_POOL.
* `redirect_listener_id` - (Optional) Requests matching this policy will be redirected to the listener with this key.
  Only valid if action is REDIRECT_TO_LISTENER.
* `redirect_listener_id` - (Optional) Requests matching this policy will be redirected to the listener with this ID.
  Only valid if action is REDIRECT_TO_LISTENER.
* `admin_state_up` - (Optional) The administrative state of the L7 Policy.
  This value can only be true (UP).
* rules - (Optional) Map of L7 rule definitions.  Each map value configures a single Layer-7 rule attached to an L7 policy and supports:
  * `region` - (Optional) The region in which to obtain the V2 Networking client.
    If omitted, the `region` argument of the provider is used.
    Changing this creates a new L7 Rule.
  * `description` - (Optional) Human-readable description for the L7 Rule.
  * `type` - (Required) The L7 Rule type - can either be HOST_NAME or PATH. Changing this creates a new L7 Rule.
  * `compare_type` - (Required) The comparison type for the L7 rule - can either be
    STARTS_WITH, EQUAL_TO or REGEX
  * `l7policy_id` - (Optional) The ID of the L7 Policy to query. Changing this creates a new
    L7 Rule.
  * `value` - (Required) The value to use for the comparison. For example, the file type to
    compare.
  * `key` - (Optional) The key to use for the comparison. For example, the name of the cookie to
    evaluate. Valid when `type` is set to COOKIE or HEADER. Changing this creates a new L7 Rule.
  * `admin_state_up` - (Optional) The administrative state of the L7 Rule.
    The value can only be true (UP).

Example input:
```
policies = {
  policy_01 = {
    name              = "policy_01"
    action            = "REDIRECT_TO_POOL"
    description       = "test l7 policy"
    position          = 1
    listener_key      = "listener_01"
    redirect_pool_key = "pool_01"
    rules = {
      rule_01 = {
        type         = "PATH"
        compare_type = "EQUAL_TO"
        value        = "/test"
      }
    }
  }
}
```
DESCRIPTION
}
