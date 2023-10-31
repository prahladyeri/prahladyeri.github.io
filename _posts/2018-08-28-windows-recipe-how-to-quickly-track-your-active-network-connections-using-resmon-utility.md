---
layout: post
title: "Windows recipe: How to quickly track your active network connections using resmon utility"
tags: windows utility
---

Windows 10 is a great operating system when its clean and well-maintained but once you start cluttering it with more and more apps, your Internet speed typically starts to slow down and it becomes increasingly difficult to find out which background app is consuming your bandwidth.<!--more-->

One way of tackling this is to harden the windows firewall by restricting outgoing TCP connections too (incoming are already restricted by default). But this is quite cumbersome in the long run as you will have to whitelist each and every executable that needs to access the internet which can be a difficult and time consuming task.

Another quick way of finding out which app is consuming your most bandwidth (whether on the background or foreground) is to fire up the **Windows Resource Monitor** by running **resmon.exe** which is a nice Windows utility program that comes by default. By clicking on the Network tab and expanding the Network Activity pane, you'll come to know exactly how much bandwidth each executable is eating on your system!

![Resource Monitor](/uploads/2018/08/resmon.png)

**Resource Monitor (resmon.exe) running on Windows**

Once you know the culprit EXE causing the bandwidth drain, you can either uninstall that app or block it in the windows firewall. All in all, resmon.exe is a great utility in the hands of the Windows power user who wants to take control of his/her operating system. I hope you find this utility useful.
