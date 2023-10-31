---
layout: post
title: "Microsoft's Github acquisition - A perspective"
tags: github gitlab linux microsoft open-source
---

As someone who has worked on Microsoft tooling since the days of Foxpro 2.6 to Visual Studio 2010 in IT career, and yet ditched them all for PHP, Python and open source years later, I think I am qualified to offer a somewhat neutral or objective perspective on this acquisition.

When this news was **[first announced on last Friday](https://www.businessinsider.in/Microsoft-has-been-talking-about-buying-GitHub-a-startup-at-the-center-of-the-software-world-last-valued-at-2-billion/articleshow/64420905.cms)**, I was naturally puzzled and so were a lot of other developers and not without reasons. The way this was initially announced without any clarification about what they were going to do with the hosting facility in future, speculations were bound to be raised and people were bound to be pissed off, especially given Microsoft's history of being "not so friendly" with open source and "not so good" with some acquisitions.

When it comes to open source, the Linux subreddit is the place where developers pour their hearts out and [this particular thread](https://www.reddit.com/r/linux/comments/8nukfa/microsoft_and_github_have_held_acquisition_talks/) quite summed up  their initial knee-jerk reaction. As the most upvoted comment says:

> its like Microsoft is obsessed with generating as much frustration in the world as possible

Other reactions were also quite similar:

> I LOL'ed.

<!-- -->
> First, Sourceforge started to install malware on the open source projects. So everyone run to Github. Now, Github might get owned by Microsoft. Not to mention Github is 100% closed source. **Gitlab** looks good every day. There are other open source git solution too.

[**GitLab**](https://gitlab.com/), the top open source competitor to Github soon became the most discussed alternative (apparently, their marketing team did their bit too with the perfect timing!). And so, a mass exodus of projects soon began, which not only became the most discussed topic on reddit, but also caught a [lot of media attention too](https://www.reuters.com/article/us-github-microsoft-gitlab/gitlab-gains-developers-after-microsoft-buys-rival-github-idUSKCN1J12BR).

Just within a couple of days from this announcement, some [13,000 projects had already migrated to Gitlab](https://motherboard.vice.com/en_us/article/ywen8x/13000-projects-ditched-github-for-gitlab-monday-morning) which included some prominent names. Naturally, it was time now for Microsoft to do some damage control. But if their PR team was any wiser, they should have already anticipated this and this damage control move should have been done at the outset as the first thing. How could they not expect this backlash considering Microsoft's past history with open source (however distant it may be)?

The first move came when Satya Nadella, the Microsoft CEO gave an interview to CNBC on Monday (4th June):

<iframe width="560" height="315" src="https://www.youtube.com/embed/m164XggdRGA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


One of the most important things Satya said in the interview was that Microsoft is a ***developer tooling** **company at core*** (let's ignore Windows and Office for a moment!). However, most developers still had concerns, they wanted to know how this high level strategy of being open source developer friendly will turn out to be in practice.

Most importantly, they needed an assurance that their daily driver for source control isn't going to be integrated and hijacked by other Microsoft products like Skype, Linkedin or even a Passport account. And that assurance came yesterday from [Nat Friedman](https://en.wikipedia.org/wiki/Nat_Friedman), the future CEO of Github [in his Reddit AMA](https://www.reddit.com/r/AMA/comments/8pc8mf/im_nat_friedman_future_ceo_of_github_ama/).

Firstly, the fact that Github Inc. was going in the hands of an open source veteran who had contributed to GNOME and MONO projects in the past was itself quite reassuring. At least, Github isn't going to be controlled by a typical corporate honcho who has nothing but shareholders' interests in mind! [Nat assured most redditors](https://www.reddit.com/r/AMA/comments/8pc8mf/im_nat_friedman_future_ceo_of_github_ama/e0a5e3r/) that Github is going to stay as it is, its developer focus is not going to be shifted, nor is it going to be integrated with any other products. And most importantly, they will never require a Microsoft account to login to Github, rather, their other products might consider allowing a Github user to authenticate to their systems in future:

> We love GitHub login. Your GitHub account is your developer identity, and many users are accustomed to signing into developer tools and services (e.g. Travis, Circle) with their GitHub accounts. So, if anything, we may decide to add GitHub as a login option to Microsoft.

Nat also [goes on to further assure](https://www.reddit.com/r/AMA/comments/8pc8mf/im_nat_friedman_future_ceo_of_github_ama/e0a6eh1/) redditors in the AMA that they will always remain a "developer first" company, and are keen to learn a lot from Github from this acquisition. Rather than impose their own work culture on Github, they'll be taking lessons from Github and try and be like them:

> We bought GitHub because we appreciate how special it is. That's why we have two principles for this acquisition going forward:
>
> Developers first. We will evaluate every decision through the lens of what is best for developers. This includes GitHub's status as an open platform with open APIs that any developer can use to extend GitHub's functionality. And it includes our commitment that we will support developers on GitHub in their use of any language, any license, any operating system, any device, and any cloud.
>
> Independence. We are not buying GitHub to turn it into Microsoft; we are buying GitHub because we believe in the importance of developers, and in GitHub's unique role in the developer community. Our goal is to help GitHub be better at being GitHub, and if anything, to help Microsoft be a little more like GitHub.

All in all, this damage control or whatever Microsoft has done seems to have done the magic at least for the moment. People and projects seem to have stopped their exodus to Gitlab, though its difficult to say what could happen in the long term.
