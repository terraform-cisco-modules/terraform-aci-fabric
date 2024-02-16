locals {
  #__________________________________________________________
  #
  # Model Inputs
  #__________________________________________________________

  defaults   = yamldecode(file("${path.module}/defaults.yaml")).defaults.fabric
  dns        = local.defaults.policies.global.dns_profiles
  fnc        = local.defaults.policies.monitoring.fabric_node_controls
  global     = lookup(lookup(var.fabric, "policies", {}), "global", {})
  interface  = lookup(lookup(var.fabric, "policies", {}), "interface", {})
  l3int      = local.defaults.policies.interface.l3_interface
  mgmt_epgs  = var.fabric.global_settings.management_epgs
  monitoring = lookup(lookup(var.fabric, "policies", {}), "monitoring", {})
  lpods      = local.defaults.pods
  pod        = lookup(lookup(var.fabric, "policies", {}), "pod", {})
  pods       = lookup(var.fabric, "pods", {})
  SNMP       = local.defaults.policies.pod.snmp
  time       = local.defaults.policies.pod.date_and_time

  #__________________________________________________________
  #
  # Pods
  #__________________________________________________________

  policy_groups = {
    for v in lookup(local.pods, "policy_groups", []) : v.name => merge(local.lpods.policy_group, v)
  }

  profiles = {
    for v in lookup(local.pods, "profiles", []) : v.name => merge(local.lpods.profile, v)
  }

  #__________________________________________________________
  #
  # Policies > Global > DNS Profile
  #__________________________________________________________

  dns_profiles = {
    for v in lookup(local.global, "dns_profiles", []) : v.name => {
      description           = lookup(v, "description", local.dns.description)
      dns_domains           = lookup(v, "dns_domains", [])
      dns_providers         = lookup(v, "dns_providers", [])
      ip_version_preference = lookup(v, "ip_version_preference", local.dns.ip_version_preference)
      management_epg        = lookup(v, "management_epg", local.dns.management_epg)
      mgmt_epg_type = local.mgmt_epgs[index(local.mgmt_epgs[*].name,
        lookup(v, "management_epg", local.dns.management_epg))
      ].type
    }
  }

  dns_domains = {
    for i in flatten([
      for key, value in local.dns_profiles : [
        for v in value.dns_domains : {
          domain         = v.domain
          default_domain = lookup(v, "default_domain", local.dns.dns_domains.default_domain)
          description    = lookup(v, "description", local.dns.dns_domains.description)
          policy         = key
        }
      ]
    ]) : "${i.policy}/${i.domain}" => i
  }

  dns_providers = {
    for i in flatten([
      for key, value in local.dns_profiles : [
        for v in value.dns_providers : {
          description  = lookup(v, "description", local.dns.dns_providers.description)
          dns_provider = v.dns_provider
          preferred    = lookup(v, "preferred", local.dns.dns_providers.preferred)
          policy       = key
        }
      ]
    ]) : "${i.policy}/${i.dns_provider}" => i
  }


  #__________________________________________________________
  #
  # Policies > Pod > Date and Time
  #__________________________________________________________

  date_and_time = {
    for v in lookup(local.pod, "date_and_time", []) : v.name => merge(local.time, v, {
      authentication_keys = lookup(v, "authentication_keys", [])
      mgmt_epg_type = local.mgmt_epgs[index(local.mgmt_epgs[*].name,
        lookup(v, "management_epg", local.time.management_epg))
      ].type
      ntp_servers = lookup(v, "ntp_servers", [])
      time_zone = length(regexall(
        "Africa/Abidjan", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-Abidjan" : length(regexall(
        "Africa/Accra", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-Accra" : length(regexall(
        "Africa/Addis_Ababa", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Africa-Addis_Ababa" : length(regexall(
        "Africa/Algiers", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Algiers" : length(regexall(
        "Africa/Asmara", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Africa-Asmara" : length(regexall(
        "Africa/Bamako", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-Bamako" : length(regexall(
        "Africa/Bangui", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Bangui" : length(regexall(
        "Africa/Banjul", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-Banjul" : length(regexall(
        "Africa/Bissau", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-Bissau" : length(regexall(
        "Africa/Blantyre", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Blantyre" : length(regexall(
        "Africa/Brazzaville", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Brazzaville" : length(regexall(
        "Africa/Bujumbura", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Bujumbura" : length(regexall(
        "Africa/Cairo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Cairo" : length(regexall(
        "Africa/Casablanca", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Casablanca" : length(regexall(
        "Africa/Ceuta", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Ceuta" : length(regexall(
        "Africa/Conakry", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-Conakry" : length(regexall(
        "Africa/Dakar", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-Dakar" : length(regexall(
        "Africa/Dar_es_Salaam", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Africa-Dar_es_Salaam" : length(regexall(
        "Africa/Djibouti", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Africa-Djibouti" : length(regexall(
        "Africa/Douala", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Douala" : length(regexall(
        "Africa/El_Aaiun", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-El_Aaiun" : length(regexall(
        "Africa/Freetown", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-Freetown" : length(regexall(
        "Africa/Gaborone", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Gaborone" : length(regexall(
        "Africa/Harare", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Harare" : length(regexall(
        "Africa/Johannesburg", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Johannesburg" : length(regexall(
        "Africa/Juba", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Africa-Juba" : length(regexall(
        "Africa/Kampala", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Africa-Kampala" : length(regexall(
        "Africa/Khartoum", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Africa-Khartoum" : length(regexall(
        "Africa/Kigali", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Kigali" : length(regexall(
        "Africa/Kinshasa", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Kinshasa" : length(regexall(
        "Africa/Lagos", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Lagos" : length(regexall(
        "Africa/Libreville", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Libreville" : length(regexall(
        "Africa/Lome", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-Lome" : length(regexall(
        "Africa/Luanda", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Luanda" : length(regexall(
        "Africa/Lubumbashi", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Lubumbashi" : length(regexall(
        "Africa/Lusaka", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Lusaka" : length(regexall(
        "Africa/Malabo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Malabo" : length(regexall(
        "Africa/Maputo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Maputo" : length(regexall(
        "Africa/Maseru", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Maseru" : length(regexall(
        "Africa/Mbabane", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Mbabane" : length(regexall(
        "Africa/Mogadishu", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Africa-Mogadishu" : length(regexall(
        "Africa/Monrovia", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-Monrovia" : length(regexall(
        "Africa/Nairobi", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Africa-Nairobi" : length(regexall(
        "Africa/Ndjamena", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Ndjamena" : length(regexall(
        "Africa/Niamey", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Niamey" : length(regexall(
        "Africa/Nouakchott", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-Nouakchott" : length(regexall(
        "Africa/Ouagadougou", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-Ouagadougou" : length(regexall(
        "Africa/Porto-Novo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Porto_Novo" : length(regexall(
        "Africa/Sao_Tome", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Africa-Sao_Tome" : length(regexall(
        "Africa/Tripoli", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Tripoli" : length(regexall(
        "Africa/Tunis", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Africa-Tunis" : length(regexall(
        "Africa/Windhoek", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Africa-Windhoek" : length(regexall(
        "America/Adak", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n540_America-Adak" : length(regexall(
        "America/Anchorage", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n480_America-Anchorage" : length(regexall(
        "America/Anguilla", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Anguilla" : length(regexall(
        "America/Antigua", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Antigua" : length(regexall(
        "America/Araguaina", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Araguaina" : length(regexall(
        "America/Argentina/Buenos_Aires", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Argentina-Buenos_Aires" : length(regexall(
        "America/Argentina/Catamarca", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Argentina-Catamarca" : length(regexall(
        "America/Argentina/Cordoba", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Argentina-Cordoba" : length(regexall(
        "America/Argentina/Jujuy", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Argentina-Jujuy" : length(regexall(
        "America/Argentina/La_Rioja", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Argentina-La_Rioja" : length(regexall(
        "America/Argentina/Mendoza", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Argentina-Mendoza" : length(regexall(
        "America/Argentina/Rio_Gallegos", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Argentina-Rio_Gallegos" : length(regexall(
        "America/Argentina/Salta", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Argentina-Salta" : length(regexall(
        "America/Argentina/San_Juan", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Argentina-San_Juan" : length(regexall(
        "America/Argentina/San_Luis", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Argentina-San_Luis" : length(regexall(
        "America/Argentina/Tucuman", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Argentina-Tucuman" : length(regexall(
        "America/Argentina/Ushuaia", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Argentina-Ushuaia" : length(regexall(
        "America/Aruba", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Aruba" : length(regexall(
        "America/Asuncion", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Asuncion" : length(regexall(
        "America/Atikokan", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Atikokan" : length(regexall(
        "America/Bahia_Banderas", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Bahia_Banderas" : length(regexall(
        "America/Barbados", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Barbados" : length(regexall(
        "America/Belem", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Belem" : length(regexall(
        "America/Belize", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Belize" : length(regexall(
        "America/Blanc-Sablon", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Blanc_Sablon" : length(regexall(
        "America/Boa_Vista", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Boa_Vista" : length(regexall(
        "America/Bogota", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Bogota" : length(regexall(
        "America/Boise", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Boise" : length(regexall(
        "America/Cambridge_Bay", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Cambridge_Bay" : length(regexall(
        "America/Campo_Grande", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Campo_Grande" : length(regexall(
        "America/Cancun", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Cancun" : length(regexall(
        "America/Caracas", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n270_America-Caracas" : length(regexall(
        "America/Cayenne", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Cayenne" : length(regexall(
        "America/Cayman", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Cayman" : length(regexall(
        "America/Chicago", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Chicago" : length(regexall(
        "America/Chihuahua", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Chihuahua" : length(regexall(
        "America/Costa_Rica", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Costa_Rica" : length(regexall(
        "America/Creston", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n420_America-Creston" : length(regexall(
        "America/Cuiaba", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Cuiaba" : length(regexall(
        "America/Curacao", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Curacao" : length(regexall(
        "America/Danmarkshavn", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_America-Danmarkshavn" : length(regexall(
        "America/Dawson", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n420_America-Dawson" : length(regexall(
        "America/Dawson_Creek", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n420_America-Dawson_Creek" : length(regexall(
        "America/Denver", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Denver" : length(regexall(
        "America/Detroit", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Detroit" : length(regexall(
        "America/Dominica", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Dominica" : length(regexall(
        "America/Edmonton", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Edmonton" : length(regexall(
        "America/Eirunepe", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Eirunepe" : length(regexall(
        "America/El_Salvador", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-El_Salvador" : length(regexall(
        "America/Fortaleza", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Fortaleza" : length(regexall(
        "America/Glace_Bay", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Glace_Bay" : length(regexall(
        "America/Godthab", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n120_America-Godthab" : length(regexall(
        "America/Goose_Bay", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Goose_Bay" : length(regexall(
        "America/Grand_Turk", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Grand_Turk" : length(regexall(
        "America/Grenada", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Grenada" : length(regexall(
        "America/Guadeloupe", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Guadeloupe" : length(regexall(
        "America/Guatemala", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Guatemala" : length(regexall(
        "America/Guayaquil", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Guayaquil" : length(regexall(
        "America/Guyana", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Guyana" : length(regexall(
        "America/Halifax", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Halifax" : length(regexall(
        "America/Havana", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Havana" : length(regexall(
        "America/Hermosillo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n420_America-Hermosillo" : length(regexall(
        "America/Indiana/Indianapolis", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Indiana-Indianapolis" : length(regexall(
        "America/Indiana/Knox", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Indiana-Knox" : length(regexall(
        "America/Indiana/Marengo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Indiana-Marengo" : length(regexall(
        "America/Indiana/Petersburg", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Indiana-Petersburg" : length(regexall(
        "America/Indiana/Tell_City", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Indiana-Tell_City" : length(regexall(
        "America/Indiana/Vevay", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Indiana-Vevay" : length(regexall(
        "America/Indiana/Vincennes", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Indiana-Vincennes" : length(regexall(
        "America/Indiana/Winamac", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Indiana-Winamac" : length(regexall(
        "America/Inuvik", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Inuvik" : length(regexall(
        "America/Iqaluit", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Iqaluit" : length(regexall(
        "America/Jamaica", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Jamaica" : length(regexall(
        "America/Juneau", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n480_America-Juneau" : length(regexall(
        "America/Kentucky/Louisville", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Kentucky-Louisville" : length(regexall(
        "America/Kentucky/Monticello", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Kentucky-Monticello" : length(regexall(
        "America/Kralendijk", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Kralendijk" : length(regexall(
        "America/La_Paz", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-La_Paz" : length(regexall(
        "America/Lima", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Lima" : length(regexall(
        "America/Los_Angeles", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n420_America-Los_Angeles" : length(regexall(
        "America/Lower_Princes", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Lower_Princes" : length(regexall(
        "America/Maceio", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Maceio" : length(regexall(
        "America/Managua", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Managua" : length(regexall(
        "America/Manaus", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Manaus" : length(regexall(
        "America/Marigot", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Marigot" : length(regexall(
        "America/Martinique", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Martinique" : length(regexall(
        "America/Matamoros", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Matamoros" : length(regexall(
        "America/Mazatlan", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Mazatlan" : length(regexall(
        "America/Menominee", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Menominee" : length(regexall(
        "America/Merida", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Merida" : length(regexall(
        "America/Metlakatla", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n480_America-Metlakatla" : length(regexall(
        "America/Mexico_City", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Mexico_City" : length(regexall(
        "America/Miquelon", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n120_America-Miquelon" : length(regexall(
        "America/Moncton", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Moncton" : length(regexall(
        "America/Monterrey", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Monterrey" : length(regexall(
        "America/Montevideo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n120_America-Montevideo" : length(regexall(
        "America/Montreal", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Montreal" : length(regexall(
        "America/Montserrat", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Montserrat" : length(regexall(
        "America/Nassau", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Nassau" : length(regexall(
        "America/New_York", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-New_York" : length(regexall(
        "America/Nipigon", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Nipigon" : length(regexall(
        "America/Nome", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n480_America-Nome" : length(regexall(
        "America/Noronha", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n120_America-Noronha" : length(regexall(
        "America/North_Dakota/Beulah", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-North_Dakota-Beulah" : length(regexall(
        "America/North_Dakota/Center", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-North_Dakota-Center" : length(regexall(
        "America/North_Dakota/New_Salem", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-North_Dakota-New_Salem" : length(regexall(
        "America/Ojinaga", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Ojinaga" : length(regexall(
        "America/Panama", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Panama" : length(regexall(
        "America/Pangnirtung", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Pangnirtung" : length(regexall(
        "America/Paramaribo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Paramaribo" : length(regexall(
        "America/Phoenix", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n420_America-Phoenix" : length(regexall(
        "America/Port-au-Prince", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Port_au_Prince" : length(regexall(
        "America/Port_of_Spain", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Port_of_Spain" : length(regexall(
        "America/Porto_Velho", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Porto_Velho" : length(regexall(
        "America/Puerto_Rico", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Puerto_Rico" : length(regexall(
        "America/Rainy_River", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Rainy_River" : length(regexall(
        "America/Rankin_Inlet", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Rankin_Inlet" : length(regexall(
        "America/Recife", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Recife" : length(regexall(
        "America/Regina", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Regina" : length(regexall(
        "America/Resolute", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Resolute" : length(regexall(
        "America/Rio_Branco", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Rio_Branco" : length(regexall(
        "America/Santa_Isabel", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n420_America-Santa_Isabel" : length(regexall(
        "America/Santarem", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Santarem" : length(regexall(
        "America/Santiago", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Santiago" : length(regexall(
        "America/Santo_Domingo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Santo_Domingo" : length(regexall(
        "America/Sao_Paulo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n120_America-Sao_Paulo" : length(regexall(
        "America/Scoresbysund", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_America-Scoresbysund" : length(regexall(
        "America/Shiprock", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Shiprock" : length(regexall(
        "America/Sitka", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n480_America-Sitka" : length(regexall(
        "America/St_Barthelemy", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-St_Barthelemy" : length(regexall(
        "America/St_Johns", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n150_America-St_Johns" : length(regexall(
        "America/St_Kitts", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-St_Kitts" : length(regexall(
        "America/St_Lucia", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-St_Lucia" : length(regexall(
        "America/St_Thomas", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-St_Thomas" : length(regexall(
        "America/St_Vincent", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-St_Vincent" : length(regexall(
        "America/Swift_Current", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Swift_Current" : length(regexall(
        "America/Tegucigalpa", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Tegucigalpa" : length(regexall(
        "America/Thule", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_America-Thule" : length(regexall(
        "America/Thunder_Bay", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Thunder_Bay" : length(regexall(
        "America/Tijuana", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n420_America-Tijuana" : length(regexall(
        "America/Toronto", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Toronto" : length(regexall(
        "America/Tortola", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n240_America-Tortola" : length(regexall(
        "America/Vancouver", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n420_America-Vancouver" : length(regexall(
        "America/Whitehorse", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n420_America-Whitehorse" : length(regexall(
        "America/Winnipeg", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_America-Winnipeg" : length(regexall(
        "America/Yakutat", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n480_America-Yakutat" : length(regexall(
        "America/Yellowknife", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_America-Yellowknife" : length(regexall(
        "Antarctica/Casey", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Antarctica-Casey" : length(regexall(
        "Antarctica/Davis", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p420_Antarctica-Davis" : length(regexall(
        "Antarctica/DumontDUrville", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p600_Antarctica-DumontDUrville" : length(regexall(
        "Antarctica/Macquarie", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p660_Antarctica-Macquarie" : length(regexall(
        "Antarctica/Mawson", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p300_Antarctica-Mawson" : length(regexall(
        "Antarctica/McMurdo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p780_Antarctica-McMurdo" : length(regexall(
        "Antarctica/Palmer", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_Antarctica-Palmer" : length(regexall(
        "Antarctica/Rothera", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_Antarctica-Rothera" : length(regexall(
        "Antarctica/South_Pole", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p780_Antarctica-South_Pole" : length(regexall(
        "Antarctica/Syowa", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Antarctica-Syowa" : length(regexall(
        "Antarctica/Vostok", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p360_Antarctica-Vostok" : length(regexall(
        "Arctic/Longyearbyen", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Arctic-Longyearbyen" : length(regexall(
        "Asia/Aden", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Asia-Aden" : length(regexall(
        "Asia/Almaty", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p360_Asia-Almaty" : length(regexall(
        "Asia/Amman", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Asia-Amman" : length(regexall(
        "Asia/Anadyr", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p720_Asia-Anadyr" : length(regexall(
        "Asia/Aqtau", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p300_Asia-Aqtau" : length(regexall(
        "Asia/Aqtobe", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p300_Asia-Aqtobe" : length(regexall(
        "Asia/Ashgabat", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p300_Asia-Ashgabat" : length(regexall(
        "Asia/Baghdad", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Asia-Baghdad" : length(regexall(
        "Asia/Bahrain", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Asia-Bahrain" : length(regexall(
        "Asia/Baku", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p300_Asia-Baku" : length(regexall(
        "Asia/Bangkok", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p420_Asia-Bangkok" : length(regexall(
        "Asia/Beirut", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Asia-Beirut" : length(regexall(
        "Asia/Bishkek", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p360_Asia-Bishkek" : length(regexall(
        "Asia/Brunei", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Brunei" : length(regexall(
        "Asia/Choibalsan", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Choibalsan" : length(regexall(
        "Asia/Chongqing", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Chongqing" : length(regexall(
        "Asia/Colombo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p330_Asia-Colombo" : length(regexall(
        "Asia/Damascus", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Asia-Damascus" : length(regexall(
        "Asia/Dhaka", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p360_Asia-Dhaka" : length(regexall(
        "Asia/Dili", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p540_Asia-Dili" : length(regexall(
        "Asia/Dubai", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p240_Asia-Dubai" : length(regexall(
        "Asia/Dushanbe", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p300_Asia-Dushanbe" : length(regexall(
        "Asia/Gaza", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Asia-Gaza" : length(regexall(
        "Asia/Harbin", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Harbin" : length(regexall(
        "Asia/Hebron", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Asia-Hebron" : length(regexall(
        "Asia/Ho_Chi_Minh", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p420_Asia-Ho_Chi_Minh" : length(regexall(
        "Asia/Hong_Kong", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Hong_Kong" : length(regexall(
        "Asia/Hovd", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p420_Asia-Hovd" : length(regexall(
        "Asia/Irkutsk", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p540_Asia-Irkutsk" : length(regexall(
        "Asia/Jakarta", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p420_Asia-Jakarta" : length(regexall(
        "Asia/Jayapura", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p540_Asia-Jayapura" : length(regexall(
        "Asia/Jerusalem", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Asia-Jerusalem" : length(regexall(
        "Asia/Kabul", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p270_Asia-Kabul" : length(regexall(
        "Asia/Kamchatka", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p720_Asia-Kamchatka" : length(regexall(
        "Asia/Karachi", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p300_Asia-Karachi" : length(regexall(
        "Asia/Kashgar", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Kashgar" : length(regexall(
        "Asia/Kathmandu", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p345_Asia-Kathmandu" : length(regexall(
        "Asia/Kolkata", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p330_Asia-Kolkata" : length(regexall(
        "Asia/Krasnoyarsk", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Krasnoyarsk" : length(regexall(
        "Asia/Kuala_Lumpur", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Kuala_Lumpur" : length(regexall(
        "Asia/Kuching", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Kuching" : length(regexall(
        "Asia/Kuwait", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Asia-Kuwait" : length(regexall(
        "Asia/Macau", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Macau" : length(regexall(
        "Asia/Magadan", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p720_Asia-Magadan" : length(regexall(
        "Asia/Makassar", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Makassar" : length(regexall(
        "Asia/Manila", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Manila" : length(regexall(
        "Asia/Muscat", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p240_Asia-Muscat" : length(regexall(
        "Asia/Nicosia", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Asia-Nicosia" : length(regexall(
        "Asia/Novokuznetsk", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p420_Asia-Novokuznetsk" : length(regexall(
        "Asia/Novosibirsk", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p420_Asia-Novosibirsk" : length(regexall(
        "Asia/Omsk", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p420_Asia-Omsk" : length(regexall(
        "Asia/Oral", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p300_Asia-Oral" : length(regexall(
        "Asia/Phnom_Penh", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p420_Asia-Phnom_Penh" : length(regexall(
        "Asia/Pontianak", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p420_Asia-Pontianak" : length(regexall(
        "Asia/Pyongyang", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p540_Asia-Pyongyang" : length(regexall(
        "Asia/Qatar", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Asia-Qatar" : length(regexall(
        "Asia/Qyzylorda", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p360_Asia-Qyzylorda" : length(regexall(
        "Asia/Rangoon", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p390_Asia-Rangoon" : length(regexall(
        "Asia/Riyadh", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Asia-Riyadh" : length(regexall(
        "Asia/Sakhalin", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p660_Asia-Sakhalin" : length(regexall(
        "Asia/Samarkand", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p300_Asia-Samarkand" : length(regexall(
        "Asia/Seoul", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p540_Asia-Seoul" : length(regexall(
        "Asia/Shanghai", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Shanghai" : length(regexall(
        "Asia/Singapore", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Singapore" : length(regexall(
        "Asia/Taipei", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Taipei" : length(regexall(
        "Asia/Tashkent", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p300_Asia-Tashkent" : length(regexall(
        "Asia/Tbilisi", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p240_Asia-Tbilisi" : length(regexall(
        "Asia/Tehran", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p270_Asia-Tehran" : length(regexall(
        "Asia/Thimphu", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p360_Asia-Thimphu" : length(regexall(
        "Asia/Tokyo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p540_Asia-Tokyo" : length(regexall(
        "Asia/Ulaanbaatar", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Ulaanbaatar" : length(regexall(
        "Asia/Urumqi", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Asia-Urumqi" : length(regexall(
        "Asia/Vientiane", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p420_Asia-Vientiane" : length(regexall(
        "Asia/Vladivostok", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p660_Asia-Vladivostok" : length(regexall(
        "Asia/Yakutsk", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p600_Asia-Yakutsk" : length(regexall(
        "Asia/Yekaterinburg", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p360_Asia-Yekaterinburg" : length(regexall(
        "Asia/Yerevan", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p240_Asia-Yerevan" : length(regexall(
        "Atlantic/Azores", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Atlantic-Azores" : length(regexall(
        "Atlantic/Bermuda", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_Atlantic-Bermuda" : length(regexall(
        "Atlantic/Canary", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Atlantic-Canary" : length(regexall(
        "Atlantic/Cape_Verde", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n60_Atlantic-Cape_Verde" : length(regexall(
        "Atlantic/Faroe", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Atlantic-Faroe" : length(regexall(
        "Atlantic/Madeira", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Atlantic-Madeira" : length(regexall(
        "Atlantic/Reykjavik", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Atlantic-Reykjavik" : length(regexall(
        "Atlantic/South_Georgia", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n120_Atlantic-South_Georgia" : length(regexall(
        "Atlantic/St_Helena", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_Atlantic-St_Helena" : length(regexall(
        "Atlantic/Stanley", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n180_Atlantic-Stanley" : length(regexall(
        "Australia/Adelaide", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p630_Australia-Adelaide" : length(regexall(
        "Australia/Brisbane", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p600_Australia-Brisbane" : length(regexall(
        "Australia/Broken_Hill", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p630_Australia-Broken_Hill" : length(regexall(
        "Australia/Currie", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p660_Australia-Currie" : length(regexall(
        "Australia/Darwin", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p570_Australia-Darwin" : length(regexall(
        "Australia/Eucla", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p525_Australia-Eucla" : length(regexall(
        "Australia/Hobart", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p660_Australia-Hobart" : length(regexall(
        "Australia/Lindeman", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p600_Australia-Lindeman" : length(regexall(
        "Australia/Lord_Howe", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p660_Australia-Lord_Howe" : length(regexall(
        "Australia/Melbourne", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p660_Australia-Melbourne" : length(regexall(
        "Australia/Perth", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p480_Australia-Perth" : length(regexall(
        "Australia/Sydney", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p660_Australia-Sydney" : length(regexall(
        "Coordinated Universal Time", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_UTC" : length(regexall(
        "Europe/Amsterdam", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Amsterdam" : length(regexall(
        "Europe/Andorra", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Andorra" : length(regexall(
        "Europe/Athens", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Athens" : length(regexall(
        "Europe/Belgrade", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Belgrade" : length(regexall(
        "Europe/Berlin", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Berlin" : length(regexall(
        "Europe/Bratislava", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Bratislava" : length(regexall(
        "Europe/Brussels", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Brussels" : length(regexall(
        "Europe/Bucharest", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Bucharest" : length(regexall(
        "Europe/Budapest", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Budapest" : length(regexall(
        "Europe/Chisinau", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Chisinau" : length(regexall(
        "Europe/Copenhagen", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Copenhagen" : length(regexall(
        "Europe/Dublin", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Europe-Dublin" : length(regexall(
        "Europe/Gibraltar", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Gibraltar" : length(regexall(
        "Europe/Guernsey", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Europe-Guernsey" : length(regexall(
        "Europe/Helsinki", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Helsinki" : length(regexall(
        "Europe/Isle_of_Man", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Europe-Isle_of_Man" : length(regexall(
        "Europe/Istanbul", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Istanbul" : length(regexall(
        "Europe/Jersey", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Europe-Jersey" : length(regexall(
        "Europe/Kaliningrad", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Kaliningrad" : length(regexall(
        "Europe/Kiev", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Kiev" : length(regexall(
        "Europe/Lisbon", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Europe-Lisbon" : length(regexall(
        "Europe/Ljubljana", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Ljubljana" : length(regexall(
        "Europe/London", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p60_Europe-London" : length(regexall(
        "Europe/Luxembourg", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Luxembourg" : length(regexall(
        "Europe/Madrid", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Madrid" : length(regexall(
        "Europe/Malta", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Malta" : length(regexall(
        "Europe/Mariehamn", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Mariehamn" : length(regexall(
        "Europe/Minsk", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Minsk" : length(regexall(
        "Europe/Monaco", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Monaco" : length(regexall(
        "Europe/Moscow", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p240_Europe-Moscow" : length(regexall(
        "Europe/Oslo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Oslo" : length(regexall(
        "Europe/Paris", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Paris" : length(regexall(
        "Europe/Podgorica", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Podgorica" : length(regexall(
        "Europe/Prague", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Prague" : length(regexall(
        "Europe/Riga", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Riga" : length(regexall(
        "Europe/Rome", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Rome" : length(regexall(
        "Europe/Samara", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p240_Europe-Samara" : length(regexall(
        "Europe/San_Marino", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-San_Marino" : length(regexall(
        "Europe/Sarajevo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Sarajevo" : length(regexall(
        "Europe/Simferopol", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Simferopol" : length(regexall(
        "Europe/Skopje", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Skopje" : length(regexall(
        "Europe/Sofia", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Sofia" : length(regexall(
        "Europe/Stockholm", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Stockholm" : length(regexall(
        "Europe/Tallinn", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Tallinn" : length(regexall(
        "Europe/Tirane", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Tirane" : length(regexall(
        "Europe/Uzhgorod", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Uzhgorod" : length(regexall(
        "Europe/Vaduz", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Vaduz" : length(regexall(
        "Europe/Vatican", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Vatican" : length(regexall(
        "Europe/Vienna", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Vienna" : length(regexall(
        "Europe/Vilnius", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Vilnius" : length(regexall(
        "Europe/Volgograd", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p240_Europe-Volgograd" : length(regexall(
        "Europe/Warsaw", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Warsaw" : length(regexall(
        "Europe/Zagreb", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Zagreb" : length(regexall(
        "Europe/Zaporozhye", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Europe-Zaporozhye" : length(regexall(
        "Europe/Zurich", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p120_Europe-Zurich" : length(regexall(
        "Indian/Antananarivo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Indian-Antananarivo" : length(regexall(
        "Indian/Chagos", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p360_Indian-Chagos" : length(regexall(
        "Indian/Christmas", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p420_Indian-Christmas" : length(regexall(
        "Indian/Cocos", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p390_Indian-Cocos" : length(regexall(
        "Indian/Comoro", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Indian-Comoro" : length(regexall(
        "Indian/Kerguelen", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p300_Indian-Kerguelen" : length(regexall(
        "Indian/Mahe", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p240_Indian-Mahe" : length(regexall(
        "Indian/Maldives", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p300_Indian-Maldives" : length(regexall(
        "Indian/Mauritius", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p240_Indian-Mauritius" : length(regexall(
        "Indian/Mayotte", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p180_Indian-Mayotte" : length(regexall(
        "Indian/Reunion", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p240_Indian-Reunion" : length(regexall(
        "Pacific/Apia", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p840_Pacific-Apia" : length(regexall(
        "Pacific/Auckland", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p780_Pacific-Auckland" : length(regexall(
        "Pacific/Chatham", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p825_Pacific-Chatham" : length(regexall(
        "Pacific/Chuuk", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p600_Pacific-Chuuk" : length(regexall(
        "Pacific/Easter", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n300_Pacific-Easter" : length(regexall(
        "Pacific/Efate", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p660_Pacific-Efate" : length(regexall(
        "Pacific/Enderbury", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p780_Pacific-Enderbury" : length(regexall(
        "Pacific/Fakaofo", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p780_Pacific-Fakaofo" : length(regexall(
        "Pacific/Fiji", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p780_Pacific-Fiji" : length(regexall(
        "Pacific/Funafuti", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p720_Pacific-Funafuti" : length(regexall(
        "Pacific/Galapagos", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n360_Pacific-Galapagos" : length(regexall(
        "Pacific/Gambier", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n540_Pacific-Gambier" : length(regexall(
        "Pacific/Guadalcanal", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p660_Pacific-Guadalcanal" : length(regexall(
        "Pacific/Guam", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p600_Pacific-Guam" : length(regexall(
        "Pacific/Honolulu", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n600_Pacific-Honolulu" : length(regexall(
        "Pacific/Johnston", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n600_Pacific-Johnston" : length(regexall(
        "Pacific/Kiritimati", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p840_Pacific-Kiritimati" : length(regexall(
        "Pacific/Kosrae", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p660_Pacific-Kosrae" : length(regexall(
        "Pacific/Kwajalein", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p720_Pacific-Kwajalein" : length(regexall(
        "Pacific/Majuro", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p720_Pacific-Majuro" : length(regexall(
        "Pacific/Marquesas", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n570_Pacific-Marquesas" : length(regexall(
        "Pacific/Midway", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n660_Pacific-Midway" : length(regexall(
        "Pacific/Nauru", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p720_Pacific-Nauru" : length(regexall(
        "Pacific/Niue", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n660_Pacific-Niue" : length(regexall(
        "Pacific/Norfolk", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p690_Pacific-Norfolk" : length(regexall(
        "Pacific/Noumea", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p660_Pacific-Noumea" : length(regexall(
        "Pacific/Pago_Pago", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n660_Pacific-Pago_Pago" : length(regexall(
        "Pacific/Palau", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p540_Pacific-Palau" : length(regexall(
        "Pacific/Pitcairn", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n480_Pacific-Pitcairn" : length(regexall(
        "Pacific/Pohnpei", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p660_Pacific-Pohnpei" : length(regexall(
        "Pacific/Port_Moresby", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p600_Pacific-Port_Moresby" : length(regexall(
        "Pacific/Rarotonga", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n600_Pacific-Rarotonga" : length(regexall(
        "Pacific/Saipan", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p600_Pacific-Saipan" : length(regexall(
        "Pacific/Tahiti", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "n600_Pacific-Tahiti" : length(regexall(
        "Pacific/Tarawa", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p720_Pacific-Tarawa" : length(regexall(
        "Pacific/Tongatapu", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p780_Pacific-Tongatapu" : length(regexall(
        "Pacific/Wake", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p720_Pacific-Wake" : length(regexall(
        "Pacific/Wallis", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p720_Pacific-Wallis" : length(regexall(
      "UTC", lookup(v, "time_zone", local.time.time_zone))) > 0 ? "p0_UTC" : "p0_UTC"
    })
  }

  ntp_authentication_keys = {
    for i in flatten([
      for key, value in local.date_and_time : [
        for v in value.authentication_keys : {
          authentication_type = lookup(
            v, "authentication_type", local.time.authentication_keys.authentication_type
          )
          key_id  = v.key_id
          policy  = key
          trusted = lookup(v, "trusted", local.time.authentication_keys.trusted)
        }
      ]
    ]) : "${i.policy}/${i.key_id}" => i
  }

  ntp_servers = {
    for i in flatten([
      for k, v in local.date_and_time : [
        for s in lookup(v, "ntp_servers", []) : {
          description    = lookup(v, "description", local.time.description)
          hostname       = s.hostname
          policy         = k
          key_id         = lookup(s, "key_id", local.time.ntp_servers.key_id)
          management_epg = v.management_epg
          mgmt_epg_type  = v.mgmt_epg_type
          maximum_polling_interval = lookup(
            v, "maximum_polling_interval", local.time.maximum_polling_interval
          )
          minimum_polling_interval = lookup(
            v, "minimum_polling_interval", local.time.minimum_polling_interval
          )
          preferred = lookup(s, "preferred", local.time.ntp_servers.preferred)
        }
      ]
    ]) : "${i.policy}/${i.hostname}" => i
  }


  #__________________________________________________________
  #
  # Policies > Interface > L3 Interface
  #__________________________________________________________

  l3_interface = [
    for v in [lookup(local.interface, "l3_interface", {})] : merge(local.l3int, v)
  ]

  #__________________________________________________________
  #
  # Policies > Monitoring > Fabric Node Controls
  #__________________________________________________________

  fabric_node_controls = [
    for v in [lookup(local.monitoring, "fabric_node_controls", {})] : merge(local.fnc, v)
  ]

  #__________________________________________________________
  #
  # Policies > Pod > SNMP Policy
  #__________________________________________________________

  snmp_policies = {
    for v in lookup(local.pod, "snmp", []) : v.name => merge(local.SNMP, v, {
      include_types      = merge(local.SNMP.include_types, lookup(v, "include_types", {}))
      snmp_client_groups = lookup(v, "snmp_client_groups", [])
      snmp_communities   = lookup(v, "snmp_communities", [])
      snmp_destinations  = lookup(v, "snmp_destinations", [])
      users              = lookup(v, "users", [])
    })
  }

  snmp_client_groups = { for i in flatten([
    for key, value in local.snmp_policies : [
      for k, v in value.snmp_client_groups : merge(local.SNMP.snmp_client_groups, v, {
        clients = lookup(v, "clients", [])
        mgmt_epg_type = local.mgmt_epgs[index(local.mgmt_epgs[*].name,
          lookup(v, "management_epg", local.SNMP.snmp_client_groups.management_epg))
        ].type
        snmp_policy = key
      })
    ]
  ]) : "${i.snmp_policy}/${i.name}" => i }

  snmp_client_group_clients = { for i in flatten([
    for key, value in local.snmp_client_groups : [
      for v in value.clients : {
        address      = v.address
        name         = lookup(v, "name", v.address)
        snmp_policy  = value.snmp_policy
        client_group = value.name
      }
    ]
  ]) : "${i.snmp_policy}/${i.client_group}/${i.address}" => i }

  snmp_communities = { for i in flatten([
    for key, value in local.snmp_policies : [
      for k, v in value.snmp_communities : merge(local.SNMP.snmp_communities, v, { snmp_policy = key })
    ]
  ]) : "${i.snmp_policy}:${i.community}" => i }

  snmp_policies_users = { for i in flatten([
    for key, value in local.snmp_policies : [
      for k, v in value.users : merge(local.SNMP.users, v, { snmp_policy = key })
    ]
  ]) : "${i.snmp_policy}/${i.username}" => i }

  snmp_trap_destinations = { for i in flatten([
    for key, value in local.snmp_policies : [
      for k, v in value.snmp_destinations : merge(local.SNMP.snmp_destinations, v, {
        mgmt_epg_type = local.mgmt_epgs[index(local.mgmt_epgs[*].name,
          lookup(v, "management_epg", local.SNMP.snmp_destinations.management_epg))
        ].type
        snmp_policy = key
        v3_security_level = length(compact([lookup(v, "username", "")])
        ) == 0 ? "noauth" : lookup(v, "v3_security_level", local.SNMP.snmp_destinations.v3_security_level)
        version = length(compact([lookup(v, "username", "")])) > 0 ? "v3" : "v2c"
      })
    ]
  ]) : "${i.snmp_policy}/${i.host}" => i }
}
