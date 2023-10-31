---
layout: post
title: "People migrating from Github to Gitlab should learn about these details first"
tags: git github gitlab microsoft open-source
---

After [Microsoft's recent acquisition of Github](https://prahladyeri.github.io/blog/2018/06/microsofts-github-acquisition-an-unbiased-perspective.html), a mass exodus has kind of begun and many small and large projects are moving their code bases to the much hyped [Gitlab](https://gitlab.com/) in a hurry, and these include both open and closed source projects. However, before migrating to Gitlab, they should take a pause and learn something about Gitlab and consider evaluating other alternatives too.<!--more-->

![Gitlab Stack](/uploads/2018/06/gitlab_stack.png){.size-full .wp-image-644 width="692" height="605"} 

**Gitlab Stack**

According to above [StackShare.io chart](https://stackshare.io/gitlab/gitlab), Gitlab basically runs on Microsoft Azure cloud hosting facility. So, if you are leaving Github in order to escape the clutches of Microsoft, then you are headed to a totally wrong place! Microsoft is exactly the place where your source code will reside in this case, only difference is that instead of controlling it directly (as in the case of Github), Microsoft will be controlling your code only technically.

I know, some of you will be saying that you are self-hosting an open source copy of Gitlab and not actually moving to [Gitlab.com](https://gitlab.com). In that case, please have a look at another item in that stack, namely Rails (RoR or Ruby on Rails framework).

Though Rails is a great framework that developers enjoy to code with, its a performance hog when it comes to actually running on production! There is a reason why [Twitter ditched Rails](https://jaredfriedman.wordpress.com/2015/09/15/why-i-wouldnt-use-rails-for-a-new-company/) in favor of Node.js instead of fixing the interpreter like Facebook did with PHP. Apart from Rails being a performance hog, consider that a git hosting facility is not a simple CRUD app. Its very difficult to do advanced things like CI/CD right in a framework like Rails and the effect is showing. It may work out initially, but once your code base starts to increase and your integrations start to scale, you'll hit the RoR scaling limit sooner or later, like [many others have](https://serverfault.com/questions/818489/gitlab-extremely-high-memory-consumption-by-ruby-bundle-process). Its not uncommon for Gitlab to eat gigabytes of your RAM or consume 100% CPU. So, if you are trying to host Gitlab in a small Digital Ocean droplet or Amazon AWS Micro instance, you can just forget about it!

Or, you can sit back and evaluate your options, it really depends on what you basically want. If you just want a free git hosting facility and don't want to self-host, there is already Github. If you don't like Microsoft, then you have Bitbucket, SourceForge, [Debian Salsa](http://salsa.debian.org/) and others too apart from Gitlab, so consider those options too before blindly deciding on Gitlab and falling for their marketing trap.

On the other hand, if you are ready to self-host and have a smaller budget (just for an AWS Micro or Digital Ocean droplet, for instance), then you can use one of the several open source and light-weight git hosting software like [gogs](https://try.gogs.io/), [gitea](https://try.gitea.io/), [phabricator](https://github.com/phacility/phabricator) and many others and self-host.

Finally, if you have a budget for hosting Gitlab on a larger instance (like AWS Large instance or 2GB droplet from Digital Ocean), then the first question I'd ask you is why not just stick to paid hosting plans of Github (or Gitlab/Bitbucket if you don't like Microsoft). That will be a lot cheaper and lenient on your pockets than self hosting a copy of Gitlab on a larger instance.

Whatever route you end up choosing, it should be a calmly taken logical decision after due consideration to all facts, not in this Github acquisition frenzy. All the best.

**Links:**

-   <https://prahladyeri.github.io/blog/2018/06/microsofts-github-acquisition-an-unbiased-perspective.html>
-   <https://stackshare.io/gitlab/gitlab>
-   <https://gitlab.com>
-   <https://jaredfriedman.wordpress.com/2015/09/15/why-i-wouldnt-use-rails-for-a-new-company/>
-   <https://serverfault.com/questions/818489/gitlab-extremely-high-memory-consumption-by-ruby-bundle-process>
-   <https://news.ycombinator.com/item?id=10235446>
-   <https://medium.com/osldev-blog/our-first-eight-months-with-gitlab-2f447af92e50>
-   <http://salsa.debian.org/>
-   <https://try.gogs.io/>
-   <https://try.gitea.io/>
-   <https://github.com/phacility/phabricator>

 
