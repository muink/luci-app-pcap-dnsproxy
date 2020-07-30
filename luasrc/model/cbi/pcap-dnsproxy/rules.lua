-- Copyright 2017-2018 Dirk Brenken (dev@brenken.org)
-- Copyright 2020 muink <https://github.com/muink>
-- Licensed to the public under the Apache License 2.0

local uci	= require "luci.model.uci".cursor()
local fs	= require("nixio.fs")
local sys	= require("luci.sys")
local util	= require("luci.util")
local packageName = "pcap-dnsproxy"
local conf = packageName
local config = "/etc/config/" .. conf
local whiteconf = "/etc/pcap-dnsproxy/WhiteList.txt"
local routingconf = "/etc/pcap-dnsproxy/Routing.txt"
local dnscryptconf = "/etc/pcap-dnsproxy/dnscrypt-resolvers.csv"

local whitelist    = translate("WhiteList")
local routinglist  = translate("RoutingList")
local dnscryptdb   = translate("DNSCrypt DB")

local GitReq = tostring(util.trim(sys.exec("git --help >/dev/null 2>/dev/null && echo true")))
local GitReqTitle
if not GitReq or GitReq == "" then
	GitReqTitle = translate("You need install 'git-http' first")
else  
	GitReqTitle = translate("Update")
end


m = Map(conf, "")


local WhiteTime = tostring(util.trim(sys.exec("cat " .. whiteconf .. " | sed -n '4p' | cut -f2 -d: | sed -n '/[0-9]\\+-[0-9]\\+-[0-9]\\+/ p'")))
if not WhiteTime or WhiteTime == "" then WhiteTime = translate("None"); else WhiteTime = WhiteTime .. "    " .. tostring(util.trim(sys.exec("echo $(( $(grep '[^[:space:]]' '" .. whiteconf .. "' | grep -Ev '#|^\\\[' | sed -n '$=') + 0 ))"))) .. translate(" Rules"); end
local DnsCryptDBTime = tostring(util.trim(sys.exec("stat -c '%y' '" .. dnscryptconf .. "' | cut -f1 -d' '")))
if not DnsCryptDBTime or DnsCryptDBTime == "" then DnsCryptDBTime = translate("None"); end

local white_url = tostring(util.trim(sys.exec("uci get pcap-dnsproxy.@" .. conf .. "[-1].white_url 2>/dev/null")))
local alt_white_url = tostring(util.trim(sys.exec("uci get pcap-dnsproxy.@" .. conf .. "[-1].alt_white_url 2>/dev/null")))
local routing_url = tostring(util.trim(sys.exec("uci get pcap-dnsproxy.@" .. conf .. "[-1].routing_url 2>/dev/null")))
local routing_v6_url = tostring(util.trim(sys.exec("uci get pcap-dnsproxy.@" .. conf .. "[-1].routing_v6_url 2>/dev/null")))

w = m:section(TypedSection, "pcap-dnsproxy", whitelist)
w.anonymous = true

wstate = w:option(DummyValue, "_wstate", translate("Last update"))
wstate.template = packageName .. "/status"
wstate.value = WhiteTime

wclear = w:option(Button, "_wclear", translate("List Cleanup"))
wclear.inputtitle = translate("Cleanup")
wclear.inputstyle = "apply"
function wclear.write(self, section)
	fs.writefile(whiteconf, "\n")
end

wurl = w:option(ListValue, "white_url", translate("Data source"),
	translate("Fast in China but not provide Zip download"))
wurl:value("https://gitee.com/felixonmars/dnsmasq-china-list.git", "Git: " .. "dnsmasq-china-list" .. " - " .. translate("Gitee"))
wurl:value("https://code.aliyun.com/felixonmars/dnsmasq-china-list.git", "Git: " .. "dnsmasq-china-list" .. " - " .. translate("Aliyun"))
wurl:value("https://codehub.devcloud.huaweicloud.com/dnsmasq-china-list00001/dnsmasq-china-list.git", "Git: " .. "dnsmasq-china-list" .. " - " .. translate("HuaweiCloud"))
wurl.rmempty = false

wup = w:option(Button, "_wup", translate("Update ") .. whitelist)
wup.inputtitle = GitReqTitle
wup.inputstyle = "apply"
function wup.write (self, section)
	if GitReq and not (GitReq == "") and white_url and not (white_url == "") then
		sys.call ("/usr/bin/pcap-dnsproxy.sh update_white_full git '" .. white_url .. "'")
	end
end

walturl = w:option(ListValue, "alt_white_url", translate("Alternate Data source"),
	translate("Just in case if you can't use 'git-http'"))
