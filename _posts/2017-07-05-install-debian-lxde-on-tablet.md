---
layout: post
title: 'How to install Debian+LXDE on ANY Android Tablet'
tags: android debian lxde linux
---

Running a linux distro on android devices is a hot topic these days, and why not? After all, android is already based on linux kernel, but a pretty much locked-down and dumbed-down version of it. The OEM doesn’t give you root and in most cases, not even an open source bootloader or kernel.<!--more-->

That way, its good for maybe the most average user who doesn’t care about the OS and just want to use their phones. But for a power user, that’s not enough.

[![Debian (LXDE) running on Xiaomi MiPad](/uploads/2017/07/debian_xfce_tablet.jpg){.size-full .wp-image-553}](/uploads/2017/07/debian_xfce_tablet.jpg) **Debian (LXDE) running on Xiaomi MiPad Tablet**

The so called apps available in the Play Store don’t allow you to utilize the full power of your linux device. A power user always wants to have the power of a full linux distro (such as Debian or Ubuntu or Fedora) on his/her device.

For a long time, I researched for the best way to install a linux distro on a tablet, preferably one that didn’t involve rooting or partitioning the device. The [debian guide](https://wiki.debian.org/ChrootOnAndroid) lists down several methods and apps to do this such as Linux Deploy, GNURoot, Termux, etc. Out of them, the least risky and one that supports most android devices (including my KitKat tablet) is [GNURoot-Debian](https://play.google.com/store/apps/details?id=com.gnuroot.debian).

Once you install this app on your tablet, it creates a self-contained `chroot` install of debian using a tool called [Proot](https://wiki.archlinux.org/index.php/Proot). Once that is done, all you need to do is open up the app terminal and just start using it:

	apt-get update
	apt-get install tmux vim gcc python python3 python3-pip

Of course, these are just some of the packages that I’ve installed, you can do whatever you want with your linux installation. The only limitation is regarding multiple user logins. By default, the app will login you as `root` and while you can create additional users using `useradd` command, don’t expect things like `setuid` and `setgid` to work. The only way to switch user is using the `su - yourLogin` command (whilst the `login` command should work too in theory, I’m having a few problems with it presently, it might need some fixing in /etc/pam.d/\* configuration files).

Further, if you have good amount of RAM on your tablet, you may consider using a desktop environment along with your headless installation (LXDE is recommended as it performs best on minimal resources). In order to do that, you’ll need two things:

1.  [XServer-XSDL app](https://play.google.com/store/apps/details?id=x.org.server&hl=en)
2.  LXDE/XFCE desktop installed.

The former is used to interact with the headless XServer installation of your debian and provide you a graphical desktop environment. For the latter, you’ll have to just `apt-get install lxde` (or lxde-core depending on your choice). Then, in order to use the desktop any time on your tablet:

1\) Open XServer-XSDL app, follow the instructions until you reach a blue screen.

2\) Go to the debian installation and run:\
export DISPLAY=:0 PULSE\_SERVER=tcp:127.0.0.1:4712\
startlxde &

3\) Go back to XServer-XSDL app to interact with the desktop.

If all goes well, you should be able to see an lxde desktop like the one shown in the above screen. Coupled with the keyboard case and a bunch of great linux apps (such as vim, emacs, geany, inkscape, eclipse, etc.), you should be able to convert your mobile tablet into a great development machine on wheels.

References:

-   <https://www.xda-developers.com/guide-installing-and-running-a-gnulinux-environment-on-any-android-device/>
-   <https://wiki.debian.org/ChrootOnAndroid>
-   <https://play.google.com/store/apps/details?id=com.gnuroot.debian>
-   <https://play.google.com/store/apps/details?id=x.org.server&hl=en>
-   <https://wiki.archlinux.org/index.php/Proot>
