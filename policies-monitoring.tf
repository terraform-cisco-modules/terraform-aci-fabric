/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricNodeControl"
 - Distinguished Named "uni/fabric/nodecontrol-default"
GUI Location:
 - Fabric > Fabric Policies > Policies > Monitoring > Fabric Node Controls > default
_______________________________________________________________________________________________________________________
*/
resource "aci_fabric_node_control" "map" {
  for_each    = { for v in local.fabric_node_controls : v.name => v }
  annotation  = "orchestrator:terraform"
  control     = each.value.enable_dom == true ? "Dom" : "None"
  description = each.value.description
  feature_sel = each.value.feature_selections
  name        = each.value.name
}

