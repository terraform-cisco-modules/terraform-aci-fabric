/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3IfPol"
 - Distinguished Named "uni/fabric/l3IfP-default"
GUI Location:
 - Fabric > Fabric Policies > Policies > Interface > L3 Interface > default
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_interface_policy" "map" {
  for_each = {
    for v in toset(["default"]) : "default" => v if local.recommended_settings.l3_interface == true
  }
  bfd_isis    = local.l3_interface.bfd_isis_policy_configuration
  description = local.l3_interface.description
  name        = "default"
}