---
layout: post
title: "Chrome's recent update for a 'Zero Day vulnerability' is much dicey and prone to fear mongering"
tags: chrome, browser
published: false
image: /uploads/code-unix.jpeg
---
So few days ago, Google Chrome released this much talked about "urgent security update" for this dastardly zero day vulnerability much talked about even on mainstream blogs like [Mint](https://www.livemint.com/technology/tech-news/urgent-security-alert-new-zero-day-vulnerability-discovered-in-google-chrome-cert-in-issues-high-severity-warning-11715662998232.html) and [News18](https://www.news18.com/tech/indian-govt-warns-about-major-google-chrome-security-alert-what-you-need-to-know-8887378.html).

But I'm ready to bet not one amongst you must be having the slightest idea of what this bug actually is and how likely are you of getting affected by it. After all, the greatest fear or concern one has upon hearing phrases like "urgent security alert" and "zero day" is that their device shouldn't get hacked by some rouge application or website, right?
 
The Schneier on Security blog has done a [great job here](https://www.schneier.com/blog/archives/2024/05/another-chrome-vulnerability.html) to explain what this bug exactly is and how likely are you to get impacted:

> The vulnerability, tracked as CVE-2024-4671, is a “use after free,” a class of bug that occurs in C-based programming languages. In these languages, developers must allocate memory space needed to run certain applications or operations. They do this by using “pointers” that store the memory addresses where the required data will reside. Because this space is finite, memory locations should be deallocated once the application or operation no longer needs it.

In order words, vulnerable C code must be running on your browser in order to get affected by this bug. Now the only piece of C code here is the Chrome browser itself which is written by Google developers and ideally shouldn't have this vulnerability. Even most extensions for the browser are written in pure javascript, most folks are not even aware of writing a browser extension in the C language today.

Which means, the only way of running external C code on your browser is you installing a third party plugin or something written in C? Now that reduces the attack vector by a tremendous factor here, me thinks. How many of you even use unofficial plugins for things like playing proprietary audio and video? The only potential "attackers" here are developers of these third party plugins which run inside your browser.

Now if they actually mention that, can you imagine how many users will be stepping over their breakfast table and rushing to their computer desk to update their browser upon hearing words like "urgent", "zero day", etc? Not many I imagine! These are just ploys by big tech companies to achieve their periodical targets for deployment or install counts, don't fall for this in future!