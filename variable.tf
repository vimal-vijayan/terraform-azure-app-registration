variable "app_name" {
  description = "application name"
  type        = string

  validation {
    condition     = can(regex("^spa-", var.app_name))
    error_message = "Service Principal Name should be spa-<app_name>-<component>-<environment>-xx"
  }
}

variable "identifier_uris" {
  type        = set(string)
  default     = []
  description = "(Optional) A set of user-defined URI(s) that uniquely identify an application within its Azure AD tenant, or within a verified custom domain if the application is multi-tenant."
}
variable "owners" {
  type        = list(string)
  description = "Object ID of owners [list of string required]"
}
variable "sign_in_audience" {
  default     = "AzureADMyOrg"
  description = "(Optional) The Microsoft account types that are supported for the current application. Must be one of AzureADMyOrg, AzureADMultipleOrgs, AzureADandPersonalMicrosoftAccount or PersonalMicrosoftAccount. Defaults to AzureADMyOrg."
  type        = string
}
variable "rotation_days" {
  default     = 365
  type        = number
  description = "Service Principal Expiry in Days, Default to 365 Days"

  validation {
    condition     = var.rotation_days < 365
    error_message = "service principal age should not be more than 365 Days"
  }
}

variable "app_role" {
  default = []
  type    = list(object({
    allowed_member_types = list(string)
    description          = string
    display_name         = string
    id                   = string
    enabled              = optional(bool, true)
  }))
  description = <<EOT
[
  {
    allowed_member_types = ["User", "Application"]
    description          = "Admins can manage roles and perform all task actions"
    display_name         = "Admin"
    enabled              = true
    id                   = "1b19509b-32b1-4e9f-b71d-4992aa991967"
    value                = "admin"
  }
]
EOT
}

variable "api" {
  default = {}
  type    = map(object({
    mapped_claims_enabled          = optional(bool, false)
    requested_access_token_version = optional(number, 1)
    known_client_applications      = optional(list(string))
    oauth2_permission_scope        = optional(list(object({
      admin_consent_description  = optional(string)
      admin_consent_display_name = optional(string)
      enabled                    = optional(bool, true)
      id                         = optional(string)
      type                       = optional(string, "User")
      user_consent_description   = optional(string)
      user_consent_display_name  = optional(string)
      value                      = optional(string)
    })))
  }))
  description = <<EOT
{
  mapped_claims_enabled          = true
  requested_access_token_version = 2

  known_client_applications = [
    azuread_application.known1.application_id,
    azuread_application.known2.application_id,
  ]

  oauth2_permission_scope = [
    {
      admin_consent_description  = "Allow the application to access example on behalf of the signed-in user."
      admin_consent_display_name = "Access example"
      enabled                    = true
      id                         = "96183846-204b-4b43-82e1-5d2222eb4b9b"
      type                       = "User"
      user_consent_description   = "Allow the application to access example on your behalf."
      user_consent_display_name  = "Access example"
      value                      = "user_impersonation"
    }
  ]
}
EOT
}

# Resource access block

variable "required_resource_access" {
  type = list(object({
    resource_app_id = string
    resource_access = list(object({
      id   = string
      type = string
    }))
  }))
  default     = []
  description = <<EOT
[
  {
    resource_app_id = "00000003-0000-0000-c000-000000000000"
    resource_access = {
      id  = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
      type = "Roll"
    }
  }
]
EOT
}

# azure ad_application_password
variable "set_application_password" {
  default     = false
  type        = bool
  description = "set application password"
}

variable "tags" {
  default = [
    "EssityDescription: This service principal is created by terraform",
    "EssityOwner: CET"
  ]
  type        = set(string)
  description = "Manifest Tags"
}

# Key vault
variable "keyvault_id" {
  default     = null
  description = "key vault id, if the app client secret and client name is need to be stored"
}
