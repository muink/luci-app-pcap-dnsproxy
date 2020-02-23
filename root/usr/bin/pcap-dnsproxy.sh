#!/bin/sh
# Copyright (C) 2020 muink <https://github.com/muink>
# This is free software, licensed under the Apache License, Version 2.0

. /lib/functions.sh

UCICFGFILE=pcap-dnsproxy # Package name
CONFDIR=/etc/pcap-dnsproxy
RAWCONFIGFILE=$CONFDIR/Config.conf-opkg
CONFIGFILE=$CONFDIR/Config.conf
RAWHOSTSFILE=$CONFDIR/Hosts.conf-opkg
HOSTSFILE=$CONFDIR/Hosts.conf
RAWIPFILTERFILE=$CONFDIR/IPFilter.conf-opkg
IPFILTERFILE=$CONFDIR/IPFilter.conf

_FUNCTION="$1"; shift
# _PARAMETERS: "$@"



base_set() {
	local section="$1"
	local config="$2"
	# Base
	local variable_list="\
	 cfg_ver\
	 cfg_refsh_time\
	 large_buff_size\
	 additional_path\
	 hosts_cfg_name\
	 ipfilter_file_name\
	"
	for _var in $variable_list; do local $_var; done
	for _var in $variable_list; do config_get $_ver "$section" $_ver; done


# Base
local command
if [ "$cfg_ver" != "" ];            then command="$command s@^\(Version\) =.*\$@\1 = ${cfg_ver}@;" ; fi
if [ "$cfg_refsh_time" != "" ];     then command="$command s@^\(File Refresh Time\) =.*\$@\1 = ${cfg_refsh_time}@;" ; fi
if [ "$large_buff_size" != "" ];    then command="$command s@^\(Large Buffer Size\) =.*\$@\1 = ${large_buff_size}@;" ; fi
if [ "$additional_path" != "" ];    then command="$command s@^\(Additional Path\) =.*\$@\1 = ${additional_path}@;" ; fi
if [ "$hosts_cfg_name" != "" ];     then command="$command s@^\(Hosts File Name\) =.*\$@\1 = ${hosts_cfg_name}@;" ; fi
if [ "$ipfilter_file_name" != "" ]; then command="$command s@^\(IPFilter File Name\) =.*\$@\1 = ${ipfilter_file_name}@;" ; fi

	sed -i "1,/^\[.*\]$/ { $command }" $config

}

log_set() {
	local section="$1"
	local config="$2"
	# Log
	local variable_list="\
	 log_level\
	 log_max_size\
	"
	for _var in $variable_list; do local $_var; done
	for _var in $variable_list; do config_get $_ver "$section" $_ver; done


# Log
local command
if [ "$log_lev" != "" ];      then command="$command s@^\(Print Log Level\) =.*\$@\1 = ${log_lev}@;" ; fi
if [ "$log_max_size" != "" ]; then command="$command s@^\(Log Maximum Size\) =.*\$@\1 = ${log_max_size}@;" ; fi

	sed -i "/^\[Log\]$/,/^\[.*\]$/ { $command }" $config

}

listen_set() {
	local section="$1"
	local config="$2"
	# Listen
	local variable_list="\
	 pcap_capt\
	 pcap_devices_blklist\
	 pcap_reading_timeout\
	 listen_proto\
	 listen_port\
	 operation_mode\
	"
	for _var in $variable_list; do local $_var; done
	for _var in $variable_list; do config_get $_ver "$section" $_ver; done


# Listen
local command
# if [ "$NONE" != "" ];                 then command="$command s@^\(Process Unique\) =.*\$@\1 = ${NONE}@;" ; fi
if [ "$pcap_capt" != "" ];            then command="$command s@^\(Pcap Capture\) =.*\$@\1 = ${pcap_capt}@;" ; fi
if [ "$pcap_devices_blklist" != "" ]; then command="$command s@^\(Pcap Devices Blacklist\) =.*\$@\1 = ${pcap_devices_blklist}@;" ; fi
if [ "$pcap_reading_timeout" != "" ]; then command="$command s@^\(Pcap Reading Timeout\) =.*\$@\1 = ${pcap_reading_timeout}@;" ; fi
if [ "$listen_proto" != "" ];         then command="$command s@^\(Listen Protocol\) =.*\$@\1 = ${listen_proto}@;" ; fi
if [ "$listen_port" != "" ];          then command="$command s@^\(Listen Port\) =.*\$@\1 = ${listen_port}@;" ; fi
if [ "$operation_mode" != "" ];       then command="$command s@^\(Operation Mode\) =.*\$@\1 = ${operation_mode}@;" ; fi
# if [ "$NONE" != "" ];                 then command="$command s@^\(IPFilter Type\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                 then command="$command s@^\(IPFilter Level\) [<=>]+ .*\$@\1 ${NONE} ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                 then command="$command s@^\(Accept Type\) =.*\$@\1 = ${NONE}@;" ; fi

	sed -i "/^\[Listen\]$/,/^\[.*\]$/ { $command }" $config

}

