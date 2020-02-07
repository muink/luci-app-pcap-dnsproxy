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


--[[ General Settings ]]--


return m
