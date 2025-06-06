terraform {
  required_providers {
    keycloak = {
      source = "keycloak/keycloak"
    }
  }
}
provider "keycloak" {
  client_id = "admin-cli"
  url       = "https://sso.labX.sikademo.com"
  username  = "user"
  password  = "bitnami"
}
