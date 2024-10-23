---
layout: post
title: 'How To Make Your Ubuntu Desktop Faster'
tags: ubuntu xubuntu linux efficiency
---

The usual advice you get when seeking a more resource conserving distro is to use a lighter spin-off such as Xubuntu, Lubuntu, etc. However, not many people know that even a "heavy" distro such as Ubuntu LTS with the default Unity Desktop could be made much lighter by uninstalling some packages and removing others from the startup. Let us see how it can be achieved:

## Remove unwanted items from Startup Applications

When you go to the Ubuntu Dash and start the "**Startup Applications**" dialog, it doesn't show you the whole picture. There are still many "hidden apps" that silently start in the background without you knowing it. In order for all these hidden apps to be displayed in that dialog, you'll have to run the following command in the terminal once:

	sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop

Once you run this and then open the "Startup Applications" dialog, you'll be able to see the hidden apps too:

![Startup Applications (Ubuntu)](/uploads/2017/09/startup_applications.png)

**Startup Applications (Ubuntu)**

From this dialog, you can disable an app from starting up by "unchecking" it. The most important that I typically uncheck on a new installation are **Backup Monitor** and **Desktop Sharing**. It doesn't make sense to have such a huge backup schizophrenia on a non-production desktop computer, so I wonder why the Backup Monitor is enabled in the first place. About 99% of sysadmins either perform a manual backup periodically, or write an automation script use something like **rsync** which is specifically designed for the job.

**Desktop Sharing** is an equally unnecessary tool to have been enabled by default on a linux desktop. This ain't the Windows world where people use Remote Desktop clients to connect to other PCs on the same network. About 99% of linux folks use **ssh** to connect to remote machines instead. Desktop Sharing should be an opt-in feature in any case and a user who specifically needs it can enable it when needed.

## Remove unnecessary background services such as cups and avahi-daemon

On a fresh Ubuntu installation, run `sudo netstat -antpe` and you'll see the rarely used `cupsd` daemon (*common unix printing service*) running on a free TCP port and  silently leeching your memory and network resources. Similarly, you can run `sudo netstat -anupe` to scan for UDP ports and you'll similarly see the cups browser daemon (`cups-browsed`) and the avahi daemon (`avahi-daemon`) services.

Use of printers has become less and less, especially since the oncoming of digital age and internet revolution. Heck, even companies have been encouraging email communication these days in a bid to avoid paper work and save trees, and here we are - one of the top linux distributions running a printer service by default!

My humble request to them is please make this an opt-in feature, those who need it will have enough sense to run `sudo apt install cups`. Until that happens, the rest of the folks can do the following:

	sudo systemctl disable cupsd
	sudo systemctl disable cups-browsed

We are not uninstalling it, just disabling the service just in case. And before you say that `cups` is needed for PDF exports from browsers, then no, the latest versions of firefox and chrome come with their own PDF extensions and don't depend on this service anymore.

As for the other service (`avahi-daemon`), it really doesn't make any sense as `avahi` is the linux implementation of Apple's proprietary protocols for peer-to-peer communication between their iDevices. Nobody in their right minds would be using an open source OS like Ubuntu on their PC/Laptop to communicate with proprietary Apple products! The two just don't play well together as Apple products only work in a closed eco-system. 

As for those rare folks who absolutely need avahi-daemon, let them install it themselves, why include this by default? Until that happens, the rest of us can disable `avahi-daemon` by simply running:

	sudo systemctl disable avahi-daemon

## Disable HUD (if you don't use it)

One of the reasons why Xubuntu has such a low memory footprint (~200 MB at idle) is that it doesn't come with memory leeching services such as the HUD. For example, on my laptop, HUD service eats a good 30MB of RAM which is too much for a service that I don't even use. As [described in this post](https://askubuntu.com/a/218073/49938), you can disable the HUD service from the terminal as follows:

	sudo chmod -x /usr/lib/indicator-appmenu/hud-service # 32bit systems
OR
	sudo chmod -x /usr/lib/x86_64-linux-gnu/hud/hud-service # 64bit systems

## Disable evolution processes (if you use thunderbird or anything else instead)

Evolution processes(such as `evolution-calendar-factory` and `evolution-addressbook-factory`) are huge memory leechers and a drain on your RAM. If you just start the system monitor and search for `evolution`, you'll find 4-5 different processes consuming a good 120MB of your RAM! Now, for someone who doesn't even use the evolution email client or any of these services, why should they be there in the first place? But unfortunately, you cannot just remove (`uninstall`) these packages using `apt`. Trying to `apt remove evolution-data-server` will break your system as they've made it a core part of the desktop. What you can do instead (if you really want to claim back that RAM) is a [workaround suggested in this post](https://askubuntu.com/a/816353/49938). Simply rename the folders as follows:

	sudo mv /usr/lib/evolution-data-server /usr/lib/evolution-data-server-disabled
	sudo mv /usr/lib/evolution /usr/lib/evolution-disabled
	
Optionally, a less dirty hack is to remove the executable flag from the individual processes, so that they won't start. This way, the processes won't start again if you update your core packages in future.

	sudo chmod -x /usr/lib/evolution/evolution-calendar-factory # less dirty hack


## Remove GNOME software center (only if you don't use it)

This piece of junk (gnome software center) takes a good 70-80MB on any typical ubuntu installation. For managing software, I find the good old `apt install` way to be much more intuitive than the gnome software center. For those rare cases when you absolutely need a GUI, the `synaptic package manager` works absolutely fine and without taking a constant toll on your resources.

As described in [this answer](https://askubuntu.com/a/783075/49938), all it takes to safely remove gnome software center from your system is:

	sudo apt purge gnome-software

------------------------------------------------------------------------

After trimming the programs and services as mentioned above, your system should become nearly as light-weight as those other lighter distros like xubuntu, lubuntu, etc. and you'll still be able to enjoy and work with a richer and more visually pleasant user interface!

On my own laptop, I was able to reduce the idle memory consumption from ~550MB to ~300MB which is as close as it gets to ubuntu-mate!

## Update

As of 18.04 LTS, Ubuntu has replaced gnome software center with a new piece of crap called "snappy" which is no better than its predecessor! To remove snappy, just follow this process:

	#check what snaps are installed
	snap list
	
	#remove all snaps
	sudo apt purge snapd
	
	#delete the snap folder
	rm -rf snap 
	
	#optionally replace snaps with standard apps
	sudo apt install gnome-calculator gnome-logs gnome-characters gnome-system-monitor 

I still don't understand why ubuntu keeps shipping this extra needless junk like `cups` and `avahi` with each new release (considering its useless for the average or most typical user out there). My best guess is they do this so that the user googles for ways to remove it and thus improve their linux skills!

*Reference:*

- <https://askubuntu.com/questions/210387/how-can-i-disable-hud-service>
- <https://askubuntu.com/a/816353/49938>
