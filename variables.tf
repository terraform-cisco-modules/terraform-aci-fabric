/*_____________________________________________________________________________________________________________________

Model Data from Top Level Module
_______________________________________________________________________________________________________________________
*/
variable "fabric" {
  description = "Fabric Model data."
  type        = any
}

/*_____________________________________________________________________________________________________________________

Fabric Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "fabric_sensitive" {
  default = {
    ntp = {
      key_id = {}
    }
    snmp = {
      authorization_key = {}
      community         = {}
      privacy_key       = {}
    }
  }
  description = <<EOT
    Note: Sensitive Variables cannot be added to a for_each loop so these are added seperately.
    * mcp_instance_policy_default: MisCabling Protocol Instance Settings.
      - key: The key or password used to uniquely identify this configuration object.
    * virtual_networking: ACI to Virtual Infrastructure Integration.
      - password: Username/Password combination to Authenticate to the Virtual Infrastructure.
  EOT
  sensitive   = true
  type = object({
    ntp = object({
      key_id = map(string)
    })
    snmp = object({
      authorization_key = map(string)
      community         = map(string)
      privacy_key       = map(string)
    })
  })
}
