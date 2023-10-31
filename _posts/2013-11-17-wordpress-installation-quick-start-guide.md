---
layout: post
title: "Wordpress installation quick-start guide"
tags: php wordpress
---

Wordpress is a blogging platform that is very easy to use, but involves many configuration trivia which may become overwhelming, unless organized and documented somewhere. Based on my experience of setting up this website, here are the things that I had to keep in mind to get it up and running:<!--more-->

-   **Wordpress file-structure:** A brief understanding of the file structure helps before delving into the installation details. The folder where you upload the contents of wordpress installation files has an index.php file that triggers other configuration files from there. You have to setup the mysql database credentials in the *wp-config.php* file before starting the installation. Inside the root folder, there are two sub-folders, **wp-admin** and **wp-content**. The wp-admin folder stores the necessary files to bring up the admin interface when you type http://your-wp-url/wp-admin to administer your site for adding posts, moderating comments, etc. The wp-content folder on the other hand, stores contains files and folders to create the structure, functionality and look and feel of your blog. The wp-content folder further has **wp-themes** and **wp-plugins** folders. The former controls the structure and look and feel (themes), whereas the latter is for adding extra bits of extra functionality (plugins).
    -   *root-folder » index.php, wp-config.php, wp-settings.php*
        -   *wp-admin - Files & folders to control admin interface.*
        -   *wp-content*
            -   *wp-themes - Files and folders to control look and feel.*
            -   *wp-plugins - Files and folders to add bits of extra functionality.*
        -   *wp-includes - Contains header files for other php scripts.*

<!-- -->

-   **Famous File-minute installation:**Once you have the basic understanding, you may proceed with the much advertised[*famous five minute installation*](http://codex.wordpress.org/Installing_WordPress#Famous_5-Minute_Install "famous five minute installation") of your wordpress site. Basically, once you have set the mysql credentials in wp-config.php, wordpress does the rest by creating the required tables for your blog-posts, comments and other elements. But make sure, the wp-user you configure has suffient rights to create/alter/query/etc. on the wordpress database you have configured.
-   **Configuration:** These settings in wp-config.php come quite handy during deployment:
    -   DB\_NAME - mysql database name reserved for the wordpress blog.
    -   DB\_USER - mysql user-id.
    -   DB\_PASSWORD - mysql password.
    -   DB\_HOST - hostname of the machine where mysql is running.

The above settings are almost always different in your local environment from that of your web-hosting machine. Hence, it is advisable that you keep the local version of wp-config.php separate by adding an exception to version control systems like git, svn, etc. if you are using any.

-   **Site name settings:** Two php global variables called WP\_HOME and WP\_SITEURL are almost always a source of trouble during migration of wordpress sites. These variables tell wordpress the url of your currently hosted wordpress site (such as http://localhost/wp or http://www.mysite.com/blog). When you migrate your database settings to your web host, wordpress obviously can't find the localhost there. To temporarily solve this issue, you can hard-code these values at the start of wp-config.php like this:
    -   define('WP\_HOME','http://workstation2/rhc/prahladyeri/php');
    -   define('WP\_SITEURL','http://workstation2/rhc/prahladyeri/php');

Once you have access to wp-admin, you should remove them from wp-config.php and go to Settings-\>General to set these variables in a proper manner under the fields, "Wordpress Address (URL)" and "Site Address (URL)".
