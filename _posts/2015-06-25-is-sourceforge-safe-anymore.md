---
layout: post
title: 'Is Sourceforge.net safe anymore to download software'
tags: sourceforge open-source
---

You have probably heard about all the recent buzz surrounding the sourceforge.net website hosting adware/malware bundled installers and naive users falling prey to it. In some cases, SF even actively took control of [abandoned developer accounts](http://arstechnica.com/information-technology/2015/05/sourceforge-grabs-gimp-for-windows-account-wraps-installer-in-bundle-pushing-adware/). to bundle their crapware.<!--more-->

![Sourceforge Logo](/uploads/old/sf-logo.png)

So, is it safe anymore to go to this site and download your favorite FLOSS software? The TLDR version is NO, unless you happen to trust the developer and the project is actively being developed by them. But to understand the big picture, you will have to see the root cause of this which goes much deeper than just sourceforge, and relates to software distribution practices in the Microsoft Windows world.

What went wrong?
----------------

Software Development consists of two important phases: Authoring of source code, and secondly, the build process where the code is compiled to binaries and bundled into installable packages that you may download. Many years ago, sourceforge was one of the rare sites that provided a place on the internet where open source developers can host their code and binaries, and users can download them. This used to go well for many years and thus sourceforge gained a nice reputation in the FLOSS Community.

But soon enough, Sourceforge decided to cash in on this reputation by breaching this trust. And they started bundling adware and crapware to the developer builds. In some cases, [the lead developers](https://forum.filezilla-project.org/viewtopic.php?t=30240) were in cohorts with Sourceforge. And as [this Windows Club article](http://www.thewindowsclub.com/safe-software-download-sites) succintly explains, Sourceforge wasn’t alone in this. There were many othere like CNET.com, Download.com, etc.

The Problem
-----------

Though the adware bundling is optional in theory, the default options are so tactfully placed that only the shrewdest of hackers can dodge all of them! Though this kind of behavior is sort of expected from B-grade sites like CNET and download.com, Sourceforge was something that the open source community held in high esteem. Though most of the developers have moved to github now, souceforge was once considered the Jerusalem for downloading FLOSS Software, especially Windows Software. Even today, their interface is the best suited for novice users who are just looking for a big green download button to click - Github interface is more geared towards developers and generally overwhelms them. But now that the Jerusalem folks have turned into heretics (for lack of a better analogy), what are our options?

The best option is to get it from the developer’s site itself if they provide it. But sometimes that’s not possible as the developer may not always have bandwidth to host the binaries, and we have to depend on 3rd party sites like sourceforge. As the author of the linked article suggests, [MajorGeeks](http://majorgeeks.com) and [Softpedia](http://softpedia.com) are generally clean in my experience. Downloading software from those cleaner sites, however, is just a workaround and doesn’t solve the larger structural problem of Software Distribution in Windows world. So, what is that solution?

The Linux Solution!
-------------------

One crisis we are facing in the Windows FLOSS world right now is the Middleman problem. The original developer (A) writes some code and compiles it, the middleman (SF) bundles adware to it and makes a quick buck, whilst an innocent user (B) clicks that download link. Since there is no way for B to verify if the package is actually bundled by A, SF continues to get his commissions.

But what if there was a way for B to verify if the package is actually signed by A? In the Linux world, we do have such a mechanism, so there is no place for middlemen to make a profit there. If I download GNU Emacs from the [GNU ftp server](http://ftp.gnu.org/gnu/emacs/), all I have to do is `gpg --verify emacs.sig emacs.tar.gz` and the system will tell me whether my emacs copy is signed by developers of Emacs, or was it tampered with for injecting any malware!

The second crisis the Windows FLOSS is facing is lack of a decent package management system. In above analogy, we can’t expect B to personally verify each downloaded software against A’s signature, s/he needs a good package manager that downloads the package from a trusted server and installs it afer verifying the signatures.

In Linux world, we have two major packaging systems known by the name of `apt` and `yum`. How are they better, stable and secure than the Windows approach of users downloading arbitrary installers from SF-like sites and installing them, is something beyond the scope of this article. But suffice it to say that its very very high time that Windows gets a similar package manager to take care of the present structural issues surrounding it. [Ninite](http://www.ninite.com/) has tried to do something in this direction, but its a proprietary and paid solution. We need open source and something that everyone accepts as a standard. Maybe, perhaps Microsoft will take the initiative and do it themselves? Only time will tell.
