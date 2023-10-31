---
layout: post
title: Package signing in PIP - It works, in a roundabout sort of way
tags: pip security python
---

A few days ago, I made [this DEV.to post](https://dev.to/prahladyeri/why-doesn-t-the-python-package-manager-pip-have-package-signing-13ll) about how Python's PIP lacks GPG package signing. Well, it turns out that I'm wrong! It does have a package signing process after all, only its one of the most manual, archaic and cumbersome security practices I've seen till date.<!--more-->

I came to know about this when I landed on [this blog post](https://kushaldas.in/posts/pypi-and-gpg-signed-packages.html) by a core python developer yesterday. To test package signing in the way described, I created a test package called [siterank](https://github.com/prahladyeri/siterank), a small script to fetch alexa ranking of given websites.

Firstly, its essential that you use only [twine](https://github.com/pypa/twine) to upload a signed package to PyPi because only twine has that feature. Secondly, their documentation seems to be outdated because some arguments don't seem to work. For example, the `--sign` argument for specifying signed files explicitly didn't work for me:

    -s, --sign            Sign files to upload using GPG
	
What worked was to upload the package file and the generated signature file (*.asc) in succession like this:

    twine upload siterank-0.2.tar.gz siterank-0.2.tar.gz.asc
	
Also note that you'll nowhere see the uploaded signature file on your [package page on PyPi](https://pypi.org/project/siterank/#files). But there are two different ways to verify the signature:

1. Firstly, you can use the [PyPi JSON API](https://pypi.org/pypi/siterank/json). It contains all the uploaded versions in `JSON` format, notice that in the second package version, the `has_sig` attribute has been set to true!
2. The second way is to add the `.asc` extension to the link to your setup file, in my case it is:
    https://files.pythonhosted.org/packages/16/f9/1dfce544610b9dcbbfcb4095c8e143c6cfd54b4371ccedc3f73df0a99926/siterank-0.2.tar.gz.asc
	
So, someone who wants to verify if this package was indeed authored by me can pull this `.asc` file and match it with my GPG public key (ID `E12979BA15FDE7FD` - which can be also found by running ` gpg --search-keys prahladyeri@yahoo.com`).

This roundabout way of verification is needless to mention, tedious and cumbersome. This process should be seamless and automated, and included in the `pip` work-flow itself like apt and dnf have done. The only probable issue is that millions of developers upload their packages to PyPi and everyone may not want to (or lack the knowledge of) signing using GPG keys. So, signing could be kept optional (as it is now) but verification option ought to be there for signed packages as it ensures security and integrity of packages.

Another issue is that of adoption. I've noticed from that JSON API that several popular projects like `requests`, `nltk`, `flask`, etc. haven't signed their packages at all. Its important that more and more developers push signed packages and thus contribute in making PyPi a more secure environment to install and distribute packages.

Security and privacy are perhaps one of the most highly discussed topics of our times. There are attempts by all kinds of people and corporations globally to compromise these by hiding as many things as possible from the plebeians. In light of this, security and privacy should be given the highest priority in open source projects. I hope the Python project understands these concerns and does something about it.