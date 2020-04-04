#!/bin/bash
# Copyright (C) 2020 muink <https://github.com/muink>
# This is free software, licensed under the Apache License, Version 2.0

. /lib/functions.sh

UCICFGFILE=pcap-dnsproxy # Package name
TYPEDSECTION=main
CONFDIR=/etc/pcap-dnsproxy

RAWCONFIGFILE=$CONFDIR/Config.conf-opkg
CONFIGFILE=$CONFDIR/Config.conf
RAWHOSTSFILE=$CONFDIR/Hosts.conf-opkg
HOSTSFILE=$CONFDIR/Hosts.conf
RAWIPFILTERFILE=$CONFDIR/IPFilter.conf-opkg
IPFILTERFILE=$CONFDIR/IPFilter.conf

_FUNCTION="$1"; shift
# _PARAMETERS: "$@"



# map_def [<type>]
# type:    <nam|map>
map_def() {
local __cmd

# map_def					-- List  ALL  element
if   [ -z "$1" ]; then __cmd=;
# map_def nam				-- List 'nam' element
elif [ "$1" == "nam" ]; then __cmd="| cut -f1 -d=";
# map_def map				-- List 'map' element
elif [ "$1" == "map" ]; then __cmd="| cut -f2 -d=";
# <type> not support
else echo 'map_def: The <type> parameter is invalid'; return 1;
fi

# Map name list
eval cat <<-MAPLIST $__cmd
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
MAPLIST
}

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
	# map_tab "$CONF_DNS"						-- List  ALL  element of maptab '$CONF_DNS'; keep'NONE'; keep function
	if   [ -z "$_vtype" ]; then __cmd=;
	# map_tab "$CONF_DNS" uci					-- List 'uci' element of maptab '$CONF_DNS'; ignore uci'NONE'; ignore raw2uci function
	elif [ "$_vtype" == "uci" ]; then __cmd="| cut -f1 -d@ | grep -v '^NONE$' | grep -v '^_.\+'";
	# map_tab "$CONF_DNS" raw					-- List 'raw' element of maptab '$CONF_DNS'; ignore raw'NONE'; ignore uci2raw function
	elif [ "$_vtype" == "raw" ]; then __cmd="| cut -f2 -d@ | grep -v '^NONE$' | grep -v '^_.\+'";
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
			NONE@Process Unique
			pcap_capt@Pcap Capture
			pcap_devices_blklist@Pcap Devices Blacklist
			pcap_reading_timeout@Pcap Reading Timeout
			listen_proto@Listen Protocol
			listen_port@Listen Port
			operation_mode@Operation Mode
			NONE@IPFilter Type
			NONE@IPFilter Level
			NONE@Accept Type
		EOF
	;;
	"$CONF_DNS")
		eval grep \"\$_element\" <<-EOF $__cmd
			global_proto@Outgoing Protocol
			direct_req@Direct Request
			cc_type@Cache Type
			cc_parameter@Cache Parameter
			NONE@Cache Single IPv4 Address Prefix
			NONE@Cache Single IPv6 Address Prefix
			cc_default_ttl@Default TTL
		EOF
	;;
	"$CONF_LOCALDNS")
		eval grep \"\$_element\" <<-EOF $__cmd
			ll_proto@Local Protocol
			ll_filter_mode@__FUNCTION='if [ "\$ll_filter_mode" == "0" ]; then echo Local Hosts=0; echo Local Routing=0; ll_force_req=0; elif [ "\$ll_filter_mode" == "hostlist" ]; then echo Local Hosts=1; echo Local Routing=0; elif [ "\$ll_filter_mode" == "routing" ]; then echo Local Hosts=0; echo Local Routing=1; ll_force_req=0; fi'
			__LLFILTER@Local Hosts
			__LLFILTER@Local Routing
			ll_force_req@Local Force Request
		EOF
	;;
	"$CONF_ADDRESSES")
		eval grep \"\$_element\" <<-EOF $__cmd
			ipv4_listen_addr@IPv4 Listen Address
			edns_client_subnet_ipv4_addr@IPv4 EDNS Client Subnet Address
			global_ipv4_addr@IPv4 Main DNS Address
			global_ipv4_addr_alt@IPv4 Alternate DNS Address
			ll_ipv4_addr@IPv4 Local Main DNS Address
			ll_ipv4_addr_alt@IPv4 Local Alternate DNS Address
			ipv6_listen_addr@IPv6 Listen Address
			edns_client_subnet_ipv6_addr@IPv6 EDNS Client Subnet Address
			global_ipv6_addr@IPv6 Main DNS Address
			global_ipv6_addr_alt@IPv6 Alternate DNS Address
			ll_ipv6_addr@IPv6 Local Main DNS Address
			ll_ipv6_addr_alt@IPv6 Local Alternate DNS Address
		EOF
	;;
	"$CONF_VALUES")
		eval grep \"\$_element\" <<-EOF $__cmd
			NONE@Thread Pool Base Number
			NONE@Thread Pool Maximum Number
			NONE@Thread Pool Reset Time
			NONE@Queue Limits Reset Time
			NONE@EDNS Payload Size
			NONE@IPv4 Packet TTL
			NONE@IPv4 Main DNS TTL
			NONE@IPv4 Alternate DNS TTL
			NONE@IPv6 Packet Hop Limits
			NONE@IPv6 Main DNS Hop Limits
			NONE@IPv6 Alternate DNS Hop Limits
			NONE@Hop Limits Fluctuation
			reliable_once_socket_timeout@Reliable Once Socket Timeout
			reliable_serial_socket_timeout@Reliable Serial Socket Timeout
			unreliable_once_socket_timeout@Unreliable Once Socket Timeout
			unreliable_serial_socket_timeout@Unreliable Serial Socket Timeout
			tcp_fast_op@TCP Fast Open
			receive_waiting@Receive Waiting
			icmp_test@ICMP Test
			domain_test@Domain Test
			alt_times@Alternate Times
			alt_times_range@Alternate Time Range
			alt_reset_time@Alternate Reset Time
			mult_req_time@Multiple Request Times
		EOF
	;;
	"$CONF_SWITCHES")
		eval grep \"\$_element\" <<-EOF $__cmd
			domain_case_conv@Domain Case Conversion
			header_processing@__FUNCTION='if [ "\$header_processing" == "0" ]; then compression_pointer_mutation=0; edns_label=0; elif [ "\$header_processing" == "cpm" ]; then edns_label=0; elif [ "\$header_processing" == "edns" ]; then compression_pointer_mutation=0; fi'
			compression_pointer_mutation@Compression Pointer Mutation
			edns_label@__FUNCTION='if [ "\$edns_label" == "0" ]; then echo EDNS Label=0; elif [ "\$edns_label" == "1" ]; then echo EDNS Label=1; elif [ "\$edns_label" == "2" ]; then echo EDNS Label=\$edns_list; fi'
			edns_list@NONE
			__EDNS@EDNS Label
			edns_client_subnet_relay@EDNS Client Subnet Relay
			dnssec_req@DNSSEC Request
			dnssec_force_record@DNSSEC Force Record
			NONE@Alternate Multiple Request
			NONE@IPv4 Do Not Fragment
			NONE@TCP Data Filter
			NONE@DNS Data Filter
			NONE@Blacklist Filter
			NONE@Resource Record Set TTL Filter
		EOF
	;;
	"$CONF_DATA")
		eval grep \"\$_element\" <<-EOF $__cmd
			NONE@ICMP ID
			NONE@ICMP Sequence
			NONE@ICMP PaddingData
			NONE@Domain Test Protocol
			NONE@Domain Test ID
			NONE@Domain Test Data
			server_domain@Local Machine Server Name
		EOF
	;;
	"$CONF_PROXY")
		eval grep \"\$_element\" <<-EOF $__cmd
			proxy_socks@SOCKS Proxy
			proxy_socks_ver@SOCKS Version
			proxy_socks_proto@SOCKS Protocol
			proxy_socks_nohandshake@SOCKS UDP No Handshake
			proxy_socks_ol@SOCKS Proxy Only
			proxy_socks_ipv4_addr@SOCKS IPv4 Address
			proxy_socks_ipv6_addr@SOCKS IPv6 Address
			proxy_socks_tg_serv@SOCKS Target Server
			proxy_socks_user@SOCKS Username
			proxy_socks_pw@SOCKS Password
			proxy_http@HTTP CONNECT Proxy
			proxy_http_proto@HTTP CONNECT Protocol
			proxy_http_ol@HTTP CONNECT Proxy Only
			proxy_http_ipv4_addr@HTTP CONNECT IPv4 Address
			proxy_http_ipv6_addr@HTTP CONNECT IPv6 Address
			proxy_http_tg_serv@HTTP CONNECT Target Server
			NONE@HTTP CONNECT TLS Handshake
			NONE@HTTP CONNECT TLS Version
			NONE@HTTP CONNECT TLS Validation
			NONE@HTTP CONNECT TLS Server Name Indication
			NONE@HTTP CONNECT TLS ALPN
			proxy_http_ver@HTTP CONNECT Version
			NONE@HTTP CONNECT Header Field
			NONE@HTTP CONNECT Header Field
			NONE@HTTP CONNECT Header Field
			NONE@HTTP CONNECT Header Field
			proxy_http_auth@__FUNCTION='if [ "\$proxy_http_auth" == "0" ]; then echo HTTP CONNECT Proxy Authorization=; elif [ "\$proxy_http_auth" == "1" ]; then echo HTTP CONNECT Proxy Authorization=\$proxy_http_user:\$proxy_http_pw; fi'
			proxy_http_user@NONE
			proxy_http_pw@NONE
			__PROXYHTTPAUTH@HTTP CONNECT Proxy Authorization
		EOF
	;;
	"$CONF_DNSCURVE")
		eval grep \"\$_element\" <<-EOF $__cmd
			dnscurve@DNSCurve
			dnscurve_proto@DNSCurve Protocol
			NONE@DNSCurve Payload Size
			dnscurve_reliable_timeout@DNSCurve Reliable Socket Timeout
			dnscurve_unreliable_timeout@DNSCurve Unreliable Socket Timeout
			dnscurve_encrypted@DNSCurve Encryption
			NONE@DNSCurve Encryption Only
			dnscurve_one_off_client_key@DNSCurve Client Ephemeral Key
			dnscurve_key_recheck_time@DNSCurve Key Recheck Time
		EOF
	;;
	"$CONF_DNSCURVEDB")
		eval grep \"\$_element\" <<-EOF $__cmd
			NONE@DNSCurve Database Name
			dnscurve_serv_db_ipv4@DNSCurve Database IPv4 Main DNS
			dnscurve_serv_db_ipv4_alt@DNSCurve Database IPv4 Alternate DNS
			dnscurve_serv_db_ipv6@DNSCurve Database IPv6 Main DNS
			dnscurve_serv_db_ipv6_alt@DNSCurve Database IPv6 Alternate DNS
		EOF
	;;
	"$CONF_DNSCURVEADDR")
		eval grep \"\$_element\" <<-EOF $__cmd
			dnscurve_serv_addr_ipv4@DNSCurve IPv4 Main DNS Address
			dnscurve_serv_addr_ipv4_alt@DNSCurve IPv4 Alternate DNS Address
			dnscurve_serv_addr_ipv6@DNSCurve IPv6 Main DNS Address
			dnscurve_serv_addr_ipv6_alt@DNSCurve IPv6 Alternate DNS Address
			dnscurve_serv_addr_ipv4_prov@DNSCurve IPv4 Main Provider Name
			dnscurve_serv_addr_ipv4_alt_prov@DNSCurve IPv4 Alternate Provider Name
			dnscurve_serv_addr_ipv6_prov@DNSCurve IPv6 Main Provider Name
			dnscurve_serv_addr_ipv6_alt_prov@DNSCurve IPv6 Alternate Provider Name
		EOF
	;;
	"$CONF_DNSCURVEKEY")
		eval grep \"\$_element\" <<-EOF $__cmd
			NONE@DNSCurve Client Public Key
			NONE@DNSCurve Client Secret Key
			dnscurve_serv_addr_ipv4_pubkey@DNSCurve IPv4 Main DNS Public Key
			dnscurve_serv_addr_ipv4_alt_pubkey@DNSCurve IPv4 Alternate DNS Public Key
			dnscurve_serv_addr_ipv6_pubkey@DNSCurve IPv6 Main DNS Public Key
			dnscurve_serv_addr_ipv6_alt_pubkey@DNSCurve IPv6 Alternate DNS Public Key
			NONE@DNSCurve IPv4 Main DNS Fingerprint
			NONE@DNSCurve IPv4 Alternate DNS Fingerprint
			NONE@DNSCurve IPv6 Main DNS Fingerprint
			NONE@DNSCurve IPv6 Alternate DNS Fingerprint
		EOF
	;;
	"$CONF_DNSCURVEMAGCNUM")
		eval grep \"\$_element\" <<-EOF $__cmd
			NONE@DNSCurve IPv4 Main Receive Magic Number
			NONE@DNSCurve IPv4 Alternate Receive Magic Number
			NONE@DNSCurve IPv6 Main Receive Magic Number
			NONE@DNSCurve IPv6 Alternate Receive Magic Number
			NONE@DNSCurve IPv4 Main DNS Magic Number
			NONE@DNSCurve IPv4 Alternate DNS Magic Number
			NONE@DNSCurve IPv6 Main DNS Magic Number
			NONE@DNSCurve IPv6 Alternate DNS Magic Number
		EOF
	;;
	*)
		echo "map_tab: The Map '$_map' does not exist"
		return 1
	;;
