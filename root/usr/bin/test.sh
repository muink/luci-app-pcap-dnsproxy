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
			ll_filter_mode@__FUNCTION 'if [ "\$ll_filter_mode" == "0" ]; then echo Local Hosts=0; echo Local Routing=0; ll_force_req=0; elif [ "\$ll_filter_mode" == "hostlist" ]; then echo Local Hosts=1; echo Local Routing=0; elif [ "\$ll_filter_mode" == "routing" ]; then echo Local Hosts=0; echo Local Routing=1; ll_force_req=0; fi'
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
			compression_pointer_mutation@Compression Pointer Mutation
			edns_label@__FUNCTION 'if [ "\$edns_label" == "0" ]; then echo EDNS Label=0; elif [ "\$edns_label" == "1" ]; then echo EDNS Label=1; elif [ "\$edns_label" == "2" ]; then echo EDNS Label=\$edns_list; fi'
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
