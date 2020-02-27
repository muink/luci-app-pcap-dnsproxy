#!/bin/sh
# Copyright (C) 2020 muink <https://github.com/muink>
# This is free software, licensed under the Apache License, Version 2.0


CONF_BASE="Base"
CONF_LOG="Log"
CONF_LISTEN="Listen"
CONF_DNS="DNS"
CONF_LOCALDNS="Local DNS"
CONF_ADDRESSES="Addresses"
CONF_VALUES="Values"
CONF_SWITCHES="Switches"
CONF_DATA="Data"
CONF_PROXY="Proxy"
CONF_DNSCURVE="DNSCurve"
CONF_DNSCURVEDB="DNSCurve Database"
CONF_DNSCURVEADDR="DNSCurve Addresses"
CONF_DNSCURVEKEY="DNSCurve Keys"
CONF_DNSCURVEMAGCNUM="DNSCurve Magic Number"



# map_tab <mapname> [<variabletype>] [<element>]
# variabletype:    <uci|raw>
map_tab() {
if [ -z "$1" ]; then echo 'map_tab: The <mapname> requires an argument'; return 1; fi
local _map="$1"
local _vtype="$2"
local _element="$3"
local __cmd


# <element> not support
if   [ "$_element" == "NONE" ]; then echo 'map_tab: The <element> parameter is invalid'; return 1;
# <element> empty
elif [ -z "$_element" ]; then
	# map_tab "$CONF_DNS"						-- List  ALL  element of maptab '$CONF_DNS'; keep'NONE'
	if   [ -z "$_vtype" ]; then __cmd=;
	# map_tab "$CONF_DNS" uci					-- List 'uci' element of maptab '$CONF_DNS'; ignore uci'NONE'
	elif [ "$_vtype" == "uci" ]; then __cmd="| cut -f1 -d@ | grep -v 'NONE'";
	# map_tab "$CONF_DNS" raw					-- List 'raw' element of maptab '$CONF_DNS'; ignore raw'NONE'
	elif [ "$_vtype" == "raw" ]; then __cmd="| cut -f2 -d@ | grep -v 'NONE'";
	# <variabletype> not support
	else echo 'map_tab: The <variabletype> parameter is invalid'; return 1;
	fi
# <element> not empty
else
	# map_tab "$CONF_DNS" '' "$_element"		-- Show relative element for value '$_element' of maptab '$CONF_DNS'; keep'NONE'
	if   [ -z "$_vtype" ]; then __cmd="| sed -n -e \"/^\${_element}@/ {s/\$_element//; s/@//p}\" -e \"/@\${_element}\$/ {s/\$_element//; s/@//p}\"";
	# map_tab "$CONF_DNS" uci "$_element"		-- Show 'uci' element for value '$_element' of maptab '$CONF_DNS'; keep'NONE'
	elif [ "$_vtype" == "uci" ]; then __cmd="| sed -n -e \"/^\${_element}@/ p\" -e \"/@\${_element}\$/ p\" | cut -f1 -d@";
	# map_tab "$CONF_DNS" raw "$_element"		-- Show 'raw' element for value '$_element' of maptab '$CONF_DNS'; keep'NONE'
	elif [ "$_vtype" == "raw" ]; then __cmd="| sed -n -e \"/^\${_element}@/ p\" -e \"/@\${_element}\$/ p\" | cut -f2 -d@";
	# <variabletype> not support
	else echo 'map_tab: The <variabletype> parameter is invalid'; return 1;
	fi
fi


case "$_map" in
	'')
		echo 'map_tab: The <mapname> requires an argument'
		return 1
	;;
	"$CONF_BASE")
		eval grep \"\$_element\" <<-EOF $__cmd
			cfg_ver@Version
			cfg_refsh_time@File Refresh Time
			large_buff_size@Large Buffer Size
			additional_path@Additional Path
			hosts_cfg_name@Hosts File Name
			ipfilter_file_name@IPFilter File Name
		EOF
	;;
	"$CONF_LOG")
		eval grep \"\$_element\" <<-EOF $__cmd
			log_lev@Print Log Level
			log_max_size@Log Maximum Size
		EOF
	;;
	"$CONF_LISTEN")
		eval grep \"\$_element\" <<-EOF $__cmd
		EOF
	;;
	"$CONF_DNS")
		eval grep \"\$_element\" <<-EOF $__cmd
		EOF
	;;
	"$CONF_LOCALDNS")
		eval grep \"\$_element\" <<-EOF $__cmd
		EOF
	;;
	"$CONF_ADDRESSES")
		eval grep \"\$_element\" <<-EOF $__cmd
		EOF
	;;
	"$CONF_VALUES")
		eval grep \"\$_element\" <<-EOF $__cmd
		EOF
	;;
	"$CONF_SWITCHES")
		eval grep \"\$_element\" <<-EOF $__cmd
		EOF
	;;
	"$CONF_DATA")
		eval grep \"\$_element\" <<-EOF $__cmd
		EOF
	;;
	"$CONF_PROXY")
		eval grep \"\$_element\" <<-EOF $__cmd
		EOF
	;;
	"$CONF_DNSCURVE")
		eval grep \"\$_element\" <<-EOF $__cmd
		EOF
	;;
	"$CONF_DNSCURVEDB")
		eval grep \"\$_element\" <<-EOF $__cmd
		EOF
	;;
	"$CONF_DNSCURVEADDR")
		eval grep \"\$_element\" <<-EOF $__cmd
		EOF
	;;
	"$CONF_DNSCURVEKEY")
		eval grep \"\$_element\" <<-EOF $__cmd
		EOF
	;;
	"$CONF_DNSCURVEMAGCNUM")
		eval grep \"\$_element\" <<-EOF $__cmd
		EOF
	;;
	*)
		echo "map_tab: The Map '$_map' does not exist"
		return 1
	;;
esac








}
map_tab "$@"
