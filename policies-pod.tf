/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "datetimePol"
 - Distinguished Name: "uni/fabric/time-{name}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > Date and Time > Policy {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "date_and_time" {
  for_each   = local.date_and_time
  class_name = "datetimePol"
  dn         = "uni/fabric/time-${each.key}"
  content = {
    #annotation   = "orchestrator:terraform"
    adminSt      = each.value.administrative_state
    authSt       = length(each.value.authentication_keys) > 0 ? "enabled" : "disabled"
    descr        = each.value.description
    name         = each.key
    serverState  = each.value.server_state
    StratumValue = each.value.stratum_value
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "datetimeNtpAuthKey"
 - Distinguished Name: "uni/fabric/time-{date_policy}/ntpauth-{key_id}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > Date and Time > Policy {date_policy}: Authentication Keys: {key_id}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "date_and_time_authentication_keys" {
  depends_on = [
    aci_rest_managed.date_and_time
  ]
  for_each   = local.ntp_authentication_keys
  class_name = "datetimeNtpAuthKey"
  dn         = "uni/fabric/time-${each.value.policy}/ntpauth-${each.value.key_id}"
  content = {
    id      = each.value.key_id
    key     = var.fabric_sensitive.ntp.key_id[each.value.key_id]
    keyType = each.value.authentication_type
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "datetimeNtpProv"
 - Distinguished Name: "uni/fabric/time-{date_policy}/ntpprov-{ntp_server}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > Date and Time > Policy {date_policy}: NTP Servers
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "date_and_time_ntp_servers" {
  for_each   = local.ntp_servers
  class_name = "datetimeNtpProv"
  dn         = "uni/fabric/time-${each.value.policy}/ntpprov-${each.value.hostname}"
  content = {
    descr      = each.value.description
    keyId      = each.value.key_id
    maxPoll    = each.value.maximum_polling_interval
    minPoll    = each.value.minimum_polling_interval
    name       = each.value.hostname
    preferred  = each.value.preferred == true ? "yes" : "no"
    trueChimer = "disabled"
  }
  child {
    rn         = "rsNtpProvToEpg"
    class_name = "datetimeRsNtpProvToEpg"
    content = {
      tDn = "uni/tn-mgmt/mgmtp-default/${each.value.mgmt_epg_type}-${each.value.management_epg}"
    }
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "datetimeFormat"
 - Distinguished Name: "uni/fabric/format-default"
GUI Location:
 - System Settings > Data and Time
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "date_and_time_format" {
  for_each   = { for k, v in local.date_and_time : k => v if k == "default" }
  class_name = "datetimeFormat"
  dn         = "uni/fabric/format-default"
  content = {
    #annotation    = "orchestrator:terraform"
    displayFormat = each.value.display_format
    showOffset    = each.value.offset_state
    tz            = each.value.time_zone
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpPol"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_policies" {
  for_each   = local.snmp_policies
  class_name = "snmpPol"
  dn         = "uni/fabric/snmppol-${each.key}"
  content = {
    #annotation = "orchestrator:terraform"
    adminSt = each.value.admin_state
    contact = each.value.contact
    descr   = each.value.description
    loc     = each.value.location
    name    = each.key
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpClientGrpP"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}/clgrp-{client_group}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy}: {client_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_policy_client_groups" {
  depends_on = [
    aci_rest_managed.snmp_policies
  ]
  for_each   = local.snmp_client_groups
  class_name = "snmpClientGrpP"
  dn         = "uni/fabric/snmppol-${each.value.snmp_policy}/clgrp-${each.value.name}"
  content = {
    descr = each.value.description
    name  = each.value.name
  }
  child {
    rn         = "rsepg"
    class_name = "snmpRsEpg"
    content = {
      tDn = "uni/tn-mgmt/mgmtp-default/${each.value.mgmt_epg_type}-${each.value.management_epg}"
    }
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpClientP"
 - Distinguished Name: "uni/fabric/snmppol-default/clgrp-{Mgmt_Domain}/client-[{SNMP_Client}]"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > default > Client Group Policies: {client_group} > Client Entries
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_policy_client_group_client_servers" {
  depends_on = [
    aci_rest_managed.snmp_policies,
    aci_rest_managed.snmp_policy_client_groups
  ]
  for_each   = local.snmp_client_group_clients
  class_name = "snmpClientP"
  dn         = "uni/fabric/snmppol-${each.value.snmp_policy}/clgrp-${each.value.client_group}/client-[${each.value.address}]"
  content = {
    addr = each.value.address
    name = each.value.name
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpCommunityP"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}/community-{sensitive_var}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy} > Community Policies
_______________________________________________________________________________________________________________________
*/
resource "aci_snmp_community" "snmp_policy_communities" {
  depends_on = [
    aci_rest_managed.snmp_policies
  ]
  for_each  = local.snmp_communities
  parent_dn = aci_rest_managed.snmp_policies[each.value.snmp_policy].id
  name      = var.fabric_sensitive.snmp.community[each.value.community]
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpUserP"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}/user-{snmp_user}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy}: SNMP V3 Users
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_policy_users" {
  depends_on = [
    aci_rest_managed.snmp_policies
  ]
  for_each   = local.snmp_policies_users
  class_name = "snmpUserP"
  dn         = "uni/fabric/snmppol-${each.value.snmp_policy}/user-[${each.value.username}]"
  content = {
    authKey  = var.fabric_sensitive.snmp.authorization_key[each.value.authorization_key]
    authType = each.value.authorization_type
    name     = each.value.username
    privKey = length(regexall("none", each.value.privacy_type)
    ) == 0 ? var.fabric_sensitive.snmp.privacy_key[each.value.privacy_key] : ""
    privType = each.value.privacy_type
  }
  lifecycle {
    ignore_changes = [
      content.authKey,
      content.privKey
    ]
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpGroup"
 - Distinguished Name: "uni/fabric/snmpgroup-{snmp_monitoring_destination_group}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > SNMP > {snmp_monitoring_destination_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_destination_groups" {
  for_each   = local.snmp_policies
  class_name = "snmpGroup"
  dn         = "uni/fabric/snmpgroup-${each.key}"
  content = {
    #annotation = "orchestrator:terraform"
    descr = each.value.description
    name  = each.key
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpTrapDest"
 - Distinguished Name: "uni/fabric/snmpgroup-{snmp_group}/trapdest-{host}-port-{port}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > SNMP > {snmp_monitoring_destination_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_trap_destinations" {
  depends_on = [
    aci_rest_managed.snmp_destination_groups
  ]
  for_each   = local.snmp_trap_destinations
  class_name = "snmpTrapDest"
  dn         = "uni/fabric/snmpgroup-${each.value.snmp_policy}/trapdest-${each.value.host}-port-${each.value.port}"
  content = {
    #annotation = "orchestrator:terraform"
    host = each.value.host
    port = each.value.port
    secName = length(compact([each.value.username])
      ) > 0 ? each.value.username : length(compact([var.fabric_sensitive.snmp.community[each.value.community]])
    ) > 0 ? var.fabric_sensitive.snmp.community[each.value.community] : "unknown"
    v3SecLvl = each.value.version == "v3" ? each.value.v3_security_level : "noauth"
    ver      = each.value.version
  }
  child {
    rn         = "rsARemoteHostToEpg"
    class_name = "fileRsARemoteHostToEpg"
    content = {
      tDn = "uni/tn-mgmt/mgmtp-default/${each.value.mgmt_epg_type}-${each.value.management_epg}"
    }
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpTrapFwdServerP"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}/trapfwdserver-[{Trap_Server}]"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy}: Trap Forward Servers
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_policy_trap_servers" {
  depends_on = [
    aci_rest_managed.snmp_policies
  ]
  for_each   = local.snmp_trap_destinations
  class_name = "snmpTrapFwdServerP"
  dn         = "uni/fabric/snmppol-${each.value.snmp_policy}/trapfwdserver-[${each.value.host}]"
  content = {
    #annotation = "orchestrator:terraform"
    addr = each.value.host
    port = each.value.port
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpSrc"
 - Distinguished Name: "uni/fabric/moncommon/snmpsrc-{SNMP_Source}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Monitoring > Common Policy > Callhome/Smart Callhome/SNMP/Syslog/TACACS: SNMP
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_trap_source" {
  for_each   = local.snmp_policies
  class_name = "snmpSrc"
  dn         = "uni/fabric/moncommon/snmpsrc-${each.key}"
  content = {
    #annotation = "orchestrator:terraform"
    incl = alltrue(
      [
        each.value.include_types.audit_logs,
        each.value.include_types.events,
        each.value.include_types.faults,
        each.value.include_types.session_logs
      ]
      ) ? "all,audit,events,faults,session" : anytrue(
      [
        each.value.include_types.audit_logs,
        each.value.include_types.events,
        each.value.include_types.faults,
        each.value.include_types.session_logs
      ]
      ) ? replace(trim(join(",", concat([
        length(regexall(true, each.value.include_types.audit_logs)) > 0 ? "audit" : ""], [
        length(regexall(true, each.value.include_types.events)) > 0 ? "events" : ""], [
        length(regexall(true, each.value.include_types.faults)) > 0 ? "faults" : ""], [
        length(regexall(true, each.value.include_types.session_logs)) > 0 ? "session" : ""]
    )), ","), ",,", ",") : "none"
    name = each.key
  }
  child {
    rn         = "rsdestGroup"
    class_name = "snmpRsDestGroup"
    content = {
      tDn = "uni/fabric/snmpgroup-${each.key}"
    }
  }
}
