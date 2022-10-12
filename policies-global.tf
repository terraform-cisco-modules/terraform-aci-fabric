/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "dnsProfile"
 - Distinguished Name: "uni/fabric/dnsp-{name}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Global > DNS Profiles > default: Management EPG
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "dns_profiles" {
  for_each   = local.dns_profiles
  class_name = "dnsProfile"
  dn         = "uni/fabric/dnsp-${each.key}"
  content = {
    # annotation      = each.value.annotation
    descr           = each.value.description
    IPVerPreference = each.value.ip_version_preference
    name            = each.key
  }
  child {
    class_name = "dnsRsProfileToEpg"
    rn         = "rsProfileToEpg"
    content = {
      tDn = "uni/tn-mgmt/mgmtp-default/${each.value.mgmt_epg_type}-${each.value.management_epg}"
    }
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "dnsProv"
 - Distinguished Name: "uni/fabric/dnsp-{name}/prov-[{dns_provider}]"
GUI Location:
 - Fabric > Fabric Policies > Policies > Global > DNS Profiles > {name}: DNS Providers
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "dns_providers" {
  depends_on = [
    aci_rest_managed.dns_profiles
  ]
  for_each   = local.dns_providers
  class_name = "dnsProv"
  dn         = "uni/fabric/dnsp-${each.value.policy}/prov-[${each.value.dns_provider}]"
  content = {
    addr = each.value.dns_provider
    # annotation = each.value.annotation
    preferred = each.value.preferred == true ? "yes" : "no"
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "dnsDomain"
 - Distinguished Name: "uni/fabric/dnsp-{name}/dom-[{domain}]"
GUI Location:
 - Fabric > Fabric Policies > Policies > Global > DNS Profiles > {name}: DNS Domains
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "dns_domains" {
  depends_on = [
    aci_rest_managed.dns_profiles
  ]
  for_each   = local.dns_domains
  class_name = "dnsDomain"
  dn         = "uni/fabric/dnsp-${each.value.policy}/dom-[${each.value.domain}]"
  content = {
    # annotation = each.value.annotation
    descr     = each.value.description
    isDefault = each.value.default_domain == true ? "yes" : "no"
    name      = each.value.domain
  }
}
