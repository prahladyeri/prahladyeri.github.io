---
layout: post
title: Wordpress to Pelican in 24 hours
tags: wordpress php python
---

Today, I finished migration of my blog from a self-hosted Wordpress site to a statically hosted [Github Pages](https://pages.github.com/) site. For the static site generator, instead of choosing Jekyll which is a hot favorite of rubyists, I went for [Pelican](https://github.com/getpelican/pelican/) instead as I figured my Python skills might be somewhat useful in dealing with that.

Having used Jekyll earlier, I felt that Pelican is pretty much the same thing. There is a configuration file in which you define your site parameters, a folder hierarchy for defining your posts and pages, and a bunch of templates (`pelican theme`) to make some serious customizations.

In this post, I'll briefly go through the migration process:

1. Run the standard Wordpress import tool and backup all your posts and comments. It's better if you disable comments on your site (or maybe even take it down entirely for maintenance until the migration is complete).
2. Copy the `uploads` folder containing your images through FTP/SFTP.
2. Install Python on your machine if not already installed.
3. Install the Pelican and Markdown packages:

		pip install pelican markdown

4. Install additional packages for importing the Wordpress XML:

		pip install BeautifulSoup4 lxml
		
5. Install `pandoc` as it's needed for `markdown-xml` conversion during the Wordpress import. Instructions for installing it for your OS can be found [here](https://pandoc.org/).
6. Create a new folder (such as `prahladyeri.github.io`) for your new blog writing/publishing.
7. Traverse to that folder through command line and run `pelican-quickstart`. It'll ask some basic questions like your blog name, title, etc. You can leave most to their defaults. Once done, it'll create a folder structure like below:

		d:\source\prahladyeri.github.io
		├───content                                            
		│   ├───pages                                          
		│   ├───uploads                                        
		│   │   ├───2016
		pelicanconf.py
		tasks.py
		MakeFile
	
8. `tasks.py` and `MakeFile` are something you can ignore unless you want to automate site generation. Now you can copy the `uploads` folder brought from Wordpress inside the `content` folder (it's the place where your posts will now reside in either markdown (`*.md`) or reStructured Text (`*.rst`) formats).
9. Copy the XML file imported from Wordpress inside the above folder.
10. Now simply run `pelican-import`:

		pelican-import --wpfile -m markdown <your-file.xml>
	
11. The above command converts all your Wordpress posts (not comments) into markdown format and copies it to the content folder. Your old site is now imported to the pelcian system and is ready for generation!
11. Make some changes to the `pelicanconf.py`. Set the attributes for `AUTHOR` and `SITENAME`. You may also want to set `PAGE_URL`, `PAGE_URL_SAVE_AS`, `ARTICLE_URL` and `ARTICLE_URL_SAVE_AS` to match your existing site's URL pattern.
12. To generate the new site, simply run:

		pelican content
	
13. This will generate a folder called `output` which you can directly serve through github pages! You can also go to the output folder and test it locally by running this command and checking in your browser:

		python -m http.server
	
14. From now on, you can compose your new blog posts by simply creating a markdown file (in this case, it's `wordpress-pelican-24-hrs.md`, add content to it and simply run `pelican content` to generate the site! The markdown content should start with header attributes which will tell pelican system about the title, date, category, tags, etc. Here is a brief sample excerpt from this very blog post:

```bash
Title: Wordpress to Pelican in 24 hours
Date: 2019-05-21 00:58
Author: Prahlad Yeri
Category: PHP
Tags: Wordpress, PHP, Python
Status: published
Cover: uploads/cover.jpg

Today, I finished migration of my blog from a self-hosted Wordpress site to a statically hosted [Github Pages](https://pages.github.com/) site. For the static site generator, instead of choosing Jekyll which is a hot favorite of rubyists, I went for [Pelican](https://github.com/getpelican/pelican/) instead as I figured my Python skills might be somewhat useful in dealing with that.
```

This is the very simplest of use cases, of course. For other advanced things like changing the theme templates and CSS, migrating to [disqus comments](https://disqus.com), etc., I'll make another post later. You may also refer the [official pelican docs](https://docs.getpelican.com/) which has all these details and a lot of other useful information.