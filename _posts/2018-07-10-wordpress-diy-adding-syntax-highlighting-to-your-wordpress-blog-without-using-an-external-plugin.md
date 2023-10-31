---
layout: post
title: 'WordPress DIY: Adding syntax highlighting to your WordPress blog without using an external plugin'
tags: php wordpress
---

Just as my other articles in [WordPress DIY](https://prahladyeri.github.io/blog/tag/wordpress+diy) series, this one also focuses on doing everything yourself by writing the code rather than using any external dependencies. There are two popular open source implementations of Syntax Highlighting JavaScript libraries: [Google's Prettify](https://github.com/google/code-prettify) and [Alex Gorbatchev's Syntax Highlighter](http://alexgorbatchev.com/SyntaxHighlighter/), and in this article, we will use the former.<!--more--> Writing your own plugin for syntax highlighting is very straightforward if you know what you are doing. Just create a file named **/wp-content/plugins/wp-prettify.php** in your WordPress installation and add the below code to it:

    <?php
    /**
     * @package WP Prettify
     * @version 0.1.0
     */
    /*
    Plugin Name: WP Prettify
    Plugin URI: http://github.com/prahladyeri/wp-prettify
    Description: Wordpress implementation of Google Prettify Syntax Highlighter
    Author: Prahlad Yeri
    Author URI: https://prahladyeri.github.io/
    Version: 0.1.0
    License: GPL version 2 or later - http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
    */


    function add_syntax_highlighter() {
    $text=<<<EOD
    <script>
    document.addEventListener('DOMContentLoaded', function(){
        var elements = document.getElementsByTagName('pre');
        for(var i=0;i<elements.length;i++) {
            if (elements[i].className.indexOf("prettyprint") == -1) {
                elements[i].className =   elements[i].className + " prettyprint "
                console.log('adding');
            }
            else {
              console.log('class already exists');
            }
        }
    });
    </script>
    <style>
    pre.prettyprint.prettyprinted {
      border: 0px;
      padding: 5px;
      font-size: 15px;
    }
    </style>

    <script src="https://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js"></script>
    EOD;

        echo $text;
    }

    add_action('wp_head', 'add_syntax_highlighter');
    ?>

Remember to enable the plugin by navigating to **/wp-admin** before using it.

This function first adds a **prettyprint** class to all your \<pre\> tags to tell the Prettify library to highlight this block and thus making syntax highlighting painless on your part. The advantage of using Google's solution is that it automatically detects the programming or scripting language inside the block, and you don't have to use additional tag markup like **"lang=php"** or something like that.

The addition of CSS **\<style\>** tag in the function is optional and not really needed. Its just my preference to hide the border and increase the padding and font size a bit.

The demonstration of this self-written plugin is quite evident as this very site runs on this plugin and the above code block is highlighted using the Google's Prettify library. If you can use the Chrome or Firefox Developer tools to analyze that \<pre\> block, it will show you that a **prettyprint** class has been added!

So, go ahead and write this plugin if you are building a WordPress blog for yourself and want to do this in a DIY way.
