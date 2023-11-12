---
layout: post
title: '[Jekyll] Maintaining drafts while writing blog posts'
tags: jekyll tricks
published: true
---

The conventional wisdom of maintaining draft posts in Jekyll is to [store them in _drafts directory](https://jekyllrb.com/docs/posts/#drafts).

> Drafts are posts without a date in the filename. They’re posts you’re still working on and don’t want to publish yet. To get up and running with drafts, create a _drafts folder in your site’s root and create your first draft:

```bash
├── _drafts
│   └── a-draft-post.md
...
```

But I found this conventional approach a bit cumbersome to follow as a daily driver. For one, at each point of time when you decide that a draft such as `a-draft-post.md` is done version, you must copy it from _drafts to _posts and also rename it with the date part.

One solution here is to write a one time bash script or something for your workflow which does that automatically when run, but if you don't want to do that, there is a cleaner approach which I've found:

The other way of declaring drafts in Jekyll is to save it in the _posts itself as usual, and simply set the `published` attribute in the front-matter section to `false`:

```
---
layout: post
title: '[Jekyll] Maintaining drafts while writing blog posts'
tags: jekyll tricks
**published: false**
---

Saved as _posts/2023-11-12-a-finished-post.md
```

This way, all you have to do is set the `published` attribute to true and push the changes to your github repository! Of course, the downside here is that you might forget to change the date at the time of doing that and your published post will end up being back-dated by a couple of days. Personally, I'm quite tolerant of that and the difference won't be much as I don't like to keep a post in "draft" status for a long time anyway.

In any case, this is just one approach for handling draft posts in the Jekyll workflow, there could be others.