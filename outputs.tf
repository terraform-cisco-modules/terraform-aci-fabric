output "pods" {
  description = <<-EOT
    Identifiers for:
      * policy_groups: Fabric => Policy Groups: {Name}
      * recurring_window: Admin => Schedulers => Fabric => {schedule_name} => Recurring Windows.
      * remote_locations: Admin => Import/Export => Remote Locations.
      * schedulers: Admin => Schedulers => Fabric.
  EOT
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
  description = <<-EOT
    Identifiers for:
      * global:
        - dns_profiles: Fabric => Fabric Policies => Policies => Global => DNS Profiles: {Name}
          * dns_domains:  Fabric => Fabric Policies => Policies => Global => DNS Profiles: {Name} => DNS Domains
          * dns_providers:  Fabric => Fabric Policies => Policies => Global => DNS Profiles: {Name} => DNS Providers
      * interface:
        - L3 Interface:  Fabric => Fabric Policies => Policies => Interface => L3 Interface: {default}
      * monitoring:
        - fabric_node_controls:  Fabric => Fabric Policies => Policies => Monitoring => Fabric Node Controls: {default}
      * pod:
        - date_and_time: Fabric => Fabric Policies => Policies => Pod => Date and Time: {default}
          * date_and_time_servers: Fabric => Fabric Policies => Policies => Pod => Date and Time: {default} => NTP Servers
        - date_and_time_format: System Settings => Date and Time
        - snmp_destination_groups: Admin => External Data Collectors => Monitoring Destinations => SNMP => {snmp_monitoring_destination_group}
        - snmp_policies: Fabric => Fabric Policies => Policies => Pod => SNMP: {default}
          * snmp_policy_client_groups: Fabric => Fabric Policies => Policies => Pod => SNMP: {default} => Client Group Policies
            - snmp_policy_client_group_client_servers: Fabric => Fabric Policies => Policies => Pod => SNMP: {default} => Client Group Policies: Client Entries
          * snmp_policy_trap_servers: Fabric => Fabric Policies => Policies => Pod => SNMP: {default} => Trap Forward Servers
          * snmp_policy_users: Fabric => Fabric Policies => Policies => Pod => SNMP: {default} => SNMP V3 Users
  EOT
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
