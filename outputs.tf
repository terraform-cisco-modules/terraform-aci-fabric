output "pods" {
  value = {
    policy_groups = {
      for v in sort(keys(aci_rest_managed.pod_policy_groups)) : v => aci_rest_managed.pod_policy_groups[v].id
    }
    profiles = {
      for v in sort(keys(aci_rest_managed.pod_profiles)) : v => aci_rest_managed.pod_profiles[v].id
    }
  }
}
output "policies" {
  value = {
    global = {
      dns_profiles = {
        for v in sort(keys(aci_rest_managed.dns_profiles)) : v => aci_rest_managed.dns_profiles[v].id
      }
      dns_profiles_dns_domains = {
        for v in sort(keys(aci_rest_managed.dns_domains)) : v => aci_rest_managed.dns_domains[v].id
      }
      dns_profiles_dns_providers = {
        for v in sort(keys(aci_rest_managed.dns_providers)) : v => aci_rest_managed.dns_providers[v].id
      }
    }
    interface = {
      l3_interface = {
        for v in sort(keys(aci_l3_interface_policy.map)) : v => aci_l3_interface_policy.map[v].id
      }
    }
    monitoring = {
      fabric_node_controls = {
        for v in sort(keys(aci_fabric_node_control.map)) : v => aci_fabric_node_control.map[v].id
      }
    }
    pod = {
      date_and_time = {
        for v in sort(keys(aci_rest_managed.date_and_time)) : v => aci_rest_managed.date_and_time[v].id
      }
      date_and_time_format = {
        for v in sort(keys(aci_rest_managed.date_and_time_format)) : v => aci_rest_managed.date_and_time_format[v].id
      }
      date_and_time_servers = {
        for v in sort(keys(aci_rest_managed.date_and_time_ntp_servers)) : v => aci_rest_managed.date_and_time_ntp_servers[v].id
      }
      snmp_destination_groups = {
        for v in sort(keys(aci_rest_managed.snmp_destination_groups)) : v => aci_rest_managed.snmp_destination_groups[v].id
      }
      snmp_policies = {
        for v in sort(keys(aci_rest_managed.snmp_policies)) : v => aci_rest_managed.snmp_policies[v].id
      }
      snmp_policy_client_groups = {
        for v in sort(keys(aci_rest_managed.snmp_policy_client_groups)) : v => aci_rest_managed.snmp_policy_client_groups[v].id
      }
      snmp_policy_client_group_client_servers = {
        for v in sort(
          keys(aci_rest_managed.snmp_policy_client_group_client_servers)
        ) : v => aci_rest_managed.snmp_policy_client_group_client_servers[v].id
      }
      snmp_policy_trap_servers = {
        for v in sort(keys(aci_rest_managed.snmp_policy_trap_servers)) : v => aci_rest_managed.snmp_policy_trap_servers[v].id
      }
      snmp_policy_users = {
        for v in sort(keys(aci_snmp_user.map)) : v => aci_snmp_user.map[v].id
      }
    }
  }
}
