---
layout: post
title: 'How to allow Ping (ICMP) requests through the Windows Firewall'
tags: windows tricks ping icmp
---

In the inbound rules, make sure the "File and Printer Sharing (Echo Request - ICMPv4-In)" rule is enabled for the currently active profile.
- The issue may not resolve if you have a "white-listed" firewall if you've blocked both incoming/outgoing connections on your firewall by default. In that case, you need to add a custom rule to allow incoming ICMP traffic (for all apps) along with whitelisting the particular ping.exe.