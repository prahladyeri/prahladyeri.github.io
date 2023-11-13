---
layout: post
title: 'How to import Disqus comments into Wordpress'
tags: blogging disqus wordpress
---

**Update** [Also check out this recent post which has further fixes and refactoring done to the console.php script](/blog/2020/03/comments-migration-from-disqus-to-wordpress.html)

Some time ago, I had switched from a self-hosted wordpress blog to a statically generated (Jekyll) blog hosted on Github Pages. For a commenting system, Disqus was quite an easy choice at that time since it was zero hassle for us site owners, and Disqus did all the heavy lifting from filtering the comments to storing and displaying them.

![Blog](/uploads/2017/09/pexels-photo-262508.jpeg)

But as time went on, I started realizing that implementing a static blog was not quite the right thing. Firstly, there were [privacy issues](https://en.wikipedia.org/wiki/Disqus#Criticism_and_privacy_concerns) around Disqus because of which many readers of my blog were discouraged from commenting. Secondly, the concept of a "static site" itself felt quite constraining to me as I couldn't implement things like contact form or a questionnaire to interact with my viewers. As a result, I decided to switch back to a plain old self-hosted wordpress blog.

Now, importing the posts was quite straightforward using the Jekyll generated RSS feed link that was pretty straightforward to use. In case you don't have it in your Jekyll blog, its very easy to write one using liquid template. Just create a file named **rss.xml** in your root folder with below contents:

```xml
{%raw%}
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
 <channel>
 <title>{{ site.name | xml_escape }} - Articles</title>
 <description>{% if site.description %}{{ site.description | xml_escape }}{% endif %}</description>
 <link>
 {{ site.url }}</link>
 {% for post in site.posts %}
 {% unless post.link %}
 <item>
 <title>{{ post.title | xml_escape }}</title>
 <description>{{ post.content | xml_escape }}</description>
 <pubDate>{{ post.date | date: "%a, %d %b %Y %H:%M:%S %z" }}</pubDate>
 <link>
 {{ site.url }}{{ post.url }}</link>
 <guid isPermaLink="true">{{ site.url }}{{ post.url }}</guid>
 </item>
 {% endunless %}
 {% endfor %}
 </channel>
</rss>
{%endraw%}
```

Once you generate the blog, you can import all posts into your wordpress by referring to the /rss.xml url on your existing Jekyll blog.

However, the bigger issue here was importing the Disqus comments, becuase while Disqus does allow you to [export a dump of your site comments](https://help.disqus.com/customer/portal/articles/472149-comments-export), their XML format is pretty weird and isn't the standard one used by wordpress and other blogging systems, as a result of which there aren't too many ready tools for importing comments from this format to any other system.

As a result, I had to write my own Wordpress importer tool. Since I did not want to go through the hassle of learning to create an "admin plugin" with all the bells and whistles, I decided to write a simple PHP console script to import the XML as mentioned [here](https://wordpress.stackexchange.com/a/76466/52396).

All I needed were two scripts: A parser script to parse the XML output of Disqus comments dump, and secondly, a wordpress handler that loops through these comments and imports them one by one by matching the post's url attribute and running **wp\_new\_comment()** to insert the comment (you can also use the older **wp\_insert\_comment()**, but its not the recommended way according to the wordpress codex).

Below is the source code for both these files. First one, **console.php** is the wordpress handler that you need to run, passing the path of the Disqus comments dump file. And **disqus\_parse.php** is the parser which is called internally by console.php. You need to copy these two files anywhere inside your WP folder structure (I copied them to **/wp-content/plugins/test/** folder), and run the console.php from the command line:

**console.php:**

<https://gist.github.com/prahladyeri/e22e4e232416ff841be670601b396c62>

**disqus_parse.php**

<https://gist.github.com/prahladyeri/d1e19d8a6d0c7ff23fe3e15f9050b6d3>

Finally, just keep one thing in mind before running the console.php. Your wordpress system might throw an exception in case it detects too many comments being inserted in a loop. To suppress that exception, you need to add the following line of code to the end of your theme's **functions.php** to disable the comment flood filter:

```
add_filter('comment_flood_filter', '__return_false');
```

Of course, remember to comment that line once you are done importing the comments.
