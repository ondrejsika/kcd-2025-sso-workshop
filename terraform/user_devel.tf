resource "keycloak_user" "devel" {
  realm_id       = keycloak_realm.kcd.id
  username       = "devel"
  enabled        = true
  email          = "devel@sikademo.com"
  email_verified = true
  first_name     = "Devel"
  last_name      = "Devel"
  initial_password {
    value     = "kcd"
    temporary = true
  }
}

resource "keycloak_user_groups" "devel" {
  realm_id = keycloak_realm.kcd.id
  user_id  = keycloak_user.devel.id
  group_ids = [
    keycloak_group.argocd-ro.id,
    keycloak_group.grafana-ro.id,
  ]
}
