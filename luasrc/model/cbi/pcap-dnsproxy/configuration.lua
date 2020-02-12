-- Copyright 2017-2018 Dirk Brenken (dev@brenken.org)
-- Copyright 2020 muink <https://github.com/muink>
-- This is free software, licensed under the Apache License, Version 2.0

local m, s, o

local fs	= require("nixio.fs")
local util	= require("luci.util")
local input    = "/etc/pcap-dnsproxy/Config.conf-opkg"
local usrinput = "/etc/pcap-dnsproxy/user/Config.conf"
local usrcfg   = "/etc/pcap-dnsproxy/user/Config"

m = SimpleForm("pcap-dnsproxy", nil,
	translate("This form allows you to modify the content of the main pcap-dnsproxy configuration file")
	.. "<br/>"
	.. translatef("For further information "
		.. "<a href=\"%s\" target=\"_blank\">"
		.. "check the online documentation</a>", translate("https://github.com/chengr28/Pcap_DNSProxy/blob/master/Documents/ReadMe.en.txt")))
m:append(Template("pcap-dnsproxy/css"))
m.submit = translate("Save")
m.reset = false

s = m:section(SimpleSection, nil, translatef("User config file: <code>%s</code>", usrcfg))

o = s:option(TextValue, "data")
o.rows = 20

function o.cfgvalue()
	local v = fs.readfile(usrcfg) or translate("File does not exist.") .. translate(" Please check your configuration or reinstall %s.", "luci-app-pcap-dnsproxy")
	return util.trim(v) ~= "" and v or translate("Empty file.")
end

function o.write(self, section, data)
	return fs.writefile(usrcfg, "\n" .. util.trim(data:gsub("\r\n", "\n")) .. "\n")
	--生成混合文件usrinput
end

function o.remove(self, section, value)
	return fs.writefile(usrcfg, "")
end

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
