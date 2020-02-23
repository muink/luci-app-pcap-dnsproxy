#!/bin/sh
# Copyright (C) 2020 muink <https://github.com/muink>
# This is free software, licensed under the Apache License, Version 2.0

. /lib/functions.sh

CONFDIR=/etc/pcap-dnsproxy
RAWCONFIGFILE=$CONFDIR/Config.conf-opkg
CONFIGFILE=$CONFDIR/Config.conf
RAWHOSTSFILE=$CONFDIR/Hosts.conf-opkg
HOSTSFILE=$CONFDIR/Hosts.conf
RAWIPFILTERFILE=$CONFDIR/IPFilter.conf-opkg
IPFILTERFILE=$CONFDIR/IPFilter.conf

config_load "pcap-dnsproxy"




base_set() {
	local section="$1"
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

	sed -i "1,/^\[.*\]$/ { $command }" $CONFIGFILE

}

log_set() {
	local section="$1"
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

	sed -i "/^\[Log\]$/,/^\[.*\]$/ { $command }" $CONFIGFILE

}

listen_set() {
	local section="$1"
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

	sed -i "/^\[Listen\]$/,/^\[.*\]$/ { $command }" $CONFIGFILE

}

dns_set() {
	local section="$1"
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

	sed -i "/^\[DNS\]$/,/^\[.*\]$/ { $command }" $CONFIGFILE

}

local_dns_set() {
	local section="$1"
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

	sed -i "/^\[Local DNS\]$/,/^\[.*\]$/ { $command }" $CONFIGFILE

}

