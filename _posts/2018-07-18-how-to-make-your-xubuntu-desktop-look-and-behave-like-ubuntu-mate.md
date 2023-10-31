---
layout: post
title: 'How to make your Xubuntu 16.04 desktop look and behave like Ubuntu-MATE'
tags: linux ubuntu ubuntu-mate xubuntu how-to
---

Xubuntu is one of the most popular among the "lighter" distros as it hardly consumes 200MB when idle and even older machines are able to run with acceptable performance. Ubuntu-MATE which is based on MATE Desktop (a GNOME-2 fork) is also a similar competing distro though its debatable whether its as light as Xubuntu in terms of resource consumption.<!--more-->

![Xubuntu Desktop which looks like Ubuntu-MATE](/uploads/2018/07/ubuntu-mate_lookalike.png)

**Xubuntu Desktop which looks like Ubuntu-MATE**

Making a switch from Xubuntu to Ubuntu-MATE totally makes sense if you have any particular reason for it, but I've observed that many people make that switch only because they like the astonishing looks of Ubuntu-MATE which are admittedly and relatively better compared to XFCE. For whatever reason (such as familiarity) if you want to just stay on Xubuntu but still want to have the "look and feel" of Ubuntu-MATE, its very easy to achieve that, you just have to follow this brief process described in this article.

**Step-1: Download the Ambiance theme for XFCE from [here](https://www.xfce-look.org/p/1016446/) and extract them to your \~/.themes/ folder.**

Whilst the official Ubuntu packages **mate-themes** and **ubuntu-mate-themes** also come with a version of Ambiance theme, the window title background didn't turn dark when I applied it for some reason. You can still have those packages installed if you want, but the one in your \~/.themes/ folder will override any installed themes.

**Step-2: Apply Ambiance GTK theme.**

Head over to Appearance applet in your XFCE Settings Manager and switch the GTK theme to **Ambiance** which you should now see after performing step-1:

![Settings Manager-\>Appearance](/uploads/2018/07/SM_appearance.png)

**Settings Manager-\>Appearance**

**Step-3: Apply Ambiance Window Manager theme.**

The next step is to do the same for Window Manager theme. Head over to Window Manager applet and make the switch there too:

![Settings Manager-\>Window Manager](/uploads/2018/07/SM_window_manager.png)

**Settings Manager-\>Window Manager**

**Step-4: Install Ubuntu-MATE icons.**

This is for adding those green MATE icons. Just run this command to install the official package:

    sudo apt install ubuntu-mate-icon-themes

Again open the Appearance applet but this time click the **Icons** tab on the top, and just select **Ambiance-MATE** from there:

![Settings Manager-\>Appearance (Icons Tab)](/uploads/2018/07/SM_appearance_icons.png)

**Settings Manager-\>Appearance (Icons Tab)**

Optionally, you can also click the **Fonts** tab and change the font to Ubuntu or one of its derivatives to get that Ubuntu-MATE feel!

**Step-5: Use the magic switch: XFCE Panel Switch.**

The **XFCE Panel Switch** is a wonderful tool that drastically alters the layout of your XFCE Desktop, just search for "XFCE Panel Switch" in your whisker menu or find it under **Settings** in your regular menu. Start that tool and you'll be able to switch to any desired desktop layout (choose "GNOME 2" for the looks of Ubuntu-MATE and click "Apply" icon which is the first in the bottom list of small icons):

![XFCE Panel Switch](/uploads/2018/07/xfce-panel-switch.png)

**XFCE Panel Switch**

Once you do that, you should be able to get a perfect Ubuntu-MATE look alike such as the one shown on the top screen. Finally and optionally, you can also install the official package **ubuntu-mate-wallpapers** if you like their wallpapers too.
