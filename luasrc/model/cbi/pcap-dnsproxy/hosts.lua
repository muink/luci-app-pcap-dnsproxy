-- Copyright 2017-2018 Dirk Brenken (dev@brenken.org)
-- Copyright 2020 muink <https://github.com/muink>
-- This is free software, licensed under the Apache License, Version 2.0

local fs    = require("nixio.fs")
local util  = require("luci.util")
local input = "/etc/pcap-dnsproxy/Hosts.conf"

if not fs.access(input) then
	m = SimpleForm("error", nil, translate("Config file not found, please check your configuration."))
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
m.submit = translate("Save")
m.reset = false

s = m:section(SimpleSection, nil,
	translate("This form allows you to modify the content of the pcap-dnsproxy Hosts configuration file (")
		.. translate(input)
		.. translate(").")
	.. "<br/>"
	.. translatef("For further information "
		.. "<a href=\"%s\" target=\"_blank\">"
		.. "check the online documentation</a>", "https://github.com/chengr28/Pcap_DNSProxy/blob/master/Documents/ReadMe.en.txt#L706"))

f = s:option(TextValue, "data")
f.rows = 20

function f.cfgvalue()
	return fs.readfile(input) or ""
end

function f.write(self, section, data)
	return fs.writefile(input, "\n" .. util.trim(data:gsub("\r\n", "\n")) .. "\n")
end

function f.remove(self, section, value)
	return fs.writefile(input, "")
end

function s.handle(self, state, data)
	return true
end

return m
