---
layout: post
title: Eclipse Mars - Not ready for Linux Yet
tags: eclipse java
---

So after hearing about all the hype and praises about this Eclipse new release called [Mars](https://projects.eclipse.org/releases/mars), I decided to give it a try on my Ubuntu laptop yesterday. Since I already use `Kepler`{.highlighter-rouge} the older version, I was looking for some big positives like performance improvements (most often talked about by a lot of Eclipse fans lately).<!--more-->

![Eclipse Red Logo](/uploads/old/eclipse-red.png)

When I started this new `eclipse`{.highlighter-rouge} on ubuntu, I first had a faint hope that it was running faster (maybe a trick of the mind instilled by the new red logo!). But the true test of any software is how it performs under REAL world conditions. Alas! As I had expected, I was only to be disappointed on the performance front. Unless there is a drastic change in underlying core components such as a code refactoring or an improvement of graphic toolkit/library, the “performance” can only get worse, not better. After I created a simple *HelloADT* project, here is what happened when I clicked on an Android Activity layout screen:

![Eclipse Mars](/uploads/old/Eclipse_Mars.png)

And this is a modern *Intel core i3* machine we are talking about with 4 GB RAM, not some old device. Just after this disaster of an IDE happened, I started my good old `kepler`{.highlighter-rouge} version and opened the same ADT project which ran without any problems:

![Eclipse Kepler](/uploads/old/Eclipse_Kepler.png)

It was good that I had kept my kepler installation folder intact, so I was able to revert. So moral of the story is:

1.  Take all claims about this “big improvement” with a pinch of salt, especially if it is a Java based software.
2.  Wait for `Eclipse mars`{.highlighter-rouge} to get more stable before using it for production work.