walturl:value("https://github.com/felixonmars/dnsmasq-china-list/archive/master.zip", "Zip: " .. "dnsmasq-china-list" .. " - " .. "GitHub")
walturl:value("https://gitlab.com/felixonmars/dnsmasq-china-list/-/archive/master/dnsmasq-china-list-master.zip", "Zip: " .. "dnsmasq-china-list" .. " - " .. "GitLab")
walturl:value("https://github.com/muink/dnsmasq-china-tool/archive/list.zip", "Zip: " .. "dnsmasq-china-tool" .. " - " .. "GitHub")
walturl.rmempty = false

waltup = w:option(Button, "_waltup", translate("Alternate Update ") .. whitelist)
waltup.inputtitle = translate("Update")
waltup.inputstyle = "apply"
function waltup.write (self, section)
	if alt_white_url and not (alt_white_url == "") then
		sys.call ("/usr/bin/pcap-dnsproxy.sh update_white_full zip '" .. alt_white_url .. "'")
	end
end

--add to scheduled tasks


local RoutingTime = tostring(util.trim(sys.exec("cat " .. routingconf .. " | sed -n '5p' | cut -f2 -d: | sed -n '/[0-9]\\+-[0-9]\\+-[0-9]\\+/ p'")))
if not RoutingTime or RoutingTime == "" then RoutingTime = translate("None"); else RoutingTime = RoutingTime 
	.. "    " .. "IPv4: " .. tostring(util.trim(sys.exec("echo $(( $(sed -n '/^## IPv4/,/^## .*/ p' '" .. routingconf .. "' | grep '[^[:space:]]' | grep -Ev '#|^\\\[' | sed -n '$=') + 0 ))"))) .. translate(" Rules") 
	.. "    " .. "IPv6: " .. tostring(util.trim(sys.exec("echo $(( $(sed -n '/^## IPv6/,/^## .*/ p' '" .. routingconf .. "' | grep '[^[:space:]]' | grep -Ev '#|^\\\[' | sed -n '$=') + 0 ))"))) .. translate(" Rules");
end

r = m:section(TypedSection, "pcap-dnsproxy", routinglist)
r.anonymous = true

rstate = r:option(DummyValue, "_rstate", translate("Last update"))
rstate.template = packageName .. "/status"
rstate.value = RoutingTime

rclear = r:option(Button, "_wclear", translate("List Cleanup"))
rclear.inputtitle = translate("Cleanup")
rclear.inputstyle = "apply"
function rclear.write(self, section)
	fs.writefile(routingconf, "\n")
end

rurl = r:option(ListValue, "routing_url", translate("IPv4 Data source"))
rurl:value("https://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest", "APNIC")
rurl:value("https://www.ipdeny.com/ipblocks/data/aggregated/cn-aggregated.zone", "IPdeny")
rurl:value("https://github.com/17mon/china_ip_list/archive/master.zip", "IPIP")
rurl:value("https://github.com/metowolf/iplist/raw/master/data/special/china.txt", "CZ88")
rurl:value("https://github.com/gaoyifan/china-operator-ip/archive/ip-lists.zip", "china-operator-ip")
rurl.rmempty = false

rv6url = r:option(ListValue, "routing_v6_url", translate("IPv6 Data source"))
rv6url:value("https://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest", "APNIC")
rv6url:value("https://www.ipdeny.com/ipv6/ipaddresses/aggregated/cn-aggregated.zone", "IPdeny")
rv6url:value("https://github.com/gaoyifan/china-operator-ip/archive/ip-lists.zip", "china-operator-ip")
rv6url.rmempty = false

rup = r:option(Button, "_rup", translate("Update ") .. routinglist)
rup.inputtitle = translate("Update")
rup.inputstyle = "apply"
function rup.write (self, section)
	if routing_url and not (routing_url == "") then
		sys.call ("/usr/bin/pcap-dnsproxy.sh update_routing_full '" .. routing_url .. "' '" .. routing_v6_url .. "'")
	end
end


d = m:section(TypedSection, "pcap-dnsproxy", dnscryptdb)
d.anonymous = true

dstate = d:option(DummyValue, "_dstate", translate("Last update"))
dstate.template = packageName .. "/status"
dstate.value = DnsCryptDBTime

dup = d:option(Button, "_dup", translate("Update ") .. dnscryptdb)
dup.inputtitle = translate("Update")
dup.inputstyle = "apply"
function dup.write (self, section)
	sys.call ("curl -Lo '" .. dnscryptconf .. "' 'https://raw.githubusercontent.com/dyne/dnscrypt-proxy/master/dnscrypt-resolvers.csv'")
end

return m
