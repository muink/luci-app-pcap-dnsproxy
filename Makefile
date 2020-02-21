#
# Copyright (C) 2020 muink <https://github.com/muink>
#
# This is free software, licensed under the Apache License, Version 2.0
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

LUCI_NAME:=luci-app-pcap-dnsproxy
PKG_VERSION:=0.4.9.13-70a40bb
PKG_RELEASE:=1

LUCI_TITLE:=LuCI for pcap-dnsproxy
LUCI_DEPENDS:=+pcap-dnsproxy

LUCI_DESCRIPTION:=LuCI for Pcap_DNSProxy. Pcap_DNSProxy, A DNS Server to avoid contaminated result.

define Package/$(LUCI_NAME)/conffiles
/etc/config/pcap_dnsproxy
/etc/pcap_dnsproxy/user/
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
