---
layout: post
title: API first" apps are the future
tags: api programming
---

Apps tend to become very complex beasts, especially when they start to scale. Part of the complexity is due to the fact that the users could be a diverse set of people with multitude of tastes and preferences which could all be conflicting.

A classic example here is this recent [tildes discussion thread](https://tildes.net/~talk/145a/unpopular_opinion_wikipedias_old_look_was_much_better_than_the_new_one) I had started expressing my displeasure at the new Wikipedia design. As you can see from the discussion, it soon became quite heated with both for and against arguments with regard to the new design.

The nature of life is such that you can't fit all people into just one mold. There are those who prefer to read wider paragraphs and others who like shorter ones. The trend seems to be moving towards the latter if the new design is indeed based on mass preference.

Many proponents of the new design will cite data and statistics to "prove" how shorter width is actually better for reading comprehension. But that's not how life works, unfortunately. User preferences are based on their feelings. If you "feel" that the banana you're eating is sweet then all the scientific data, research, etc. in the world stating that it's bitter instead won't change your mind.
	
Thankfully, Wikipedia has other classic or old school themes which they've retained just like old Reddit, so this problem is solved. There is also the case that Wikipedia is based on the open source PHP software called [Mediawiki](https://www.mediawiki.org/) which can be accessible through an [API also](https://www.mediawiki.org/wiki/API:Main_page). Those having an issue with the "official" font-end can thus use the API to fetch the wiki articles and display them in whatever format they want.

The business wisdom here is that more and more Internet users are becoming "power users" now, they have strong preferences about UI and aesthetics, and they're prepared to put some effort to improve that experience. The number of these power users is only going to increase on the Interwebs if this trend of the past continues.

As a commercial app developer or firm, you can gain an edge here by offering an "API first" platform. What this means is that there is a clear separation in code between the user interface and backend logic. The interface is just a shell or front which calls the "headless" APIs on the backend to do almost everything the app needs like logging into the system, fetching the data related to business logic like customers, orders, invoices, etc. and much more. Another advantage here is that you can improve your font-end code without disturbing the back-end logic which is coded in the APIs.

The user doesn't need to care about how the data is actually fetched by the app. However, some of those users are going to be power users who may want a different interface or font-end features. They could be programmers too who can write a python script or something to suit their own taste provided an API exists. You, as an app developer, can cater to that need by bundling the APIs as a feature of your app and making the app itself "API first".