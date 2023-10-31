---
layout: post
title: DIY Keyword research for small bloggers using absolutely free tools
tags: keyword-research seo blogging
---

There are a plethora of keyword research tools available in the market such as [SEMRush](https://www.semrush.com/), [ahrefs](https://ahrefs.com/dashboard), [KWFinder](https://kwfinder.com/), etc. and while a subscription to them makes sense if you are a small company or startup, it definitely doesn't for small bloggers who work with a limited budget.

![python code](/uploads/laptop-coffee-mobile.jpeg)

But even if you have an absolutely zero budget, you can still perform decent keyword research and get the exact same results that these popular web services offer. However, you won't be served that information on a platter and you will have to work for it and setup your own workflow after sourcing inputs or raw material from various freely available tools. You must also know a little bit of scripting/programming and be prepared to write some scripts in a language like python.

Each blogger or researcher may have a different workflow with respect to keyword research, mine involves the following two tools:

1. [Google Keyword Planner](https://ads.google.com/aw/keywordplanner/)
2. [AnswerThePublic.com](https://answerthepublic.com/)

Both are excellent and robust freely available tools (though the latter gets you only a limited number of searches each day which is fine if you're a small blogger who posts only few times a week).

In general, writing any article involves the following steps:

1. Determination of the topic and/or niche you want to publish about.
2. Research and gather information or sources about it (like books, wikipedia, online blogs, etc.)
3. Actually write the article.
4. Give it a decent or captivating headline.

Performing keyword research beforehand will help you with almost all these steps extensively. Firstly, it will help you determine which topic or niche you must blog about so that people actually find your content through search engines. In other words, you shouldn't end up writing an excellent piece about a topic which:

1. Nobody is interested in (low search volume).
2. Has so high competition that it's very difficult to rank on the first page.

These are the two areas which you must actively avoid if you want to blog for visibility or getting web traffic. Of course, there are hobby bloggers who post just for the sake of fun or writing passion and that's fine too.

Coming to the process of niche determination using keyword research, it involves two tasks:

1. Find out which keywords related to our broader topic are currently in vogue or trending.
2. Find out which among those related keywords have a combination of good search volume and less ranking difficulty.

With Google Keyword Planner, both these tasks can be clubbed into one as it provides ways to both discover new keywords and getting search volume and forecasts for a given bunch of keywords (see below).

![Google Keyword Planner Tool](/uploads/google_keyword_planner_tool.png)

An alternative process of niche determination involves using ATP (answerthepublic.com) for the first task as it provides a richer set of related keywords which are questions or slightly longer phrases which have the potential for attracting long tail search volume. You then input these longer keywords provided by ATP to the second part of the Google Planner Tool ("Get search volume and forecasts"). But keep in mind that you can't just lift the keywords from ATP and enter them directly to Google Keyword Planner tool!

Here is where scripting comes into picture. The CSV data exported by ATP has to be sanitized to the proper format (extra columns removed) so that it can be then entered to the Google Keyword Planner Tool. Scripting is also needed to store the output CSV from Google Planner to a proper database. Personally, I prefer `sqlite` but `mysql` is fine too. Google's output CSV has almost everything you need, almost everything which the other subscription based services provide.

![Google Keyword Planner Results](/uploads/google_keyword_planner_results.png)

But the only catch is that it's a DIY. You need to write your own program or script which imports this output to your database tables and stores data in the respective fields. "Avg. monthly searches" is quite apparent, you can use a long integer column called `searches` to store this. "Competition" tells you qualitatively whether it's high/medium/low for that keyword, and "Competition (Index Value)" does the same quantitatively. It's an index value ranging from 0 to 100 and often referred to as KD (Keyword Difficulty) in the other popular tools.

Once you've built your own workflow with automated scripts that involves importing and sanitizing data from ATP/Google, and storing it to a local database, you should be able to get what you want with a simple SQL query such as this:

	select keyword from keywords where keyword like '%flask%' and searches >= 1000 and comp_idx < 30;
	
This will return all keywords in the `python flask`	niche which has a good search volume (1000 or above) and less difficulty to rank (competition index is less than 30). You can then proceed to use those keywords for writing your article which will now have a greater visibility.

A paid tool like SEMRush or ahrefs would have given you the exact same results as this SQL query but your solution is custom developed and more importantly, suited to your own work-flow. The only difference is that your database won't be having billions keywords at the start but it will grow organically and gradually as you keep writing articles and keep researching new content.