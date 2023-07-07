<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform ACI - Fabric Module

A Terraform module to configure ACI Fabric Policies.

This module is part of the Cisco [*Intersight as Code*](https://cisco.com/go/intersightascode) project. Its goal is to allow users to instantiate network fabrics in minutes using an easy to use, opinionated data model. It takes away the complexity of having to deal with references, dependencies or loops. By completely separating data (defining variables) from logic (infrastructure declaration), it allows the user to focus on describing the intended configuration while using a set of maintained and tested Terraform Modules without the need to understand the low-level Intersight object model.

A comprehensive example using this module is available here: https://github.com/terraform-cisco-modules/easy-aci-complete

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.8.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.8.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_fabric"></a> [fabric](#input\_fabric) | Fabric Model data. | `any` | n/a | yes |
| <a name="input_controller_type"></a> [controller\_type](#input\_controller\_type) | The Type of Controller for this Site.<br>- apic<br>- ndo | `string` | `"apic"` | no |
| <a name="input_management_epgs"></a> [management\_epgs](#input\_management\_epgs) | The Management EPG's that will be used by the script.<br>- name: Name of the EPG<br>- type: Type of EPG<br>  * inb<br>  * oob | <pre>list(object(<br>    {<br>      name = string<br>      type = string<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "name": "default",<br>    "type": "oob"<br>  }<br>]</pre> | no |
| <a name="input_apic_certificate__1"></a> [apic\_certificate\_\_1](#input\_apic\_certificate\_\_1) | APIC Certificate 1. | `string` | `""` | no |
| <a name="input_apic_certificate_2"></a> [apic\_certificate\_2](#input\_apic\_certificate\_2) | APIC Certificate 2. | `string` | `""` | no |
| <a name="input_apic_intermediate_plus_root_ca_1"></a> [apic\_intermediate\_plus\_root\_ca\_1](#input\_apic\_intermediate\_plus\_root\_ca\_1) | Intermediate and Root CA Certificate 1. | `string` | `""` | no |
| <a name="input_apic_intermediate_plus_root_ca_2"></a> [apic\_intermediate\_plus\_root\_ca\_2](#input\_apic\_intermediate\_plus\_root\_ca\_2) | Intermediate and Root CA Certificate 2. | `string` | `""` | no |
| <a name="input_apic_private_key_1"></a> [apic\_private\_key\_1](#input\_apic\_private\_key\_1) | APIC Private Key 1. | `string` | `""` | no |
| <a name="input_apic_private_key_2"></a> [apic\_private\_key\_2](#input\_apic\_private\_key\_2) | APIC Private Key 2. | `string` | `""` | no |
| <a name="input_ntp_key_1"></a> [ntp\_key\_1](#input\_ntp\_key\_1) | Key Assigned to NTP id 1. | `string` | `""` | no |
| <a name="input_ntp_key_2"></a> [ntp\_key\_2](#input\_ntp\_key\_2) | Key Assigned to NTP id 2. | `string` | `""` | no |
| <a name="input_ntp_key_3"></a> [ntp\_key\_3](#input\_ntp\_key\_3) | Key Assigned to NTP id 3. | `string` | `""` | no |
| <a name="input_ntp_key_4"></a> [ntp\_key\_4](#input\_ntp\_key\_4) | Key Assigned to NTP id 4. | `string` | `""` | no |
| <a name="input_ntp_key_5"></a> [ntp\_key\_5](#input\_ntp\_key\_5) | Key Assigned to NTP id 5. | `string` | `""` | no |
| <a name="input_snmp_authorization_key_1"></a> [snmp\_authorization\_key\_1](#input\_snmp\_authorization\_key\_1) | SNMP Authorization Key 1. | `string` | `""` | no |
| <a name="input_snmp_authorization_key_2"></a> [snmp\_authorization\_key\_2](#input\_snmp\_authorization\_key\_2) | SNMP Authorization Key 2. | `string` | `""` | no |
| <a name="input_snmp_authorization_key_3"></a> [snmp\_authorization\_key\_3](#input\_snmp\_authorization\_key\_3) | SNMP Authorization Key 3. | `string` | `""` | no |
| <a name="input_snmp_authorization_key_4"></a> [snmp\_authorization\_key\_4](#input\_snmp\_authorization\_key\_4) | SNMP Authorization Key 4. | `string` | `""` | no |
| <a name="input_snmp_authorization_key_5"></a> [snmp\_authorization\_key\_5](#input\_snmp\_authorization\_key\_5) | SNMP Authorization Key 5. | `string` | `""` | no |
| <a name="input_snmp_community_1"></a> [snmp\_community\_1](#input\_snmp\_community\_1) | SNMP Community 1. | `string` | `""` | no |
| <a name="input_snmp_community_2"></a> [snmp\_community\_2](#input\_snmp\_community\_2) | SNMP Community 2. | `string` | `""` | no |
| <a name="input_snmp_community_3"></a> [snmp\_community\_3](#input\_snmp\_community\_3) | SNMP Community 3. | `string` | `""` | no |
| <a name="input_snmp_community_4"></a> [snmp\_community\_4](#input\_snmp\_community\_4) | SNMP Community 4. | `string` | `""` | no |
| <a name="input_snmp_community_5"></a> [snmp\_community\_5](#input\_snmp\_community\_5) | SNMP Community 5. | `string` | `""` | no |
| <a name="input_snmp_privacy_key_1"></a> [snmp\_privacy\_key\_1](#input\_snmp\_privacy\_key\_1) | SNMP Privacy Key 1. | `string` | `""` | no |
| <a name="input_snmp_privacy_key_2"></a> [snmp\_privacy\_key\_2](#input\_snmp\_privacy\_key\_2) | SNMP Privacy Key 2. | `string` | `""` | no |
| <a name="input_snmp_privacy_key_3"></a> [snmp\_privacy\_key\_3](#input\_snmp\_privacy\_key\_3) | SNMP Privacy Key 3. | `string` | `""` | no |
| <a name="input_snmp_privacy_key_4"></a> [snmp\_privacy\_key\_4](#input\_snmp\_privacy\_key\_4) | SNMP Privacy Key 4. | `string` | `""` | no |
| <a name="input_snmp_privacy_key_5"></a> [snmp\_privacy\_key\_5](#input\_snmp\_privacy\_key\_5) | SNMP Privacy Key 5. | `string` | `""` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_date_and_time"></a> [date\_and\_time](#output\_date\_and\_time) | n/a |
| <a name="output_dns_profiles"></a> [dns\_profiles](#output\_dns\_profiles) | n/a |
| <a name="output_snmp_client_groups"></a> [snmp\_client\_groups](#output\_snmp\_client\_groups) | n/a |
| <a name="output_snmp_policies"></a> [snmp\_policies](#output\_snmp\_policies) | n/a |
## Resources

| Name | Type |
|------|------|
| [aci_fabric_node_control.fabric_node_controls](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/fabric_node_control) | resource |
| [aci_l3_interface_policy.l3_interface](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/l3_interface_policy) | resource |
| [aci_rest_managed.apic_keyring](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.apic_oper_keyring](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.apic_trustpoint](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.date_and_time](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.date_and_time_format](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dns_domains](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dns_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dns_providers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.ntp_authentication_keys](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.ntp_servers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
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
| [aci_rest_managed.snmp_client_group_clients](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_client_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_destination_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_policies](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_policies_trap_servers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_policy_users](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_trap_destinations](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.snmp_trap_source](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_snmp_community.snmp_policy_communities](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/snmp_community) | resource |
<!-- END_TF_DOCS -->