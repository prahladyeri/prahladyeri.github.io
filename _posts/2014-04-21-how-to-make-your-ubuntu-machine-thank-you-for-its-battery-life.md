---
layout: post
title: 'How to make your ubuntu machine thank you for its battery life!'
tags: linux how-to
---

Ever since I bought my Toshiba Dual-core Notebook and installed ubuntu on it, I was disappointed by the fact that how quickly it used to heat up and the battery started draining. Add to the equation, the Indian summer of 40 degrees Celsius plus, and you soon have your fans crying with agony.<!--more-->

Of course,  the Toshiba CD comes with all the bells and whistles for power saving, but thats only for the Windows users, what about us Linuxers? After some [research](http://www.noobslab.com/2013/10/enable-laptop-mode-and-other-tweaks-to.html), I came to know about some tweaks I can perform on my ubuntu system so that my laptop not only heats less, but also gets its battery life expanded!

The fact is that one of the most power hungry component of your machine is the CPU (apart from your LCD/screen). Assuming that you are already sane enough not to keep your screen brightness at its max, here is an important tweak that you may perform to prolong the life of your battery. If you are having any issues with your CPU fan making a lot of [noise](http://lifehacker.com/5813003/how-can-i-quiet-a-noisy-computer-fan), this will help with that issue too, (since by lowering your CPU consumption you will make your fan work less).

[![indicator-cpufreq - An ubuntu app](/uploads/old/indicator-cpufreq.png){.size-full .wp-image-2524 width="173" height="221"}](http://prahladyeri.github.io/uploads/old/indicator-cpufreq.png)

*indicator-cpufreq - An ubuntu app*

This small wonder of an app can be installed on ubuntu by running `sudo apt-get install indicator-cpufreq`.

Once it is installed just add the command `indicator-cpufreq` to your startup applications, and you will see the above applet in your ubuntu system tray! You may now choose to set your CPU scaling mode to `Powersave` whenever you are performing any less cpu-intensive task (like most of us) such as editing a Libreoffice document or a spreadsheet. On the other hand, you may occasionally set the scaling mode to `Performance` when you are doing some cpu-intensive task such as playing a 3D game.

By default, the applet starts in `Ondemand` mode. To, set the default to `Powersave`, all you have to do is make a small edit to script `/etc/init.d/ondemand` as follows:

	for CPUFREQ in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
		do
		[ -f $CPUFREQ ] || continue
		#changed by Prahlad from ondemand to powersave
		echo -n powersave > $CPUFREQ
	done

Take this small step (if you already haven't) and see how your battery life prolongs, as your electricity bill falls!!

**References:**

1.  <http://www.noobslab.com/2013/10/enable-laptop-mode-and-other-tweaks-to.html>
2.  <http://askubuntu.com/questions/223250/how-to-tweak-powertop-to-reduce-power-consumption?rq=1>
3.  <http://lifehacker.com/5866009/control-your-computers-fan-speeds-for-better-performance-when-you-need-it-silence-when-you-dont>
4.  <http://lifehacker.com/5813003/how-can-i-quiet-a-noisy-computer-fan>
5.  <https://bugs.launchpad.net/indicator-cpufreq/+bug/1082868>
