resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "cert" {
  private_key_pem = tls_private_key.private_key.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "My Org"
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  validity_period_hours = 8760
  is_ca_certificate     = false

}
