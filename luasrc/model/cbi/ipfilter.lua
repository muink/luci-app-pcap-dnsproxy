-- Copyright 2017-2018 Dirk Brenken (dev@brenken.org)
-- Copyright 2020 muink <https://github.com/muink>
-- This is free software, licensed under the Apache License, Version 2.0

local m, s, o

local fs    = require("nixio.fs")
local util  = require("luci.util")
local input    = "/etc/pcap_dnsproxy/IPFilter.raw"
local usrinput = "/etc/pcap_dnsproxy/IPFilter.conf"
local usrcfg   = "/etc/pcap_dnsproxy/user/IPFilter"

m = SimpleForm("pcap-dnsproxy", nil,
	translate("This form allows you to modify the content of the pcap-dnsproxy IPFilter config file")
	.. "<br/>"
	.. translatef("For further information "
		.. "<a href=\"%s\" target=\"_blank\">"
		.. "check the online documentation</a>", translate("https://github.com/chengr28/Pcap_DNSProxy/blob/master/Documents/ReadMe.en.txt#L891")))
m:append(Template("pcap-dnsproxy/css"))
m.submit = translate("Save")
m.reset = false

--usrcfg

s = m:section(SimpleSection, nil, translatef("Original config file: <code>%s</code>", input))

o = s:option(TextValue, "original")
o.rows = 20
o.readonly = true

function o.cfgvalue()
	local v = fs.readfile(input) or translate("File does not exist.") .. translate(" Please check your configuration or reinstall %s.", "pcap-dnsproxy")
	return util.trim(v) ~= "" and v or translate("Empty file.")
end

function s.handle(self, state, data)
	return true
end

return m