dns_set() {
	local section="$1"
	local config="$2"
	# DNS
	local variable_list="\
	 global_proto\
	 direct_req\
	 cc_type\
	 cc_parameter\
	 cc_default_ttl\
	"
	for _var in $variable_list; do local $_var; done
	for _var in $variable_list; do config_get $_ver "$section" $_ver; done


# DNS
local command
if [ "$global_proto" != "" ];   then command="$command s@^\(Outgoing Protocol\) =.*\$@\1 = ${global_proto}@;" ; fi
if [ "$direct_req" != "" ];     then command="$command s@^\(Direct Request\) =.*\$@\1 = ${direct_req}@;" ; fi
if [ "$cc_type" != "" ];        then command="$command s@^\(Cache Type\) =.*\$@\1 = ${cc_type}@;" ; fi
if [ "$cc_parameter" != "" ];   then command="$command s@^\(Cache Parameter\) =.*\$@\1 = ${cc_parameter}@;" ; fi
# if [ "$NONE" != "" ];           then command="$command s@^\(Cache Single IPv4 Address Prefix\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];           then command="$command s@^\(Cache Single IPv6 Address Prefix\) =.*\$@\1 = ${NONE}@;" ; fi
if [ "$cc_default_ttl" != "" ]; then command="$command s@^\(Default TTL\) =.*\$@\1 = ${cc_default_ttl}@;" ; fi

	sed -i "/^\[DNS\]$/,/^\[.*\]$/ { $command }" $config

}

local_dns_set() {
	local section="$1"
	local config="$2"
	# Local DNS
	local variable_list="\
	 ll_proto\
	 ll_filter_mode\
	 ll_force_req\
	"
	for _var in $variable_list; do local $_var; done
	for _var in $variable_list; do config_get $_ver "$section" $_ver; done

	local _hosts
	local _routing
	if [ "$ll_filter_mode" == "hostlist" ]; then _hosts=1; _routing=0; fi
	if [ "$ll_filter_mode" == "routing" ];  then _hosts=0; _routing=1; ll_force_req=0; fi


# Local DNS
local command
if [ "$ll_proto" != "" ];     then command="$command s@^\(Local Protocol\) =.*\$@\1 = ${ll_proto}@;" ; fi
if [ "$_hosts" != "" ];       then command="$command s@^\(Local Hosts\) =.*\$@\1 = ${_hosts}@;" ; fi
if [ "$_routing" != "" ];     then command="$command s@^\(Local Routing\) =.*\$@\1 = ${_routing}@;" ; fi
if [ "$ll_force_req" != "" ]; then command="$command s@^\(Local Force Request\) =.*\$@\1 = ${ll_force_req}@;" ; fi

	sed -i "/^\[Local DNS\]$/,/^\[.*\]$/ { $command }" $config

}

