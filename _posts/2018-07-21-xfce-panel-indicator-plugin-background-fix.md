---
layout: post
title: 'XFCE panel indicator plugin background fix'
tags: xfce xubuntu linux
---

The indicator plugin in XFCE panel has been a very useful but also a very controversial plugin! The reason is that its the only plugin on the XFCE panel developed in GTK3 (whereas rest of the panel is developed in GTK2) and this causes some theming issues.<!--more-->

Specifically, only those themes will work for the panel who's developers have taken care to style both the GTK2 and GTK3 components, otherwise it results in an odd background color around the indicator plugin which isn't in sync with rest of the theme:

![xfce-indicator-plugin-background-issue](/uploads/2018/07/xfce-indicator-plugin-background-issue.png){.size-full .wp-image-976 width="380" height="130"}

**XFCE indicator-plugin background issue**

[Bug \#1408979](https://bugs.launchpad.net/bugs/1408979) has been reported on launchpad for this and even askubuntu is filled with [a bunch of questions](https://askubuntu.com/questions/663248/xubuntu-indicator-plugin-background) pertaining to this issue. I came across this while trying to port [ambiance looks to my xubuntu desktop](https://prahladyeri.github.io/blog/2018/07/how-to-make-your-xubuntu-desktop-look-and-behave-like-ubuntu-mate.html).

The fix is really simple if your theme already has GTK3 support (but not for the indicator plugin specifically). GTK3 support typically exists for your theme if it has **/gtk-3.0** folder in its root folder. All you have to do is open the **/\<your\_theme\>/gtk-3.0/gtk.css** and add this style patch to it:

    /*xfce panel workaround */

    .xfce4-panel {
      background-color: @dark_bg_color; 
      font: normal;
    }

    .xfce4-panel .button {
      background-image: none;
      background-color: @dark_bg_color;
      border-radius: 0;
    }

    .xfce4-panel .button:active,
    .xfce4-panel .button:checked {
      background-image: none;
      background-color: shade(@dark_bg_color, 1.20);
      border: none;
    }

    .xfce4-panel .button:hover,
    .xfce4-panel .button:active:hover,
    .xfce4-panel .button:checked:hover {
      background-color: shade(@dark_bg_color, 1.20);
      border: none;
    }

Make sure to replace the **\@dark\_bg\_color** with whatever your theme's background color is. After the above change, just apply your theme using the theme switcher and you will see this problem magically fixed!

Now in cases where your theme doesn't have GTK3 support, it might get tricky. I faced this same issue with the [Ambiance XFCE theme](https://www.xfce-look.org/p/1016446/), for instance. What I did as a workaround was copy the **gtk-3.0** folder from the official Ambiance theme from **ubuntu-mate-themes** package to the linked XFCE theme's folder and then did the above fix. Of course, I could have used the official theme itself in the first place, but it doesn't support xfwm4.

I hope the above information helps you if you were looking for a fix to this exact same issue.
