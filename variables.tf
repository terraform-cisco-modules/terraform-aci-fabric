/*_____________________________________________________________________________________________________________________

Model Data from Top Level Module
_______________________________________________________________________________________________________________________
*/
variable "model" {
  description = "Model data."
  type        = any
}


/*_____________________________________________________________________________________________________________________

Global Shared Variables
_______________________________________________________________________________________________________________________
*/


variable "annotation" {
  default     = "orchestrator:terraform:easy-aci-v2.0"
  description = "The Version of this Script."
  type        = string
}

variable "annotations" {
  default = [
    {
      key   = "orchestrator"
      value = "terraform:easy-aci:v2.0"
    }
  ]
  description = "The Version of this Script."
  type = list(object(
    {
      key   = string
      value = string
    }
  ))
}

variable "controller_type" {
  default     = "apic"
  description = <<-EOT
    The Type of Controller for this Site.
    - apic
    - ndo
  EOT
  type        = string
}

variable "management_epgs" {
  default = [
    {
      name = "default"
      type = "oob"
    }
  ]
  description = <<-EOT
    The Management EPG's that will be used by the script.
    - name: Name of the EPG
    - type: Type of EPG
      * inb
      * oob
  EOT
  type = list(object(
    {
      name = string
      type = string
    }
  ))
}


/*_____________________________________________________________________________________________________________________

Fabric > Policies > Pod > Date and Time - Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "ntp_key_1" {
  default     = ""
  description = "Key Assigned to NTP id 1."
  sensitive   = true
  type        = string
}

variable "ntp_key_2" {
  default     = ""
  description = "Key Assigned to NTP id 2."
  sensitive   = true
  type        = string
}

variable "ntp_key_3" {
  default     = ""
  description = "Key Assigned to NTP id 3."
  sensitive   = true
  type        = string
}

variable "ntp_key_4" {
  default     = ""
  description = "Key Assigned to NTP id 4."
  sensitive   = true
  type        = string
}

variable "ntp_key_5" {
  default     = ""
  description = "Key Assigned to NTP id 5."
  sensitive   = true
  type        = string
}


/*_____________________________________________________________________________________________________________________

Fabric > Policies > Pod > SNMP  ??? Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "snmp_authorization_key_1" {
  default     = ""
  description = "SNMP Authorization Key 1."
  sensitive   = true
  type        = string
}

variable "snmp_authorization_key_2" {
  default     = ""
  description = "SNMP Authorization Key 2."
  sensitive   = true
  type        = string
}

variable "snmp_authorization_key_3" {
  default     = ""
  description = "SNMP Authorization Key 3."
  sensitive   = true
  type        = string
}

variable "snmp_authorization_key_4" {
  default     = ""
  description = "SNMP Authorization Key 4."
  sensitive   = true
  type        = string
}

variable "snmp_authorization_key_5" {
  default     = ""
  description = "SNMP Authorization Key 5."
  sensitive   = true
  type        = string
}

variable "snmp_community_1" {
  default     = ""
  description = "SNMP Community 1."
  sensitive   = true
  type        = string
}

variable "snmp_community_2" {
  default     = ""
  description = "SNMP Community 2."
  sensitive   = true
  type        = string
}

variable "snmp_community_3" {
  default     = ""
  description = "SNMP Community 3."
  sensitive   = true
  type        = string
}

variable "snmp_community_4" {
  default     = ""
  description = "SNMP Community 4."
  sensitive   = true
  type        = string
}

variable "snmp_community_5" {
  default     = ""
  description = "SNMP Community 5."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_1" {
  default     = ""
  description = "SNMP Privacy Key 1."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_2" {
  default     = ""
  description = "SNMP Privacy Key 2."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_3" {
  default     = ""
  description = "SNMP Privacy Key 3."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_4" {
  default     = ""
  description = "SNMP Privacy Key 4."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_5" {
  default     = ""
  description = "SNMP Privacy Key 5."
  sensitive   = true
  type        = string
}
