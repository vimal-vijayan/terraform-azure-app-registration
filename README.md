## Sample Usage

```
data "azurerm_client_config" "current" {}

module "app-registration" {
  source  = "app.terraform.io/Essity/app-registration/azure"
  version = "1.2.6" # check the latest version of the module
  
  app_name                  = "spa-devops-sample-application-dev"
  owners                    = ["example@essity.com", data.azurerm_client_config.current.client_id]
  set_application_password  = false
  required_resource_access  = [{
      resource_app_id = "00000003-0000-0000-c000-000000000000"
      resource_access = [
        {
          id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
          type = "Role"
        },
        {
          id   = "62a82d76-70ea-41e2-9197-370581804d09" # Group.ReadWrite.All
          type = "Role"
        }
      ]
    }]
  tags                      = [
    "EssityDescription: This app registration is created by terraform",
    "EssityOwner: Cloud Enablement Team"
  ]
  set_application_password = true
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.30.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.30.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.31.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.app](https://registry.terraform.io/providers/hashicorp/azuread/2.30.0/docs/resources/application) | resource |
| [azuread_application_password.client-secret](https://registry.terraform.io/providers/hashicorp/azuread/2.30.0/docs/resources/application_password) | resource |
| [azuread_service_principal.spn](https://registry.terraform.io/providers/hashicorp/azuread/2.30.0/docs/resources/service_principal) | resource |
| [azurerm_key_vault_secret.aad-app-client-id](https://registry.terraform.io/providers/hashicorp/azurerm/3.31.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.client-secret](https://registry.terraform.io/providers/hashicorp/azurerm/3.31.0/docs/resources/key_vault_secret) | resource |
| [random_uuid.api](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.oauth-api](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [time_rotating.client](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api"></a> [api](#input\_api) | {<br>  mapped\_claims\_enabled          = true<br>  requested\_access\_token\_version = 2<br><br>  known\_client\_applications = [<br>    azuread\_application.known1.application\_id,<br>    azuread\_application.known2.application\_id,<br>  ]<br><br>  oauth2\_permission\_scope = [<br>    {<br>      admin\_consent\_description  = "Allow the application to access example on behalf of the signed-in user."<br>      admin\_consent\_display\_name = "Access example"<br>      enabled                    = true<br>      id                         = "96183846-204b-4b43-82e1-5d2222eb4b9b"<br>      type                       = "User"<br>      user\_consent\_description   = "Allow the application to access example on your behalf."<br>      user\_consent\_display\_name  = "Access example"<br>      value                      = "user\_impersonation"<br>    }<br>  ]<br>} | <pre>map(object({<br>    mapped_claims_enabled          = optional(bool, false)<br>    requested_access_token_version = optional(number, 1)<br>    known_client_applications      = optional(list(string))<br>    oauth2_permission_scope        = optional(list(object({<br>      admin_consent_description  = optional(string)<br>      admin_consent_display_name = optional(string)<br>      enabled                    = optional(bool, true)<br>      id                         = optional(string)<br>      type                       = optional(string, "User")<br>      user_consent_description   = optional(string)<br>      user_consent_display_name  = optional(string)<br>      value                      = optional(string)<br>    })))<br>  }))</pre> | `{}` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | application name | `string` | n/a | yes |
| <a name="input_app_role"></a> [app\_role](#input\_app\_role) | [<br>  {<br>    allowed\_member\_types = ["User", "Application"]<br>    description          = "Admins can manage roles and perform all task actions"<br>    display\_name         = "Admin"<br>    enabled              = true<br>    id                   = "1b19509b-32b1-4e9f-b71d-4992aa991967"<br>    value                = "admin"<br>  }<br>] | <pre>list(object({<br>    allowed_member_types = list(string)<br>    description          = string<br>    display_name         = string<br>    id                   = string<br>    enabled              = optional(bool, true)<br>  }))</pre> | `[]` | no |
| <a name="input_identifier_uris"></a> [identifier\_uris](#input\_identifier\_uris) | (Optional) A set of user-defined URI(s) that uniquely identify an application within its Azure AD tenant, or within a verified custom domain if the application is multi-tenant. | `set(string)` | `[]` | no |
| <a name="input_keyvault_id"></a> [keyvault\_id](#input\_keyvault\_id) | key vault id, if the app client secret and client name is need to be stored | `any` | `null` | no |
| <a name="input_owners"></a> [owners](#input\_owners) | Object ID of owners [list of string required] | `list(string)` | n/a | yes |
| <a name="input_required_resource_access"></a> [required\_resource\_access](#input\_required\_resource\_access) | [<br>  {<br>    resource\_app\_id = "00000003-0000-0000-c000-000000000000"<br>    resource\_access = {<br>      id  = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All<br>      type = "Roll"<br>    }<br>  }<br>] | <pre>list(object({<br>    resource_app_id = string<br>    resource_access = list(object({<br>      id   = string<br>      type = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_rotation_days"></a> [rotation\_days](#input\_rotation\_days) | Service Principal Expiry in Days, Default to 365 Days | `number` | `365` | no |
| <a name="input_set_application_password"></a> [set\_application\_password](#input\_set\_application\_password) | set application password | `bool` | `false` | no |
| <a name="input_sign_in_audience"></a> [sign\_in\_audience](#input\_sign\_in\_audience) | (Optional) The Microsoft account types that are supported for the current application. Must be one of AzureADMyOrg, AzureADMultipleOrgs, AzureADandPersonalMicrosoftAccount or PersonalMicrosoftAccount. Defaults to AzureADMyOrg. | `string` | `"AzureADMyOrg"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Manifest Tags | `set(string)` | <pre>[<br>  "EssityDescription: This service principal is created by terraform",<br>  "EssityOwner: CET"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app-client-name"></a> [app-client-name](#output\_app-client-name) | Enterprise application Name |
| <a name="output_app-role-id"></a> [app-role-id](#output\_app-role-id) | App role id |
| <a name="output_application-id"></a> [application-id](#output\_application-id) | Enterprise application id |
| <a name="output_client-secret"></a> [client-secret](#output\_client-secret) | Client Secret |
| <a name="output_object-id"></a> [object-id](#output\_object-id) | Service Principal object id |
