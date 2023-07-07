/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricNodeControl"
 - Distinguished Named "uni/fabric/nodecontrol-default"
GUI Location:
 - Fabric > Fabric Policies > Policies > Monitoring > Fabric Node Controls > default
_______________________________________________________________________________________________________________________
*/
resource "aci_fabric_node_control" "fabric_node_controls" {
  for_each = {
    for v in toset(["default"]) : "default" => v if local.recommended_settings.fabric_node_controls == true
  }
  control     = local.fabric_node_controls.enable_dom
  description = local.fabric_node_controls.description
  feature_sel = local.fabric_node_controls.feature_selections
  name        = "default"
}

