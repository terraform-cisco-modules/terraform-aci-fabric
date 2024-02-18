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
  timezones = jsonencode({
    "Africa/Abidjan" : "p0_Africa-Abidjan",
    "Africa/Accra" : "p0_Africa-Accra",
    "Africa/Addis_Ababa" : "p180_Africa-Addis_Ababa",
    "Africa/Algiers" : "p60_Africa-Algiers",
    "Africa/Asmara" : "p180_Africa-Asmara",
    "Africa/Bamako" : "p0_Africa-Bamako",
    "Africa/Bangui" : "p60_Africa-Bangui",
    "Africa/Banjul" : "p0_Africa-Banjul",
    "Africa/Bissau" : "p0_Africa-Bissau",
    "Africa/Blantyre" : "p120_Africa-Blantyre",
    "Africa/Brazzaville" : "p60_Africa-Brazzaville",
    "Africa/Bujumbura" : "p120_Africa-Bujumbura",
    "Africa/Cairo" : "p120_Africa-Cairo",
    "Africa/Casablanca" : "p60_Africa-Casablanca",
    "Africa/Ceuta" : "p120_Africa-Ceuta",
    "Africa/Conakry" : "p0_Africa-Conakry",
    "Africa/Dakar" : "p0_Africa-Dakar",
    "Africa/Dar_es_Salaam" : "p180_Africa-Dar_es_Salaam",
    "Africa/Djibouti" : "p180_Africa-Djibouti",
    "Africa/Douala" : "p60_Africa-Douala",
    "Africa/El_Aaiun" : "p0_Africa-El_Aaiun",
    "Africa/Freetown" : "p0_Africa-Freetown",
    "Africa/Gaborone" : "p120_Africa-Gaborone",
    "Africa/Harare" : "p120_Africa-Harare",
    "Africa/Johannesburg" : "p120_Africa-Johannesburg",
    "Africa/Juba" : "p180_Africa-Juba",
    "Africa/Kampala" : "p180_Africa-Kampala",
    "Africa/Khartoum" : "p180_Africa-Khartoum",
    "Africa/Kigali" : "p120_Africa-Kigali",
    "Africa/Kinshasa" : "p60_Africa-Kinshasa",
    "Africa/Lagos" : "p60_Africa-Lagos",
    "Africa/Libreville" : "p60_Africa-Libreville",
    "Africa/Lome" : "p0_Africa-Lome",
    "Africa/Luanda" : "p60_Africa-Luanda",
    "Africa/Lubumbashi" : "p120_Africa-Lubumbashi",
    "Africa/Lusaka" : "p120_Africa-Lusaka",
    "Africa/Malabo" : "p60_Africa-Malabo",
    "Africa/Maputo" : "p120_Africa-Maputo",
    "Africa/Maseru" : "p120_Africa-Maseru",
    "Africa/Mbabane" : "p120_Africa-Mbabane",
    "Africa/Mogadishu" : "p180_Africa-Mogadishu",
    "Africa/Monrovia" : "p0_Africa-Monrovia",
    "Africa/Nairobi" : "p180_Africa-Nairobi",
    "Africa/Ndjamena" : "p60_Africa-Ndjamena",
    "Africa/Niamey" : "p60_Africa-Niamey",
    "Africa/Nouakchott" : "p0_Africa-Nouakchott",
    "Africa/Ouagadougou" : "p0_Africa-Ouagadougou",
    "Africa/Porto-Novo" : "p60_Africa-Porto_Novo",
    "Africa/Sao_Tome" : "p0_Africa-Sao_Tome",
    "Africa/Tripoli" : "p120_Africa-Tripoli",
    "Africa/Tunis" : "p60_Africa-Tunis",
    "Africa/Windhoek" : "p120_Africa-Windhoek",
    "America/Adak" : "n540_America-Adak",
    "America/Anchorage" : "n480_America-Anchorage",
    "America/Anguilla" : "n240_America-Anguilla",
    "America/Antigua" : "n240_America-Antigua",
    "America/Araguaina" : "n180_America-Araguaina",
    "America/Argentina/Buenos_Aires" : "n180_America-Argentina-Buenos_Aires",
    "America/Argentina/Catamarca" : "n180_America-Argentina-Catamarca",
    "America/Argentina/Cordoba" : "n180_America-Argentina-Cordoba",
    "America/Argentina/Jujuy" : "n180_America-Argentina-Jujuy",
    "America/Argentina/La_Rioja" : "n180_America-Argentina-La_Rioja",
    "America/Argentina/Mendoza" : "n180_America-Argentina-Mendoza",
    "America/Argentina/Rio_Gallegos" : "n180_America-Argentina-Rio_Gallegos",
    "America/Argentina/Salta" : "n180_America-Argentina-Salta",
    "America/Argentina/San_Juan" : "n180_America-Argentina-San_Juan",
    "America/Argentina/San_Luis" : "n180_America-Argentina-San_Luis",
    "America/Argentina/Tucuman" : "n180_America-Argentina-Tucuman",
    "America/Argentina/Ushuaia" : "n180_America-Argentina-Ushuaia",
    "America/Aruba" : "n240_America-Aruba",
    "America/Asuncion" : "n180_America-Asuncion",
    "America/Atikokan" : "n300_America-Atikokan",
    "America/Bahia_Banderas" : "n300_America-Bahia_Banderas",
    "America/Barbados" : "n240_America-Barbados",
    "America/Belem" : "n180_America-Belem",
    "America/Belize" : "n360_America-Belize",
    "America/Blanc-Sablon" : "n240_America-Blanc_Sablon",
    "America/Boa_Vista" : "n240_America-Boa_Vista",
    "America/Bogota" : "n300_America-Bogota",
    "America/Boise" : "n360_America-Boise",
    "America/Cambridge_Bay" : "n360_America-Cambridge_Bay",
    "America/Campo_Grande" : "n180_America-Campo_Grande",
    "America/Cancun" : "n300_America-Cancun",
    "America/Caracas" : "n270_America-Caracas",
    "America/Cayenne" : "n180_America-Cayenne",
    "America/Cayman" : "n300_America-Cayman",
    "America/Chicago" : "n300_America-Chicago",
    "America/Chihuahua" : "n360_America-Chihuahua",
    "America/Costa_Rica" : "n360_America-Costa_Rica",
    "America/Creston" : "n420_America-Creston",
    "America/Cuiaba" : "n180_America-Cuiaba",
    "America/Curacao" : "n240_America-Curacao",
    "America/Danmarkshavn" : "p0_America-Danmarkshavn",
    "America/Dawson" : "n420_America-Dawson",
    "America/Dawson_Creek" : "n420_America-Dawson_Creek",
    "America/Denver" : "n360_America-Denver",
    "America/Detroit" : "n240_America-Detroit",
    "America/Dominica" : "n240_America-Dominica",
    "America/Edmonton" : "n360_America-Edmonton",
    "America/Eirunepe" : "n240_America-Eirunepe",
    "America/El_Salvador" : "n360_America-El_Salvador",
    "America/Fortaleza" : "n180_America-Fortaleza",
    "America/Glace_Bay" : "n180_America-Glace_Bay",
    "America/Godthab" : "n120_America-Godthab",
    "America/Goose_Bay" : "n180_America-Goose_Bay",
    "America/Grand_Turk" : "n240_America-Grand_Turk",
    "America/Grenada" : "n240_America-Grenada",
    "America/Guadeloupe" : "n240_America-Guadeloupe",
    "America/Guatemala" : "n360_America-Guatemala",
    "America/Guayaquil" : "n300_America-Guayaquil",
    "America/Guyana" : "n240_America-Guyana",
    "America/Halifax" : "n180_America-Halifax",
    "America/Havana" : "n240_America-Havana",
    "America/Hermosillo" : "n420_America-Hermosillo",
    "America/Indiana/Indianapolis" : "n240_America-Indiana-Indianapolis",
    "America/Indiana/Knox" : "n300_America-Indiana-Knox",
    "America/Indiana/Marengo" : "n240_America-Indiana-Marengo",
    "America/Indiana/Petersburg" : "n240_America-Indiana-Petersburg",
    "America/Indiana/Tell_City" : "n300_America-Indiana-Tell_City",
    "America/Indiana/Vevay" : "n240_America-Indiana-Vevay",
    "America/Indiana/Vincennes" : "n240_America-Indiana-Vincennes",
    "America/Indiana/Winamac" : "n240_America-Indiana-Winamac",
    "America/Inuvik" : "n360_America-Inuvik",
    "America/Iqaluit" : "n240_America-Iqaluit",
    "America/Jamaica" : "n300_America-Jamaica",
    "America/Juneau" : "n480_America-Juneau",
    "America/Kentucky/Louisville" : "n240_America-Kentucky-Louisville",
    "America/Kentucky/Monticello" : "n240_America-Kentucky-Monticello",
    "America/Kralendijk" : "n240_America-Kralendijk",
    "America/La_Paz" : "n240_America-La_Paz",
    "America/Lima" : "n300_America-Lima",
    "America/Los_Angeles" : "n420_America-Los_Angeles",
    "America/Lower_Princes" : "n240_America-Lower_Princes",
    "America/Maceio" : "n180_America-Maceio",
    "America/Managua" : "n360_America-Managua",
    "America/Manaus" : "n240_America-Manaus",
    "America/Marigot" : "n240_America-Marigot",
    "America/Martinique" : "n240_America-Martinique",
    "America/Matamoros" : "n300_America-Matamoros",
    "America/Mazatlan" : "n360_America-Mazatlan",
    "America/Menominee" : "n300_America-Menominee",
    "America/Merida" : "n300_America-Merida",
    "America/Metlakatla" : "n480_America-Metlakatla",
    "America/Mexico_City" : "n300_America-Mexico_City",
    "America/Miquelon" : "n120_America-Miquelon",
    "America/Moncton" : "n180_America-Moncton",
    "America/Monterrey" : "n300_America-Monterrey",
    "America/Montevideo" : "n120_America-Montevideo",
    "America/Montreal" : "n240_America-Montreal",
    "America/Montserrat" : "n240_America-Montserrat",
    "America/Nassau" : "n240_America-Nassau",
    "America/New_York" : "n240_America-New_York",
    "America/Nipigon" : "n240_America-Nipigon",
    "America/Nome" : "n480_America-Nome",
    "America/Noronha" : "n120_America-Noronha",
    "America/North_Dakota/Beulah" : "n300_America-North_Dakota-Beulah",
    "America/North_Dakota/Center" : "n300_America-North_Dakota-Center",
    "America/North_Dakota/New_Salem" : "n300_America-North_Dakota-New_Salem",
    "America/Ojinaga" : "n360_America-Ojinaga",
    "America/Panama" : "n300_America-Panama",
    "America/Pangnirtung" : "n240_America-Pangnirtung",
    "America/Paramaribo" : "n180_America-Paramaribo",
    "America/Phoenix" : "n420_America-Phoenix",
    "America/Port-au-Prince" : "n240_America-Port_au_Prince",
    "America/Port_of_Spain" : "n240_America-Port_of_Spain",
    "America/Porto_Velho" : "n240_America-Porto_Velho",
    "America/Puerto_Rico" : "n240_America-Puerto_Rico",
    "America/Rainy_River" : "n300_America-Rainy_River",
    "America/Rankin_Inlet" : "n300_America-Rankin_Inlet",
    "America/Recife" : "n180_America-Recife",
    "America/Regina" : "n360_America-Regina",
    "America/Resolute" : "n300_America-Resolute",
    "America/Rio_Branco" : "n240_America-Rio_Branco",
    "America/Santa_Isabel" : "n420_America-Santa_Isabel",
    "America/Santarem" : "n180_America-Santarem",
    "America/Santiago" : "n180_America-Santiago",
    "America/Santo_Domingo" : "n240_America-Santo_Domingo",
    "America/Sao_Paulo" : "n120_America-Sao_Paulo",
    "America/Scoresbysund" : "p0_America-Scoresbysund",
    "America/Shiprock" : "n360_America-Shiprock",
    "America/Sitka" : "n480_America-Sitka",
    "America/St_Barthelemy" : "n240_America-St_Barthelemy",
    "America/St_Johns" : "n150_America-St_Johns",
    "America/St_Kitts" : "n240_America-St_Kitts",
    "America/St_Lucia" : "n240_America-St_Lucia",
    "America/St_Thomas" : "n240_America-St_Thomas",
    "America/St_Vincent" : "n240_America-St_Vincent",
    "America/Swift_Current" : "n360_America-Swift_Current",
    "America/Tegucigalpa" : "n360_America-Tegucigalpa",
    "America/Thule" : "n180_America-Thule",
    "America/Thunder_Bay" : "n240_America-Thunder_Bay",
    "America/Tijuana" : "n420_America-Tijuana",
    "America/Toronto" : "n240_America-Toronto",
    "America/Tortola" : "n240_America-Tortola",
    "America/Vancouver" : "n420_America-Vancouver",
    "America/Whitehorse" : "n420_America-Whitehorse",
    "America/Winnipeg" : "n300_America-Winnipeg",
    "America/Yakutat" : "n480_America-Yakutat",
    "America/Yellowknife" : "n360_America-Yellowknife",
    "Antarctica/Casey" : "p480_Antarctica-Casey",
    "Antarctica/Davis" : "p420_Antarctica-Davis",
    "Antarctica/DumontDUrville" : "p600_Antarctica-DumontDUrville",
    "Antarctica/Macquarie" : "p660_Antarctica-Macquarie",
    "Antarctica/Mawson" : "p300_Antarctica-Mawson",
    "Antarctica/McMurdo" : "p780_Antarctica-McMurdo",
    "Antarctica/Palmer" : "n180_Antarctica-Palmer",
    "Antarctica/Rothera" : "n180_Antarctica-Rothera",
    "Antarctica/South_Pole" : "p780_Antarctica-South_Pole",
    "Antarctica/Syowa" : "p180_Antarctica-Syowa",
    "Antarctica/Vostok" : "p360_Antarctica-Vostok",
    "Arctic/Longyearbyen" : "p120_Arctic-Longyearbyen",
    "Asia/Aden" : "p180_Asia-Aden",
    "Asia/Almaty" : "p360_Asia-Almaty",
    "Asia/Amman" : "p180_Asia-Amman",
    "Asia/Anadyr" : "p720_Asia-Anadyr",
    "Asia/Aqtau" : "p300_Asia-Aqtau",
    "Asia/Aqtobe" : "p300_Asia-Aqtobe",
    "Asia/Ashgabat" : "p300_Asia-Ashgabat",
    "Asia/Baghdad" : "p180_Asia-Baghdad",
    "Asia/Bahrain" : "p180_Asia-Bahrain",
    "Asia/Baku" : "p300_Asia-Baku",
    "Asia/Bangkok" : "p420_Asia-Bangkok",
    "Asia/Beirut" : "p180_Asia-Beirut",
    "Asia/Bishkek" : "p360_Asia-Bishkek",
    "Asia/Brunei" : "p480_Asia-Brunei",
    "Asia/Choibalsan" : "p480_Asia-Choibalsan",
    "Asia/Chongqing" : "p480_Asia-Chongqing",
    "Asia/Colombo" : "p330_Asia-Colombo",
    "Asia/Damascus" : "p180_Asia-Damascus",
    "Asia/Dhaka" : "p360_Asia-Dhaka",
    "Asia/Dili" : "p540_Asia-Dili",
    "Asia/Dubai" : "p240_Asia-Dubai",
    "Asia/Dushanbe" : "p300_Asia-Dushanbe",
    "Asia/Gaza" : "p180_Asia-Gaza",
    "Asia/Harbin" : "p480_Asia-Harbin",
    "Asia/Hebron" : "p180_Asia-Hebron",
    "Asia/Ho_Chi_Minh" : "p420_Asia-Ho_Chi_Minh",
    "Asia/Hong_Kong" : "p480_Asia-Hong_Kong",
    "Asia/Hovd" : "p420_Asia-Hovd",
    "Asia/Irkutsk" : "p540_Asia-Irkutsk",
    "Asia/Jakarta" : "p420_Asia-Jakarta",
    "Asia/Jayapura" : "p540_Asia-Jayapura",
    "Asia/Jerusalem" : "p180_Asia-Jerusalem",
    "Asia/Kabul" : "p270_Asia-Kabul",
    "Asia/Kamchatka" : "p720_Asia-Kamchatka",
    "Asia/Karachi" : "p300_Asia-Karachi",
    "Asia/Kashgar" : "p480_Asia-Kashgar",
    "Asia/Kathmandu" : "p345_Asia-Kathmandu",
    "Asia/Kolkata" : "p330_Asia-Kolkata",
    "Asia/Krasnoyarsk" : "p480_Asia-Krasnoyarsk",
    "Asia/Kuala_Lumpur" : "p480_Asia-Kuala_Lumpur",
    "Asia/Kuching" : "p480_Asia-Kuching",
    "Asia/Kuwait" : "p180_Asia-Kuwait",
    "Asia/Macau" : "p480_Asia-Macau",
    "Asia/Magadan" : "p720_Asia-Magadan",
    "Asia/Makassar" : "p480_Asia-Makassar",
    "Asia/Manila" : "p480_Asia-Manila",
    "Asia/Muscat" : "p240_Asia-Muscat",
    "Asia/Nicosia" : "p180_Asia-Nicosia",
    "Asia/Novokuznetsk" : "p420_Asia-Novokuznetsk",
    "Asia/Novosibirsk" : "p420_Asia-Novosibirsk",
    "Asia/Omsk" : "p420_Asia-Omsk",
    "Asia/Oral" : "p300_Asia-Oral",
    "Asia/Phnom_Penh" : "p420_Asia-Phnom_Penh",
    "Asia/Pontianak" : "p420_Asia-Pontianak",
    "Asia/Pyongyang" : "p540_Asia-Pyongyang",
    "Asia/Qatar" : "p180_Asia-Qatar",
    "Asia/Qyzylorda" : "p360_Asia-Qyzylorda",
    "Asia/Rangoon" : "p390_Asia-Rangoon",
    "Asia/Riyadh" : "p180_Asia-Riyadh",
    "Asia/Sakhalin" : "p660_Asia-Sakhalin",
    "Asia/Samarkand" : "p300_Asia-Samarkand",
    "Asia/Seoul" : "p540_Asia-Seoul",
    "Asia/Shanghai" : "p480_Asia-Shanghai",
    "Asia/Singapore" : "p480_Asia-Singapore",
    "Asia/Taipei" : "p480_Asia-Taipei",
    "Asia/Tashkent" : "p300_Asia-Tashkent",
    "Asia/Tbilisi" : "p240_Asia-Tbilisi",
    "Asia/Tehran" : "p270_Asia-Tehran",
    "Asia/Thimphu" : "p360_Asia-Thimphu",
    "Asia/Tokyo" : "p540_Asia-Tokyo",
    "Asia/Ulaanbaatar" : "p480_Asia-Ulaanbaatar",
    "Asia/Urumqi" : "p480_Asia-Urumqi",
    "Asia/Vientiane" : "p420_Asia-Vientiane",
    "Asia/Vladivostok" : "p660_Asia-Vladivostok",
    "Asia/Yakutsk" : "p600_Asia-Yakutsk",
    "Asia/Yekaterinburg" : "p360_Asia-Yekaterinburg",
    "Asia/Yerevan" : "p240_Asia-Yerevan",
    "Atlantic/Azores" : "p0_Atlantic-Azores",
    "Atlantic/Bermuda" : "n180_Atlantic-Bermuda",
    "Atlantic/Canary" : "p60_Atlantic-Canary",
    "Atlantic/Cape_Verde" : "n60_Atlantic-Cape_Verde",
    "Atlantic/Faroe" : "p60_Atlantic-Faroe",
    "Atlantic/Madeira" : "p60_Atlantic-Madeira",
    "Atlantic/Reykjavik" : "p0_Atlantic-Reykjavik",
    "Atlantic/South_Georgia" : "n120_Atlantic-South_Georgia",
    "Atlantic/St_Helena" : "p0_Atlantic-St_Helena",
    "Atlantic/Stanley" : "n180_Atlantic-Stanley",
    "Australia/Adelaide" : "p630_Australia-Adelaide",
    "Australia/Brisbane" : "p600_Australia-Brisbane",
    "Australia/Broken_Hill" : "p630_Australia-Broken_Hill",
    "Australia/Currie" : "p660_Australia-Currie",
    "Australia/Darwin" : "p570_Australia-Darwin",
    "Australia/Eucla" : "p525_Australia-Eucla",
    "Australia/Hobart" : "p660_Australia-Hobart",
    "Australia/Lindeman" : "p600_Australia-Lindeman",
    "Australia/Lord_Howe" : "p660_Australia-Lord_Howe",
    "Australia/Melbourne" : "p660_Australia-Melbourne",
    "Australia/Perth" : "p480_Australia-Perth",
    "Australia/Sydney" : "p660_Australia-Sydney",
    "Coordinated Universal Time" : "p0_UTC",
    "Europe/Amsterdam" : "p120_Europe-Amsterdam",
    "Europe/Andorra" : "p120_Europe-Andorra",
    "Europe/Athens" : "p180_Europe-Athens",
    "Europe/Belgrade" : "p120_Europe-Belgrade",
    "Europe/Berlin" : "p120_Europe-Berlin",
    "Europe/Bratislava" : "p120_Europe-Bratislava",
    "Europe/Brussels" : "p120_Europe-Brussels",
    "Europe/Bucharest" : "p180_Europe-Bucharest",
    "Europe/Budapest" : "p120_Europe-Budapest",
    "Europe/Chisinau" : "p180_Europe-Chisinau",
    "Europe/Copenhagen" : "p120_Europe-Copenhagen",
    "Europe/Dublin" : "p60_Europe-Dublin",
    "Europe/Gibraltar" : "p120_Europe-Gibraltar",
    "Europe/Guernsey" : "p60_Europe-Guernsey",
    "Europe/Helsinki" : "p180_Europe-Helsinki",
    "Europe/Isle_of_Man" : "p60_Europe-Isle_of_Man",
    "Europe/Istanbul" : "p180_Europe-Istanbul",
    "Europe/Jersey" : "p60_Europe-Jersey",
    "Europe/Kaliningrad" : "p180_Europe-Kaliningrad",
    "Europe/Kiev" : "p180_Europe-Kiev",
    "Europe/Lisbon" : "p60_Europe-Lisbon",
    "Europe/Ljubljana" : "p120_Europe-Ljubljana",
    "Europe/London" : "p60_Europe-London",
    "Europe/Luxembourg" : "p120_Europe-Luxembourg",
    "Europe/Madrid" : "p120_Europe-Madrid",
    "Europe/Malta" : "p120_Europe-Malta",
    "Europe/Mariehamn" : "p180_Europe-Mariehamn",
    "Europe/Minsk" : "p180_Europe-Minsk",
    "Europe/Monaco" : "p120_Europe-Monaco",
    "Europe/Moscow" : "p240_Europe-Moscow",
    "Europe/Oslo" : "p120_Europe-Oslo",
    "Europe/Paris" : "p120_Europe-Paris",
    "Europe/Podgorica" : "p120_Europe-Podgorica",
    "Europe/Prague" : "p120_Europe-Prague",
    "Europe/Riga" : "p180_Europe-Riga",
    "Europe/Rome" : "p120_Europe-Rome",
    "Europe/Samara" : "p240_Europe-Samara",
    "Europe/San_Marino" : "p120_Europe-San_Marino",
    "Europe/Sarajevo" : "p120_Europe-Sarajevo",
    "Europe/Simferopol" : "p180_Europe-Simferopol",
    "Europe/Skopje" : "p120_Europe-Skopje",
    "Europe/Sofia" : "p180_Europe-Sofia",
    "Europe/Stockholm" : "p120_Europe-Stockholm",
    "Europe/Tallinn" : "p180_Europe-Tallinn",
    "Europe/Tirane" : "p120_Europe-Tirane",
    "Europe/Uzhgorod" : "p180_Europe-Uzhgorod",
    "Europe/Vaduz" : "p120_Europe-Vaduz",
    "Europe/Vatican" : "p120_Europe-Vatican",
    "Europe/Vienna" : "p120_Europe-Vienna",
    "Europe/Vilnius" : "p180_Europe-Vilnius",
    "Europe/Volgograd" : "p240_Europe-Volgograd",
    "Europe/Warsaw" : "p120_Europe-Warsaw",
    "Europe/Zagreb" : "p120_Europe-Zagreb",
    "Europe/Zaporozhye" : "p180_Europe-Zaporozhye",
    "Europe/Zurich" : "p120_Europe-Zurich",
    "Indian/Antananarivo" : "p180_Indian-Antananarivo",
    "Indian/Chagos" : "p360_Indian-Chagos",
    "Indian/Christmas" : "p420_Indian-Christmas",
    "Indian/Cocos" : "p390_Indian-Cocos",
    "Indian/Comoro" : "p180_Indian-Comoro",
    "Indian/Kerguelen" : "p300_Indian-Kerguelen",
    "Indian/Mahe" : "p240_Indian-Mahe",
    "Indian/Maldives" : "p300_Indian-Maldives",
    "Indian/Mauritius" : "p240_Indian-Mauritius",
    "Indian/Mayotte" : "p180_Indian-Mayotte",
    "Indian/Reunion" : "p240_Indian-Reunion",
    "Pacific/Apia" : "p840_Pacific-Apia",
    "Pacific/Auckland" : "p780_Pacific-Auckland",
    "Pacific/Chatham" : "p825_Pacific-Chatham",
    "Pacific/Chuuk" : "p600_Pacific-Chuuk",
    "Pacific/Easter" : "n300_Pacific-Easter",
    "Pacific/Efate" : "p660_Pacific-Efate",
    "Pacific/Enderbury" : "p780_Pacific-Enderbury",
    "Pacific/Fakaofo" : "p780_Pacific-Fakaofo",
    "Pacific/Fiji" : "p780_Pacific-Fiji",
    "Pacific/Funafuti" : "p720_Pacific-Funafuti",
    "Pacific/Galapagos" : "n360_Pacific-Galapagos",
    "Pacific/Gambier" : "n540_Pacific-Gambier",
    "Pacific/Guadalcanal" : "p660_Pacific-Guadalcanal",
    "Pacific/Guam" : "p600_Pacific-Guam",
    "Pacific/Honolulu" : "n600_Pacific-Honolulu",
    "Pacific/Johnston" : "n600_Pacific-Johnston",
    "Pacific/Kiritimati" : "p840_Pacific-Kiritimati",
    "Pacific/Kosrae" : "p660_Pacific-Kosrae",
    "Pacific/Kwajalein" : "p720_Pacific-Kwajalein",
    "Pacific/Majuro" : "p720_Pacific-Majuro",
    "Pacific/Marquesas" : "n570_Pacific-Marquesas",
    "Pacific/Midway" : "n660_Pacific-Midway",
    "Pacific/Nauru" : "p720_Pacific-Nauru",
    "Pacific/Niue" : "n660_Pacific-Niue",
    "Pacific/Norfolk" : "p690_Pacific-Norfolk",
    "Pacific/Noumea" : "p660_Pacific-Noumea",
    "Pacific/Pago_Pago" : "n660_Pacific-Pago_Pago",
    "Pacific/Palau" : "p540_Pacific-Palau",
    "Pacific/Pitcairn" : "n480_Pacific-Pitcairn",
    "Pacific/Pohnpei" : "p660_Pacific-Pohnpei",
    "Pacific/Port_Moresby" : "p600_Pacific-Port_Moresby",
    "Pacific/Rarotonga" : "n600_Pacific-Rarotonga",
    "Pacific/Saipan" : "p600_Pacific-Saipan",
    "Pacific/Tahiti" : "n600_Pacific-Tahiti",
    "Pacific/Tarawa" : "p720_Pacific-Tarawa",
    "Pacific/Tongatapu" : "p780_Pacific-Tongatapu",
    "Pacific/Wake" : "p720_Pacific-Wake",
    "Pacific/Wallis" : "p720_Pacific-Wallis",
    "UTC" : "p0_UTC"
  })

  date_and_time = {
    for v in lookup(local.pod, "date_and_time", []) : v.name => merge(local.time, v, {
      authentication_keys = lookup(v, "authentication_keys", [])
      mgmt_epg_type = local.mgmt_epgs[index(local.mgmt_epgs[*].name,
        lookup(v, "management_epg", local.time.management_epg))
      ].type
      ntp_servers = lookup(v, "ntp_servers", [])
      time_zone   = jsondecode(local.timezones)[lookup(v, "time_zone", local.time.time_zone)]
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
