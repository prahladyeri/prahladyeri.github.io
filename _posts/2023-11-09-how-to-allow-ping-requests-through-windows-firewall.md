---
layout: post
title: 'How to allow Ping (ICMP) requests through the Windows Firewall'
tags: windows tricks ping icmp
published: true
---

The ping.exe is a great tool provided by the Windows operating system to check and ensure if we are connected to another computer located across the Internet or even our own local LAN through the ICMP (Internet Control Message Protocol).

However, it often happens that even if the remote machine is online, the ping request fails due to firewall or other settings and throws a "General Failure" or similar error message:

![ping icmp general-failure](/uploads/ping-icmp/ping-general-failure.png)

If your Internet is working fine otherwise and you're able to browse the websites, the culprit in most cases is a Windows firewall rule which is blocking the outbound ping requests. So, head over to the Windows firewall settings through the Control Panel->Administrative Tools or by simply running the `wf.msc` tool in the run dialog. Open the outbound rules settings and you should be able to see the following three rules set for ICMPv4-Out echo requests as shown below. Make sure the "File and Printer Sharing (Echo Request - ICMPv4-Out)" rule is enabled for the currently active profile (Domain/Private/Public).

![windows firewall outbound icmp](/uploads/ping-icmp/wf-outbound.png)

Now, unless you've changed something drastically in these firewall settings, there is a good chance that that they should be enabled by default. If not, then simply enable them and your ping requests should start working after that:

![ping icmp success](/uploads/ping-icmp/ping-success.png)

Now, it might happen in some cases that enabling this firewall rule for ICMP still doesn't work and you're still getting the ping errors. This depends on whether the currently active profile for your network connection is Domain, Private or Public, and which remote machine you're trying to access here. If you observe the firewall rules closely, you'll see that only the Domain profile is allowed to make a ping request to remote websites such as google.com, other profiles are limited to ping only in the local subnet:

![ping wf-detail](/uploads/ping-icmp/wf-detail.png)

Microsoft, in their great wisdom, thought that if your connection profile is Private or Public, you shouldn't have any need to ping an Internet resource like google.com! In this case, you'll have to either change your network connection profile to Domain through the control panel, or simply add a new outbound firewall rule that allows all outbound ICMP requests. If you choose to do the latter, you can then disable the built-in rules that you enabled earlier.

Hopefully, your outbound ping requests should start working by now!