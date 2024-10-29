---
layout: post
title: 'An interesting tale from history: what the Noscript vs. Adblock Plus incident taught us about add-on security'
image: '/uploads/abp-vs-noscript.webp'
tags: firefox chrome
---
Firefox has long been a pillar of the open-source software community, renowned for its commitment to privacy, freedom, and transparency. With strict guidelines for what enters its add-on repository, it’s easy to assume that developers of highly popular extensions share these same values. But sometimes, reality challenges our assumptions in unexpected ways. 

Let’s revisit an intriguing tale from 2009 that changed the way we think about browser add-on security: the infamous clash between two popular Firefox add-ons, **Adblock Plus (ABP)** and **Noscript**. This story isn’t just a moment of open-source drama—it’s a cautionary tale about trust, transparency, and how we evaluate the tools we rely on every day.

#### **The incident: Noscript vs. Adblock Plus – a code war unfolds**

Back in 2009, Noscript, a popular security add-on developed by Giorgio Maone, was partially funded by advertisements. To earn revenue, Giorgio’s add-on quietly whitelisted his own ad-supported websites within Adblock Plus (ABP) without user consent. But it wasn’t a simple whitelist addition; Noscript altered ABP’s internal settings to achieve this, effectively hacking into a fellow add-on’s functionality. This was more than a simple slip-up; it was a violation of user trust.

Naturally, the move didn’t go unnoticed. **Wladimir Palant**, the developer behind Adblock Plus, discovered the modifications, sparking a public outcry and addressing it in a detailed blog post titled “[Attention Noscript users](https://forum.adblockplus.org/viewtopic.php?t=7356)” . What ensued was a very public “code war” between the developers, highlighting a significant vulnerability in how Firefox extensions interacted with each other at that time.

![abp-vs-noscript.webp](/uploads/abp-vs-noscript.webp)

#### **Why this incident still matters today**

Noscript’s actions might seem minor in hindsight—especially after Giorgio’s public apology on his blog, “[Dear Adblock Plus and Noscript users, dear Mozilla community](http://hackademix.net/2009/05/04/dear-adblock-plus-and-noscript-users-dear-mozilla-community)” —but the implications ran deeper. This wasn’t just about one developer’s questionable judgment. It was a moment that revealed a larger issue: Firefox’s add-on architecture didn’t provide users with adequate control or visibility over permissions.

It also raised broader questions: If a security-focused extension like Noscript could manipulate another extension, what about the myriad lesser-known plugins users were installing without a second thought?

#### **Lessons learned: modern add-on security and transparency**

Over the years, browsers have evolved, and so have the security measures around add-ons. Today, **permission-based security models** are the industry standard, with browsers like Chrome and Firefox explicitly informing users about what an extension can access. Mozilla, in particular, has introduced **WebExtensions**, a new architecture that offers enhanced isolation between add-ons to prevent similar incidents.

However, it’s not just about architectural changes. This story underscores the need for vigilance when using third-party extensions. Here are a few best practices to keep in mind:

1. **Review Permissions:** Always check the permissions requested by an add-on. If it seems to require more access than its function justifies, it’s worth reconsidering.
2. **Stick to Trusted Developers:** While popularity doesn’t guarantee trustworthiness, sticking to well-known and highly rated add-ons with transparent histories is usually safer.
3. **Stay Updated:** Browser policies and extension capabilities change frequently. Regularly review your installed extensions to ensure they’re up-to-date and still secure.

#### **How far we’ve come: the evolution of add-on policies**

It’s interesting to reflect on how far we’ve come since the Noscript-ABP incident. Mozilla’s **addons.mozilla.org (AMO)** now subjects all add-ons to automated and manual reviews. There are stricter guidelines, better transparency, and a comprehensive permission system in place.

The Firefox add-on saga is a valuable reminder of how even open-source ecosystems are susceptible to lapses in transparency and accountability. It’s a testament to the need for constant evolution in how browsers handle user privacy and security.

#### **A final thought**

In hindsight, the Noscript and ABP conflict was more than just a developer feud—it was a pivotal moment that shaped the future of browser security. As users, we benefit from this history, with safer add-ons and better guidelines. But as technology evolves, so do the risks, and it’s on all of us to stay informed and vigilant.

So, the next time you click “Add to Firefox,” remember: every piece of software has a story, and it’s worth taking the time to understand it.

