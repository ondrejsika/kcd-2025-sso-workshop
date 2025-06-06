resource "keycloak_openid_client" "default" {
  realm_id              = keycloak_realm.kcd.id
  client_id             = "default"
  name                  = "default"
  enabled               = true
  access_type           = "CONFIDENTIAL"
  client_secret         = "default"
  standard_flow_enabled = true
  valid_redirect_uris = [
    "*",
  ]
}

resource "keycloak_openid_client_default_scopes" "default" {
  realm_id  = keycloak_realm.kcd.id
  client_id = keycloak_openid_client.default.id
  default_scopes = [
    "profile",
    "email",
    keycloak_openid_client_scope.kcd_groups.name,
  ]
}
