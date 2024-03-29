# frozen_string_literal: true
module HubriseMoney
  class Money
    module CurrencyData
      COUNTRY_TO_CURRENCY = {
        "AD" => "EUR",
        "AE" => "AED",
        "AF" => "AFN",
        "AG" => "XCD",
        "AI" => "XCD",
        "AL" => "ALL",
        "AM" => "AMD",
        "AN" => "ANG",
        "AO" => "AOA",
        "AQ" => "USD",
        "AR" => "ARS",
        "AS" => "USD",
        "AT" => "EUR",
        "AU" => "AUD",
        "AW" => "AWG",
        "AX" => "EUR",
        "AZ" => "AZN",
        "BA" => "BAM",
        "BB" => "BBD",
        "BD" => "BDT",
        "BE" => "EUR",
        "BF" => "XOF",
        "BG" => "BGN",
        "BH" => "BHD",
        "BI" => "BIF",
        "BJ" => "XOF",
        "BL" => "EUR",
        "BM" => "BMD",
        "BN" => "BND",
        "BO" => "BOB",
        "BQ" => "USD",
        "BR" => "BRL",
        "BS" => "BSD",
        "BT" => "BTN",
        "BV" => "NOK",
        "BW" => "BWP",
        "BY" => "BYR",
        "BZ" => "BZD",
        "CA" => "CAD",
        "CC" => "AUD",
        "CD" => "CDF",
        "CF" => "XAF",
        "CG" => "XAF",
        "CH" => "CHF",
        "CI" => "XOF",
        "CK" => "NZD",
        "CL" => "CLP",
        "CM" => "XAF",
        "CN" => "CNY",
        "CO" => "COP",
        "CR" => "CRC",
        "CU" => "CUP",
        "CV" => "CVE",
        "CW" => "ANG",
        "CX" => "AUD",
        "CY" => "EUR",
        "CZ" => "CZK",
        "DE" => "EUR",
        "DJ" => "DJF",
        "DK" => "DKK",
        "DM" => "XCD",
        "DO" => "DOP",
        "DZ" => "DZD",
        "EC" => "USD",
        "EE" => "EUR",
        "EG" => "EGP",
        "EH" => "MAD",
        "ER" => "ETB",
        "ES" => "EUR",
        "ET" => "ETB",
        "FI" => "EUR",
        "FJ" => "USD",
        "FK" => "FKP",
        "FM" => "USD",
        "FO" => "DKK",
        "FR" => "EUR",
        "GA" => "XAF",
        "GB" => "GBP",
        "GD" => "XCD",
        "GE" => "GEL",
        "GF" => "EUR",
        "GG" => "GBP",
        "GH" => "GHS",
        "GI" => "GIP",
        "GL" => "DKK",
        "GM" => "GMD",
        "GN" => "GNF",
        "GP" => "EUR",
        "GQ" => "XAF",
        "GR" => "EUR",
        "GS" => "GBP",
        "GT" => "GTQ",
        "GU" => "USD",
        "GW" => "XOF",
        "GY" => "GYD",
        "HK" => "HKD",
        "HM" => "AUD",
        "HN" => "HNL",
        "HR" => "HRK",
        "HT" => "USD",
        "HU" => "HUF",
        "ID" => "IDR",
        "IE" => "EUR",
        "IL" => "ILS",
        "IM" => "IMP",
        "IN" => "INR",
        "IO" => "USD",
        "IQ" => "IQD",
        "IR" => "IRR",
        "IS" => "ISK",
        "IT" => "EUR",
        "JE" => "JEP",
        "JM" => "JMD",
        "JO" => "JOD",
        "JP" => "JPY",
        "KE" => "KES",
        "KG" => "KGS",
        "KH" => "KHR",
        "KI" => "AUD",
        "KM" => "KMF",
        "KN" => "XCD",
        "KP" => "KPW",
        "KR" => "KRW",
        "KW" => "KWD",
        "KY" => "KYD",
        "KZ" => "KZT",
        "LA" => "LAK",
        "LB" => "LBP",
        "LC" => "XCD",
        "LI" => "CHF",
        "LK" => "LKR",
        "LR" => "LRD",
        "LS" => "LSL",
        "LT" => "EUR",
        "LU" => "EUR",
        "LV" => "EUR",
        "LY" => "LYD",
        "MA" => "MAD",
        "MC" => "EUR",
        "MD" => "MDL",
        "ME" => "EUR",
        "MF" => "EUR",
        "MG" => "MGA",
        "MH" => "USD",
        "MK" => "MKD",
        "ML" => "XOF",
        "MM" => "MMK",
        "MN" => "MNT",
        "MO" => "MOP",
        "MP" => "USD",
        "MQ" => "EUR",
        "MR" => "MRO",
        "MS" => "XCD",
        "MT" => "EUR",
        "MU" => "MUR",
        "MV" => "MVR",
        "MW" => "MWK",
        "MX" => "MXN",
        "MY" => "MYR",
        "MZ" => "MZN",
        "NA" => "NAD",
        "NC" => "XPF",
        "NE" => "XOF",
        "NF" => "AUD",
        "NG" => "NGN",
        "NI" => "NIO",
        "NL" => "EUR",
        "NO" => "NOK",
        "NP" => "NPR",
        "NR" => "AUD",
        "NU" => "NZD",
        "NZ" => "NZD",
        "OM" => "OMR",
        "PA" => "PAB",
        "PE" => "PEN",
        "PF" => "XPF",
        "PG" => "PGK",
        "PH" => "PHP",
        "PK" => "PKR",
        "PL" => "PLN",
        "PM" => "EUR",
        "PN" => "NZD",
        "PR" => "USD",
        "PS" => "ILS",
        "PT" => "EUR",
        "PW" => "USD",
        "PY" => "PYG",
        "QA" => "QAR",
        "RE" => "EUR",
        "RO" => "RON",
        "RS" => "RSD",
        "RU" => "RUB",
        "RW" => "RWF",
        "SA" => "SAR",
        "SB" => "SBD",
        "SC" => "SCR",
        "SD" => "SDG",
        "SE" => "SEK",
        "SG" => "SGD",
        "SH" => "SHP",
        "SI" => "EUR",
        "SJ" => "NOK",
        "SK" => "EUR",
        "SL" => "SLL",
        "SM" => "EUR",
        "SN" => "XOF",
        "SO" => "SOS",
        "SR" => "SRD",
        "SS" => "SSP",
        "ST" => "STD",
        "SV" => "USD",
        "SX" => "ANG",
        "SY" => "SYP",
        "SZ" => "SZL",
        "TC" => "USD",
        "TD" => "XAF",
        "TF" => "EUR",
        "TG" => "XOF",
        "TH" => "THB",
        "TJ" => "TJS",
        "TK" => "NZD",
        "TL" => "IDR",
        "TM" => "TMT",
        "TN" => "TND",
        "TO" => "TOP",
        "TR" => "TRY",
        "TT" => "TTD",
        "TV" => "TVD",
        "TW" => "TWD",
        "TZ" => "TZS",
        "UA" => "UAH",
        "UG" => "UGX",
        "UM" => "USD",
        "US" => "USD",
        "UY" => "UYU",
        "UZ" => "UZS",
        "VA" => "EUR",
        "VC" => "XCD",
        "VE" => "VEF",
        "VG" => "USD",
        "VI" => "USD",
        "VN" => "VND",
        "VU" => "VUV",
        "WF" => "XPF",
        "WS" => "USD",
        "YE" => "YER",
        "YT" => "EUR",
        "ZA" => "ZAR",
        "ZM" => "ZMW",
        "ZW" => "ZWD",
      }

      CURRENCY_TO_SYMBOL = {
        "EUR" => "€",
        "AED" => "د.إ",
        "AFN" => "؋",
        "XCD" => "$",
        "ALL" => "L",
        "AMD" => "դր.",
        "ANG" => "ƒ",
        "AOA" => "Kz",
        "USD" => "$",
        "ARS" => "$",
        "AUD" => "$",
        "AWG" => "ƒ",
        "AZN" => "\u20BC",
        "BAM" => "КМ",
        "BBD" => "$",
        "BDT" => "৳",
        "XOF" => "Fr",
        "BGN" => "лв.",
        "BHD" => "ب.د",
        "BIF" => "Fr",
        "BMD" => "$",
        "BND" => "$",
        "BOB" => "Bs.",
        "BRL" => "R$",
        "BSD" => "$",
        "BTN" => "Nu.",
        "NOK" => "kr",
        "BWP" => "P",
        "BYR" => "Br",
        "BZD" => "$",
        "CAD" => "$",
        "CDF" => "Fr",
        "XAF" => "Fr",
        "CHF" => "CHF",
        "NZD" => "$",
        "CLP" => "$",
        "CNY" => "¥",
        "COP" => "$",
        "CRC" => "₡",
        "CUP" => "$",
        "CVE" => "$",
        "CZK" => "Kč",
        "DJF" => "Fdj",
        "DKK" => "kr.",
        "DOP" => "$",
        "DZD" => "د.ج",
        "EGP" => "ج.م",
        "MAD" => "د.م.",
        "ETB" => "Br",
        "FKP" => "£",
        "GBP" => "£",
        "GEL" => "ლ",
        "GHS" => "₵",
        "GIP" => "£",
        "GMD" => "D",
        "GNF" => "Fr",
        "GTQ" => "Q",
        "GYD" => "$",
        "HKD" => "$",
        "HNL" => "L",
        "HRK" => "kn",
        "HUF" => "Ft",
        "IDR" => "Rp",
        "ILS" => "₪",
        "IMP" => "£",
        "INR" => "₹",
        "IQD" => "ع.د",
        "IRR" => "﷼",
        "ISK" => "kr",
        "JEP" => "£",
        "JMD" => "$",
        "JOD" => "د.ا",
        "JPY" => "¥",
        "KES" => "KSh",
        "KGS" => "som",
        "KHR" => "៛",
        "KMF" => "Fr",
        "KPW" => "₩",
        "KRW" => "₩",
        "KWD" => "د.ك",
        "KYD" => "$",
        "KZT" => "〒",
        "LAK" => "₭",
        "LBP" => "ل.ل",
        "LKR" => "₨",
        "LRD" => "$",
        "LSL" => "L",
        "LYD" => "ل.د",
        "MDL" => "L",
        "MGA" => "Ar",
        "MKD" => "ден",
        "MMK" => "K",
        "MNT" => "₮",
        "MOP" => "P",
        "MRO" => "UM",
        "MUR" => "₨",
        "MVR" => "MVR",
        "MWK" => "MK",
        "MXN" => "$",
        "MYR" => "RM",
        "MZN" => "MTn",
        "NAD" => "$",
        "XPF" => "Fr",
        "NGN" => "₦",
        "NIO" => "C$",
        "NPR" => "₨",
        "OMR" => "ر.ع.",
        "PAB" => "B/.",
        "PEN" => "S/.",
        "PGK" => "K",
        "PHP" => "₱",
        "PKR" => "₨",
        "PLN" => "zł",
        "PYG" => "₲",
        "QAR" => "ر.ق",
        "RON" => "Lei",
        "RSD" => "РСД",
        "RUB" => "\u20BD",
        "RWF" => "FRw",
        "SAR" => "ر.س",
        "SBD" => "$",
        "SCR" => "₨",
        "SDG" => "£",
        "SEK" => "kr",
        "SGD" => "$",
        "SHP" => "£",
        "SLL" => "Le",
        "SOS" => "Sh",
        "SRD" => "$",
        "SSP" => "£",
        "STD" => "Db",
        "SYP" => "£S",
        "SZL" => "E",
        "THB" => "฿",
        "TJS" => "ЅМ",
        "TMT" => "T",
        "TND" => "د.ت",
        "TOP" => "T$",
        "TRY" => "\u20BA",
        "TTD" => "$",
        "TWD" => "$",
        "TZS" => "Sh",
        "UAH" => "₴",
        "UGX" => "USh",
        "UYU" => "$",
        "UZS" => nil,
        "VEF" => "Bs",
        "VND" => "₫",
        "VUV" => "Vt",
        "YER" => "﷼",
        "ZAR" => "R",
        "ZMW" => "ZK",
        "ZWD" => "$",
      }

      CURRENCIES = CURRENCY_TO_SYMBOL.keys
    end
  end
end