addresses_set() {
	local section="$1"
	local config="$2"
	# Addresses
	local variable_list="\
	 ipv4_listen_addr\
	 edns_client_subnet_ipv4_addr\
	 global_ipv4_addr\
	 global_ipv4_addr_alt\
	 ll_ipv4_addr\
	 ll_ipv4_addr_alt\
	 ipv6_listen_addr\
	 edns_client_subnet_ipv6_addr\
	 global_ipv6_addr\
	 global_ipv6_addr_alt\
	 ll_ipv6_addr\
	 ll_ipv6_addr_alt\
	"
	for _var in $variable_list; do local $_var; done
	for _var in $variable_list; do config_get $_ver "$section" $_ver; done


# Addresses
local command
if [ "$ipv4_listen_addr" != "" ];             then command="$command s@^\(IPv4 Listen Address\) =.*\$@\1 = ${ipv4_listen_addr}@;" ; fi
if [ "$edns_client_subnet_ipv4_addr" != "" ]; then command="$command s@^\(IPv4 EDNS Client Subnet Address\) =.*\$@\1 = ${edns_client_subnet_ipv4_addr}@;" ; fi
if [ "$global_ipv4_addr" != "" ];             then command="$command s@^\(IPv4 Main DNS Address\) =.*\$@\1 = ${global_ipv4_addr}@;" ; fi
if [ "$global_ipv4_addr_alt" != "" ];         then command="$command s@^\(IPv4 Alternate DNS Address\) =.*\$@\1 = ${global_ipv4_addr_alt}@;" ; fi
if [ "$ll_ipv4_addr" != "" ];                 then command="$command s@^\(IPv4 Local Main DNS Address\) =.*\$@\1 = ${ll_ipv4_addr}@;" ; fi
if [ "$ll_ipv4_addr_alt" != "" ];             then command="$command s@^\(IPv4 Local Alternate DNS Address\) =.*\$@\1 = ${ll_ipv4_addr_alt}@;" ; fi

if [ "$ipv6_listen_addr" != "" ];             then command="$command s@^\(IPv6 Listen Address\) =.*\$@\1 = ${ipv6_listen_addr}@;" ; fi
if [ "$edns_client_subnet_ipv6_addr" != "" ]; then command="$command s@^\(IPv6 EDNS Client Subnet Address\) =.*\$@\1 = ${edns_client_subnet_ipv6_addr}@;" ; fi
if [ "$global_ipv6_addr" != "" ];             then command="$command s@^\(IPv6 Main DNS Address\) =.*\$@\1 = ${global_ipv6_addr}@;" ; fi
if [ "$global_ipv6_addr_alt" != "" ];         then command="$command s@^\(IPv6 Alternate DNS Address\) =.*\$@\1 = ${global_ipv6_addr_alt}@;" ; fi
if [ "$ll_ipv6_addr" != "" ];                 then command="$command s@^\(IPv6 Local Main DNS Address\) =.*\$@\1 = ${ll_ipv6_addr}@;" ; fi
if [ "$ll_ipv6_addr_alt" != "" ];             then command="$command s@^\(IPv6 Local Alternate DNS Address\) =.*\$@\1 = ${ll_ipv6_addr_alt}@;" ; fi

	sed -i "/^\[Addresses\]$/,/^\[.*\]$/ { $command }" $config

}

values_set() {
	local section="$1"
	local config="$2"
	# Values
	local variable_list="\
	 reliable_once_socket_timeout\
	 reliable_serial_socket_timeout\
	 unreliable_once_socket_timeout\
	 unreliable_serial_socket_timeout\
	 tcp_fast_op\
	 receive_waiting\
	 icmp_test\
	 domain_test\
	 alt_times\
	 alt_times_range\
	 alt_reset_time\
	 mult_req_time\
	"
	for _var in $variable_list; do local $_var; done
	for _var in $variable_list; do config_get $_ver "$section" $_ver; done


# Values
local command
# if [ "$NONE" != "" ];                             then command="$command s@^\(Thread Pool Base Number\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                             then command="$command s@^\(Thread Pool Maximum Number\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                             then command="$command s@^\(Thread Pool Reset Time\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                             then command="$command s@^\(Queue Limits Reset Time\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                             then command="$command s@^\(EDNS Payload Size\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                             then command="$command s@^\(IPv4 Packet TTL\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                             then command="$command s@^\(IPv4 Main DNS TTL\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                             then command="$command s@^\(IPv4 Alternate DNS TTL\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                             then command="$command s@^\(IPv6 Packet Hop Limits\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                             then command="$command s@^\(IPv6 Main DNS Hop Limits\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                             then command="$command s@^\(IPv6 Alternate DNS Hop Limits\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                             then command="$command s@^\(Hop Limits Fluctuation\) =.*\$@\1 = ${NONE}@;" ; fi
if [ "$reliable_once_socket_timeout" != "" ];     then command="$command s@^\(Reliable Once Socket Timeout\) =.*\$@\1 = ${reliable_once_socket_timeout}@;" ; fi
if [ "$reliable_serial_socket_timeout" != "" ];   then command="$command s@^\(Reliable Serial Socket Timeout\) =.*\$@\1 = ${reliable_serial_socket_timeout}@;" ; fi
if [ "$unreliable_once_socket_timeout" != "" ];   then command="$command s@^\(Unreliable Once Socket Timeout\) =.*\$@\1 = ${unreliable_once_socket_timeout}@;" ; fi
if [ "$unreliable_serial_socket_timeout" != "" ]; then command="$command s@^\(Unreliable Serial Socket Timeout\) =.*\$@\1 = ${unreliable_serial_socket_timeout}@;" ; fi
if [ "$tcp_fast_op" != "" ];                      then command="$command s@^\(TCP Fast Open\) =.*\$@\1 = ${tcp_fast_op}@;" ; fi
if [ "$receive_waiting" != "" ];                  then command="$command s@^\(Receive Waiting\) =.*\$@\1 = ${receive_waiting}@;" ; fi
if [ "$icmp_test" != "" ];                        then command="$command s@^\(ICMP Test\) =.*\$@\1 = ${icmp_test}@;" ; fi
if [ "$domain_test" != "" ];                      then command="$command s@^\(Domain Test\) =.*\$@\1 = ${domain_test}@;" ; fi
if [ "$alt_times" != "" ];                        then command="$command s@^\(Alternate Times\) =.*\$@\1 = ${alt_times}@;" ; fi
if [ "$alt_times_range" != "" ];                  then command="$command s@^\(Alternate Time Range\) =.*\$@\1 = ${alt_times_range}@;" ; fi
if [ "$alt_reset_time" != "" ];                   then command="$command s@^\(Alternate Reset Time\) =.*\$@\1 = ${alt_reset_time}@;" ; fi
if [ "$mult_req_time" != "" ];                    then command="$command s@^\(Multiple Request Times\) =.*\$@\1 = ${mult_req_time}@;" ; fi

	sed -i "/^\[Values\]$/,/^\[.*\]$/ { $command }" $config

}

