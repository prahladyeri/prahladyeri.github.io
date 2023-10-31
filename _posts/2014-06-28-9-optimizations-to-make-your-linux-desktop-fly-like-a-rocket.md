---
layout: post
title: 9 Optimizations to make your Linux Desktop fly like a Rocket!
tags: ubuntu linux
---

This article is the result of notes I've prepared during tweaking, twisting and optimizing ubuntu variants over the last few years. In case you use any other distro, some of these settings may not be applicable to you. For best results, these changes must be done on top of a fresh installation, otherwise chances of things breaking increase a bit. Each step is optional - In case of software removals, do it only if you are not going to use the concerned software. Be careful before making any changes and know exactly what and why you are doing that.<!--more-->

### \#1 Optimize disk access with noatime:

Each file and folder on your linux system has a file-creation timestamp and a modification timestamp. Apart from that, linux tries to keep track of "access time" for each of these files. Now keeping track of the access time has its performace-cost, and if you want to remove this performance cost, you need to specify "noatime" attribute in the disk partition entries in your /etc/fstab file. Edit this file in your text-editor and set noatime as follows:

	UUID=97102801-14e3-9752-7412-d9c57e30981w / ext4 errors=remount-ro 0,**noatime** 1

### \#2 Optimize Swappiness:

Swappiness is the tendency of the linux kernel to prefer disk-swapping vis-a-vis physical memory. The default swappiness value of 60 was kept considering server installations. If you are a desktop user having a machine with good RAM, you would normally prefer disk-swapping to be minimal. You can safely reduce this value to 10. To do so edit the file /etc/sysctl.conf and add the following:

	vm.swappiness=10

(Just change the entry if it already exists, don't make a duplicate!)

### \#3 Install preload:

If you typically use the same programs regularly, preload will help you by loading into memory, the programs that you use most frequently. To install on ubuntu:

	sudo apt-get install preload

### \#4 Place your mission critical apps in /dev/shm:

Few weeks back, I was having performance issues with running Eclipse on ubuntu. After tweaking and optimizing various JVM settings in vain, the thing that really made the difference was [placing the entire JDK folder in RAMDISK](https://prahladyeri.github.io/blog/2014/06/real-way-make-eclipse-run-faster-ubuntu.html). The /dev/shm folder is like a virtual ramdisk (on ubuntu and derivatives) where you can place your temporal, high-priority stuff to run it in "best performance" mode.

### \#5 Remove unwanted programs from startup:

Many linux distros such as ubuntu come loaded with a ton of baggage, and if you are someone like me, you might feel obliged to reduce some burden off your system by removing or disabling unwanted software and daemons from it. You can do this by going to "Startup Applications" in the System menu, but ubuntu hides the pre-installed apps by default. To overcome this limitation, open your terminal and issue the below command:

	sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop

[![ubuntu startup](/uploads/old/startup.png){.alignnone .size-full .wp-image-3092 width="649" height="612"}](https://prahladyeri.github.io/uploads/old/startup.png)

Now you can go through the startup programs list and can disable the unwanted ones. Common sense will tell you that if you don't use bluetooth on your machine, you can get rid of the "Bluetooth Manager". Similar is the case with "Backup Monitor" in case you don't need to sync your backups in realtime. Here is the list of services that I've safely disabled without causing any issues:

-   Backup Monitor
-   Bluetooth Manager
-   Chat
-   Desktop sharing
-   Gwibber
-   Ocra screen reader
-   Personal file sharing
-   Screen saver
-   Ubuntu one
-   update notifier

### \#6 Uninstall software that you don't use:

The next step is to remove those software that you don't use at all. Again, some common sense but with some caution is needed here. There are some programs (like empathy) that form the core part of ubuntu, so it won't allow you to "apt-get remove.." them without removing unity itself. In such cases, we will disable such programs from starting up as services (next step). Some of the programs that you may safely remove are:

	apt-get remove samba-common\
	apt-get remove cups\
	apt-get remove avahi-daemon avahi-autoipd

I typically uninstall all three after a new installation. The first one is needed for file-sharing in the local network if you have one. Second is the print daemon, and third is used to broadcast common network services across the local network and finding local hosts by using friendly names like "local.workstation".

### \#7 Disable unwanted daemons:

In case you don't want to remove the cups program as you might need printing in future, you can disable them for the time being. To do so, issue the below command:

	sudo sh -c "echo 'manual' \>\> /etc/init/cups.override"

You may disable any daemon in this manner by doing a manual override, just replace the "cups.override" with the daemon name that you want removed such as:

	sudo sh -c "echo 'manual' \>\> /etc/init/bluetooth.override"

Later, if you want to enable that daemon, all you to do is delete the .override file.

### \#8 Optimize Nautilus to behave in a speedy manner:

This is totally optional. Nautilus, by default, tries to show thumbnails of each and every file in a directory. If the directory contains a lot of files, this causes a noticable delay. Now if you are in the habit of regularly previewing thumbnails of your images, don't do this optimization. Otherwise, if previewing thumbnails don't matter to you and all you are interested in is speed (like me), you can go to Edit-\>Preferences-\>Preview-tab and set the preview settings to Never.

### \#9 Disable translation downloads in aptitude:

This setting is for speeding up the downloads from apt repositories rather than your machine. By default, ubuntu adds additional translation repos when you issue "apt-get update" command to update your repository settings. If you only need english, you can disable translation downloads by editing /etc/apt/apt.conf.d/00aptitude and additing this line to it:

	Acquire::Languages "none";

*References:*

- <http://askubuntu.com/questions/74653/how-can-i-remove-the-translation-entries-in-apt>
- <http://askubuntu.com/questions/2194/how-can-i-improve-overall-system-performance>
- <http://askubuntu.com/questions/173094/how-can-i-use-ram-storage-for-the-tmp-directory-and-how-to-set-a-maximum-amount>
