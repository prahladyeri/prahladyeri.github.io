---
layout: post
title: "Wordpress DIY: Adding Google Analytics Script to your Blog Without using an External Plugin"
tags: php wordpress
---

Adding a custom script element to your Wordpress blog is really straightforward if you know what you are doing and there isn't any need to install a third-party plugin for this.<!--more-->

Now, for something like spam protection (Akismet) or adding contact forms (Contact Form Seven), its quite understandable, but if you take the approach of adding third party plugins for every little plus and minus operation (such as adding a Google Analytics script), then its neither good for the maintenance nor security of your Wordpress blog.

In this article, I'm going to explain how to create a simple custom plugin for your Wordpress blog that you'll hand-code yourself. The custom plugin will be quite generic and can be later used for adding other elements too such as maybe twitter card attributes, etc.

Create the following PHP Plugin file in the code editor of your choice and save it as **/wp-content/plugins/custom\_headers.php** in your Wordpress installation.

    <?php 
    /**
     * @package Custom Headers
     * @version 0.1.0
     */
    /*
    Plugin Name: Custom Headers
    Plugin URI: http://github.com/prahladyeri/custom-headers/
    Description: Add a bunch of custom headers before the head tag.
    Author: Prahlad Yeri
    Version: 0.1.0
    Author URI: https://prahladyeri.github.io
    */

    function add_analytics_header() {
    $analytics=<<<EOD
    <-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=UA-XXXXXXX-X">
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      gtag('config', 'UA-XXXXXXX-X');
    </script>
    EOD;
        echo $analytics;
    }
    add_action('wp_head', 'add_analytics_header');

Just remember to update the package meta stuff (Plugin Name, Author, etc.) as it suits you and put your own Analytics ID in place of UA-XXXXXXX-X.

Its as simple as that, your plugin is ready! Just enable this plugin by going to Plugins-\>Installed Plugins in your Wordpress admin panel.
