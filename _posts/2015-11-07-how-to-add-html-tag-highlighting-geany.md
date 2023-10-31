---
layout: post
title: How to add HTML tag highlighting to Geany
tags: geany linux how-to
---

Ever since I bid farewell to `Windows` after they introduced that horrible `Metro` interface in `Windows 8`, I had been on the lookout for FOSS Linux alternatives that can run easily on my `ubuntu 14.04` machine. One such lookout was a replacement for `Notepad++` as I always need a handy editor for scripting and other miscellaneous tasks (such as writing this draft in markdown syntax). For large projects, there are always “heavy” things like `eclipse` and `netbeans` but I generally tend to avoid them if I can.<!--more-->

Now, the bread-and-butter `Linux` alternative for `Notepad++` is [Geany](http://www.geany.org/), a light-weight editor developed by Enrico Tröger. Geany has all the wonderful features that `Notepad++` has, except one: There is no highlighting available for matching html tag pairs. And as any Web Developer worth his salt will know, an HTML file will soon start turning out to be a huge cosmic soup of tags and braces once the app starts evolving, and this feature can become handy in the situation. And whilst there is a plugin called `Pair Tag Highlighter`, it isn’t readily available in the ubuntu 14.04 repository. Like many users, I decided to ignore this small nagging inconvenience and moved on. But recently, I was able to spare some time from my daily errands and decided to have a go at it.

The solution to this isn’t that apparent as even my googlefu had to go through a lot of filters before I came across this [only post](http://askubuntu.com/questions/589172/html-pair-tag-highlight-alternative-for-geany-editor-on-ubuntu-14-04) that gave me the solution, though it was a bit more involved and required me to checkout a github repo and build the plugin. This means one of two things: Either a lot of people are not interested in `Geany` any more and moved on to other editors like `Sublime Text`, or that they have decided to live with this inconvenience. If you are from the latter group, your inconvenience is soon going to be over. All you have to do is this:

	sudo apt-get install git
	cd /tmp
	git clone https://github.com/geany/geany-plugins.git
	cd geany-plugins/
	sed -i 's/1.25/1.23/' wscript
	./waf configure --enable-plugins=pairtaghighlighter
	make all
	sudo make install

Things to note:

1.  The fifth line uses the `sed` tool to change the minimum required version in `wscript` from `1.25` to `1.23`. However, after I’ve written this article, the plugin developer might have raised the minimum requirement and changed it to `1.26` or something. So, replace accordingly.
2.  Make sure you have the latest version of `python` installed in order to use the `waf` tool. You also need to install `intltool` package if it does not already exist.
3.  If all goes well, restart Geany and go to `Tools->Plugin Manager` and enable the Plugin `Pair Tag Highlighter`. Once you do that, your HTML code will start highlighting the opening and closing tags as shown below:

![Geany with HTML pair tag highlighting](/uploads/old/geany-tag-highlight.png)

*References:*

- <http://askubuntu.com/questions/589172/html-pair-tag-highlight-alternative-for-geany-editor-on-ubuntu-14-04>
- <http://askubuntu.com/questions/616369/a-alternative-to-install-pairtaghighlighter-for-geany-1-23-21>
