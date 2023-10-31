---
layout: post
title: 'listdir vs scandir vs glob - The one and preferably only one obvious way to do it!'
tags: pip open-source python
---

You know, sometimes when I read those python aphorisms like "beautiful is better than ugly" I wonder whether the makers were being sarcastic or real, and I'm not kidding!

Its not just about `listdir` and `scandir`, a whole lot of things are ambiguous and you'll find a lot of different ways to do those same things thus contributing to a non-standard and messy system of working. setuptools and distutils are the obvious examples, there are so many setuptools components that still internally use the old distutils packages that its astonishing. The easy_install is yet another way to do the same packaging dance!

Sometimes, a functionality in shutil is broken and you need to import the alternative from good old distutils which is truly absurd and preposterous. Most recently, I came stumbled across just this:

```python
from distutils.dir_util import copy_tree
```

The shutil.copy_tree is broken (it doesn't automatically create non-existent folders and there are some other irregularities), so I had to use the copy_tree from distutils.dir_util module.

Here is another great example. `distutils.core`, `pkg_resources` and there is another package called `site` all doing basically one and the same thing. In this instance, I had to write a local version of `pip --freeze` that checked my local setup.py and generated the requirements.txt from that instead of globally installed modules. As you can see, there are perhaps a lot of confusing ways of implementing this same thing:

```python
#!/usr/bin/env python
import os
import distutils.core
import pkg_resources

if __name__ == "__main__":
	setup = distutils.core.run_setup("setup.py")
	ss = ""
	for req in setup.install_requires:
		 vv  = pkg_resources.get_distribution(req).version
		 ss += "%s==%s\n" % (req, vv)
	ss = ss.strip()
	print(ss)
	open('requirements.txt','w').write(ss)
	print("Written to requirements.txt")
```

So, please tell me again, is this for real or sarcasm!

```
Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
**There should be one-- and preferably only one --obvious way to do it.**
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
```