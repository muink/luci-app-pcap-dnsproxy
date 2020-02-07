-- Copyright 2017-2018 Dirk Brenken (dev@brenken.org)
-- Copyright 2015 Matthew <https://github.com/matthew728960>
-- Copyright 2020 muink <https://github.com/muink>
-- Licensed to the public under the Apache License 2.0

local fs	= require("nixio.fs")
local util	= require("luci.util")
local conf = "pcap-dnsproxy"
local config = "/etc/config/" .. conf

m = Map(conf, "")

s = m:section(TypedSection, "uci_cfg", nil,
	translatef("For further information "
		.. "<a href=\"%s\" target=\"_blank\">"
		.. "check the online documentation</a>", "https://github.com/chengr28/Pcap_DNSProxy/blob/master/Documents/ReadMe.en.txt"))
s.anonymous = true


--[[ Tab section ]]--

s:tab("dnscurve_set", translate("DNSCurve"))


--[[ General Settings ]]--


--[[ DNSCurve ]]--

dnscurve = s:taboption("dnscurve_set", Flag, "dnscurve", translate("DNSCurve (DNSCrypt)"))

dnscurve_proto = s:taboption("dnscurve_set", ListValue, "dnscurve_proto", translate("DNSCurve Protocol"))
dnscurve_proto:value("IPv4 + UDP")
dnscurve_proto:value("IPv4 + Force TCP")
dnscurve_proto:value("IPv4 + TCP + UDP")
dnscurve_proto:value("IPv6 + UDP")
dnscurve_proto:value("IPv6 + Force TCP")
dnscurve_proto:value("IPv6 + TCP + UDP")
dnscurve_proto:value("IPv4 + IPv6 + UDP")
dnscurve_proto:value("IPv4 + IPv6 + Force TCP")
dnscurve_proto:value("IPv4 + IPv6 + TCP + UDP")
--dnscurve_proto.default = "IPv4 + UDP"
dnscurve_proto.rmempty = false
dnscurve_proto:depends("dnscurve", "1")

dnscurve_reliable_timeout = s:taboption("dnscurve_set", Value, "dnscurve_reliable_timeout", translate("Reliable DNSCurve Protocol Port Timeout"),
	translate("in milliseconds, minimum to 500"))
dnscurve_reliable_timeout.datatype = "min(500)"
dnscurve_reliable_timeout.placeholder = "3000"
dnscurve_reliable_timeout.rmempty = false
dnscurve_reliable_timeout:depends("dnscurve","1")

dnscurve_unreliable_timeout = s:taboption("dnscurve_set", Value, "dnscurve_unreliable_timeout", translate("Unreliable DNSCurve Protocol Port Timeout"),
	translate("in milliseconds, minimum to 500"))
dnscurve_unreliable_timeout.datatype = "min(500)"
dnscurve_unreliable_timeout.placeholder = "2000"
dnscurve_unreliable_timeout.rmempty = false
dnscurve_unreliable_timeout:depends("dnscurve","1")

dnscurve_encrypted = s:taboption("dnscurve_set", Flag, "dnscurve_encrypted", translate("Encryption"))
dnscurve_encrypted.rmempty = false
dnscurve_encrypted:depends("dnscurve", "1")

dnscurve_one_off_client_key = s:taboption("dnscurve_set", Flag, "dnscurve_one_off_client_key", translate("Client Ephemeral Key"))
dnscurve_one_off_client_key.rmempty = false
dnscurve_one_off_client_key:depends("dnscurve", "1")

dnscurve_key_recheck_time = s:taboption("dnscurve_set", Value, "dnscurve_key_recheck_time", translate("Server Connection Information Check Interval"),
	translate("In seconds, minimum is 10"))
dnscurve_key_recheck_time.datatype = "min(10)"
dnscurve_key_recheck_time.placeholder = "1800"
dnscurve_key_recheck_time.rmempty = false
dnscurve_key_recheck_time:depends("dnscurve","1")

dnscurve_server_input = s:taboption("dnscurve_set", ListValue, "dnscurve_server_input", translate("Server Input"))
dnscurve_server_input:value("auto", translate("Database"))
dnscurve_server_input:value("manual", translate("Addresses"))
--dnscurve_server_input.default = "database"
dnscurve_server_input.rmempty = false
dnscurve_server_input:depends("dnscurve", "1")

--== Database ==---

