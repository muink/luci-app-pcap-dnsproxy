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

