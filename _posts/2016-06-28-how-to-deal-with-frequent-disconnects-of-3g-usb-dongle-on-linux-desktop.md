---
layout: post
title: "How to deal with frequent disconnects of 3G USB Dongle on Linux Desktop"
tags: hardware linux how-to
---

One of the major issues on linux desktop these days has to do with 3G USB dongles/modems. In many countries like India, a USB dongle still remains a major way to access the Internet. The latest versions of `network-manager` has solved most of the issues relating to the basic recognition of these modems, but one major irritant still remains on Ubuntu 16.04 and a few other distros.<!--more-->

It so happens that many a times, the connection entirely vanishes from the network-manager applet menu on the top right. For example, if you hibernate your laptop and then wake it, the menu is no longer there. However, if you manually take out the dongle and re-insert, the modem is recognized and the menu reappears. If you want to avoid that manual re-insertion and want to do a “soft reset” instead, here is what you can do:

1.  Send a reset signal to your usb modem:

		sudo usb_modeswitch -v 12d1 -p 1496 -R

2.  Send a modeswitch signal to your usb modem:

		sudo usb_modeswitch -v 12d1 -p 1496 -J

The parameters, `-v` and `-p` stand for vendor code and product code respectively and you can find them by running `lsusb` command. For example, the below entry is for vendor code `12d1` (Huawei) and the product code is `1496`.

	Bus 001 Device 004: ID 12d1:1496 Huawei Technologies Co., Ltd. Broadband stick

Please remember that for modeswitch signal, the parameter -J is vendor specific and works for Huawei modems only, please run `man usb-modeswitch` to find out your vendor specific modeswitch control parameter. For instance, its -O for Sony and -L for Cisco control parameter.

Of course, once you try these commands and find that they are working, you can add them as a shortcut to your `~/.bashrc` file. Something like this:


	alias "reset_huawei=sudo usb_modeswitch -v 12d1 -p 1496 -R"
	alias "modeswitch_huawei=sudo usb_modeswitch -v 12d1 -p 1496 -J"

Now, all you need to do is run `reset_huawei && modeswitch_huawei` and that’s it! No need to manually re-insert the dongle anymore.
