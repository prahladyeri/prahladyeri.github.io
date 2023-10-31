---
layout: post
title: 'How to assemble a fast and minimal Debian Desktop using Openbox'
tags: debian linux
---

Being a web developer, one of the nagging things to do is keeping your hardware in sync with your performance requirements. In the good old times, a `P4` or even a `Celeron` based PC or laptop was enough for programming. But with changing times, the required investment to get a sane performance has increased to astronomical levels.<!--more-->

Problem is not just with the limitations of hardware, but our requirements too have increased. Apart from the tons of most needed apps like `eclipse`, `firefox`, `libreoffice`, `thunderbird`, etc., you now have to keep VMs running in `virtualbox` at the same time you are having a chat on `skype` with your client. Add to that, *heavy* things like `eclipse` or `Android Emulator` and your linux (or even Windows) desktop will start to buckle under the pressure.

All in all, even an Intel *i5* or *i7* chip isn’t sufficient today to handle multiple heavy or memory consuming apps. The only solution I have found is to use a lighter window-manager like `Openbox`, `Fluxbox` or `IceWM` instead of a heavy Desktop Environment like `GNOME`, `Unity` or `KDE`. This tutorial contains all the steps needed to assemble on your own light-weight DE based on `Openbox` on Debian (or one of its compatible derivatives like Ubuntu or Linux Mint).

![Openbox](/uploads/2016/02/openbox.png){.size-full .wp-image-498 width="956" height="537"} **Openbox**

[Openbox](http://openbox.org) is an open source project (GPL licensed) based on the good old blackbox. It provides just the minimal framework to build a no-flashy, sane desktop environment that gets out of your way, so most resources are used for running the *actual apps* that you use. Openbox occupies less than 8 MB of RAM on your machine. Again, this kind of setup is not for everyone, in case you are a huge fan of the Unity dash or GNOME dash, you may not like Openbox at all. On the other hand, if you like the new MATE Desktop which is based on the old GNOME 2, you may find this approach interesting. In fact, Openbox is the window manager used by `LXDE`, the DE most famous for being light on resources. You are, in fact, going to create something like your own version of `LXDE` by following this tutorial, only its even more minimal and custom to your requirements. Here is how to do it:

1.  Download the Debian minimal net-install ISO from [here](https://www.debian.org/CD/netinst/). It is roughly 150-200 MB in size.
2.  Either burn the `ISO` to a USB drive or try it out in a VM first.
3.  Use the text based or graphical installer to complete the installation.
4.  Once you land on the command line, login as the superuser (`su`) and install these packages:

		apt-get install network-manager
		apt-get install xorg openbox xdm
		apt-get install xbacklight pcmanfm lxappearance lxpanel gmrun gnome-terminal

5.  To make the panel automatically show up, add this to `~/.config/openbox/autostart` file using `nano` or `vim` editors:

		lxpanel &

6.  Restart

Note that this will create only a *bare minimum*, workable DE with just a File Manager and no other usable apps. lxpanel is a “Windows-98 style” panel that sits on top/bottom of your desktop and gives a “start-menu” in which your programs are organized. lxappearance is a handy tool to switch GTK themes which comes very useful. You still have to install `evince` to read PDF books, `geany` or `gedit` for a GUI text editor, `iceweasel` and `icedove` for a browser and mail client respectively, and `libreoffice-calc` for a spreadsheet.

But the good thing is that you are the *master* of your desktop world now. You don’t have to live with that extra load of bloated baggage that heavy DEs usually come with. If you follow the above process correctly, you will end up with an installation size of less than 500 MB! And your own custom-made DE that works!

As for customization, `Openbox` is [highly customizable](http://openbox.org/wiki/Help:Configuration). Arch Linux also has a wonderful [documentation](https://wiki.archlinux.org/index.php/openbox) on this topic, and [here](https://www.maketecheasier.com/configure-andcustomize-openbox/) is another brief guide. For menus, you can either install `obmenu` or if you are a simplicity fan like me, you can just edit your way through `~/.config/openbox/menu.xml`. This, and the other file, `~/.config/openbox/rc.xml` are the only two Openbox configuration files and they have all the needed options. In fact, if you decide to make use of the `lxpanel` main menu, you don’t even have to edit the `menu.xml` of Openbox.

------------------------------------------------------------------------

Notes:

-   `lxpanel` is not the only option for installing a Desktop panel, there are others too like `fbpanel`, `tint2` and `xfce4-panel`. Read [this](https://www.maketecheasier.com/configure-andcustomize-openbox/) for more details.
-   To add a battery indicator to the `lxpanel`, add this to the `~/.config/lxpanel/default/panels/panel`

		Plugin {
		  type = batt
		}

-   To save your openbox customizations between sessions (which is a basic requirement), copy the `rc.xml` and `menu.xml` from `/etc/X11/openbox` to `~/.config/openbox/` (create this folder if it doesn’t exist).
-   `gmrun` is needed to show the run dialog that pops up when you press `Alt+F2` in any “normal” DE. Once you install `gmrun`, just add below code to `~/.config/openbox/rc.xml` somewhere in the `<keyboard>` section, in order to make the keys work:

		<!--start: Prahlad-->
		<keybind key="A-F2">
		<action name="Execute">
		  <command>gmrun</command>
		</action>
		</keybind>
		<!--end: Prahlad-->

-   `xdm` is optional, but helpful if you don’t want to do a lot of configuration changes in `xorg` files to show up the desktop automatically each time you login. Of course, you can use `lightdm` too if you want.
-   I don’t use bluetooth a lot and haven’t included any of those packages, but there are many of them such as `bluez` in case you need one.

References:

-   [Openbox Wiki - Configuration](http://openbox.org/wiki/Help:Configuration)
-   [Arch Linux Openbox docs](https://wiki.archlinux.org/index.php/openbox)
-   [Make Tech Easier - Openbox configuration guide](https://www.maketecheasier.com/configure-andcustomize-openbox/)
-   [Debian Netinstall Download](https://www.debian.org/CD/netinst/)
-   [lxpanel Battery Indicator installation](https://bbs.archlinux.org/viewtopic.php?id=156272)