esac




}

# uci2conf <section> <mapname> <conffile>
uci2conf() {
	local initvar=(section map config)
	for _var in "${initvar[@]}"; do
		if [ -z "$1" ]; then echo "uci2conf: The <$_var> requires an argument"; return 1;
		else eval "local \$_var=\"\$1\"" && shift; fi
	done

	
# Defining variables for uci config
#cat <<< `map_tab "$@"` | sed -n "s/^\(.*\)/'\1/; s/\(.*\)$/\1'/ p"
local uci_list=`map_tab "$map" uci | sed -n "s/^\(.*\)/'\1/; s/\(.*\)$/\1'/ p"` # "$@"
	eval uci_list=(${uci_list//'/\'})
local uci_count=${#uci_list[@]}
# Get values of uci config
for _var in "${uci_list[@]}"; do local $_var; config_get "$_var" "$section" "$_var"; done
#eval "config_set \"\$section\" \"\$_var\" \"\$$_var\"" # Only set to environment variables


# Write $config file
local command
local araw_list
local _raw
local __FUNCTION

for _var in "${uci_list[@]}"; do
	# <$_var> not empty AND <$$_var> not empty
	if [ -n "$_var" -a -n "$(eval echo \$$_var)" ]; then

		_raw=`map_tab "$map" raw "$_var"` # ~~Also need process DynamicList like: 'HTTP CONNECT Header Field'~~ Consider not adding, can only added them from user conffile

		# <$_raw> returns not empty
		if [ -n "$_raw" ]; then
			# Not Normal uci element
			if   [ "`echo "$_raw" | grep "^__.\+$"`" ]; then
				# Function uci element
				eval "$_raw" # Extract function body
					#eval "echo '$__FUNCTION'"
				eval "$__FUNCTION" >/dev/null
				araw_list=`eval "$__FUNCTION" | sed -n "s/^\(.*\)/'\1/; s/\(.*\)$/\1'/ p"` # "$@"
					eval araw_list=(${araw_list//'/\'})
                
				# Write Function conf
				for _tab in "${araw_list[@]}"; do
					command="$command s~^\($(echo "$_tab" | cut -f1 -d=)\) \([<=>]\).*\$~\1 \2 $(echo "$_tab" | cut -f2 -d=)~;"
					#echo "$(echo "$_tab" | cut -f1 -d=) -- $(echo "$_tab" | cut -f2 -d=)" #debug test
				done
			# All-in-one uci element
			elif [ "$_raw" == "NONE" ]; then
				echo "Usually used to combine multiple uci parameters into one raw parameter" >/dev/null
			# Normal uci element
			else
				# Write Normal conf
				eval "_var=\"\$$_var\""
				command="$command s~^\($_raw\) \([<=>]\).*\$~\1 \2 ${_var}~;"
				#echo "Normal: ${_raw} = ${_var}" #debug test
			fi
		# <$_raw> returns empty
		else
			echo "uci2conf: The Element '$_var' not have relative element"; return 1
			echo "This situation basically does not exist" >/dev/null
		fi
	
	# <$_var> returns empty
	else
		echo "uci2conf: The Element '$_var' is empty" >/dev/null
	fi
done
		#echo "$command"

	if   [ "$map" == "$(eval echo \$$CONF_LIST_FIRST)" ]; then sed -i "1,/^\[.*\]$/            { $command }" $config;
	elif [ "$map" == "$(eval echo \$$CONF_LIST_LAST)" ]; then  sed -i "/^\[$map\]$/,$          { $command }" $config;
	else                                                       sed -i "/^\[$map\]$/,/^\[.*\]$/ { $command }" $config;
	fi

}

# conf2uci <section> <mapname> <conffile> <pkgname>
conf2uci() {
	local initvar=(section map config pkgnm)
	for _var in "${initvar[@]}"; do
		if [ -z "$1" ]; then echo "uci2conf: The <$_var> requires an argument"; return 1;
		else eval "local \$_var=\"\$1\"" && shift; fi
	done

	
# Defining variables for conffile
#cat <<< `map_tab "$@"` | sed -n "s/^\(.*\)/'\1/; s/\(.*\)$/\1'/ p"
local raw_list=`map_tab "$map" raw | sed -n "s/^\(.*\)/'\1/; s/\(.*\)$/\1'/ p"` # "$@"
	eval raw_list=(${raw_list//'/\'})
local raw_count=${#raw_list[@]}
#for _ll in "${raw_list[@]}"; do echo "$_ll"; done


# Write uci settings $section
local command
local araw_list
local _uci
local _value
local __FUNCTION

for _var in "${raw_list[@]}"; do

	_uci=`map_tab "$map" uci "$_var"`

	# <$_var> not empty AND relative uci element not empty
	if [ -n "$_var" -a -n "$_uci" ]; then

		_value="$(sed -n "/^\[${map}\]$/,/^\[.*\]$/ { s~^${_var} [<=>] *\(.*\)$~\1~ p }" $config)"

		# Not Normal raw element
		if   [ "`echo "$_uci" | grep "^__.\+$"`" ]; then
			# Function raw element
			eval "$_uci" # Extract function body
				#eval "echo '$__FUNCTION'"
			eval "$__FUNCTION" >/dev/null
			araw_list=`eval "$__FUNCTION" | sed -n "s/^\(.*\)/'\1/; s/\(.*\)$/\1'/ p"` # "$@"
				eval araw_list=(${araw_list//'/\'})
            
			# Write Function conf
			for _tab in "${araw_list[@]}"; do
				uci_set "$pkgnm" "$section" "$(echo "$_tab" | cut -f1 -d=)" "$(echo "$_tab" | cut -f2 -d=)"
				#echo "Function: $(echo "$_tab" | cut -f1 -d=) = $(echo "$_tab" | cut -f2 -d=)" #debug test
			done
		# Undefined raw element
		elif [ "$_uci" == "NONE" ]; then
			echo "The relative uci element value of \"$_raw\" is undefined" >/dev/null
		# Normal raw element
		else
			# Write Normal uci
			uci_set "$pkgnm" "$section" "$_uci" "$_value"
			#echo "Normal: ${_uci} = ${_value}" #debug test
		fi

	# <$_var> OR <$_uci> returns empty
	else
		echo "conf2uci: The Element \"$_var\" not exist or not have relative element"; return 1
		echo "This situation basically does not exist" >/dev/null
	fi
done

	uci_commit

}

uci2conf_full() {
	local TypedSection="$TYPEDSECTION"
	local ConfigFile="$CONFIGFILE"
	config_load $UCICFGFILE

	# Init pcap-dnsproxy Main Config file
	cp -f $RAWCONFIGFILE $CONFIGFILE 2>/dev/null

	# Apply Uci config to pcap-dnsproxy Main Config file
	for _conf in "${CONF_LIST[@]}"; do
		eval "config_foreach uci2conf \"\$TypedSection\" \"\$$_conf\" \"\$ConfigFile\""
	done

	# Apply User config to pcap-dnsproxy Main Config file
	

}

conf2uci_full() {
	local PackageName="$UCICFGFILE"
	local TypedSection="@$TYPEDSECTION[-1]"
	local ConfigFile="$CONFIGFILE"

	# Clear ${PackageName}.${TypedSection}
	uci_remove "$PackageName" "$TypedSection"
	uci_add    "$PackageName" "$TYPEDSECTION"

	# Apply pcap-dnsproxy Main Config file to Uci config
	for _conf in "${CONF_LIST[@]}"; do
		eval "conf2uci \"\$TypedSection\" \"\$$_conf\" \"\$ConfigFile\" \"\$PackageName\""
	done

}

reset_conf_full() {

	# Reset pcap-dnsproxy Main Config file
	cp -f $RAWCONFIGFILE $CONFIGFILE 2>/dev/null

	# Reset pcap-dnsproxy Uci Config
	conf2uci_full

}


# ================ Main ================ #

# Define Map name list
CONF_LIST=`map_def nam | sed -n "s/^\(.*\)/'\1/; s/\(.*\)$/\1'/ p"` # "$@"
	eval CONF_LIST=(${CONF_LIST//'/\'})
CONF_LIST_COUNT=${#CONF_LIST[@]}
     CONF_LIST_FIRST=${CONF_LIST[0]}
eval CONF_LIST_LAST=\${CONF_LIST[$((${CONF_LIST_COUNT}-1))]}

# Define Map name and values
for _var in "`map_def`"; do eval "${_var[@]}"; done
	#for _var in "${CONF_LIST[@]}"; do eval echo $_var=\\\"\$$_var\\\"; done





#Y:map_def     for _conf in "${CONF_LIST[@]}"; do eval "map_tab \"\$$_conf\""; done
#Y:map_tab     map_tab "$@"
#config_get bbt
#Y:uci2conf    uci2conf 'cfg34fb357e' "$CONF_LOCALDNS" './test.conf'

