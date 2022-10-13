output "date_and_time" {
  value = local.date_and_time != {} ? { for v in sort(
    keys(aci_rest_managed.date_and_time)
  ) : v => aci_rest_managed.date_and_time[v].id } : {}
}

output "dns_profiles" {
  value = local.dns_profiles != {} ? { for v in sort(
    keys(aci_rest_managed.dns_profiles)
  ) : v => aci_rest_managed.dns_profiles[v].id } : {}
}

output "snmp_client_groups" {
  value = local.snmp_client_groups != {} ? { for v in sort(
    keys(aci_rest_managed.snmp_client_groups)
  ) : v => aci_rest_managed.snmp_client_groups[v].id } : {}
}

output "snmp_policies" {
  value = local.snmp_policies != {} ? { for v in sort(
    keys(aci_rest_managed.snmp_policies)
  ) : v => aci_rest_managed.snmp_policies[v].id } : {}
}
