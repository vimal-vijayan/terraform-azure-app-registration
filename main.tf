//api
resource "random_uuid" "api" {}
resource "random_uuid" "oauth-api" {}


resource "azuread_application" "app" {
  display_name     = var.app_name
  owners           = var.owners
  sign_in_audience = var.sign_in_audience
  identifier_uris  = var.identifier_uris

  tags = var.tags

  dynamic "api" {
    for_each = length(var.api) == 0 ? {} : var.api
    content {
      mapped_claims_enabled          = lookup(api.value, "mapped_claims_enabled", false )
      requested_access_token_version = lookup(api.value, "requested_access_token_version", 1)
      known_client_applications      = lookup(api.value, "known_client_applications", null)

      dynamic "oauth2_permission_scope" {
        iterator = oauth
        for_each = length(api.value.oauth2_permission_scope) == 0 ? [] : api.value.oauth2_permission_scope
        content {
          id                         = lookup(api.value, "id", uuid())
          admin_consent_display_name = lookup(api.value, "oauth2_permission_scope", null)
          admin_consent_description  = lookup(api.value, "oauth2_permission_scope", null)
          enabled                    = lookup(api.value, "enabled", true)
          type                       = lookup(api.value, "type", "User")
          user_consent_description   = lookup(api.value, "user_consent_description", null)
          user_consent_display_name  = lookup(api.value, "user_consent_display_name", null)
          value                      = lookup(api.value, "value", null)
        }
      }

    }
  }

  dynamic "required_resource_access" {
    for_each = length(var.required_resource_access) == 0 ? [] : var.required_resource_access
    content {
      resource_app_id = lookup(required_resource_access.value, "resource_app_id", null )
      dynamic "resource_access" {
        for_each = required_resource_access.value.resource_access
        content {
          id   = lookup(resource_access.value, "id", null )
          type = lookup(resource_access.value, "type", null )
        }
      }
    }
  }

  dynamic "app_role" {
    for_each = length(var.app_role) == 0 ? [] : var.app_role
    content {
      allowed_member_types = lookup(app_role.value, "allowed_member_types", ["User"])
      description          = lookup(app_role.value, "description", null )
      display_name         = lookup(app_role.value, "display_name", null )
      id                   = lookup(app_role.value, "id", null )
      enabled              = lookup(app_role.value, "enabled", true )
    }
  }
}

resource "azuread_service_principal" "spn" {
  application_id               = azuread_application.app.application_id
  app_role_assignment_required = false
  owners                       = var.owners

  tags = local.common_tags
}

resource "time_rotating" "client" {
  count         = var.set_application_password == false ? 0 : 1
  rotation_days = var.rotation_days

  triggers = {
    rotation = var.rotation_days
  }

}

resource "azuread_application_password" "client-secret" {
  count                 = var.set_application_password == false ? 0 : 1
  application_object_id = azuread_application.app.object_id
  rotate_when_changed   = {
    rotation = one(time_rotating.client[*].rotation_days)
  }

  #  lifecycle {
  #    ignore_changes = all
  #  }
}