dnscurve_server_database_ipv4 = s:taboption("dnscurve_set", Value, "dnscurve_server_database_ipv4", translate("IPv4 Main DNS"),
	translatef("The 'Name' field of the corresponding server in the "
		.. "<a href=\"%s\" target=\"_blank\">"
		.. "DNSCurve database</a>", "https://github.com/dyne/dnscrypt-proxy/blob/master/dnscrypt-resolvers.csv"))
dnscurve_server_database_ipv4:value("cisco")
--dnscurve_server_database_ipv4.default = "cisco"
dnscurve_server_database_ipv4.rmempty = false
dnscurve_server_database_ipv4:depends("dnscurve_server_input","auto")

dnscurve_server_database_ipv4_alt = s:taboption("dnscurve_set", Value, "dnscurve_server_database_ipv4_alt", translate("IPv4 Alternate DNS"))
dnscurve_server_database_ipv4_alt:value("d0wn-sg-ns1")
dnscurve_server_database_ipv4_alt.rmempty = false
dnscurve_server_database_ipv4_alt:depends("dnscurve_server_input","auto")

dnscurve_server_database_ipv6 = s:taboption("dnscurve_set", Value, "dnscurve_server_database_ipv6", translate("IPv6 Main DNS"))
dnscurve_server_database_ipv6:value("cisco-ipv6")
--dnscurve_server_database_ipv6.default = "cisco-ipv6"
dnscurve_server_database_ipv6.rmempty = false
dnscurve_server_database_ipv6:depends("dnscurve_server_input","auto")

dnscurve_server_database_ipv6_alt = s:taboption("dnscurve_set", Value, "dnscurve_server_database_ipv6_alt", translate("IPv6 Alternate DNS"))
dnscurve_server_database_ipv6_alt:value("d0wn-sg-ns1-ipv6")
dnscurve_server_database_ipv6_alt.rmempty = false
dnscurve_server_database_ipv6_alt:depends("dnscurve_server_input","auto")

--== Addresses ==--

---- IPv4 Main ----
dnscurve_server_addr_ipv4 = s:taboption("dnscurve_set", Value, "dnscurve_server_addr_ipv4", translate("IPv4 Main DNS Address"),
	translatef("More support for DNSCurve (DNSCrypt) servers please move "
		.. "<a href=\"%s\" target=\"_blank\">"
		.. "here</a>", "https://github.com/dyne/dnscrypt-proxy/blob/master/dnscrypt-resolvers.csv"))
dnscurve_server_addr_ipv4:value("208.67.220.220:443")
--dnscurve_server_addr_ipv4.default = "208.67.220.220:443"
dnscurve_server_addr_ipv4.rmempty = false
dnscurve_server_addr_ipv4:depends("dnscurve_server_input","manual")

dnscurve_server_addr_ipv4_prov = s:taboption("dnscurve_set", Value, "dnscurve_server_addr_ipv4_prov", translate("IPv4 Main Provider Name"))
dnscurve_server_addr_ipv4_prov:value("2.dnscrypt-cert.opendns.com")
--dnscurve_server_addr_ipv4_prov.default = "2.dnscrypt-cert.opendns.com"
dnscurve_server_addr_ipv4_prov.rmempty = false
dnscurve_server_addr_ipv4_prov:depends("dnscurve_server_input","manual")

dnscurve_server_addr_ipv4_pubkey = s:taboption("dnscurve_set", Value, "dnscurve_server_addr_ipv4_pubkey", translate("IPv4 Main Provider Public Key"))
dnscurve_server_addr_ipv4_pubkey:value("B735:1140:206F:225D:3E2B:D822:D7FD:691E:A1C3:3CC8:D666:8D0C:BE04:BFAB:CA43:FB79")
--dnscurve_server_addr_ipv4_pubkey.default = "B735:1140:206F:225D:3E2B:D822:D7FD:691E:A1C3:3CC8:D666:8D0C:BE04:BFAB:CA43:FB79"
dnscurve_server_addr_ipv4_pubkey.rmempty = false
dnscurve_server_addr_ipv4_pubkey:depends("dnscurve_server_input","manual")

---- IPv4 Alternate ----
dnscurve_server_addr_ipv4_alt = s:taboption("dnscurve_set", Value, "dnscurve_server_addr_ipv4_alt", translate("IPv4 Alternate DNS Address"))
dnscurve_server_addr_ipv4_alt:value("128.199.248.105:443")
dnscurve_server_addr_ipv4_alt.rmempty = false
dnscurve_server_addr_ipv4_alt:depends("dnscurve_server_input","manual")

