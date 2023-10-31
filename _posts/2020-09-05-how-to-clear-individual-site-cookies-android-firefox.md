---
layout: post
title: How to clear individual site cookies on android firefox
tags: android firefox
---

One might wonder why an entire blog post is needed for a simple matter of clearing cookies on a web browser in the 21st century. But believe it or not, such are the state of things when it comes to android browsing! Firefox is a great browser to have on Android because it gives you three features which are impossible to get even with Google's Chrome:

1. Plugin Support
2. Ad Blocking
3. Data Privacy 

That's why over 3 million users have decided to stick with firefox despite the fact that its performance totally lacks in comparison to Chrome. Even so, there are some annoying bugs in firefox such as not being able to clear cookies for individual websites (at least as of version 68.11). This seemingly simple feature isn't available out of the box on firefox and when I googled for it, I found two solutions:

1. As this [android stackexchange answer](https://android.stackexchange.com/a/120476/38760) suggests, you can try extracting the below data file (where firefox stores cookies) to your PC, edit it and then put it back (you must be rooted though):

        /data/data/org.mozilla.firefox/files/mozilla/{YOUR_PROFILE}/cookies.sqlite

2. But if you aren't rooted or you don't want to go through the above troubled exercise, I've found a much simpler solution which is to install [this extension called Cookie Manager by Rob W](https://addons.mozilla.org/en-US/firefox/addon/a-cookie-manager).

Since the android firefox browser supports extensions, I found it much easier to just install this extension, open it and type a domain such as *.reddit.com for which you want the cookies deleted, and press the "Search cookies" button:

![cookie manager](/uploads/cookie_manager.png)

Then you just click the "Select all" button at the bottom followed by "Remove selected", that's it!
