/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3IfPol"
 - Distinguished Named "uni/fabric/l3IfP-default"
GUI Location:
 - Fabric > Fabric Policies > Policies > Interface > L3 Interface > default
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_interface_policy" "map" {
  for_each    = { for v in local.l3_interface : v.name => v }
  annotation  = "orchestrator:terraform"
  bfd_isis    = each.value.bfd_isis_policy_configuration
  description = each.value.description
  name        = each.value.name
}