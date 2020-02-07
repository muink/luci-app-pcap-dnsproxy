-- Copyright 2017-2018 Dirk Brenken (dev@brenken.org)
-- Copyright 2020 muink <https://github.com/muink>
-- This is free software, licensed under the Apache License, Version 2.0

local fs    = require("nixio.fs")
local util  = require("luci.util")
local input = "/tmp/pcap-dnsproxy-error.log"

if not fs.access(input) then
	m = SimpleForm("error", nil, translate("No pcap-dnsproxy error logs yet!"))
	m.reset = false
	m.submit = false
	return m
end

if fs.stat(input).size >= 102400 then
	m = SimpleForm("error", nil,
		translate("The file size is too large for online editing in LuCI (&ge; 100 KB). ")
		.. translate("Please edit this file directly in a terminal session."))
	m.reset = false
	m.submit = false
	return m
end

m = SimpleForm("input", nil)
m:append(Template("pcap-dnsproxy/css"))
m.reset = false
m.submit = false

s = m:section(SimpleSection, nil,
	translate("The following error logs is generated by pcap-dnsproxy. ")
	.. translatef("For further information "
		.. "<a href=\"%s\" target=\"_blank\">"
		.. "check the online documentation</a>", "https://github.com/chengr28/Pcap_DNSProxy/blob/master/Documents/FAQ.en.txt"))

f = s:option(TextValue, "data")
f.rows = 20
f.readonly = "readonly"

function f.cfgvalue()
	return fs.readfile(input) or ""
end

function s.handle(self, state, data)
	return true
end

return m
