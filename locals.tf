locals {
  allowed_member_types = ["Application"]
  description          = "Apps that have this role have the ability to invoke the API."
  display_name         = "Can Invoke the API"
  enabled              = true
  id                   = random_uuid.oauth-api.result
  value                = "InvokeRole"
  tags                 = [
    "EssityDescription: This app registration is created by terraform",
    "EssityOwner: Cloud Enablement Team"
  ]
  common_tags = coalesce(var.tags, local.tags)
}