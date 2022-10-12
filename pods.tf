/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricPodPGrp"
 - Distinguished Name: "uni/fabric/funcprof/podpgrp-{policy_group}"
GUI Location:
 - Fabric > Fabric Policies > Pods > Policy Groups: {policy_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "pod_policy_groups" {
  for_each   = { for v in toset(["default"]) : "default" => v if local.recommended_settings.pods == true }
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}"
  class_name = "fabricPodPGrp"
  content = {
    # annotation = coalesce(local.pods.policy_group.annotation, local.defaults.annotation)
    descr = local.pods.policy_group.description
    name  = each.key
  }
}

resource "aci_rest_managed" "pod_policy_groups_bgp_rr_policy" {
  for_each   = { for v in toset(["default"]) : "default" => v if local.recommended_settings.pods == true }
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rspodPGrpBGPRRP"
  class_name = "fabricRsPodPGrpBGPRRP"
  content = {
    tnBgpInstPolName = "${local.pods.policy_group.bgp_route_reflector_policy}"
  }
}

resource "aci_rest_managed" "pod_policy_groups_coop_policy" {
  for_each   = { for v in toset(["default"]) : "default" => v if local.recommended_settings.pods == true }
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rspodPGrpCoopP"
  class_name = "fabricRsPodPGrpCoopP"
  content = {
    tnCoopPolName = "${local.pods.policy_group.coop_group_policy}"
  }
}

resource "aci_rest_managed" "pod_policy_groups_date_and_time_policy" {
  for_each   = { for v in toset(["default"]) : "default" => v if local.recommended_settings.pods == true }
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rsTimePol"
  class_name = "fabricRsTimePol"
  content = {
    tnDatetimePolName = "${local.pods.policy_group.date_time_policy}"
  }
}

resource "aci_rest_managed" "pod_policy_groups_isis_policy" {
  for_each   = { for v in toset(["default"]) : "default" => v if local.recommended_settings.pods == true }
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rspodPGrpIsisDomP"
  class_name = "fabricRsPodPGrpIsisDomP"
  content = {
    tnIsisDomPolName = "${local.pods.policy_group.isis_policy}"
  }
}

resource "aci_rest_managed" "pod_policy_groups_macsec_policy" {
  for_each   = { for v in toset(["default"]) : "default" => v if local.recommended_settings.pods == true }
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rsmacsecPol"
  class_name = "fabricRsMacsecPol"
  content = {
    tnMacsecFabIfPolName = "${local.pods.policy_group.macsec_policy}"
  }
}

resource "aci_rest_managed" "pod_policy_groups_mgmt_policy" {
  for_each   = { for v in toset(["default"]) : "default" => v if local.recommended_settings.pods == true }
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rsCommPol"
  class_name = "fabricRsCommPol"
  content = {
    tnCommPolName = "${local.pods.policy_group.management_access_policy}"
  }
}

resource "aci_rest_managed" "pod_policy_groups_snmp_policy" {
  for_each   = { for v in toset(["default"]) : "default" => v if local.recommended_settings.pods == true }
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rssnmpPol"
  class_name = "fabricRsSnmpPol"
  content = {
    tnSnmpPolName = "${local.pods.policy_group.snmp_policy}"
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricPodP"
 - Distinguished Name: "uni/fabric/funcprof/podpgrp-{pod_profile}"
GUI Location:
 - Fabric > Fabric Policies > Pods > Profiles > Pod Profile {pod_profile}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "pod_profiles" {
  depends_on = [
    aci_rest_managed.pod_policy_groups
  ]
  for_each   = { for v in toset(["default"]) : "default" => v if local.recommended_settings.pods == true }
  class_name = "fabricPodP"
  dn         = "uni/fabric/podprof-${each.key}"
  content = {
    # annotation = coalesce(local.pods.profile.annotation, local.defaults.annotation)
    descr = local.pods.profile.description
    name  = each.key
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricPodS"
 - Distinguished Name: "uni/fabric/podprof-${pod_profile}/pods-${name}-typ-ALL"
GUI Location:
 - Fabric > Fabric Policies > Pods > Profiles > Pod Profile {pod_profile} > Pod Selectors
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "pod_profile_selectors_all" {
  depends_on = [
    aci_rest_managed.pod_policy_groups,
    aci_rest_managed.pod_profiles
  ]
  for_each = {
    for v in toset(["default"]
    ) : "default" => v if local.recommended_settings.pods == true && local.pods.profile.pod_selector_type == "ALL"
  }
  class_name = "fabricPodS"
  dn         = "uni/fabric/podprof-${each.key}/pods-${each.key}-typ-ALL"
  content = {
    # annotation = coalesce(local.pods.profile.annotation, local.defaults.annotation)
    name = each.key
    type = local.pods.profile.pod_selector_type
  }
  child {
    rn         = "rspodPGrp"
    class_name = "fabricRsPodPGrp"
    content = {
      tDn = "uni/fabric/funcprof/podpgrp-${each.key}"
    }
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricPodS"
 - Distinguished Name: "uni/fabric/podprof-${pod_profile}/pods-${name}-typ-range"
GUI Location:
 - Fabric > Fabric Policies > Pods > Profiles > Pod Profile {pod_profile} > Pod Selectors
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "pod_profile_selectors_range" {
  depends_on = [
    aci_rest_managed.pod_policy_groups,
    aci_rest_managed.pod_profiles
  ]
  for_each = {
    for v in toset(["default"]
    ) : "default" => v if local.recommended_settings.pods == true && local.pods.profile.pod_selector_type == "range"
  }
  class_name = "fabricPodS"
  dn         = "uni/fabric/podprof-default/pods-${each.key}-typ-range"
  content = {
    annotation = coalesce(local.pods.profile.annotation, local.defaults.annotation)
    name       = each.key
    type       = local.pods.profile.pod_selector_type
  }
  child {
    rn = length(
      local.pods.profile.pods
      ) > 1 ? "podblk-${element(local.pods.profile.pods, 0)}_${element(local.pods.profile.pods, 1
    )}" : "podblk-${element(local.pods.profile.pods, 0)}"
    class_name = "fabricPodBlk"
    content = {
      from_ = element(local.pods.profile.pods, 0)
      to_ = length(local.pods.profile.pods) > 1 ? element(local.pods.profile.pods, 1
      ) : element(local.pods.profile.pods, 0)
    }
  }
  child {
    rn         = "rspodPGrp"
    class_name = "fabricRsPodPGrp"
    content = {
      tDn = "uni/fabric/funcprof/podpgrp-${each.key}"
    }
  }
}
