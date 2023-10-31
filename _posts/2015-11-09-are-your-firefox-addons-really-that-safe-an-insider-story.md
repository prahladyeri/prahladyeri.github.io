---
layout: post
title: 'Are your Firefox addons really that safe? - An Insider Story'
tags: linux
---

Firefox is one of the most competitive FOSS browsers out there, there is no denying it. Mozilla also has strict guidelines regarding what goes into their repos. And in the spirit of all things open source, you may naturally tend to believe that developers who have written your coolest new *million ratings plus* addon are also held to Mozilla’s high standards and subject to all quality audits.<!--more-->

Well, read this short story before subjecting yourself to that blind faith and just clicking on every `Add to Firefox`{.highlighter-rouge} button in your browser.

![Mozilla plugins](/uploads/old/Mozilla_plugins.png)

This story is about two popular firefox addons, *Adblock-Plus* and *Noscript*. A few years ago, the Noscript addon was at least partially funded by advertisements. To make a long tale short, the Noscript developer, Giorgio Maone decided to make Noscript meddle with the settings of ABP plugin to whitelist his own sites that earned him advertisement revenue. Of course, this attracted a lot of [unwanted attention](https://adblockplus.org/blog/attention-noscript-users) and a code war ensued between the ABP dev Wladimir Palantir and Giorgio. Things would not have gone that far, had Giorgio just “whitelisted” his advert websites using ABP’s API or other open methods. The fact that he actually hacked into Firefox internals to make his own addon override Wladimir’s ABP is what made all hell break loose.

The most ironical about this is the fact that *Noscript* itself is a security-plugin, meaning it is used to block adware to keep the user safe! If the developer of a plugin like *Noscript* would do this, then just think about what all stupid things those random developers of funky little addons might be doing. Of course, Giorgio [publicly apologized](http://hackademix.net/2009/05/04/dear-adblock-plus-and-noscript-users-dear-mozilla-community/) for the debacle he had caused and reading his sincere apology might almost make you forget all qualms about addon security. But the issue here is not about this little turf war between ABP and Noscript, nor is it about what Giorgio did was right or wrong, he handled the situation correctly, regardless. The larger issue here is the security architecture in the entire firefox ecosystem.

You see, when I install a Chrome addon, it asks me as a user what all permissions it needs to be granted. I will know at once, whether it is going to write to my file system, or access the HTML tags in the browser, and it most certainly tells me whether it could play havoc with the other installed addons or not (as happened in this case). Its high time that Firefox too needs to come up with such granular security levels when it comes to installing addons. Only then, incidents like the Noscript debacle can be safely prevented.

So, next time when you click on that *Add to Firefox* button on the install page, just think about what all goes in a developer’s mind when they write those plugins. I know there are a lot of great FOSS developers (Wladimir and Giorgio included) who selflessly contribute to the open source software, but it is not always apparent whether it is purely out of selflessness or there is an insidious motive on their part to make money by using the users of their addons.

References:

<https://adblockplus.org/blog/attention-noscript-users>\
<http://hackademix.net/2009/05/04/dear-adblock-plus-and-noscript-users-dear-mozilla-community>