switches_set() {
	local section="$1"
	local config="$2"
	# Switches
	local variable_list="\
	 domain_case_conv\
	 compression_pointer_mutation\
	 edns_label\
	 edns_list\
	 edns_client_subnet_relay\
	 dnssec_req\
	 dnssec_force_record\
	"
	for _var in $variable_list; do local $_var; done
	for _var in $variable_list; do config_get $_ver "$section" $_ver; done

	local _edns
	if [ "$compression_pointer_mutation" != "0" ]; then _edns=0;
	else
		if [ "$edns_label" == "0" ]; then _edns=0;
		elif [ "$edns_label" == "1" ]; then _edns=1;
		else _edns="$edns_list";
		fi
	fi


# Switches
local command
if [ "$domain_case_conv" != "" ];             then command="$command s@^\(Domain Case Conversion\) =.*\$@\1 = ${domain_case_conv}@;" ; fi
if [ "$compression_pointer_mutation" != "" ]; then command="$command s@^\(Compression Pointer Mutation\) =.*\$@\1 = ${compression_pointer_mutation}@;" ; fi
if [ "$_edns" != "" ];                        then command="$command s@^\(EDNS Label\) =.*\$@\1 = ${_edns}@;" ; fi
if [ "$edns_client_subnet_relay" != "" ];     then command="$command s@^\(EDNS Client Subnet Relay\) =.*\$@\1 = ${edns_client_subnet_relay}@;" ; fi
if [ "$dnssec_req" != "" ];                   then command="$command s@^\(DNSSEC Request\) =.*\$@\1 = ${dnssec_req}@;" ; fi
if [ "$dnssec_force_record" != "" ];          then command="$command s@^\(DNSSEC Force Record\) =.*\$@\1 = ${dnssec_force_record}@;" ; fi
# if [ "$NONE" != "" ];                         then command="$command s@^\(Alternate Multiple Request\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                         then command="$command s@^\(IPv4 Do Not Fragment\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                         then command="$command s@^\(TCP Data Filter\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                         then command="$command s@^\(DNS Data Filter\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                         then command="$command s@^\(Blacklist Filter\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                         then command="$command s@^\(Resource Record Set TTL Filter\) =.*\$@\1 = ${NONE}@;

	sed -i "/^\[Switches\]$/,/^\[.*\]$/ { $command }" $config

}

