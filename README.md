<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
# OpenTelekomCloud Elastic Load Balancer Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md)
[![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE)
[![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE)
[![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/CloudAstro/elb/opentelekomcloud/)

This module is designed to manage **Elastic Load Balancers (ELB)** within OpenTelekomCloud (OTC). It enables flexible configuration options for ELB creation, including listener rules, backend pool setup, health checks, and custom tags for better organization.

## Features

- **Elastic Load Balancer Management**: Automates the creation and management of Elastic Load Balancers within OpenTelekomCloud.
- **Listener Configuration**: Supports the configuration of multiple listeners (HTTP, HTTPS, TCP, etc.) for flexible traffic routing.
- **Backend Pool Management**: Allows the assignment and management of backend servers and server groups.
- **Health Checks**: Enables customizable health checks for backend servers to ensure high availability and resilience.
- **Flexible Network Options**: Supports integration with custom subnets, security groups, and availability zones.

# Setup Requirements

To successfully apply the module, make sure to source the required variables either through the `.envrc` file or use `direnv` to automatically load environment variables for configuration. This step is crucial for proper execution of the module.

You can also use AK/SK authentication (`OS_ACCESS_KEY` and `OS_SECRET_KEY`) as an alternative to `OS_PASSWORD` and `OS_USERNAME` for accessing OpenTelekomCloud.

Ensure the following variables are set up correctly in your `.envrc` file for authentication:

```shell
export OS_USERNAME="USERNAME"
export OS_PASSWORD="PASSWORD"
export OS_DOMAIN_NAME="OTC000xxxx"
export OS_PROJECT_NAME="eu-de_project-name"
export OS_REGION="eu-de"
```

Once the .envrc file is set up, you can source it in your shell by running the following command:

```shell
source .envrc
```

# Example Usage

This example demonstrates how to provision a subnet across multiple availability zones with CIDR block configurations and custom timeouts:

```hcl
data "opentelekomcloud_identity_project_v3" "example" {
  name = "eu-de_test"
}

module "vpc" {
  source = "CloudAstro/vpc/opentelekomcloud"
  name   = "vpc-example"
  cidr   = "10.10.0.0/24"
}

module "subnet" {
  source     = "CloudAstro/vpc-subnet/opentelekomcloud"
  name       = "snet-example"
  cidr       = "10.10.0.0/26"
  gateway_ip = "10.10.0.1"
  vpc_id     = module.vpc.vpc_v1.id
}

module "elb" {
  source                = "../../"
  vip_subnet_id         = module.subnet.vpc_subnet.subnet_id
  name                  = "lb_example"
  description           = "description"
  tenant_id             = data.opentelekomcloud_identity_project_v3.example.id
  vip_address           = "10.10.0.2"
  admin_state_up        = true
  loadbalancer_provider = "vlb"
  listeners = {
    listener_01 = {
      name          = "listener_01"
      protocol      = "TERMINATED_HTTPS"
      protocol_port = 8080
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
      }
    }
    listener_02 = {
      name          = "listener_02"
      protocol      = "TERMINATED_HTTPS"
      protocol_port = 443
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
  pools = {
    pool_01 = {
      name      = "pool_01"
      protocol  = "HTTP"
      lb_method = "ROUND_ROBIN"
    }
    pool_02 = {
      name         = "pool_02"
      protocol     = "HTTP"
      lb_method    = "ROUND_ROBIN"
      listener_key = "listener_02"
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
  }
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
  tags = {
    foo = "bar"
    key = "value"
  }
}
```
<!-- markdownlint-disable MD033 -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.0 |
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >= 1.36.35 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >= 1.36.35 |

## Resources

| Name | Type |
|------|------|
| [opentelekomcloud_lb_certificate_v2.client](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_certificate_v2) | resource |
| [opentelekomcloud_lb_certificate_v2.server](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_certificate_v2) | resource |
| [opentelekomcloud_lb_certificate_v2.sni](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_certificate_v2) | resource |
| [opentelekomcloud_lb_l7policy_v2.this](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_l7policy_v2) | resource |
| [opentelekomcloud_lb_l7rule_v2.this](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_l7rule_v2) | resource |
| [opentelekomcloud_lb_listener_v2.this](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_listener_v2) | resource |
| [opentelekomcloud_lb_loadbalancer_v2.this](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_loadbalancer_v2) | resource |
| [opentelekomcloud_lb_member_v2.this](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_member_v2) | resource |
| [opentelekomcloud_lb_monitor_v2.this](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_monitor_v2) | resource |
| [opentelekomcloud_lb_pool_v2.this](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_pool_v2) | resource |
| [opentelekomcloud_lb_whitelist_v2.this](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_whitelist_v2) | resource |

<!-- markdownlint-disable MD013 -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vip_subnet_id"></a> [vip\_subnet\_id](#input\_vip\_subnet\_id) | * `vip_subnet_id` - (Required) The network on which to allocate the<br/>  loadbalancer's address. A tenant can only create loadalancers on networks<br/>  authorized by policy (e.g. networks that belong to them or networks that<br/>  are shared). Changing this creates a new loadbalancer.<br/><br/>-> When used with `opentelekomcloud_vpc_subnet_v1`, not `id` but<br/>`subnet_id`needs to be used<br/><br/>Example input:<pre>vip_subnet_id = opentelekomcloud_vpc_subnet_v1.example.subnet_id</pre> | `string` | n/a | yes |
| <a name="input_admin_state_up"></a> [admin\_state\_up](#input\_admin\_state\_up) | * `admin_state_up` - (Optional) The administrative state of the loadbalancer.<br/>  A valid value is only true (UP).<br/><br/>Example input:<pre>admin_state_up = false</pre> | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | * `description` - (Optional) Human-readable description for the loadbalancer.<br/><br/>Example input:<pre>description = "description"</pre> | `string` | `null` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | The following arguments are supported:<br/>* `protocol` - (Required) The protocol - can either be `TCP`, `HTTP`, `UDP` or `TERMINATED_HTTPS`.<br/>  Changing this creates a new Listener.<br/>* `protocol_port` - (Required) The port on which to listen for client traffic.<br/>  Changing this creates a new Listener.<br/>* `tenant_id` - (Optional) Required for admins. The UUID of the tenant who owns<br/>  the Listener.  Only administrative users can specify a tenant UUID<br/>  other than their own. Changing this creates a new Listener.<br/>* `loadbalancer_id` - (Required) The load balancer on which to provision this<br/>  Listener. Changing this creates a new Listener.<br/>* `name` - (Optional) Human-readable name for the Listener. Does not have<br/>  to be unique.<br/>* `default_pool_id` - (Optional) The ID of the default pool with which the<br/>  Listener is associated. Changing this creates a new Listener.<br/>* `description` - (Optional) Human-readable description for the Listener.<br/>* `http2_enable`- (Optional) `true` to enable HTTP/2 mode of ELB.<br/>  HTTP/2 is disabled by default if not set.<br/>* `default_tls_container_ref` - (Optional) Specifies the ID of a certificate container of type `server`<br/>  used by the listener. The value contains a maximum of 128 characters. The default value is `null`.<br/>  This parameter is **required** when protocol is set to `TERMINATED_HTTPS`.<br/>  See [here](https://wiki.openstack.org/wiki/Network/LBaaS/docs/how-to-create-tls-loadbalancer)<br/>  for more information.<br/>* `client_ca_tls_container_ref`  (Optional) Specifies the ID of a certificate container of type `client`<br/>  used by the listener. The value contains a maximum of 128 characters. The default value is `null`.<br/>  The loadbalancer only establishes a TLS connection if the client presents a certificate delivered by<br/>  the client CA whose certificate is registered in the referenced certificate container. The option is<br/>  effective only in conjunction with `TERMINATED_HTTPS`.<br/>* `sni_container_refs` - (Optional) Lists the IDs of SNI certificates (server certificates with a domain name) used<br/>  by the listener. If the parameter value is an empty list, the SNI feature is disabled.<br/>  The default value is `[]`. It only works in conjunction with `TERMINATED_HTTPS`.<br/>* `tls_ciphers_policy`- (Optional) Controls the TLS version used. Supported values are `tls-1-0`, `tls-1-1`,<br/>  `tls-1-2` and `tls-1-2-strict`. If not set, the loadbalancer uses `tls-1-0`. See<br/>  [here](https://docs.otc.t-systems.com/api/elb/elb_zq_jt_0001.html) for details about the supported cipher<br/>  suites. The option is effective only in conjunction with `TERMINATED_HTTPS`.<br/>* `transparent_client_ip_enable` - (Optional) Specifies whether to pass source IP addresses of the clients to<br/>  backend servers. The value is always `true` for `HTTP` and `HTTPS` listeners. For `TCP` and `UDP` listeners the<br/>  value can be `true` or `false` with `false` by default.<br/>* `admin_state_up` - (Optional) The administrative state of the Listener.<br/>  A valid value is `true` (UP) or `false` (DOWN).<br/>* `tags` - (Optional) Tags key/value pairs to associate with the loadbalancer listener.<br/>* `ip_group` - (Optional, Map) Specifies the IP address group associated with the listener.<br/>  * `id` - (Required, String) Specifies the ID of the IP address group associated with the listener.<br/>    Specifies the ID of the IP address group associated with the listener.<br/>    If `ip_list` in `opentelekomcloud_lb_ipgroup_v3` is set to an empty array `[]` and type to `whitelist`, no IP addresses are allowed to access the listener.<br/>    If `ip_list` in `opentelekomcloud_lb_ipgroup_v3` is set to an empty array `[]` and type to `blacklist`, any IP address is allowed to access the listener.<br/>  * `enable` - (Optional, Bool) Specifies whether to enable access control.<br/>    `true`: Access control will be enabled.<br/>    `false` (default): Access control will be disabled.<br/>  * `type` - (Optional, String) Specifies how access to the listener is controlled.<br/>    `white` (default): A whitelist will be configured. Only IP addresses in the whitelist can access the listener.<br/>    `black`: A blacklist will be configured. IP addresses in the blacklist are not allowed to access the listener.<br/>*	certificates - (Optional) Map of load balancer certificate definitions to create and attach to the listener. Each map value supports:<br/>	* `region` - (Optional) The region in which to obtain the V2 Networking client.<br/>    A Networking client is needed to create an LB certificate. If omitted, the<br/>    `region` argument of the provider is used. Changing this creates a new<br/>    LB certificate.<br/>  * `name` - (Optional) Human-readable name for the Certificate. Does not have<br/>    to be unique.<br/>  * `description` - (Optional) Human-readable description for the Certificate.<br/>  * `domain` - (Optional) The domain of the Certificate.<br/>  * `private_key` - (Optional) The private encrypted key of the Certificate, PEM format.<br/>    Required for certificates of type `server`.<br/>  * `certificate` - (Required) The public encrypted key of the Certificate, PEM format.<br/>  * `type`- (Optional) The type of certificate the container holds. Either `server` or `client`.<br/>    Defaults to `server` if not set. Changing this creates a new LB certificate.<br/>* whitelists - (Optional) Map of whitelist definitions. Each value configures ELB access control for a listener. Each map value supports:<br/>  * `listener_id` - (Required) The Listener ID that the whitelist will be associated with. Changing this creates a new whitelist.<br/>  * `enable_whitelist` - (Optional) Specify whether to enable access control.<br/>  * `whitelist` - (Optional) Specifies the IP addresses in the whitelist. Use commas(,) to separate<br/>    the multiple IP addresses.<br/><br/>Example input:<pre>listeners = {<br/>  listener_01 = {<br/>    name          = "listener_01"<br/>    protocol      = "TERMINATED_HTTPS"<br/>    protocol_port = 90<br/>    certificates = {<br/>      cert_01 = {<br/>        type        = "server"<br/>        private_key = tls_private_key.private_key.private_key_pem<br/>        certificate = tls_self_signed_cert.cert.cert_pem<br/>      }<br/>      cert_02 = {<br/>        type        = "client"<br/>        certificate = tls_self_signed_cert.cert.cert_pem<br/>      }<br/>      cert_03 = {<br/>        type        = "server"<br/>        domain      = "test.com"<br/>        private_key = tls_private_key.private_key.private_key_pem<br/>        certificate = tls_self_signed_cert.cert.cert_pem<br/>      }<br/>    }<br/>    whitelists = {<br/>      whitelist_01 = {<br/>        whitelist = "10.0.0.1"<br/>      }<br/>    }<br/>  }<br/>}</pre> | <pre>map(object({<br/>    protocol                     = string<br/>    protocol_port                = number<br/>    tenant_id                    = optional(string)<br/>    loadbalancer_id              = optional(string)<br/>    name                         = optional(string)<br/>    default_pool_id              = optional(string)<br/>    description                  = optional(string)<br/>    http2_enable                 = optional(bool, false)<br/>    default_tls_container_ref    = optional(string)<br/>    client_ca_tls_container_ref  = optional(string)<br/>    sni_container_refs           = optional(list(string))<br/>    tls_ciphers_policy           = optional(string, "tls-1-0")<br/>    transparent_client_ip_enable = optional(bool)<br/>    admin_state_up               = optional(bool, true)<br/>    tags                         = optional(map(any))<br/>    ip_group = optional(object({<br/>      id     = string<br/>      enable = optional(bool)<br/>      type   = optional(string)<br/>    }))<br/>    certificates = optional(map(object({<br/>      region      = optional(string)<br/>      name        = optional(string)<br/>      description = optional(string)<br/>      domain      = optional(string)<br/>      private_key = optional(string)<br/>      certificate = string<br/>      type        = optional(string)<br/>    })))<br/>    whitelists = optional(map(object({<br/>      enable_whitelist = optional(bool, true)<br/>      whitelist        = optional(string, "")<br/>      listener_id      = optional(string)<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_loadbalancer_provider"></a> [loadbalancer\_provider](#input\_loadbalancer\_provider) | * `loadbalancer_provider` - (Optional) The name of the provider. Changing this<br/>  creates a new loadbalancer.<br/><br/>Example input:<pre>loadbalancer_provider = "vlb"</pre> | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | * `name` - (Optional) Human-readable name for the loadbalancer. Does not have<br/>  to be unique.<br/><br/>Example input:<pre>name = elb-example</pre> | `string` | `null` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | The following arguments are supported:<br/>* `region` - (Optional) The region in which to obtain the V2 Networking client.<br/>  If omitted, the `region` argument of the provider is used.<br/>  Changing this creates a new L7 Policy.<br/>* `tenant_id` - (Optional) Required for admins. The UUID of the tenant who owns<br/>  the L7 Policy. Only administrative users can specify a tenant UUID<br/>  other than their own. Changing this creates a new L7 Policy.<br/>* `name` - (Optional) Human-readable name for the L7 Policy. Does not have<br/>  to be unique.<br/>* `description` - (Optional) Human-readable description for the L7 Policy.<br/>* `action` - (Required) The L7 Policy action - can either be REDIRECT\_TO\_POOL,<br/>  or REDIRECT\_TO\_LISTENER. Changing this creates a new L7 Policy.<br/>* `listener_key` - (Required) The Listener key on which the L7 Policy will be associated with.<br/>  Changing this creates a new L7 Policy.<br/>* `listener_id` - (Optional) The Listener on which the L7 Policy will be associated with.<br/>  Changing this creates a new L7 Policy.<br/>* `position` - (Optional) The position of this policy on the listener. Positions start at 1. Changing this creates a new L7 Policy.<br/>* `redirect_pool_key` - (Optional) Requests matching this policy will be redirected to the pool with this key.<br/>  Only valid if action is REDIRECT\_TO\_POOL.<br/>* `redirect_pool_id` - (Optional) Requests matching this policy will be redirected to the pool with this ID.<br/>  Only valid if action is REDIRECT\_TO\_POOL.<br/>* `redirect_listener_id` - (Optional) Requests matching this policy will be redirected to the listener with this key.<br/>  Only valid if action is REDIRECT\_TO\_LISTENER.<br/>* `redirect_listener_id` - (Optional) Requests matching this policy will be redirected to the listener with this ID.<br/>  Only valid if action is REDIRECT\_TO\_LISTENER.<br/>* `admin_state_up` - (Optional) The administrative state of the L7 Policy.<br/>  This value can only be true (UP).<br/>* rules - (Optional) Map of L7 rule definitions.  Each map value configures a single Layer-7 rule attached to an L7 policy and supports:<br/>  * `region` - (Optional) The region in which to obtain the V2 Networking client.<br/>    If omitted, the `region` argument of the provider is used.<br/>    Changing this creates a new L7 Rule.<br/>  * `description` - (Optional) Human-readable description for the L7 Rule.<br/>  * `type` - (Required) The L7 Rule type - can either be HOST\_NAME or PATH. Changing this creates a new L7 Rule.<br/>  * `compare_type` - (Required) The comparison type for the L7 rule - can either be<br/>    STARTS\_WITH, EQUAL\_TO or REGEX<br/>  * `l7policy_id` - (Optional) The ID of the L7 Policy to query. Changing this creates a new<br/>    L7 Rule.<br/>  * `value` - (Required) The value to use for the comparison. For example, the file type to<br/>    compare.<br/>  * `key` - (Optional) The key to use for the comparison. For example, the name of the cookie to<br/>    evaluate. Valid when `type` is set to COOKIE or HEADER. Changing this creates a new L7 Rule.<br/>  * `admin_state_up` - (Optional) The administrative state of the L7 Rule.<br/>    The value can only be true (UP).<br/><br/>Example input:<pre>policies = {<br/>  policy_01 = {<br/>    name              = "policy_01"<br/>    action            = "REDIRECT_TO_POOL"<br/>    description       = "test l7 policy"<br/>    position          = 1<br/>    listener_key      = "listener_01"<br/>    redirect_pool_key = "pool_01"<br/>    rules = {<br/>      rule_01 = {<br/>        type         = "PATH"<br/>        compare_type = "EQUAL_TO"<br/>        value        = "/test"<br/>      }<br/>    }<br/>  }<br/>}</pre> | <pre>map(object({<br/>    region                = optional(string)<br/>    tenant_id             = optional(string)<br/>    name                  = optional(string)<br/>    description           = optional(string)<br/>    action                = string<br/>    listener_key          = string<br/>    listener_id           = optional(string)<br/>    position              = optional(number, 100)<br/>    redirect_pool_key     = optional(string)<br/>    redirect_pool_id      = optional(string)<br/>    redirect_listener_key = optional(string)<br/>    redirect_listener_id  = optional(string)<br/>    admin_state_up        = optional(string, true)<br/>    rules = optional(map(object({<br/>      region         = optional(string)<br/>      description    = optional(string)<br/>      type           = string<br/>      compare_type   = string<br/>      l7policy_id    = optional(string)<br/>      value          = string<br/>      key            = optional(string)<br/>      admin_state_up = optional(bool, true)<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_pools"></a> [pools](#input\_pools) | The following arguments are supported:<br/>* `tenant_id` - (Optional) Required for admins. The UUID of the tenant who owns<br/>  the pool.  Only administrative users can specify a tenant UUID<br/>  other than their own. Changing this creates a new pool.<br/>* `name` - (Optional) Human-readable name for the pool.<br/>* `description` - (Optional) Human-readable description for the pool.<br/>* `protocol` - (Required) The protocol - can either be TCP, UDP or HTTP.<br/>  Changing this creates a new pool.<br/>* `loadbalancer_id` - (Optional) The load balancer on which to provision this<br/>  pool. Changing this creates a new pool.<br/>* `listener_key` - (Optional) The Listener key on which the members of the pool<br/>  will be associated with. Changing this creates a new pool.<br/>* `listener_id` - (Optional) The Listener id on which the members of the pool<br/>  will be associated with. Changing this creates a new pool.<br/>* `lb_method` - (Required) The load balancing algorithm to<br/>  distribute traffic to the pool's members. Must be one of<br/>  `ROUND_ROBIN`, `LEAST_CONNECTIONS`, or `SOURCE_IP`.<br/>* `admin_state_up` - (Optional) The administrative state of the pool.<br/>  A valid value is true (UP) or false (DOWN).<br/>* `persistence` - (Optional) Omit this field to prevent session persistence. Indicates<br/>  whether connections in the same session will be processed by the same Pool<br/>  member or not. Changing this creates a new pool. The `persistence` argument supports:<br/>  * `type` - (Optional; Required if `type != null`) The type of persistence mode. The current specification<br/>    supports `SOURCE_IP`, `HTTP_COOKIE`, and `APP_COOKIE`.<br/>  * `cookie_name` - (Optional; Required if `type = APP_COOKIE`) The name of the cookie if persistence mode is set<br/>    appropriately.<br/>* members - (Optional) Map of pool member definitions (use any names you like). Each map value configures one backend member and supports:<br/>  * `pool_id` - (Required) The id of the pool that this member will be<br/>    assigned to.<br/>  * `subnet_id` - (Required) The subnet in which to access the member<br/>  * `name` - (Optional) Human-readable name for the member.<br/>  * `tenant_id` - (Optional) Required for admins. The UUID of the tenant who owns<br/>    the member.  Only administrative users can specify a tenant UUID<br/>    other than their own. Changing this creates a new member.<br/>  * `address` - (Required) The IP address of the member to receive traffic from<br/>    the load balancer. Changing this creates a new member.<br/>  * `protocol_port` - (Required) The port on which to listen for client traffic.<br/>    Changing this creates a new member.<br/>  * `weight` - (Optional)  A positive integer value that indicates the relative<br/>    portion of traffic that this member should receive from the pool. For<br/>    example, a member with a `weight` of `10` receives five times as much traffic<br/>    as a member with a `weight` of `2`. If the value is `0`, the backend server will not accept new requests<br/>  * `admin_state_up` - (Optional) The administrative state of the member.<br/>    A valid value is `true` (UP) or `false` (DOWN).<br/>* monitors - (Optional) Map of health monitor definitions (use any names you like). Each entry supports:<br/>  * `pool_id` - (Required) The id of the pool that this monitor will be assigned to.<br/>  * `name` - (Optional) The Name of the Monitor.<br/>  * `tenant_id` - (Optional) Required for admins. The UUID of the tenant who owns<br/>    the monitor. Only administrative users can specify a tenant UUID<br/>    other than their own. Changing this creates a new monitor.<br/>  * `type` - (Required) The type of probe, which is `TCP`, `UDP_CONNECT`, or `HTTP`,<br/>    that is sent by the load balancer to verify the member state. Changing this<br/>    creates a new monitor.<br/>  * `delay` - (Required) The time, in seconds, between sending probes to members.<br/>  * `timeout` - (Required) Maximum number of seconds for a monitor to wait for a<br/>    ping reply before it times out. The value must be less than the delay value.<br/>  * `max_retries` - (Required) Number of permissible ping failures before<br/>    changing the member's status to INACTIVE. Must be a number between 1 and 10.<br/>  * `admin_state_up` - (Optional) The administrative state of the monitor.<br/>    A valid value is `true` (`UP`) or `false` (`DOWN`).<br/>  * `http_method` - (Optional) Required for HTTP types. The HTTP method used<br/>    for requests by the monitor. If this attribute is not specified, it<br/>    defaults to `GET`. The value can be `GET`, `HEAD`, `POST`, `PUT`, `DELETE`,<br/>    `TRACE`, `OPTIONS`, `CONNECT`, and `PATCH`.<br/>  * `domain_name` - (Optional) The `domain_name` of the HTTP request during the health check.<br/>  * `url_path` - (Optional) Required for HTTP types. URI path that will be<br/>    accessed if monitor type is `HTTP`.<br/>  * `expected_codes` - (Optional) Required for `HTTP` types. Expected HTTP codes<br/>    for a passing HTTP monitor. You can either specify a single status like<br/>    `"200"`, or a list like `"200,202"`.<br/>  * `monitor_port` - (Optional) Specifies the health check port. The port number<br/>    ranges from 1 to 65535. The value is left blank by default, indicating that<br/>    the port of the backend server is used as the health check port.<br/><br/>Example input:<pre>pool_01 = {<br/>  name         = "pool_01"<br/>  protocol     = "HTTP"<br/>  lb_method    = "ROUND_ROBIN"<br/>  listener_key = "listener_01"<br/>  members = {<br/>    member_01 = {<br/>      protocol_port = 8080<br/>      address       = "10.10.0.7"<br/>    }<br/>  }<br/>  monitors = {<br/>    monitor_01 = {<br/>      type           = "HTTP"<br/>      delay          = 20<br/>      timeout        = 10<br/>      max_retries    = 5<br/>      url_path       = "/"<br/>      expected_codes = "200"<br/>    }<br/>  }<br/>}</pre> | <pre>map(object({<br/>    tenant_id       = optional(string)<br/>    name            = optional(string)<br/>    description     = optional(string)<br/>    protocol        = string<br/>    loadbalancer_id = optional(string)<br/>    listener_key    = optional(string)<br/>    listener_id     = optional(string)<br/>    lb_method       = string<br/>    admin_state_up  = optional(bool, true)<br/>    persistence = optional(object({<br/>      type        = optional(string)<br/>      cookie_name = optional(string)<br/>    }))<br/>    members = optional(map(object({<br/>      pool_id        = optional(string)<br/>      subnet_id      = optional(string)<br/>      name           = optional(string)<br/>      tenant_id      = optional(string)<br/>      address        = string<br/>      protocol_port  = number<br/>      weight         = optional(number, 1)<br/>      admin_state_up = optional(bool, true)<br/>    })))<br/>    monitors = optional(map(object({<br/>      pool_id        = optional(string)<br/>      name           = optional(string)<br/>      tenand_id      = optional(string)<br/>      type           = string<br/>      delay          = number<br/>      timeout        = number<br/>      max_retries    = number<br/>      admin_state_up = optional(bool, true)<br/>      http_method    = optional(string, "GET")<br/>      domain_name    = optional(string)<br/>      url_path       = optional(string, "/")<br/>      expected_codes = optional(string)<br/>      monitor_port   = optional(string)<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | * `tags` - (Optional) The key/value pairs to associate with the subnet.<br/><br/>Example input:<pre>tags = {<br/>  foo = "bar"<br/>  key = "value"<br/>}</pre> | `map(string)` | `null` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | * `tenant_id` - (Optional) Required for admins. The UUID of the tenant who owns<br/>  the Loadbalancer.  Only administrative users can specify a tenant UUID<br/>  other than their own. Changing this creates a new loadbalancer.<br/><br/>Example input:<pre>tenant_id = data.opentelekomcloud_identity_project_v3.example.id</pre> | `string` | `null` | no |
| <a name="input_vip_address"></a> [vip\_address](#input\_vip\_address) | * `vip_address` - (Optional) The ip address of the load balancer.<br/>  Changing this creates a new loadbalancer.<br/><br/>Example input:<pre>vip_address = 10.0.0.1</pre> | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_certificate"></a> [lb\_certificate](#output\_lb\_certificate) | ## Attributes Reference<br/><br/>The following attributes are exported:<br/>* `region` - See Argument Reference above.<br/>* `name` - See Argument Reference above.<br/>* `description` - See Argument Reference above.<br/>* `domain` - See Argument Reference above.<br/>* `private_key` - See Argument Reference above.<br/>* `certificate` - See Argument Reference above.<br/>* `type` - See Argument Reference above.<br/>* `update_time` - Indicates the update time.<br/>* `create_time` - Indicates the creation time.<br/>* `expire_time` - Indicates certificate expiration time.<br/><br/>Example output:<pre>output "certificate_name" {<br/>  value = module.module_name.lb_certificate.type_name.name<br/>}</pre> |
| <a name="output_lb_l7policy"></a> [lb\_l7policy](#output\_lb\_l7policy) | The following arguments are supported:<br/>* `region` - (Optional) The region in which to obtain the V2 Networking client.<br/>  If omitted, the `region` argument of the provider is used.<br/>  Changing this creates a new L7 Policy.<br/>* `tenant_id` - (Optional) Required for admins. The UUID of the tenant who owns<br/>  the L7 Policy. Only administrative users can specify a tenant UUID<br/>  other than their own. Changing this creates a new L7 Policy.<br/>* `name` - (Optional) Human-readable name for the L7 Policy. Does not have<br/>  to be unique.<br/>* `description` - (Optional) Human-readable description for the L7 Policy.<br/>* `action` - (Required) The L7 Policy action - can either be REDIRECT\_TO\_POOL,<br/>  or REDIRECT\_TO\_LISTENER. Changing this creates a new L7 Policy.<br/>* `listener_id` - (Required) The Listener on which the L7 Policy will be associated with.<br/>  Changing this creates a new L7 Policy.<br/>* `position` - (Optional) The position of this policy on the listener. Positions start at 1. Changing this creates a new L7 Policy.<br/>* `redirect_pool_id` - (Optional) Requests matching this policy will be redirected to the pool with this ID.<br/>  Only valid if action is REDIRECT\_TO\_POOL.<br/>* `redirect_listener_id` - (Optional) Requests matching this policy will be redirected to the listener with this ID.<br/>  Only valid if action is REDIRECT\_TO\_LISTENER.<br/>* `admin_state_up` - (Optional) The administrative state of the L7 Policy.<br/>  This value can only be true (UP).<br/><br/>Example output:<pre>output "policy_name" {<br/>  value = module.module_name.lb_l7policy.policy_name.name<br/>}</pre> |
| <a name="output_lb_l7rule"></a> [lb\_l7rule](#output\_lb\_l7rule) | The following attributes are exported:<br/>* `id` - The unique ID for the L7 Rule.<br/>* `region` - See Argument Reference above.<br/>* `tenant_id` - See Argument Reference above.<br/>* `type` - See Argument Reference above.<br/>* `compare_type` - See Argument Reference above.<br/>* `l7policy_id` - See Argument Reference above.<br/>* `value` - See Argument Reference above.<br/>* `key` - See Argument Reference above.<br/>* `invert` - See Argument Reference above.<br/>* `admin_state_up` - See Argument Reference above.<br/>* `listener_id` - The ID of the Listener owning this resource.<br/><br/>Example output:<pre>output "rule_name" {<br/>  value = module.module_name.lb_l7rule.rule_name.name<br/>}</pre> |
| <a name="output_lb_listener"></a> [lb\_listener](#output\_lb\_listener) | The following attributes are exported:<br/>* `id` - The unique ID for the Listener.<br/>* `protocol` - See Argument Reference above.<br/>* `protocol_port` - See Argument Reference above.<br/>* `tenant_id` - See Argument Reference above.<br/>* `name` - See Argument Reference above.<br/>* `default_port_id` - See Argument Reference above.<br/>* `description` - See Argument Reference above.<br/>* `http2_enable` - See Argument Reference above.<br/>* `default_tls_container_ref` - See Argument Reference above.<br/>* `client_ca_tls_container_ref` - See Argument Reference above.<br/>* `sni_container_refs` - See Argument Reference above.<br/>* `tls_ciphers_policy` - See Argument Reference above.<br/>* `admin_state_up` - See Argument Reference above.<br/>* `tags` - See Argument Reference above.<br/><br/>Example output:<pre>output "listener_name" {<br/>  value = module.module_name.lb_listener.lb_listener_name.name<br/>}</pre> |
| <a name="output_lb_loadbalancer"></a> [lb\_loadbalancer](#output\_lb\_loadbalancer) | The following attributes are exported:<br/>* `vip_subnet_id` - See Argument Reference above.<br/>* `name` - See Argument Reference above.<br/>* `description` - See Argument Reference above.<br/>* `tenant_id` - See Argument Reference above.<br/>* `vip_address` - See Argument Reference above.<br/>* `admin_state_up` - See Argument Reference above.<br/>* `loadbalancer_provider` - See Argument Reference above.<br/>* `vip_port_id` - The Port ID of the Load Balancer IP.<br/>* `tags` - See Argument Reference above.<br/><br/>Example output:<pre>output "lb_name" {<br/>  value = module.module_name.lb_loadbalancer.name<br/>}</pre> |
| <a name="output_lb_member"></a> [lb\_member](#output\_lb\_member) | The following attributes are exported:<br/>* `id` - The unique ID for the member.<br/>* `name` - See Argument Reference above.<br/>* `weight` - See Argument Reference above.<br/>* `admin_state_up` - See Argument Reference above.<br/>* `tenant_id` - See Argument Reference above.<br/>* `subnet_id` - See Argument Reference above.<br/>* `pool_id` - See Argument Reference above.<br/>* `address` - See Argument Reference above.<br/>* `protocol_port` - See Argument Reference above.<br/><br/>Example output:<pre>output "member_name" {<br/>  value = module.module_name.lb_member.lb_member_name.name<br/>}</pre> |
| <a name="output_lb_monitor"></a> [lb\_monitor](#output\_lb\_monitor) | The following attributes are exported:<br/>* `id` - The unique ID for the monitor.<br/>* `tenant_id` - See Argument Reference above.<br/>* `type` - See Argument Reference above.<br/>* `delay` - See Argument Reference above.<br/>* `timeout` - See Argument Reference above.<br/>* `max_retries` - See Argument Reference above.<br/>* `url_path` - See Argument Reference above.<br/>* `domain_name` - See Argument Reference above.<br/>* `http_method` - See Argument Reference above.<br/>* `expected_codes` - See Argument Reference above.<br/>* `admin_state_up` - See Argument Reference above.<br/>* `monitor_port` - See Argument Reference above.<br/><br/>Example output:<pre>output "monitor_name" {<br/>  value = module.module_name.lb_monitor.monitor_name.name<br/>}</pre> |
| <a name="output_lb_pool"></a> [lb\_pool](#output\_lb\_pool) | ## Attributes Reference<br/>The following attributes are exported:<br/>* `id` - The unique ID for the pool.<br/>* `tenant_id` - See Argument Reference above.<br/>* `name` - See Argument Reference above.<br/>* `description` - See Argument Reference above.<br/>* `protocol` - See Argument Reference above.<br/>* `lb_method` - See Argument Reference above.<br/>* `persistence` - See Argument Reference above.<br/>* `admin_state_up` - See Argument Reference above.<br/><br/>Example output:<pre>output "pool_name" {<br/>  value = module.module_name.lb_pool.lb_pool_name.name<br/>}</pre> |
| <a name="output_lb_whitelist"></a> [lb\_whitelist](#output\_lb\_whitelist) | The following attributes are exported:<br/>* `id` - The unique ID for the whitelist.<br/>* `tenant_id` - See Argument Reference above.<br/>* `listener_id` - See Argument Reference above.<br/>* `enable_whitelist` - See Argument Reference above.<br/>* `whitelist` - See Argument Reference above.<br/><br/>Example output:<pre>output "whitelist_name" {<br/>  value = module.module_name.lb_whitelist.whitelist_name.name<br/>}</pre> |

## Modules

No modules.

## 🌐 Additional Information  

This module provides a flexible and robust way to manage Elastic Load Balancers (ELB) within OpenTelekomCloud, supporting advanced load balancing features such as multi-protocol listeners, backend pool management, health checks, and resource tagging.  
It can be used for both standalone ELB deployments and as a scalable component within larger cloud architectures.

## 📚 Resources

- [Terraform OpenTelekomCloud ELB Resource](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_loadbalancer_v2)  
- [OpenTelekomCloud Elastic Load Balancer Overview](https://docs.otc.t-systems.com/elastic-load-balancing/index.html)  
- [Terraform OpenTelekomCloud Provider](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs)  

## ⚠️ Notes  

- Ensure that the ELB type (internal/external) matches your network and security requirements.  
- Proper configuration of listeners and health checks is essential for high availability and performance.  
- Use tagging to simplify cost tracking and resource organization in your environment.  
- Check OpenTelekomCloud documentation for region-specific ELB limitations, quotas, and best practices.

## 🧾 License  

This module is released under the **Apache 2.0 License**. See the [LICENSE](./LICENSE) file for full details.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->