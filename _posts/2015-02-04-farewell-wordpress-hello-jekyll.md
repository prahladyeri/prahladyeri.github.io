---
layout: post
title: 'Migrating from WordPress to Jekyll: save money with a static site'
tags: php wordpress jekyll
image: /uploads/migrate-wp-jekyll.jpg
---

Here I am, signing off from a self-hosted [WordPress](http://www.wordpress.org) site and finding a welcome change in [Jekyll](http://jekyllrb.com/), a blog-aware static site generator. There is nothing new about this, several well-known bloggers have already migrated to Jekyll in the last few years. Ever since Tom Preston Werner created this software in 2008 and published his infamous article about [Blogging Like a Hacker](http://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html), it has become the go-to thing for at least the small and indie bloggers.

While WordPress is a powerful platform, it can feel over-engineered for simple blogging needs. For indie bloggers who don't need the complexities of a RDBMS like MySQL, a static site could be a more efficient solution. The hassles of administering and maintaining various themes and plugins could feel overwhelming at times. However, since there weren’t too many alternatives in those days and PHP hosting was an easy path, many ignored this factor.

### How Jekyll can save you hosting costs

Jekyll generates static sites made of pure HTML/CSS. Static sites, unlike dynamic ones, don’t require server-side processing or database queries, which reduces hosting resource usage and speeds up load times. This makes static sites both cost-efficient and faster. In fact, [Github pages](https://github.com/jekyll/jekyll/wiki/Sites) provides you fully free static hosting for Zero USD per month!

![migrate-wp-jekyll](/uploads/migrate-wp-jekyll.jpg)

### Jekyll vs WordPress: A closer look

While both Jekyll and WordPress serve the purpose of creating websites, they differ in several key areas, making Jekyll a better choice for specific use cases like simple blogs or static sites.

1. **Speed and Performance**: WordPress relies heavily on server-side PHP scripts and database queries to dynamically generate pages, which can slow down site performance, especially if not optimized. On the other hand, Jekyll pre-generates static HTML pages, significantly reducing load times as there's no need to process requests or queries. Static sites also tend to perform better under heavy traffic since they're served directly from the server without any backend processing.

2. **Security**: WordPress’s widespread usage makes it a common target for hackers, particularly due to vulnerabilities in plugins, themes, or unpatched core software. Jekyll, by contrast, is far less prone to security breaches because static sites don’t require a database or server-side processing, reducing potential attack vectors. With Jekyll, you don’t have to worry about plugin updates or securing a backend.

3. **Customization and Plugins**: WordPress shines when it comes to flexibility through its vast ecosystem of plugins and themes. However, this can lead to bloat, slowing down your site. Jekyll’s simplicity means fewer customization options compared to WordPress, but it also means less overhead. Instead of relying on plugins, you can customize your Jekyll site directly through code, giving you full control without unnecessary baggage.

4. **Maintenance**: WordPress sites require regular maintenance, such as updating plugins, themes, and the WordPress core itself. This can be time-consuming and may lead to incompatibilities. With Jekyll, maintenance is minimal—once your site is deployed, it’s mostly hands-off. There's no need to manage databases, perform software updates, or worry about downtime due to version conflicts.

In essence, if you're running a content-heavy blog that doesn’t need dynamic features or heavy customization, Jekyll can save you time and resources. For more feature-rich or complex sites, WordPress remains a powerful choice but comes with its own set of maintenance responsibilities.

### SEO and other challenges with Jekyll

While Jekyll offers numerous benefits in terms of speed, cost, and simplicity, there are a few considerations that you should keep in mind before making the switch.

1. **SEO (Search Engine Optimization)**: In WordPress, SEO optimization is often handled through plugins like Yoast, which makes it easy to tweak meta tags, sitemaps, and other SEO-related elements. With Jekyll, these features aren’t built-in, and you’ll need to configure your SEO manually. This means writing metadata directly into your HTML or Markdown files and creating your own XML sitemaps. Fortunately, there are [Jekyll plugins](https://jekyll.github.io/plugins/) for generating sitemaps, RSS feeds, and optimizing metadata for SEO, but setting them up might require some coding knowledge.

2. **Dynamic Content**: One of WordPress’s biggest advantages is its ability to handle dynamic content like comments, forms, or membership systems. While services like [Disqus](https://disqus.com/) or [Staticman](https://staticman.net/) can add dynamic features like comments to Jekyll sites, they don’t offer the same level of functionality or flexibility that WordPress does. For bloggers who want more interactive features like user logins, contact forms, or complex ecommerce capabilities, WordPress may still be the better option.

3. **Learning Curve**: While Jekyll is simpler in terms of maintenance, there’s a learning curve when it comes to getting started. You’ll need to be comfortable with the command line, Git, and Markdown, as well as basic HTML and CSS for customizations. While WordPress allows users to manage their site through a graphical interface, Jekyll requires a more hands-on approach, which might be daunting for beginners.

4. **Third-Party Integrations**: WordPress integrates seamlessly with various third-party services through its plugin ecosystem, from payment gateways to email marketing platforms. Jekyll, while offering more control, may require additional effort to integrate with these services manually.

Despite these challenges, Jekyll’s advantages—especially in terms of speed, security, and cost—far outweigh the downsides for users looking for a simple, fast, and secure platform for static content.

### The implementation

As any seasoned PHP programmer would tell you, programming in a language like PHP isn’t everyone’s cup of tea. While you don’t have to do any programming for hosting a static site, you should still know about a few things in order to implement a static site:

-   [Jekyll](http://jekyllrb.com/): Jekyll is a static site generation tool written in Ruby language to generate blog-aware static sites (like the one you are presently reading). Visit the link to find documentation that explain what Jekyll is, how to install Ruby and Jekyll on your system and publish your posts with it.
-   [Markdown](http://daringfireball.net/projects/markdown/syntax): Markdown is a utilitarian formatting language crafted specially with online publishers in mind. Jekyll posts written in Markdown syntax are saved with the extension of `*.md`. While you can write posts in HTML syntax too, knowing markdown comes very handy and saves time.

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

---

### Tools of the trade

-   [Disqus](https://disqus.com/): Perhaps the only feature for which most indie bloggers need a dynamic site is that of posting comments. Thanks to services like Disqus, bloggers can now leave the hassle of maintaining their own database for storing their readers’ comments. Disqus does this for them.
-   [Github pages](https://github.com/jekyll/jekyll/wiki/Sites): GitHub Pages is an excellent option for bloggers looking for a reliable, free static web hosting service. It offers generous bandwidth and content hosting, making it a great choice for many users, especially those who want to keep costs low while maintaining flexibility.
-   [Google Analytics](https://www.google.com/analytics): Google Analytics integrates seamlessly with Jekyll, providing valuable insights into your audience demographics and behaviors without needing additional WordPress plugins.

### Outcome: Why Jekyll is worth the switch

After making the switch from WordPress to Jekyll, I can confidently say that the benefits of a static site far outweigh the initial setup effort. From improved site performance and lower hosting costs to greater security and minimal maintenance, Jekyll has proven to be a highly efficient platform for my blogging needs.

If you're running a simple blog, personal portfolio, or documentation site, and you're tired of managing a database and paying for expensive hosting, Jekyll might just be the solution you've been looking for. By leveraging GitHub Pages and static site generation, you can enjoy the peace of mind that comes with a fast, secure, and cost-effective website.

**Take the leap today** and explore Jekyll as your next blogging platform. With plenty of resources and guides available, including some I’ve listed in the references and migration checklist below, you’ll find the transition smoother than expected.

### Migration checklist

| Step | Description | Tools/Resources |
|------|-------------|-----------------|
| **1. Backup Your WordPress Site** | Before making any changes, back up your WordPress site, including the database and files. | [UpdraftPlus](https://wordpress.org/plugins/updraftplus/), [All-in-One WP Migration](https://wordpress.org/plugins/all-in-one-wp-migration/) |
| **2. Install Ruby and Jekyll** | Set up Ruby and Jekyll on your local machine to create and manage your static site. | [Jekyll Installation Guide](https://jekyllrb.com/docs/installation/) |
| **3. Export WordPress Content** | Use a plugin or WordPress's export tool to export your posts, pages, and media. | [Jekyll Exporter Plugin](https://wordpress.org/plugins/jekyll-exporter/), WordPress Export Tool |
| **4. Convert WordPress Content to Jekyll** | Use the exported content to convert it to Jekyll’s format, which involves generating Markdown files. | [Jekyll Exporter Plugin](https://wordpress.org/plugins/jekyll-exporter/) |
| **5. Set Up Your Jekyll Site** | Create a new Jekyll site and configure your theme, layouts, and plugins. | [Jekyll Docs](https://jekyllrb.com/docs/), [Jekyll Themes](https://jekyllthemes.io/) |
| **6. Customize Your Jekyll Site** | Modify the theme, layout, and styles to match your old WordPress site or give it a fresh design. | HTML/CSS, [Poole Jekyll Theme](http://joshualande.com/jekyll-github-pages-poole/) |
| **7. Add Comments via Disqus** | Use Disqus to handle comments since Jekyll doesn’t support dynamic comment systems. | [Disqus for Jekyll](https://disqus.com/) |
| **8. Implement SEO** | Set up SEO by adding meta tags and optimizing content. Use Jekyll plugins for sitemaps and meta tags. | [Jekyll SEO Plugin](https://github.com/jekyll/jekyll-seo-tag) |
| **9. Set Up Analytics** | Integrate Google Analytics to track your site’s performance. | [Google Analytics](https://analytics.google.com/) |
| **10. Host Your Jekyll Site** | Choose a hosting service like GitHub Pages, Netlify, or your own server. | [GitHub Pages](https://pages.github.com/), [Netlify](https://www.netlify.com/) |
| **11. Test Your Jekyll Site** | Test your static site to ensure everything is functioning as expected. | Browser, Jekyll Local Server |
| **12. Migrate DNS to New Hosting (Optional)** | If you're using a custom domain, update your DNS settings to point to the new host. | [GitHub Pages Custom Domain Setup](https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages/) |
| **13. Finalize Migration** | Once tested, finalize the migration by making the Jekyll site live and notifying users of the change. | N/A |


*Reference:*

-   [Wordpress to Jekyll - Migration guide](http://hadihariri.com/2013/12/24/migrating-from-wordpress-to-jekyll/)
-   [Wordpress to Jekyll - How to](http://paulstamatiou.com/how-to-wordpress-to-jekyll/)
-   [Jekyll, A blog aware static site generator](https://github.com/jekyll/jekyll/wiki/Sites)
-   [Blogging Like a Hacker](https://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html)
-   [Jekyll, Wikipedia](https://en.wikipedia.org/wiki/Jekyll_%28software%29)
-   [Github pages](https://github.com/jekyll/jekyll/wiki/Sites)
-   [How to set up a custom domain with Github pages](https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages/)
-   [Poole - A minimalistic Jekyll theme](http://joshualande.com/jekyll-github-pages-poole/)