data_set() {
	local section="$1"
	local config="$2"
	# Data
	local variable_list="\
	 server_domain\
	"
	for _var in $variable_list; do local $_var; done
	for _var in $variable_list; do config_get $_ver "$section" $_ver; done


# Data
local command
# if [ "$NONE" != "" ];          then command="$command s@^\(ICMP ID\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];          then command="$command s@^\(ICMP Sequence\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];          then command="$command s@^\(ICMP PaddingData\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];          then command="$command s@^\(Domain Test Protocol\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];          then command="$command s@^\(Domain Test ID\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];          then command="$command s@^\(Domain Test Data\) =.*\$@\1 = ${NONE}@;" ; fi
if [ "$server_domain" != "" ]; then command="$command s@^\(Local Machine Server Name\) =.*\$@\1 = ${server_domain}@;" ; fi

	sed -i "/^\[Data\]$/,/^\[.*\]$/ { $command }" $config

}

proxy_set() {
	local section="$1"
	local config="$2"
	# Proxy
	local variable_list="\
	 proxy_socks\
	 proxy_socks_ver\
	 proxy_socks_proto\
	 proxy_socks_nohandshake\
	 proxy_socks_ol\
	 proxy_socks_ipv4_addr\
	 proxy_socks_ipv6_addr\
	 proxy_socks_tg_serv\
	 proxy_socks_auth\
	 proxy_socks_user\
	 proxy_socks_pw\
	 proxy_http\
	 proxy_http_proto\
	 proxy_http_ol\
	 proxy_http_ipv4_addr\
	 proxy_http_ipv6_addr\
	 proxy_http_tg_serv\
	 proxy_http_ver\
	 proxy_http_auth\
	 proxy_http_user\
	 proxy_http_pw\
	"
	for _var in $variable_list; do local $_var; done
	for _var in $variable_list; do config_get $_ver "$section" $_ver; done

	local _httpauth
	if [ "$proxy_http_auth" == "1" ]; then _httpauth="${proxy_http_user}:${proxy_http_pw}"; fi
	if [ "$proxy_http_auth" == "0" ]; then _httpauth=; fi


# Proxy
local command
if [ "$proxy_socks" != "" ];             then command="$command s@^\(SOCKS Proxy\) =.*\$@\1 = ${proxy_socks}@;" ; fi
if [ "$proxy_socks_ver" != "" ];         then command="$command s@^\(SOCKS Version\) =.*\$@\1 = ${proxy_socks_ver}@;" ; fi
if [ "$proxy_socks_proto" != "" ];       then command="$command s@^\(SOCKS Protocol\) =.*\$@\1 = ${proxy_socks_proto}@;" ; fi
if [ "$proxy_socks_nohandshake" != "" ]; then command="$command s@^\(SOCKS UDP No Handshake\) =.*\$@\1 = ${proxy_socks_nohandshake}@;" ; fi
if [ "$proxy_socks_ol" != "" ];          then command="$command s@^\(SOCKS Proxy Only\) =.*\$@\1 = ${proxy_socks_ol}@;" ; fi
if [ "$proxy_socks_ipv4_addr" != "" ];   then command="$command s@^\(SOCKS IPv4 Address\) =.*\$@\1 = ${proxy_socks_ipv4_addr}@;" ; fi
if [ "$proxy_socks_ipv6_addr" != "" ];   then command="$command s@^\(SOCKS IPv6 Address\) =.*\$@\1 = ${proxy_socks_ipv6_addr}@;" ; fi
if [ "$proxy_socks_tg_serv" != "" ];     then command="$command s@^\(SOCKS Target Server\) =.*\$@\1 = ${proxy_socks_tg_serv}@;" ; fi
if [ "$proxy_socks_user" != "" ];        then command="$command s@^\(SOCKS Username\) =.*\$@\1 = ${proxy_socks_user}@;" ; fi
if [ "$proxy_socks_pw" != "" ];          then command="$command s@^\(SOCKS Password\) =.*\$@\1 = ${proxy_socks_pw}@;" ; fi
if [ "$proxy_http" != "" ];              then command="$command s@^\(HTTP CONNECT Proxy\) =.*\$@\1 = ${proxy_http}@;" ; fi
if [ "$proxy_http_proto" != "" ];        then command="$command s@^\(HTTP CONNECT Protocol\) =.*\$@\1 = ${proxy_http_proto}@;" ; fi
if [ "$proxy_http_ol" != "" ];           then command="$command s@^\(HTTP CONNECT Proxy Only\) =.*\$@\1 = ${proxy_http_ol}@;" ; fi
if [ "$proxy_http_ipv4_addr" != "" ];    then command="$command s@^\(HTTP CONNECT IPv4 Address\) =.*\$@\1 = ${proxy_http_ipv4_addr}@;" ; fi
if [ "$proxy_http_ipv6_addr" != "" ];    then command="$command s@^\(HTTP CONNECT IPv6 Address\) =.*\$@\1 = ${proxy_http_ipv6_addr}@;" ; fi
if [ "$proxy_http_tg_serv" != "" ];      then command="$command s@^\(HTTP CONNECT Target Server\) =.*\$@\1 = ${proxy_http_tg_serv}@;" ; fi
# if [ "$NONE" != "" ];                    then command="$command s@^\(HTTP CONNECT TLS Handshake\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                    then command="$command s@^\(HTTP CONNECT TLS Version\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                    then command="$command s@^\(HTTP CONNECT TLS Validation\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                    then command="$command s@^\(HTTP CONNECT TLS Server Name Indication\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                    then command="$command s@^\(HTTP CONNECT TLS ALPN\) =.*\$@\1 = ${NONE}@;" ; fi
if [ "$proxy_http_ver" != "" ];          then command="$command s@^\(HTTP CONNECT Version\) =.*\$@\1 = ${proxy_http_ver}@;" ; fi
# if [ "$NONE" != "" ];                    then command="$command s@^\(HTTP CONNECT Header Field\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                    then command="$command s@^\(HTTP CONNECT Header Field\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                    then command="$command s@^\(HTTP CONNECT Header Field\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                    then command="$command s@^\(HTTP CONNECT Header Field\) =.*\$@\1 = ${NONE}@;" ; fi
if [ "$_httpauth" != "" ];               then command="$command s@^\(HTTP CONNECT Proxy Authorization\) =.*\$@\1 = ${_httpauth}@;" ; fi

	sed -i "/^\[Proxy\]$/,/^\[.*\]$/ { $command }" $config

}

