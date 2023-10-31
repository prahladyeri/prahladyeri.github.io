---
layout: post
title: 'Performing a little usability tweak on the XFCE window recycler in greybird theme'
tags: linux xfce
---

Xubuntu is my favorite distro, hands down and the default Greybird theme is just wonderful! There used to be a time when I liked Ubuntu-MATE too, but not so much since they took the road to GTK+3! Coming back to the topic, XFCE works great but it has a small usability issue in the default Greybird theme which annoys most power users.<!--more-->

ALT+TAB is the usual way to recycle window icons on any DE, and the "tab" key determines the currently focused window. Now, one of the Greybird theme developers decided in his profound wisdom that a mouse move over the cycling dialog can cause a window focus too. Since the mouse cursor occupies a central position most of the time, it automatically causes an item in the cycling dialog to be selected which is not intended at all! While this could be a great "feature" for those users who like juggling with their mouse while pressing the ALT+TAB keys, I hardly think any power user would like to do that. For most users, this could be easily a cause of annoyance or frustration since they have to move the mouse out of the dialog's range to ensure that it doesn't interfere with their selection again.

![XFCE Alt+Tab Cycling Dialog](/uploads/2018/09/alt-tab-cycling.png)

As you can see, the blue background represents the selected/active window. Now, imagine intending to select the firefox window by pressing ALT+TAB, but terminal window gets selected instead since the mouse happens to be placed there! Astonishingly, however, I couldn't find any discussions or issues raised regarding this anywhere on the internet except [this one thread on XFCE forums](https://forum.xfce.org/viewtopic.php?id=9585). After making some tweaks to their code, I was able to come up with my own version which resolves this issue:

    include "/usr/share/themes/Greybird/gtk-2.0/gtkrc"

    style "xfwm-tabwin-tweak"
    {
     Xfwm4TabwinWidget::border-width = 1
     Xfwm4TabwinWidget::border-alpha = 0.9
     Xfwm4TabwinWidget::icon-size = 64
     Xfwm4TabwinWidget::listview-icon-size = 16
     Xfwm4TabwinWidget::preview-size = 512
     Xfwm4TabwinWidget::alpha = 0.9 #0.8
     Xfwm4TabwinWidget::border-radius = 5 #10

    bg[NORMAL] = shade (0.45, @bg_color_dark) # widget background color
     bg[ACTIVE] = shade (0.65, @selected_bg_color)# when keyboard and mouse focus on the same item
     bg[PRELIGHT] = shade (0.45, @bg_color_dark) # color of item with mouse hovering on it, which we want to make it
     bg[SELECTED] = shade (0.65, @selected_bg_color) #color of selected item using keyboard

    fg[NORMAL] = shade (0.8, "#fff") #shade (0.8, @base_color)
     fg[ACTIVE] = "#fff" #@base_color # text color of item where our mouse and keyboard meet
     fg[PRELIGHT] = shade (0.8, "#fff") #shade (0.8, @base_color)
     fg[SELECTED] = "#fff" #@base_color

    engine "murrine" {
     roundness = 6
     }
    }

    widget "xfwm4-tabwin*" style "xfwm-tabwin-tweak"

Save the above file as \~/.gtkrc-2.0 and change your theme from Greybird to something else and back again, and this issue will be resolved.