dnscurve_server_addr_ipv4_alt_prov = s:taboption("dnscurve_set", Value, "dnscurve_server_addr_ipv4_alt_prov", translate("IPv4 Alternate Provider Name"))
dnscurve_server_addr_ipv4_alt_prov:value("2.dnscrypt-cert.sg.d0wn.biz")
dnscurve_server_addr_ipv4_alt_prov.rmempty = false
dnscurve_server_addr_ipv4_alt_prov:depends("dnscurve_server_input","manual")

dnscurve_server_addr_ipv4_alt_pubkey = s:taboption("dnscurve_set", Value, "dnscurve_server_addr_ipv4_alt_pubkey", translate("IPv4 Alternate Provider Public Key"))
dnscurve_server_addr_ipv4_alt_pubkey:value("D82B:2B76:1DA0:8470:B55B:820C:FAAB:9F32:D632:E9E0:5616:2CE7:7D21:E970:98FF:4A34")
dnscurve_server_addr_ipv4_alt_pubkey.rmempty = false
dnscurve_server_addr_ipv4_alt_pubkey:depends("dnscurve_server_input","manual")

---- IPv6 Main ----
dnscurve_server_addr_ipv6 = s:taboption("dnscurve_set", Value, "dnscurve_server_addr_ipv6", translate("IPv6 Main DNS Address"))
dnscurve_server_addr_ipv6:value("[2620:0:CCC::2]:443")
--dnscurve_server_addr_ipv6.default = "[2620:0:CCC::2]:443"
dnscurve_server_addr_ipv6.rmempty = false
dnscurve_server_addr_ipv6:depends("dnscurve_server_input","manual")

dnscurve_server_addr_ipv6_prov = s:taboption("dnscurve_set", Value, "dnscurve_server_addr_ipv6_prov", translate("IPv6 Main Provider Name"))
dnscurve_server_addr_ipv6_prov:value("2.dnscrypt-cert.opendns.com")
--dnscurve_server_addr_ipv6_prov.default = "2.dnscrypt-cert.opendns.com"
dnscurve_server_addr_ipv6_prov.rmempty = false
dnscurve_server_addr_ipv6_prov:depends("dnscurve_server_input","manual")

dnscurve_server_addr_ipv6_pubkey = s:taboption("dnscurve_set", Value, "dnscurve_server_addr_ipv6_pubkey", translate("IPv6 Main Provider Public Key"))
dnscurve_server_addr_ipv6_pubkey:value("B735:1140:206F:225D:3E2B:D822:D7FD:691E:A1C3:3CC8:D666:8D0C:BE04:BFAB:CA43:FB79")
--dnscurve_server_addr_ipv6_pubkey.default = "B735:1140:206F:225D:3E2B:D822:D7FD:691E:A1C3:3CC8:D666:8D0C:BE04:BFAB:CA43:FB79"
dnscurve_server_addr_ipv6_pubkey.rmempty = false
dnscurve_server_addr_ipv6_pubkey:depends("dnscurve_server_input","manual")

---- IPv6 Alternate ----
dnscurve_server_addr_ipv6_alt = s:taboption("dnscurve_set", Value, "dnscurve_server_addr_ipv6_alt", translate("IPv6 Alternate DNS Address"))
dnscurve_server_addr_ipv6_alt:value("[2400:6180:0:d0::38:d001]:443")
dnscurve_server_addr_ipv6_alt.rmempty = false
dnscurve_server_addr_ipv6_alt:depends("dnscurve_server_input","manual")

dnscurve_server_addr_ipv6_alt_prov = s:taboption("dnscurve_set", Value, "dnscurve_server_addr_ipv6_alt_prov", translate("IPv6 Alternate Provider Name"))
dnscurve_server_addr_ipv6_alt_prov:value("2.dnscrypt-cert.sg.d0wn.biz")
dnscurve_server_addr_ipv6_alt_prov.rmempty = false
dnscurve_server_addr_ipv6_alt_prov:depends("dnscurve_server_input","manual")

dnscurve_server_addr_ipv6_alt_pubkey = s:taboption("dnscurve_set", Value, "dnscurve_server_addr_ipv6_alt_pubkey", translate("IPv6 Alternate Provider Public Key"))
dnscurve_server_addr_ipv6_alt_pubkey:value("D82B:2B76:1DA0:8470:B55B:820C:FAAB:9F32:D632:E9E0:5616:2CE7:7D21:E970:98FF:4A34")
dnscurve_server_addr_ipv6_alt_pubkey.rmempty = false
dnscurve_server_addr_ipv6_alt_pubkey:depends("dnscurve_server_input","manual")


return m