dnscurve_set() {
	local section="$1"
	local config="$2"
	# DNSCurve
	local variable_list="\
	 dnscurve\
	 dnscurve_proto\
	 dnscurve_reliable_timeout\
	 dnscurve_unreliable_timeout\
	 dnscurve_encrypted\
	 dnscurve_one_off_client_key\
	 dnscurve_key_recheck_time\
	 dnscurve_serv_input\
	 dnscurve_serv_db_ipv4\
	 dnscurve_serv_db_ipv4_alt\
	 dnscurve_serv_db_ipv6\
	 dnscurve_serv_db_ipv6_alt\
	 dnscurve_serv_addr_ipv4\
	 dnscurve_serv_addr_ipv4_alt\
	 dnscurve_serv_addr_ipv6\
	 dnscurve_serv_addr_ipv6_alt\
	 dnscurve_serv_addr_ipv4_prov\
	 dnscurve_serv_addr_ipv4_alt_prov\
	 dnscurve_serv_addr_ipv6_prov\
	 dnscurve_serv_addr_ipv6_alt_prov\
	 dnscurve_serv_addr_ipv4_pubkey\
	 dnscurve_serv_addr_ipv4_alt_pubkey\
	 dnscurve_serv_addr_ipv6_pubkey\
	 dnscurve_serv_addr_ipv6_alt_pubkey\
	"
	for _var in $variable_list; do local $_var; done
	for _var in $variable_list; do config_get $_ver "$section" $_ver; done

	if [ "$dnscurve_serv_input" == "manual" ]; then
		unset dnscurve_serv_db_ipv4
		unset dnscurve_serv_db_ipv4_alt
		unset dnscurve_serv_db_ipv6
		unset dnscurve_serv_db_ipv6_alt
	fi


# DNSCurve
local command
if [ "$dnscurve" != "" ];                    then command="$command s@^\(DNSCurve\) =.*\$@\1 = ${dnscurve}@;" ; fi
if [ "$dnscurve_proto" != "" ];              then command="$command s@^\(DNSCurve Protocol\) =.*\$@\1 = ${dnscurve_proto}@;" ; fi
# if [ "$NONE" != "" ];                        then command="$command s@^\(DNSCurve Payload Size\) =.*\$@\1 = ${NONE}@;" ; fi
if [ "$dnscurve_reliable_timeout" != "" ];   then command="$command s@^\(DNSCurve Reliable Socket Timeout\) =.*\$@\1 = ${dnscurve_reliable_timeout}@;" ; fi
if [ "$dnscurve_unreliable_timeout" != "" ]; then command="$command s@^\(DNSCurve Unreliable Socket Timeout\) =.*\$@\1 = ${dnscurve_unreliable_timeout}@;" ; fi
if [ "$dnscurve_encrypted" != "" ];          then command="$command s@^\(DNSCurve Encryption\) =.*\$@\1 = ${dnscurve_encrypted}@;" ; fi
# if [ "$NONE" != "" ];                        then command="$command s@^\(DNSCurve Encryption Only\) =.*\$@\1 = ${NONE}@;" ; fi
if [ "$dnscurve_one_off_client_key" != "" ]; then command="$command s@^\(DNSCurve Client Ephemeral Key\) =.*\$@\1 = ${dnscurve_one_off_client_key}@;" ; fi
if [ "$dnscurve_key_recheck_time" != "" ];   then command="$command s@^\(DNSCurve Key Recheck Time\) =.*\$@\1 = ${dnscurve_key_recheck_time}@;" ; fi

	sed -i "/^\[DNSCurve\]$/,/^\[.*\]$/ { $command }" $config


# DNSCurve Database
unset command
# if [ "$NONE" != "" ];                      then command="$command s@^\(DNSCurve Database Name\) =.*\$@\1 = ${NONE}@;" ; fi
if [ "$dnscurve_serv_db_ipv4" != "" ];     then command="$command s@^\(DNSCurve Database IPv4 Main DNS\) =.*\$@\1 = ${dnscurve_serv_db_ipv4}@;" ; fi
if [ "$dnscurve_serv_db_ipv4_alt" != "" ]; then command="$command s@^\(DNSCurve Database IPv4 Alternate DNS\) =.*\$@\1 = ${dnscurve_serv_db_ipv4_alt}@;" ; fi
if [ "$dnscurve_serv_db_ipv6" != "" ];     then command="$command s@^\(DNSCurve Database IPv6 Main DNS\) =.*\$@\1 = ${dnscurve_serv_db_ipv6}@;" ; fi
if [ "$dnscurve_serv_db_ipv6_alt" != "" ]; then command="$command s@^\(DNSCurve Database IPv6 Alternate DNS\) =.*\$@\1 = ${dnscurve_serv_db_ipv6_alt}@;" ; fi

	sed -i "/^\[DNSCurve Database\]$/,/^\[.*\]$/ { $command }" $config


# DNSCurve Addresses
unset command
if [ "$dnscurve_serv_addr_ipv4" != "" ];          then command="$command s@^\(DNSCurve IPv4 Main DNS Address\) =.*\$@\1 = ${dnscurve_serv_addr_ipv4}@;" ; fi
if [ "$dnscurve_serv_addr_ipv4_alt" != "" ];      then command="$command s@^\(DNSCurve IPv4 Alternate DNS Address\) =.*\$@\1 = ${dnscurve_serv_addr_ipv4_alt}@;" ; fi
if [ "$dnscurve_serv_addr_ipv6" != "" ];          then command="$command s@^\(DNSCurve IPv6 Main DNS Address\) =.*\$@\1 = ${dnscurve_serv_addr_ipv6}@;" ; fi
if [ "$dnscurve_serv_addr_ipv6_alt" != "" ];      then command="$command s@^\(DNSCurve IPv6 Alternate DNS Address\) =.*\$@\1 = ${dnscurve_serv_addr_ipv6_alt}@;" ; fi
if [ "$dnscurve_serv_addr_ipv4_prov" != "" ];     then command="$command s@^\(DNSCurve IPv4 Main Provider Name\) =.*\$@\1 = ${dnscurve_serv_addr_ipv4_prov}@;" ; fi
if [ "$dnscurve_serv_addr_ipv4_alt_prov" != "" ]; then command="$command s@^\(DNSCurve IPv4 Alternate Provider Name\) =.*\$@\1 = ${dnscurve_serv_addr_ipv4_alt_prov}@;" ; fi
if [ "$dnscurve_serv_addr_ipv6_prov" != "" ];     then command="$command s@^\(DNSCurve IPv6 Main Provider Name\) =.*\$@\1 = ${dnscurve_serv_addr_ipv6_prov}@;" ; fi
if [ "$dnscurve_serv_addr_ipv6_alt_prov" != "" ]; then command="$command s@^\(DNSCurve IPv6 Alternate Provider Name\) =.*\$@\1 = ${dnscurve_serv_addr_ipv6_alt_prov}@;" ; fi

	sed -i "/^\[DNSCurve Addresses\]$/,/^\[.*\]$/ { $command }" $config


# DNSCurve Keys
unset command
# if [ "$NONE" != "" ];                               then command="$command s@^\(DNSCurve Client Public Key\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                               then command="$command s@^\(DNSCurve Client Secret Key\) =.*\$@\1 = ${NONE}@;" ; fi
if [ "$dnscurve_serv_addr_ipv4_pubkey" != "" ];     then command="$command s@^\(DNSCurve IPv4 Main DNS Public Key\) =.*\$@\1 = ${dnscurve_serv_addr_ipv4_pubkey}@;" ; fi
if [ "$dnscurve_serv_addr_ipv4_alt_pubkey" != "" ]; then command="$command s@^\(DNSCurve IPv4 Alternate DNS Public Key\) =.*\$@\1 = ${dnscurve_serv_addr_ipv4_alt_pubkey}@;" ; fi
if [ "$dnscurve_serv_addr_ipv6_pubkey" != "" ];     then command="$command s@^\(DNSCurve IPv6 Main DNS Public Key\) =.*\$@\1 = ${dnscurve_serv_addr_ipv6_pubkey}@;" ; fi
if [ "$dnscurve_serv_addr_ipv6_alt_pubkey" != "" ]; then command="$command s@^\(DNSCurve IPv6 Alternate DNS Public Key\) =.*\$@\1 = ${dnscurve_serv_addr_ipv6_alt_pubkey}@;" ; fi
# if [ "$NONE" != "" ];                               then command="$command s@^\(DNSCurve IPv4 Main DNS Fingerprint\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                               then command="$command s@^\(DNSCurve IPv4 Alternate DNS Fingerprint\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                               then command="$command s@^\(DNSCurve IPv6 Main DNS Fingerprint\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                               then command="$command s@^\(DNSCurve IPv6 Alternate DNS Fingerprint\) =.*\$@\1 = ${NONE}@;" ; fi

	sed -i "/^\[DNSCurve Keys\]$/,/^\[.*\]$/ { $command }" $config


# DNSCurve Magic Number
unset command
# if [ "$NONE" != "" ];                     then command="$command s@^\(DNSCurve IPv4 Main Receive Magic Number\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                     then command="$command s@^\(DNSCurve IPv4 Alternate Receive Magic Number\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                     then command="$command s@^\(DNSCurve IPv6 Main Receive Magic Number\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                     then command="$command s@^\(DNSCurve IPv6 Alternate Receive Magic Number\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                     then command="$command s@^\(DNSCurve IPv4 Main DNS Magic Number\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                     then command="$command s@^\(DNSCurve IPv4 Alternate DNS Magic Number\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                     then command="$command s@^\(DNSCurve IPv6 Main DNS Magic Number\) =.*\$@\1 = ${NONE}@;" ; fi
# if [ "$NONE" != "" ];                     then command="$command s@^\(DNSCurve IPv6 Alternate DNS Magic Number\) =.*\$@\1 = ${NONE}@;" ; fi

	sed -i "/^\[DNSCurve Magic Number\]$/,$ { $command }" $config

}

uci2conf() {
	local section='uci_cfg'
	config_load $UCICFGFILE

	# Init pcap-dnsproxy Main Config file
	cp -f $RAWCONFIGFILE $CONFIGFILE 2>/dev/null

	# Apply Uci config to pcap-dnsproxy Main Config file
	# config_foreach base_set $section $CONFIGFILE
	# config_foreach log_set $section $CONFIGFILE
	config_foreach listen_set $section $CONFIGFILE
	config_foreach dns_set $section $CONFIGFILE
	config_foreach local_dns_set $section $CONFIGFILE
	config_foreach addresses_set $section $CONFIGFILE
	config_foreach values_set $section $CONFIGFILE
	config_foreach switches_set $section $CONFIGFILE
	config_foreach data_set $section $CONFIGFILE
	config_foreach proxy_set $section $CONFIGFILE
	config_foreach dnscurve_set $section $CONFIGFILE

	# Apply User config to pcap-dnsproxy Main Config file
	



}
