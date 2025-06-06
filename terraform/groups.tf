resource "keycloak_group" "grafana-admin" {
  realm_id = keycloak_realm.kcd.id
  name     = "grafana-admin"
}

resource "keycloak_group" "grafana-ro" {
  realm_id = keycloak_realm.kcd.id
  name     = "grafana-ro"
}

resource "keycloak_group" "argocd-admin" {
  realm_id = keycloak_realm.kcd.id
  name     = "argocd-admin"
}

resource "keycloak_group" "argocd-ro" {
  realm_id = keycloak_realm.kcd.id
  name     = "argocd-ro"
}

resource "keycloak_group" "kubernetes-admin" {
  realm_id = keycloak_realm.kcd.id
  name     = "kubernetes-admin"
}

resource "keycloak_group" "kubernetes-ro" {
  realm_id = keycloak_realm.kcd.id
  name     = "kubernetes-ro"
}
