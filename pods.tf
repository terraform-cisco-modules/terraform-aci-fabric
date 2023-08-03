/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricPodPGrp"
 - Distinguished Name: "uni/fabric/funcprof/podpgrp-{policy_group}"
GUI Location:
 - Fabric > Fabric Policies > Pods > Policy Groups: {policy_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "pod_policy_groups" {
  for_each   = local.policy_groups
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}"
  class_name = "fabricPodPGrp"
  content = {
    #annotation = "orchestrator:terraform"
    descr      = each.value.description
    name       = each.key
  }
}

resource "aci_rest_managed" "pod_policy_groups_bgp_rr_policy" {
  depends_on = [
    aci_rest_managed.pod_policy_groups
  ]
  for_each   = local.policy_groups
  class_name = "fabricRsPodPGrpBGPRRP"
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rspodPGrpBGPRRP"
  content = {
    tnBgpInstPolName = "${each.value.bgp_route_reflector_policy}"
  }
}

resource "aci_rest_managed" "pod_policy_groups_coop_policy" {
  depends_on = [
    aci_rest_managed.pod_policy_groups
  ]
  for_each   = local.policy_groups
  class_name = "fabricRsPodPGrpCoopP"
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rspodPGrpCoopP"
  content = {
    tnCoopPolName = "${each.value.coop_group_policy}"
  }
}

resource "aci_rest_managed" "pod_policy_groups_date_and_time_policy" {
  depends_on = [
    aci_rest_managed.pod_policy_groups
  ]
  for_each   = local.policy_groups
  class_name = "fabricRsTimePol"
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rsTimePol"
  content = {
    tnDatetimePolName = "${each.value.date_time_policy}"
  }
}

resource "aci_rest_managed" "pod_policy_groups_isis_policy" {
  depends_on = [
    aci_rest_managed.pod_policy_groups
  ]
  for_each   = local.policy_groups
  class_name = "fabricRsPodPGrpIsisDomP"
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rspodPGrpIsisDomP"
  content = {
    tnIsisDomPolName = "${each.value.isis_policy}"
  }
}

resource "aci_rest_managed" "pod_policy_groups_macsec_policy" {
  depends_on = [
    aci_rest_managed.pod_policy_groups
  ]
  for_each   = local.policy_groups
  class_name = "fabricRsMacsecPol"
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rsmacsecPol"
  content = {
    tnMacsecFabIfPolName = "${each.value.macsec_policy}"
  }
}

resource "aci_rest_managed" "pod_policy_groups_mgmt_policy" {
  depends_on = [
    aci_rest_managed.pod_policy_groups
  ]
  for_each   = local.policy_groups
  class_name = "fabricRsCommPol"
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rsCommPol"
  content = {
    tnCommPolName = "${each.value.management_access_policy}"
  }
}

resource "aci_rest_managed" "pod_policy_groups_snmp_policy" {
  depends_on = [
    aci_rest_managed.pod_policy_groups
  ]
  for_each   = local.policy_groups
  class_name = "fabricRsSnmpPol"
  dn         = "uni/fabric/funcprof/podpgrp-${each.key}/rssnmpPol"
  content = {
    tnSnmpPolName = "${each.value.snmp_policy}"
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
  for_each   = local.policy_groups
  class_name = "fabricPodP"
  dn         = "uni/fabric/podprof-${each.key}"
  content = {
    #annotation = "orchestrator:terraform"
    descr      = each.value.description
    name       = each.key
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
    for k, v in local.profiles : k => v if v.pod_selector_type == "ALL"
  }
  class_name = "fabricPodS"
  dn         = "uni/fabric/podprof-${each.key}/pods-${each.key}-typ-ALL"
  content = {
    #annotation = "orchestrator:terraform"
    name       = each.key
    type       = each.value.pod_selector_type
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
    for k, v in local.profiles : k => v if v.pod_selector_type == "range"
  }
  class_name = "fabricPodS"
  dn         = "uni/fabric/podprof-${each.key}/pods-${each.key}-typ-range"
  content = {
    #annotation = "orchestrator:terraform"
    name       = each.key
    type       = each.value.pod_selector_type
  }
  child {
    rn = length(
      each.value.pods
      ) > 1 ? "podblk-${element(each.value.pods, 0)}_${element(each.value.pods, 1
    )}" : "podblk-${element(each.value.pods, 0)}"
    class_name = "fabricPodBlk"
    content = {
      from_ = element(each.value.pods, 0)
      to_ = length(each.value.pods) > 1 ? element(each.value.pods, 1
      ) : element(each.value.pods, 0)
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
