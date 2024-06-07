---
layout: post
title: "Introducing Comment-Monk: Simple comment hosting system for static blogs and websites"
tags: php webdev wordpress
published: true
image: /uploads/comment-monk.jpeg
---

I wanted to implement a comment hosting system for my static blog <https://prahladyeri.github.io>, just basic Wordpress.org style commenting feature with user's name, website, etc., no complicated logins or sign-ups or third-party platforms. The user reads your blog, posts a comment, and you approve from the backend (or alternatively, it gets auto-approved and you get an email notification). I had decided on something like Disqus initially but found the inspiration from [wptavern.com](https://wptavern.com/reflections-on-my-2-weeks-writing-for-the-tavern), it's quite a popular blog on the Wordpress streets and if they can run a simple commenting system then why can't we?

Since github pages doesn't provide any backend PHP scripting facility, I had to develop a whole backend app along with a frontend EMCA script which could be plugged into a `div` block at the end of a blog post, a space typically reserved for comments. [Comment-Monk](https://github.com/prahladyeri/comment-monk/) is the result of that effort. I have made this app open source (GNU GPL v3.0) so that it can be used by as many folks as possible. To use this app for your own static blog, just download the repo and deploy it to a PHP web hosting service. It's a very light script with Sqlite backend, intentionally kept small enough to be deployed to one of those cheap (even free) PHP hosting facilities.

Once you start the app, it takes you to the Install page where you can register with your details and credentials using which you can login to the app and administer it as a super user. It also asks the website or domain of your blog where you'll host the commenting system.

![cm-login](/uploads/cm-login.png)

Once you login and go to home page, you can see this screen where you can view and manage your comments. Right now, you can just view and delete your comments but more features are en-route in the upcoming versions. You can also set your user preferences from the "Actions" menu on the top right.

![cm-dashboard](/uploads/cm-dashboard.png)

Most importantly, you can click on the "Client Snippet" button which will guide you to implement your frontend HTML code to embed the comments.

Once you do that, your static blog should look something like this:

![cm-client](/uploads/cm-client.png)

At the place where you added the `script` tag, you should be able to see a ready comment block showing all existing comments along with a submit form to post one.

Your audience can read your content and be able to post a comment. The backend validates the URI (Uniform Resource Identifier) and if a registered domain is found, creates an entry for that comment which will be reflected in the administrator's (YOUR) dashboard. I think this is almost as simple as it could be!

The comments block has a very basic and bland look by default but you can customize it fully by editing the `/static/cm-client.css` on backend which is used for styling it.

I hope you will find this system useful for your static blog. If you face any issue, don't forget to raise it on the [github tracker](https://github.com/prahladyeri/comment-monk/). Happy Coding!