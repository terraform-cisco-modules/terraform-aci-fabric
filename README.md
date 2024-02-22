<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform ACI - Fabric Module

A Terraform module to configure ACI Fabric Policies.

### NOTE: THIS MODULE IS DESIGNED TO BE CONSUMED USING "EASY ACI"

### A comprehensive example using this module is available below:

## [Easy ACI](https://github.com/terraform-cisco-modules/easy-aci)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.13.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | 2.13.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_fabric"></a> [fabric](#input\_fabric) | Fabric Model data. | `any` | n/a | yes |
| <a name="input_fabric_sensitive"></a> [fabric\_sensitive](#input\_fabric\_sensitive) | Note: Sensitive Variables cannot be added to a for\_each loop so these are added seperately.<br>    * mcp\_instance\_policy\_default: MisCabling Protocol Instance Settings.<br>      - key: The key or password used to uniquely identify this configuration object.<br>    * virtual\_networking: ACI to Virtual Infrastructure Integration.<br>      - password: Username/Password combination to Authenticate to the Virtual Infrastructure. | <pre>object({<br>    ntp = object({<br>      key_id = map(string)<br>    })<br>    snmp = object({<br>      authorization_key = map(string)<br>      community         = map(string)<br>      privacy_key       = map(string)<br>    })<br>  })</pre> | <pre>{<br>  "ntp": {<br>    "key_id": {}<br>  },<br>  "snmp": {<br>    "authorization_key": {},<br>    "community": {},<br>    "privacy_key": {}<br>  }<br>}</pre> | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pods"></a> [pods](#output\_pods) | Identifiers for:<br>  * policy\_groups: Fabric => Policy Groups: {Name}<br>  * recurring\_window: Admin => Schedulers => Fabric => {schedule\_name} => Recurring Windows.<br>  * remote\_locations: Admin => Import/Export => Remote Locations.<br>  * schedulers: Admin => Schedulers => Fabric. |
| <a name="output_policies"></a> [policies](#output\_policies) | Identifiers for:<br>  * global:<br>    - dns\_profiles: Fabric => Fabric Policies => Policies => Global => DNS Profiles: {Name}<br>      * dns\_domains:  Fabric => Fabric Policies => Policies => Global => DNS Profiles: {Name} => DNS Domains<br>      * dns\_providers:  Fabric => Fabric Policies => Policies => Global => DNS Profiles: {Name} => DNS Providers<br>  * interface:<br>    - L3 Interface:  Fabric => Fabric Policies => Policies => Interface => L3 Interface: {default}<br>  * monitoring:<br>    - fabric\_node\_controls:  Fabric => Fabric Policies => Policies => Monitoring => Fabric Node Controls: {default}<br>  * pod:<br>    - date\_and\_time: Fabric => Fabric Policies => Policies => Pod => Date and Time: {default}<br>      * date\_and\_time\_servers: Fabric => Fabric Policies => Policies => Pod => Date and Time: {default} => NTP Servers<br>    - date\_and\_time\_format: System Settings => Date and Time<br>    - snmp\_destination\_groups: Admin => External Data Collectors => Monitoring Destinations => SNMP => {snmp\_monitoring\_destination\_group}<br>    - snmp\_policies: Fabric => Fabric Policies => Policies => Pod => SNMP: {default}<br>      * snmp\_policy\_client\_groups: Fabric => Fabric Policies => Policies => Pod => SNMP: {default} => Client Group Policies<br>        - snmp\_policy\_client\_group\_client\_servers: Fabric => Fabric Policies => Policies => Pod => SNMP: {default} => Client Group Policies: Client Entries<br>      * snmp\_policy\_trap\_servers: Fabric => Fabric Policies => Policies => Pod => SNMP: {default} => Trap Forward Servers<br>      * snmp\_policy\_users: Fabric => Fabric Policies => Policies => Pod => SNMP: {default} => SNMP V3 Users |
## Resources

| Name | Type |
|------|------|
| [aci_fabric_node_control.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/fabric_node_control) | resource |
| [aci_l3_interface_policy.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/l3_interface_policy) | resource |
| [aci_rest_managed.date_and_time](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.date_and_time_authentication_keys](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.date_and_time_format](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.date_and_time_ntp_servers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dns_domains](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dns_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dns_providers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pod_policy_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pod_policy_groups_bgp_rr_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pod_policy_groups_coop_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pod_policy_groups_date_and_time_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pod_policy_groups_isis_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pod_policy_groups_macsec_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pod_policy_groups_mgmt_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pod_policy_groups_snmp_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pod_profile_selectors_all](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pod_profile_selectors_range](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.pod_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_destination_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_policies](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_policy_client_group_client_servers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_policy_client_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_policy_trap_servers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_trap_destinations](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_trap_source](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_snmp_community.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/snmp_community) | resource |
| [aci_snmp_user.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/snmp_user) | resource |
<!-- END_TF_DOCS -->