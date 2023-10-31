---
layout: post
title: "Google appengine tip: How to clear appcfg credential cache"
tags: google-app-engine web-development
---

Many a times, it so happens that you need to work with multiple credentials while uploading/downloading apps on Google appengine. In such a scenario, it becomes difficult to switch credentials instantly.<!--more-->

[![gae\_new\_Logo](/uploads/old/gae_new_Logo.png){.alignnone .size-full .wp-image-1382 width="54" height="48"}](/uploads/old/gae_new_Logo.png)

For instance, you have just uploaded an app using appcfg.py with your google credentials and they are still stored in the cache. So when you want to upload a new app, it won't ask you for email/password and still try to retrieve old credentials automatically ignoring any command-line parameters you have given! Thus, you keep scratching your head as to why you are getting a permission-denied error while uploading/downloading the app!

The only way out here is clearing the credential cache of appcfg. On Linux systems, these are stored in a file called:

	/home/username/.appcfg_cookies

On Windows based systems, these are typically stored in:

	C:\Users\username\.appcfg_cookies

Just delete this file and you are done! Next time, appcfg.py will ask you for a fresh google email and password, thus enabling you to upload/download your app.

*References:*

<http://stackoverflow.com/q/5149914/849365>