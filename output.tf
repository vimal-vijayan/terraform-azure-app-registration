output "app-role-id" {
  value       = one(azuread_application.app.app_role[*].id)
  description = "App role id"
}
output "application-id" {
  value       = azuread_application.app.application_id
  description = "Enterprise application id"
}
output "app-client-name" {
  value       = azuread_application.app.display_name
  description = "Enterprise application Name"
}
output "client-secret" {
  value       = one(azuread_application_password.client-secret[*].value)
  description = "Client Secret"
}
output "object-id" {
  value       = azuread_service_principal.spn.object_id
  description = "Service Principal object id"
}
