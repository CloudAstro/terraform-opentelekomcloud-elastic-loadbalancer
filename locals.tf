locals {
  _cert_server_ids = merge([
    for key, value in var.listeners :
    value.certificates != null ? {
      for cert_key, cert_value in value.certificates :
      key => cert_key
      if cert_value.type == "server" && cert_value.domain == null
    } : {}
  ]...)

  _cert_client_ids = merge([
    for key, value in var.listeners :
    value.certificates != null ? {
      for cert_key, cert_value in value.certificates :
      key => cert_key
      if cert_value.type == "client"
    } : {}
  ]...)

  _cert_sni_ids = merge([
    for key, value in var.listeners :
    value.certificates != null ? {
      for cert_key, cert_value in value.certificates :
      "${key}_${cert_key}" => {
        listener_key = key
        cert_key     = cert_key
      }
      if cert_value.domain != null
    } : {}
  ]...)

  listener_cert_server = try(nonsensitive(local._cert_server_ids), local._cert_server_ids)
  listener_cert_client = try(nonsensitive(local._cert_client_ids), local._cert_client_ids)
  listener_cert_sni    = try(nonsensitive(local._cert_sni_ids), local._cert_sni_ids)
}

locals {
  whitelists = merge([
    for key, value in var.listeners : (
      value.whitelists != null ? {
        for wl_key, wl_value in value.whitelists : "${key}_${wl_key}" => merge(
          { parent_key = key },
          wl_value
        )
      } : {}
    )
  ]...)
}

locals {
  members = merge([
    for key, value in var.pools : (
      value.members != null ? {
        for member_key, member in value.members : member_key => merge(
          { parent_key = key },
          member
        )
      } : {}
    )
  ]...)
}

locals {
  monitors = merge([
    for key, value in var.pools : (
      value.monitors != null ? {
        for monitor_key, monitor in value.monitors : monitor_key => merge(
          { parent_key = key },
          monitor
        )
      } : {}
    )
  ]...)
}

locals {
  rules = merge([
    for key, value in var.policies : (
      value.rules != null ? {
        for rule_key, rule in value.rules : rule_key => merge(
          { parent_key = key },
          rule
        )
      } : {}
    )
  ]...)
}