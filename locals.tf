locals {
  listener_cert_server = merge([
    for key, value in var.listeners :
    value.certificates != null ? {
      for cert_key, cert_value in value.certificates :
      key => cert_value
      if cert_value.type == "server" && cert_value.domain == null
    } : {}
  ]...)

  listener_cert_client = merge([
    for key, value in var.listeners :
    value.certificates != null ? {
      for cert_key, cert_value in value.certificates :
      key => cert_value
      if cert_value.type == "client"
    } : {}
  ]...)

  listener_cert_sni = merge([
    for key, value in var.listeners :
    value.certificates != null ? {
      for cert_key, cert_value in value.certificates :
      "${key}_${cert_key}" => cert_value
      if cert_value.domain != null
    } : {}
  ]...)

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
