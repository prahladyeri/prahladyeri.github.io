---
layout: post
title: "The REAL way to make Eclipse run faster on Ubuntu"
tags: eclipse java
---

If you are still one of those people who are frustrated with the crawling speed of eclipse IDE (especially after the recent clunky releases of Juno/Kepler), then you are in good company! Most of the advice you might have read until now for speeding up Eclipse must have involved tweaking the following parameters in eclipse.ini file:<!--more-->

::: {.wp_syntax}
`-Xmn512m -Xms1024m -Xmx1024m -Xss2m -XX:PermSize=1024m -XX:MaxPermSize=1024m -XX:+UseParallelGC `{.python}</code>
:::

Since Eclipse is pretty much a RAM hungry monster, feeding it with lots of RAM should surely make it run fast, right? Wrong! Until recently I had spent a lot of time tweaking those parameters, but no substantial performance could be gained (though I have 4GB of RAM with i3 which is not a bad configuration). The main issue here is that the underlying linux won't provide the required boost to eclipse no matter whatever the parameters you provide. For instance, the system monitor shows that eclipse is only consuming 500Mb RAM, now what difference will it make if I provide 2048m to -XX:MaxPermSize?

[![System Monitor](/uploads/old/eclipse-monitor-300x236.png){.size-medium .wp-image-2969}](https://prahladyeri.github.io/uploads/old/eclipse-monitor.png) System Monitor

My search lead me to another better [approach](http://ubuntuguide.net/ubuntu-using-ramdisk-for-better-performance-and-fast-response) to solving this problem. If somehow we can load JDK into a shared memory or a RAM-Disk instead of it starting from the local hard-disk, both startup time and performance could be drastically improved.

But how do we create a RAM-Disk on linux? Well, if you using ubuntu, then you are in [luck!](http://superuser.com/questions/45342/when-should-i-use-dev-shm-and-when-should-i-use-tmp) Ubuntu has a working RAM-Disk folder called **/dev/shm** that could be globally used by any application as a temporary storage. If you go to that folder, you can see lots of files stored by pulseaudio.

I thought why not copy the JDK folder to /dev/shm and provide that as a -vm parameter to eclipse. Lo and behold! Eclipse runs about 10 times faster on my ubuntu machine. Try it yourself and let me know (If you are having performance issues with Eclipse, that is..-).
