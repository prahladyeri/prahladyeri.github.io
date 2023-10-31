---
layout: post
title: 'The 7 "Bread and Butter" Plugins for your Wordpress blog'
tags: wordpress php
---

Based on my experiments while setting up this blog, below are the 7 "bread and butter" plugins for your wordpress blog. These plugins came very handy for me and allowed me to seamlessly integrate much needed functionality in my blog without writing a single line of php code.<!--more-->

[![Wordpress Plugin](/uploads/old/database_active.png){.alignnone .wp-image-186 width="77" height="77"}](/uploads/old/database_active.png)

1.  **[Contact Form 7](http://wordpress.org/plugins/contact-form-7/) (Contact Forms): **While designing this blog, a Contact page was one of my primary requirements. This plugin is popular and well maintained. Once installed, you will have a Contact tab on your dashboard that has a default contact-form with a short-code. You can copy-paste this short-code into any post or page of yours, and lo and behold! You have a contact form ready ~~such as [the one on this blog](http://prahladyeri.github.io/contact/)~~. Of course, you can customize the default contact-form to change the fields to suit your particular needs. By default, the form filled by the user is mailed to the admin user's email address. If you want to store the form data in the WP database in addition to that, you will have to install the [Flamingo](http://wordpress.org/extend/plugins/flamingo/) plugin along with this.
2.  **[Jetpack](http://wordpress.org/plugins/jetpack/) (Multi-purpose): **This is what I would term the "bread-and-butter" plugin for wordpress blog owners. Brought to you by Automattic (the company behind Wordpress), this plugin provides almost every feature a blogger can think of such as:
    -   Comprehensive statistics such as hits per page/post, incoming/outoing links, referrals, etc.
    -   Social buttons and a social-networking based comment system.
    -   Email subscriptions for your blog posts and comments.
    -   A mobile theme that automatically streamlines your site for mobile visitors.
    -   Allowing your readers to login to your blog using their wordpress.com account.
3.  **[Akismet](http://wordpress.org/plugins/akismet/) (Spam control): **Again, this is a "bread and butter" kind of plugin. What kind of blogger, in his right mind, will trust comments on his high-traffic blog to be spam free! Akismet is a web-service that specializes in eradicating spam. Once you install this plugin, all your comments will be scanned by this web service before they make way to your dashboard.
4.  **[WordPress Importer](http://wordpress.org/extend/plugins/wordpress-importer/) (migrating your existing wordpress blog): **If you are migrating your posts from another wordpress hosted blog or a wordpress.com blog (like I did), you need this plugin to import the posts that you exported from there. In fact, wordpress automatically prompts you to install this plugin when you go to Dashboard-\>Tools-\>Import to import your posts.
5.  **[XML Sitemap & Google News Feeds](http://wordpress.org/plugins/xml-sitemap-feed/) (Submitting sitemaps to spiders): **A well written blog must also be searchable by spiders and search-engines, so that it can send readers to your blog. Now, when you submit your blog url to the search-engines like Google or Bing, it pays to have a sitemap so that the spiders know how is your blog or website structured. After installing this plugin, an automatic sitemap url is seamlessly generated for you at http://Your-WP-URL/sitemap.xml. You can then submit this sitemap url to the search engines and thus increase the visibility of your wordpress blog.
6.  **[W3 Total Cache](http://wordpress.org/plugins/w3-total-cache/) (caching and performance): **Whilst I haven't installed this plugin myself yet, it is said to improve the performance of your blog by serving static content to your users instead of running heavy-duty php scripts that increase your backend load. This plugin is also recommended by the XML Sitemap plugin.
7.  **[Backup](http://wordpress.org/plugins/backup/) (backing up your wordpress site):** You usually take an export of your posts from the Tools-Export menu, but if you want to backup your entire wordpress blog including the mysql database dump and all files used for hosting your wordpress blog, then this plugin is the way to go.
