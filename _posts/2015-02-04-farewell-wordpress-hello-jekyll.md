---
layout: post
title: 'Farewell Wordpress, Hello Jekyll!'
tags: php wordpress jekyll
---

Here I am, signing off from a *self-hosted, over-bloated [Wordpress](http://www.wordpress.org)* site and finding a welcome change in [Jekyll](http://jekyllrb.com/), a blog-aware static site generator. There is nothing new about this, several well-known bloggers have already migrated to Jekyll in the last few years including [Rasmus Andersson](http://rsms.me/), [Nick Quaranto](http://quaran.to/) and [Roger Chapman](http://rogchap.com/). Ever since Tom Preston Werner invented this thing in 2008 and published his infamous article about [Blogging Like a Hacker](http://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html), it has become the *Go-to thing* for those of us who favour on-line publishing above everything else.<!--more-->

And that’s for many good reasons, the most important being a major issue with Wordpress design - *Of what use is an RDBMS database like mysql in a weblog?*. I think this question should have been asked the day Wordpress was invented. However, since there weren’t too many alternatives in those days and `php` hosting was *way too easy*, most ignored this factor.

### Save me a ton of money

Jekyll generates static sites made of pure HTML/CSS. A static site is a website whose content stays static (*unchanged by any user-input*) on the server-side (though dynamic functionality can be provided on the client-side using javascript). What this means is that you are not only done away with the hassle of hosting your own database, but also avoid *costly monthly fees* going to your Web Hosting Providers. That’s because unlike a `php` hosted dynamic site, a static site is much much faster and cheaper. In fact, [Github pages](https://github.com/jekyll/jekyll/wiki/Sites) provides you free static web hosting without any bandwidth or space restrictions!

### How do I implement this?

The *References* section at the bottom contains a couple of links to detailed migration guides if you intend to go this route. As any seasoned `php` programmer would tell you, programming in a language like `php` isn’t everyone’s cup of tea. While you don’t have to do any programming for hosting a static site, you should still know about a few things in order to implement a static site:

-   [Jekyll](http://jekyllrb.com/): Jekyll is a command line tool written in `ruby` language to generate blog-aware static sites (like the one you are presently viewing). Visit the link to find docs that explain what Jekyll is, how to install ruby and jekyll on your system and publish your posts.
-   [Markdown](http://daringfireball.net/projects/markdown/syntax): `Markdown` is a beautiful language crafted specially with on-line publishers in mind. Jekyll posts written in `Markdown` syntax are saved with the extension of `.md`. While you can write posts in plain old html syntax too, knowing markdown comes very handy and saves time.

For instance, when I write:

	[Jekyll](http://jekyllrb.com/)
        
It becomes:

[Jekyll](http://jekyllrb.com/)

Making lists, headings, etc. is as easy. For instance,

```
### Three hashes means H3
#### Four hashes means H4
1. This is list-item1
2. This is list-item2
```

becomes:

### Three hashes means H3

#### Four hashes means H4

1.  This is list-item1
2.  This is list-item2

-   [Disqus](https://disqus.com/): Perhaps the only feature for which most bloggers need a dynamic site is that of posting comments. Thanks to services like disqus, bloggers can now leave the hassle of maintaining their own database for storing their readers’ comments. Disqus does this for them. Read on the link to find out how to implement it on your Jekyll blog.
-   [Github pages](https://github.com/jekyll/jekyll/wiki/Sites): Github pages is literally a boon for us bloggers. I’m aware of no other static web hosting service that lets you host unlimited content with practically unlimited bandwidth!
-   [Google Analytics](https://www.google.com/analytics): This is an invaluable service from Google used for tracking the web traffic on your blog or website. And not just hit-counts, you get to know what kinds of visitors come to your site based on demographic stats like location, age-group, gender, likes/dislikes, etc. All you have to do is put a bunch of code that analytics site provides you in your jekyll default template. Even when I was on Wordpress, I was using Google Analytics instead of the various stats plugins that come with Wordpress.

### Outcome

Jekyll feels so good that I can’t recommend you enough of it! If you are presently using a self-hosted wordpress site and want to migrate to Jekyll and Github-pages, just go ahead and do it without any second thoughts. And after that, please let me know about your migration experience through `disqus` comments below this post!

*Reference:*

-   [Wordpress to Jekyll - Migration guide](http://hadihariri.com/2013/12/24/migrating-from-wordpress-to-jekyll/)
-   [Wordpress to Jekyll - How to](http://paulstamatiou.com/how-to-wordpress-to-jekyll/)
-   [Jekyll, A blog aware static site generator](https://github.com/jekyll/jekyll/wiki/Sites)
-   [Blogging Like a Hacker](http://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html)
-   [Jekyll, Wikipedia](http://en.wikipedia.org/wiki/Jekyll_%28software%29)
-   [Github pages](https://github.com/jekyll/jekyll/wiki/Sites)
-   [How to set up a custom domain with Github pages](https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages/)
-   [Poole - A minimalistic Jekyll theme](http://joshualande.com/jekyll-github-pages-poole/)
