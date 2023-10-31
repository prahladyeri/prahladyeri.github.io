---
layout: post
title: "Smyte is no more - The latest episode in the acquisition saga of Tech Giants"
tags: open-source twitter technology
---

Not even a month has been passed since Microsoft gave a big surprise to the world at large and the open source community by [acquiring Github Inc.](https://prahladyeri.github.io/blog/2018/06/microsofts-github-acquisition-an-unbiased-perspective.html) a few days ago, and there has been [another acquisition](https://techcrunch.com/2018/06/21/twitter-acquires-anti-abuse-technology-provider-smyte/) yesterday. This time, Twitter Inc. bought the well known online service [Smyte](https://smyte.com/). Smyte was an online provider of anti-abuse technology services, i.e. things like AI algorithms for identifying online trolling, etc. Many customers were totally dependent on this provider's API which suddenly disappeared off the radar after Twitter Inc. acquired them yesterday.<!--more-->

A whole lot of customers and other depending services were affected because of this [including npm](https://twitter.com/seldo/status/1009873821141118976?s=09), the popular Node.js package manager. As usual, [Reddit](https://old.reddit.com/r/sysadmin/comments/8swr1e/reminder_that_external_dependencies_can_shut_down/) was one of the first places where people turned up to know what's going on and update their statuses. As one of the comments quite intelligently notes, this is a very good lesson on this modern web development way that involves depending on a zillion external services and leaving your application open to the whims of acquisitions and centralization of technology powers:

::: {.reddit-embed data-embed-media="www.redditmedia.com" data-embed-parent="false" data-embed-live="true" data-embed-uuid="5bebab31-c06c-4d2c-bbd0-d938f9f97409" data-embed-created="2018-06-22T14:47:54.034Z"}
[Comment](https://old.reddit.com/r/sysadmin/comments/8swr1e/reminder_that_external_dependencies_can_shut_down/e13j9tx/) from discussion [Reminder that external dependencies can shut down without notice](https://old.reddit.com/r/sysadmin/comments/8swr1e/reminder_that_external_dependencies_can_shut_down/).
:::

<p>
<script async src="https://www.redditstatic.com/comment-embed.js"></script>
</p>
Similarly, Twitter was also filled today with tweets of complains from existing Smyte customers who have suddenly stopped receiving any communication from their service provider:

https://twitter.com/arthens/status/1009925187364458496

Jeremy Ashkenas, the inventor of famous Backbone.js and Underscore.js JavaScript libraries expressed his feelings in a very sarcastic tweet:

https://twitter.com/jashkenas/status/1010014139320680449

I don't know what was Twitter's intention before acquiring Smyte, but the way this is going on, this has to end in only one of the two ways:

1\. Either developers take lessons from these incidents and stop depending so much on layer-2 solutions and external dependencies.

2\. Technology giants become a bit more empathetic to the needs of smaller businesses and understand that just acquiring other services isn't a solution to the innovation problem.
