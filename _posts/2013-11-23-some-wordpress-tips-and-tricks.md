---
layout: post
title: 'Some Wordpress tips and tricks'
tags: wordpress php
---

Wordpress is a universally recognized and robust blogging platform written in the PHP language. Below are a bunch of Wordpress tricks that I've learned during my deployments, and I'd like to share with you.

***1. Change breadcrumbs to start from "Home" instead of Site-Title***: When I set up this site, the breadcrumbs in the post used to read like this:

[Prahlad Yeri » ](https://prahladyeri.github.io/)[wordpress » ](https://prahladyeri.github.io/category/wordpress/)WordPress installation quick-start guide

However, I wanted it to look like this:

[Home » ](https://prahladyeri.github.io/)[wordpress » ](https://prahladyeri.github.io/category/wordpress/)WordPress installation quick-start guide

In order to do that, you need to look into your theme-functions.php file and see where wordpress is echoing your breadcrumbs. In the mantra theme, I found this in the function mantra\_breadcrumbs(). So accordingly, I changed get\_bloginfo('name') and hard-coded it to 'Home':

    //changed by prahlad
    //echo '<a href="'.get_bloginfo('url').'">'.get_bloginfo('name').' &raquo; </a>'; 
    echo '<a href="'.get_bloginfo('url').'">'.'Home'.' &raquo; </a>';

You have to do this at multiple places in the mantra\_breadcrumbs() (or your theme's equivalent function) wherever get\_bloginfo('name') is used and replace it with 'Home'.

***2. How to crop off the big page-title that appears on top of pages:* **This is a nice little css trick.  Just open your theme's style.css and switch off the display for "entry-title" class elements within the "page" class elements. This will hide the page titles only on page-titles (and not posts!):

    /*start: prahlad - used to hide post-titles on all pages (not posts)*/
    .page .entry-title {
     display: none;
    }
    /*end: prahlad*/

If you notice that some whitespace is still left on top of the page, you can try some of these modifiers:

    .site-header {
     padding-bottom: 0;
    }

    .site-content {
     margin-top: 0;
    }

    #content {
     margin-top: -20px;
    }

***3. How to add a contact-form to your post or page:***  In order to do that you need a Contact-Form plugin. The most popular and well-maintained plugin at that is "Contact-Forms 7":

<http://wordpress.org/plugins/contact-form-7/>

This is a pretty decent form plugin that, from a single line of short-code (in your page or post), creates a basic all-purpose contact-form such as this:

![Page created with Contact Forms 7](/uploads/old/Contact-Forms-7.png)

**Page created with Contact Forms 7**

When you install this plugin, you will see an additional "Contact" tab in your dashboard. When you click that, you will see a default form with a short-code like this:

    [contact-form-7 id="116" title="Contact form 1"]

You can copy-paste this short-code anywhere in the editor for your page or post. For this site's contact page, it looked something like this:

    [contact-form-7 id="116" title="Contact form 1"]

By default, the information in the text-fields are mailed to the admin user's email-address when a user submits this form. You can change all this by editing the default form that you find in the "Contact" tab of your dashboard. You can add/remove the text-fields, add validation and much [more](http://contactform7.com/tag-syntax/).

Another plugin that works in combination with this is the [flamingo plugin](http://wordpress.org/plugins/flamingo). It is useful in case you want to store the contact information in the wordpress database in addition to getting it mailed to your email address.

***4: Change the footer notices (such as "Powered by Wordpress", etc..):*** Just open your footer.php from editor and try to find a snippet such as this:

    <footer id="colophon" role="contentinfo">
     <div class="site-info">
     <?php do_action( 'twentytwelve_credits' ); ?>

Change it accordingly to suit your needs.

***References:***

- <http://www.cryoutcreations.eu/forums/t/breadcrumbs-how-to-show-home-instead-of-site-title-in-the-breadcrumbs>
- <http://wordpress.org/plugins/contact-form-7/>
- <http://www.wpsquared.com/top-10-wordpress-contact-form-plugins/>
- <http://wordpress.org/support/topic/plugin-contact-form-7-16?replies=5>
- <http://contactform7.com/text-fields/>
- <http://contactform7.com/tag-syntax/>
