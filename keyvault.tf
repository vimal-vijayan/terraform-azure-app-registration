resource "azurerm_key_vault_secret" "client-secret" {
  count        = var.keyvault_id == null || var.set_application_password == false ? 0 : 1
  key_vault_id = var.keyvault_id
  name         = "${var.app_name}-secret"
  value        = one(azuread_application_password.client-secret[*].value)
}

resource "azurerm_key_vault_secret" "aad-app-client-id" {
  count        = var.keyvault_id == null ? 0 : 1
  key_vault_id = var.keyvault_id
  name         = "${var.app_name}-clientid"
  value        = azuread_service_principal.spn.application_id
}