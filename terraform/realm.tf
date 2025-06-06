resource "keycloak_realm" "kcd" {
  realm                    = "kcd"
  enabled                  = true
  display_name_html        = "<h1>KCD SSO</h1>"
  login_with_email_allowed = true
  login_theme              = "training"
  reset_password_allowed   = true
  remember_me              = true
}

resource "keycloak_openid_client_scope" "kcd_groups" {
  realm_id               = keycloak_realm.kcd.id
  name                   = "groups"
  include_in_token_scope = true
  gui_order              = 1
}

resource "keycloak_openid_group_membership_protocol_mapper" "kcd_groups" {
  realm_id        = keycloak_realm.kcd.id
  client_scope_id = keycloak_openid_client_scope.kcd_groups.id
  name            = "groups"
  claim_name      = "groups"
  full_path       = false
}
