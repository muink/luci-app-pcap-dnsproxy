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
local _map="$1"
local _vtype="$2"
local _element="$3"

case "$_map" in
	'')
		echo 'map_tab: The <mapname> requires an argument'
		return 1
	;;
	"$CONF_BASE")
		echo 'You select 1'
	;;
	"$CONF_LOG")
		echo 'You select 1'
	;;
	"$CONF_LISTEN")
		echo 'You select 1'
	;;
	"$CONF_DNS")
		echo 'You select 1'
	;;
	"$CONF_LOCALDNS")
		echo 'You select 1'
	;;
	"$CONF_ADDRESSES")
		echo 'You select 1'
	;;
	"$CONF_VALUES")
		echo 'You select 1'
	;;
	"$CONF_SWITCHES")
		echo 'You select 1'
	;;
	"$CONF_DATA")
		echo 'You select 1'
	;;
	"$CONF_PROXY")
		echo 'You select 1'
	;;
	"$CONF_DNSCURVE")
		echo 'You select 1'
	;;
	"$CONF_DNSCURVEDB")
		echo 'You select 1'
	;;
	"$CONF_DNSCURVEADDR")
		echo 'You select 1'
	;;
	"$CONF_DNSCURVEKEY")
		echo 'You select 1'
	;;
	"$CONF_DNSCURVEMAGCNUM")
		echo 'You select 1'
	;;
	*)
		echo "map_tab: Map '$_map' does not exist"
		return 1
	;;
esac








}
