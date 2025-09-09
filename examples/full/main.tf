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
