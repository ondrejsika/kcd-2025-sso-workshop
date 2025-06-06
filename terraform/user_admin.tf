resource "keycloak_user" "admin" {
  realm_id       = keycloak_realm.kcd.id
  username       = "admin"
  enabled        = true
  email          = "admin@sikademo.com"
  email_verified = true
  first_name     = "Admin"
  last_name      = "Admin"
  initial_password {
    value     = "kcd"
    temporary = true
  }
}

resource "keycloak_user_groups" "admin" {
  realm_id = keycloak_realm.kcd.id
  user_id  = keycloak_user.admin.id
  group_ids = [
    keycloak_group.kubernetes-admin.id,
    keycloak_group.argocd-admin.id,
    keycloak_group.grafana-admin.id,
  ]
}
