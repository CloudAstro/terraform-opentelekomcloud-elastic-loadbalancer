variable "pools" {
  type = map(object({
    tenant_id       = optional(string)
    name            = optional(string)
    description     = optional(string)
    protocol        = string
    loadbalancer_id = optional(string)
    listener_key    = optional(string)
    listener_id     = optional(string)
    lb_method       = string
    admin_state_up  = optional(bool, true)
    persistence = optional(object({
      type        = optional(string)
      cookie_name = optional(string)
    }))
    members = optional(map(object({
      pool_id        = optional(string)
      subnet_id      = optional(string)
      name           = optional(string)
      tenant_id      = optional(string)
      address        = string
      protocol_port  = number
      weight         = optional(number, 1)
      admin_state_up = optional(bool, true)
    })))
    monitors = optional(map(object({
      pool_id        = optional(string)
      name           = optional(string)
      tenand_id      = optional(string)
      type           = string
      delay          = number
      timeout        = number
      max_retries    = number
      admin_state_up = optional(bool, true)
      http_method    = optional(string, "GET")
      domain_name    = optional(string)
      url_path       = optional(string, "/")
      expected_codes = optional(string)
      monitor_port   = optional(string)
    })))
  }))
  default     = {}
  description = <<DESCRIPTION
The following arguments are supported:
* `tenant_id` - (Optional) Required for admins. The UUID of the tenant who owns
  the pool.  Only administrative users can specify a tenant UUID
  other than their own. Changing this creates a new pool.
* `name` - (Optional) Human-readable name for the pool.
* `description` - (Optional) Human-readable description for the pool.
* `protocol` - (Required) The protocol - can either be TCP, UDP or HTTP.
  Changing this creates a new pool.
* `loadbalancer_id` - (Optional) The load balancer on which to provision this
  pool. Changing this creates a new pool.
* `listener_key` - (Optional) The Listener key on which the members of the pool
  will be associated with. Changing this creates a new pool.
* `listener_id` - (Optional) The Listener id on which the members of the pool
  will be associated with. Changing this creates a new pool.
* `lb_method` - (Required) The load balancing algorithm to
  distribute traffic to the pool's members. Must be one of
  `ROUND_ROBIN`, `LEAST_CONNECTIONS`, or `SOURCE_IP`.
* `admin_state_up` - (Optional) The administrative state of the pool.
  A valid value is true (UP) or false (DOWN).
* `persistence` - (Optional) Omit this field to prevent session persistence. Indicates
  whether connections in the same session will be processed by the same Pool
  member or not. Changing this creates a new pool. The `persistence` argument supports:
  * `type` - (Optional; Required if `type != null`) The type of persistence mode. The current specification
    supports `SOURCE_IP`, `HTTP_COOKIE`, and `APP_COOKIE`.
  * `cookie_name` - (Optional; Required if `type = APP_COOKIE`) The name of the cookie if persistence mode is set
    appropriately.
* members - (Optional) Map of pool member definitions (use any names you like). Each map value configures one backend member and supports:
  * `pool_id` - (Required) The id of the pool that this member will be
    assigned to.
  * `subnet_id` - (Required) The subnet in which to access the member
  * `name` - (Optional) Human-readable name for the member.
  * `tenant_id` - (Optional) Required for admins. The UUID of the tenant who owns
    the member.  Only administrative users can specify a tenant UUID
    other than their own. Changing this creates a new member.
  * `address` - (Required) The IP address of the member to receive traffic from
    the load balancer. Changing this creates a new member.
  * `protocol_port` - (Required) The port on which to listen for client traffic.
    Changing this creates a new member.
  * `weight` - (Optional)  A positive integer value that indicates the relative
    portion of traffic that this member should receive from the pool. For
    example, a member with a `weight` of `10` receives five times as much traffic
    as a member with a `weight` of `2`. If the value is `0`, the backend server will not accept new requests
  * `admin_state_up` - (Optional) The administrative state of the member.
    A valid value is `true` (UP) or `false` (DOWN).
* monitors - (Optional) Map of health monitor definitions (use any names you like). Each entry supports:
  * `pool_id` - (Required) The id of the pool that this monitor will be assigned to.
  * `name` - (Optional) The Name of the Monitor.
  * `tenant_id` - (Optional) Required for admins. The UUID of the tenant who owns
    the monitor. Only administrative users can specify a tenant UUID
    other than their own. Changing this creates a new monitor.
  * `type` - (Required) The type of probe, which is `TCP`, `UDP_CONNECT`, or `HTTP`,
    that is sent by the load balancer to verify the member state. Changing this
    creates a new monitor.
  * `delay` - (Required) The time, in seconds, between sending probes to members.
  * `timeout` - (Required) Maximum number of seconds for a monitor to wait for a
    ping reply before it times out. The value must be less than the delay value.
  * `max_retries` - (Required) Number of permissible ping failures before
    changing the member's status to INACTIVE. Must be a number between 1 and 10.
  * `admin_state_up` - (Optional) The administrative state of the monitor.
    A valid value is `true` (`UP`) or `false` (`DOWN`).
  * `http_method` - (Optional) Required for HTTP types. The HTTP method used
    for requests by the monitor. If this attribute is not specified, it
    defaults to `GET`. The value can be `GET`, `HEAD`, `POST`, `PUT`, `DELETE`,
    `TRACE`, `OPTIONS`, `CONNECT`, and `PATCH`.
  * `domain_name` - (Optional) The `domain_name` of the HTTP request during the health check.
  * `url_path` - (Optional) Required for HTTP types. URI path that will be
    accessed if monitor type is `HTTP`.
  * `expected_codes` - (Optional) Required for `HTTP` types. Expected HTTP codes
    for a passing HTTP monitor. You can either specify a single status like
    `"200"`, or a list like `"200,202"`.
  * `monitor_port` - (Optional) Specifies the health check port. The port number
    ranges from 1 to 65535. The value is left blank by default, indicating that
    the port of the backend server is used as the health check port.

Example input:
```
pool_01 = {
  name         = "pool_01"
  protocol     = "HTTP"
  lb_method    = "ROUND_ROBIN"
  listener_key = "listener_01"
  members = {
    member_01 = {
      protocol_port = 8080
      address       = "10.10.0.7"
    }
  }
  monitors = {
    monitor_01 = {
      type           = "HTTP"
      delay          = 20
      timeout        = 10
      max_retries    = 5
      url_path       = "/"
      expected_codes = "200"
    }
  }
}
```
DESCRIPTION
}
