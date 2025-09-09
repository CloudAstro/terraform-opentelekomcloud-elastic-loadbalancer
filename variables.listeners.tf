variable "listeners" {
  type = map(object({
    protocol                     = string
    protocol_port                = number
    tenant_id                    = optional(string)
    loadbalancer_id              = optional(string)
    name                         = optional(string)
    default_pool_id              = optional(string)
    description                  = optional(string)
    http2_enable                 = optional(bool, false)
    default_tls_container_ref    = optional(string)
    client_ca_tls_container_ref  = optional(string)
    sni_container_refs           = optional(list(string))
    tls_ciphers_policy           = optional(string, "tls-1-0")
    transparent_client_ip_enable = optional(bool)
    admin_state_up               = optional(bool, true)
    tags                         = optional(map(any))
    ip_group = optional(object({
      id     = string
      enable = optional(bool)
      type   = optional(string)
    }))
    certificates = optional(map(object({
      region      = optional(string)
      name        = optional(string)
      description = optional(string)
      domain      = optional(string)
      private_key = optional(string)
      certificate = string
      type        = optional(string)
    })))
    whitelists = optional(map(object({
      enable_whitelist = optional(bool, true)
      whitelist        = optional(string, "")
      listener_id      = optional(string)
    })))
  }))
  default     = {}
  description = <<DESCRIPTION
The following arguments are supported:
* `protocol` - (Required) The protocol - can either be `TCP`, `HTTP`, `UDP` or `TERMINATED_HTTPS`.
  Changing this creates a new Listener.
* `protocol_port` - (Required) The port on which to listen for client traffic.
  Changing this creates a new Listener.
* `tenant_id` - (Optional) Required for admins. The UUID of the tenant who owns
  the Listener.  Only administrative users can specify a tenant UUID
  other than their own. Changing this creates a new Listener.
* `loadbalancer_id` - (Required) The load balancer on which to provision this
  Listener. Changing this creates a new Listener.
* `name` - (Optional) Human-readable name for the Listener. Does not have
  to be unique.
* `default_pool_id` - (Optional) The ID of the default pool with which the
  Listener is associated. Changing this creates a new Listener.
* `description` - (Optional) Human-readable description for the Listener.
* `http2_enable`- (Optional) `true` to enable HTTP/2 mode of ELB.
  HTTP/2 is disabled by default if not set.
* `default_tls_container_ref` - (Optional) Specifies the ID of a certificate container of type `server`
  used by the listener. The value contains a maximum of 128 characters. The default value is `null`.
  This parameter is **required** when protocol is set to `TERMINATED_HTTPS`.
  See [here](https://wiki.openstack.org/wiki/Network/LBaaS/docs/how-to-create-tls-loadbalancer)
  for more information.
* `client_ca_tls_container_ref`  (Optional) Specifies the ID of a certificate container of type `client`
  used by the listener. The value contains a maximum of 128 characters. The default value is `null`.
  The loadbalancer only establishes a TLS connection if the client presents a certificate delivered by
  the client CA whose certificate is registered in the referenced certificate container. The option is
  effective only in conjunction with `TERMINATED_HTTPS`.
* `sni_container_refs` - (Optional) Lists the IDs of SNI certificates (server certificates with a domain name) used
  by the listener. If the parameter value is an empty list, the SNI feature is disabled.
  The default value is `[]`. It only works in conjunction with `TERMINATED_HTTPS`.
* `tls_ciphers_policy`- (Optional) Controls the TLS version used. Supported values are `tls-1-0`, `tls-1-1`,
  `tls-1-2` and `tls-1-2-strict`. If not set, the loadbalancer uses `tls-1-0`. See
  [here](https://docs.otc.t-systems.com/api/elb/elb_zq_jt_0001.html) for details about the supported cipher
  suites. The option is effective only in conjunction with `TERMINATED_HTTPS`.
* `transparent_client_ip_enable` - (Optional) Specifies whether to pass source IP addresses of the clients to
  backend servers. The value is always `true` for `HTTP` and `HTTPS` listeners. For `TCP` and `UDP` listeners the
  value can be `true` or `false` with `false` by default.
* `admin_state_up` - (Optional) The administrative state of the Listener.
  A valid value is `true` (UP) or `false` (DOWN).
* `tags` - (Optional) Tags key/value pairs to associate with the loadbalancer listener.
* `ip_group` - (Optional, Map) Specifies the IP address group associated with the listener.
  * `id` - (Required, String) Specifies the ID of the IP address group associated with the listener.
    Specifies the ID of the IP address group associated with the listener.
    If `ip_list` in `opentelekomcloud_lb_ipgroup_v3` is set to an empty array `[]` and type to `whitelist`, no IP addresses are allowed to access the listener.
    If `ip_list` in `opentelekomcloud_lb_ipgroup_v3` is set to an empty array `[]` and type to `blacklist`, any IP address is allowed to access the listener.
  * `enable` - (Optional, Bool) Specifies whether to enable access control.
    `true`: Access control will be enabled.
    `false` (default): Access control will be disabled.
  * `type` - (Optional, String) Specifies how access to the listener is controlled.
    `white` (default): A whitelist will be configured. Only IP addresses in the whitelist can access the listener.
    `black`: A blacklist will be configured. IP addresses in the blacklist are not allowed to access the listener.
*	certificates - (Optional) Map of load balancer certificate definitions to create and attach to the listener. Each map value supports:
	* `region` - (Optional) The region in which to obtain the V2 Networking client.
    A Networking client is needed to create an LB certificate. If omitted, the
    `region` argument of the provider is used. Changing this creates a new
    LB certificate.
  * `name` - (Optional) Human-readable name for the Certificate. Does not have
    to be unique.
  * `description` - (Optional) Human-readable description for the Certificate.
  * `domain` - (Optional) The domain of the Certificate.
  * `private_key` - (Optional) The private encrypted key of the Certificate, PEM format.
    Required for certificates of type `server`.
  * `certificate` - (Required) The public encrypted key of the Certificate, PEM format.
  * `type`- (Optional) The type of certificate the container holds. Either `server` or `client`.
    Defaults to `server` if not set. Changing this creates a new LB certificate.
* whitelists - (Optional) Map of whitelist definitions. Each value configures ELB access control for a listener. Each map value supports:
  * `listener_id` - (Required) The Listener ID that the whitelist will be associated with. Changing this creates a new whitelist.
  * `enable_whitelist` - (Optional) Specify whether to enable access control.
  * `whitelist` - (Optional) Specifies the IP addresses in the whitelist. Use commas(,) to separate
    the multiple IP addresses.

Example input:
```
listeners = {
  listener_01 = {
    name          = "listener_01"
    protocol      = "TERMINATED_HTTPS"
    protocol_port = 90
    certificates = {
      cert_01 = {
        type        = "server"
        private_key = tls_private_key.private_key.private_key_pem
        certificate = tls_self_signed_cert.cert.cert_pem
      }
      cert_02 = {
        type        = "client"
        certificate = tls_self_signed_cert.cert.cert_pem
      }
      cert_03 = {
        type        = "server"
        domain      = "test.com"
        private_key = tls_private_key.private_key.private_key_pem
        certificate = tls_self_signed_cert.cert.cert_pem
      }
    }
    whitelists = {
      whitelist_01 = {
        whitelist = "10.0.0.1"
      }
    }
  }
}
```
DESCRIPTION
}
