---
layout: post
title: "The joy of coding a command line english dictionary program in dotnet"
tags: dotnet csharp command-line
published: false
image: /uploads/code.jpg
---
In today's globally connected digital village, we often come across words and syllables which are quite new to us. Most folks hardly take the trouble to look up a dictionary, though; there is no immediate or short-term incentive to increase your word power, especially in a world where LLMs can do most of the intellectual bidding for you.

For those of us who do care about the ever degrading human intellect and ways of preserving what little is left of it, a dictionary app or program becomes quite an essential and indispensable tool on the desktop computer. There are quite a few GUI Apps in the Windows desktop world for this, perhaps the most popular is the [WordWeb dictionary and thesaurus tool](https://wordweb.info/free/) which is a freeware.

![WordWeb Dictionary App](https://uk2.wordwebsoftware.com/wordweb/v10/ODE2_reference.png)

WordWeb isn't exactly open source but does come with a specific condition for usage: *The user must purchase a paid license if they ever took more than two flights in a single year.* By the way, it's coded in Free Pascal which happens to be one of my favorite languages. In an alternative universe, I'd probably be using FP as a daily driver today if I hadn't fallen for C# first.

The second popular dictionary app is the [open source Artha](https://artha.sourceforge.net/) which is also a widely used dictionary and thesaurus app. This is GPL licensed and proper open source.

![Artha Dictionary App](https://artha.sourceforge.net/wiki/images/thumb/c/cf/Screen_antonyms.png/300px-Screen_antonyms.png)

Being a minimalist and utilitarian power user, I had two basic issues with these desktop GUI tools:

- They're memory resident programs and keep eating a chunk of your RAM.
- I have no need of the GUI bloat, just a quick lookup for an unknown word is needed.

What I really wanted was the native, zero-bloat equivalent of the Linux command line `dict` utility. Since a lightweight, native equivalent didn't quite fit my workflow in the Windows world, I decided to [write one myself in C#](https://github.com/prahladyeri/dict). A simple, efficient command that just outputs the meaning and synonyms of a word.

![dict program](/uploads/portfolio_assets/dict.png)

The program uses the open source [WordNet](https://wordnet.princeton.edu/documentation/wndb5wn) as the data source, the same one used by some of these other dictionary apps. Needless to say, dict is still a work in progress, additional features like looking up antonyms and related words are yet to come. I'm also planning to add a `--random-word` option which could be useful for building word power.

Coding programs like these which you enjoy using yourself can be a source of tremendous joy in a world full of fast paced delivery deadlines and overwhelming pressure for AI assistance. In order to keep the art of human coding alive in the future, we need to find a purpose - the old school way. There is no other way to do it.