-- Copyright 2020 muink <https://github.com/muink>
-- Licensed to the public under the Apache License 2.0

module("luci.controller.pcap-dnsproxy", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pcap_dnsproxy") then
		return
	end

	entry({"admin", "network", "pcap-dnsproxy"}, firstchild(), _("Pcap_DNSProxy Server"), 30).dependent = false
	--entry({"admin", "network", "pcap-dnsproxy", "overview"}, template("pcap-dnsproxy/helloworld"), _("Overview"), 1).leaf = true
	entry({"admin", "network", "pcap-dnsproxy", "general"}, cbi("pcap-dnsproxy/general"), _("General Settings"), 3).leaf = true

	entry({"admin", "network", "pcap-dnsproxy", "advanced"}, firstchild(), _("Advanced"), 4)
	entry({"admin", "network", "pcap-dnsproxy", "advanced", "configuration"}, form("pcap-dnsproxy/configuration"), _("Edit Configuration"), 1).leaf = true
	entry({"admin", "network", "pcap-dnsproxy", "advanced", "hosts"}, form("pcap-dnsproxy/hosts"), _("Edit Hosts"), 4).leaf = true
	entry({"admin", "network", "pcap-dnsproxy", "advanced", "ipfilter"}, form("pcap-dnsproxy/ipfilter"), _("Edit IPFilter"), 5).leaf = true
	entry({"admin", "network", "pcap-dnsproxy", "advanced", "dnscrypt_database"}, template("pcap-dnsproxy/helloworld"), _("Update DNSCrypt database"), 6).leaf = true
	entry({"admin", "network", "pcap-dnsproxy", "advanced", "routing"}, template("pcap-dnsproxy/helloworld"), _("Update Routing"), 10).leaf = true
	entry({"admin", "network", "pcap-dnsproxy", "advanced", "whitelist"}, template("pcap-dnsproxy/helloworld"), _("Update WhiteList"), 11).leaf = true

	entry({"admin", "network", "pcap-dnsproxy", "log"}, firstchild(), _("Logfile"), 6)
	--entry({"admin", "network", "pcap-dnsproxy", "log", "logread"}, call("read_log"), _("Logfile"), 1).leaf = true
	entry({"admin", "network", "pcap-dnsproxy", "log"}, form("pcap-dnsproxy/logfile"), _("Logfile"), 6).leaf = true

	entry({"admin", "network", "pcap-dnsproxy", "action"}, call("pcap_dnsproxy_action")).leaf = true
	--entry({"admin", "network", "pcap-dnsproxy", "status"}, call("action_status")).leaf = true
end


function pcap_dnsproxy_action(name)
	local packageName = "pcap_dnsproxy"
	if name == "start" then
		luci.sys.init.start(packageName)
	elseif name == "action" then
		luci.util.exec("/etc/init.d/" .. packageName .. " reload >/dev/null 2>&1")
		luci.util.exec("/etc/init.d/dnsmasq restart >/dev/null 2>&1")
	elseif name == "stop" then
		luci.sys.init.stop(packageName)
	elseif name == "enable" then
		--luci.sys.init.enable(packageName)
		luci.util.exec("uci set " .. packageName .. ".@pcap-dnsproxy[-1].enabled=1; uci commit " .. packageName)
	elseif name == "disable" then
		--luci.sys.init.disable(packageName)
		luci.util.exec("uci set " .. packageName .. ".@pcap-dnsproxy[-1].enabled=0; uci commit " .. packageName)
	end
	luci.http.prepare_content("text/plain")
	luci.http.write("0")
end

--[[
function read_log()
    local lcldata = luci.util.exec("logread -e 'Pcap_DNSProxy'")
    local lcldesc = luci.i18n.translate(
        "This shows syslog filtered for events involving Pcap_DNSProxy.")

    luci.template.render("pcap-dnsproxy/show-textbox",
        {heading = "", description = lcldesc, content = lcldata})
end
function action_status()
  local e={}
  e.running=luci.sys.call("busybox ps -w | grep UnblockNeteaseMusic/app.js | grep -v grep >/dev/null")==0
  luci.http.prepare_content("application/json")
  luci.http.write_json(e)
end]]--
