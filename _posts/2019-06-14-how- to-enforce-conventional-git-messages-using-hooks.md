---
layout: post
title: "How to enforce conventional commit messages using git hooks"
tags: git open-source how-to linux
---

[Conventional git commit messages](https://www.conventionalcommits.org/en/v1.0.0-beta.4/) are not just nice to have but great to have. In fact, once you get to know them, you'll start feeling that they are essential in any serious programming project. Consider the difference between following two commit messages for instance:

	git commit -m "added social login feature for authentication using twitter"
	git commit -m "feat(authentication): added social login using twitter"
	
The second one is not only more readable but it also follows standards which makes it easier to integrate with build tools such as Travis CI and Appveyor. Not just that, you can easily automate `CHANGELOG` generation when your `git log` looks like this:

	> git log --oneline
	61c8ca9 (HEAD -> master) fix: navbar not responsive on mobile
	479c48b test: prepared test cases for user authentication
	a992020 chore: moved to semantic versioning
	b818120 fix: button click even handler firing twice
	c6e9a97 fix: login page css
	dfdc715 feat(authentication): added social login using twitter
	
All in all, I like conventional commit messages so much that I don't want to keep it optional but make it the default way of life. How do I do it? The answer is simple: *git hooks*.

You don't need to be a git ninja or expert to work with hooks. Suffice it to know that inside your special git repository folder (named `.git`), there are some other special folders:

	logs
	hooks
	objects
	refs
	
The one we are interested in is `hooks`. To get the hang of it, create a test project on your machine and initialize an empty git repository by running:

	git init .
	
Now visit the `.git` folder just generated and navigate to the hooks folder. There will be a bunch of scripts with `.sample` extension (which means they are all disabled). The one we are interested in is `commit-msg`. This is the hook that fires just before your commit is made and thus allows you to reject the commit by throwing an error if the message isn't in proper format.

Create a new script in this directory named `commit-msg` and add the below code (you'll need python installed) to it using your favorite editor (mine is notepad++!):

```python
#!/usr/bin/env python
import re, sys, os

def main():
	# example:
	# feat(apikey): added the ability to add api key to configuration
	pattern = r'(build|ci|docs|feat|fix|perf|refactor|style|test|chore|revert)(\([\w\-]+\))?:\s.*'
	filename = sys.argv[1]
	ss = open(filename, 'r').read()
	m = re.match(pattern, ss)
	if m == None: raise Exception("conventional commit validation failed")

if __name__ == "__main__":
	main()
```
		
Save the script and make it executable (by running `chmod u+x commit-msg` on linux, not required on windows). Now head back to your source code folder where you initialized the git repo and create a source file just for testing. Then, `git add` and try to commit just for testing using a non-conventional message. If all goes well, it should fail like this!

	> git commit -m "added a new feature for xyz"
	Traceback (most recent call last):
	  File "C:/Users/prahlad/Documents/scripts/check_commit.py", line 22, in <module>
		main()
	  File "C:/Users/prahlad/Documents/scripts/check_commit.py", line 19, in main
		if m == None: raise Exception("conventional commit validation failed")
	Exception: conventional commit validation failed	
	Now test with a valid commit message and it should work!

Once you practice this a few times and get a hang over it, you'll then want to make this behavior default for whatever projects you start using `git init` in future, isn't it? Sure, you can do that by creating a global git commit hook template but that will be a post for another day. First things first!

**Edit**

For those really interested in enforcing and automating this thing, I've just published a python package called [enforce-git-message](https://github.com/prahladyeri/enforce-git-message). All you need to do is install that python package and it'll automatically copy the above script to your `~/.git-templates` directory and also set the value for `git config init.templatedir`.

    pip install enforce-git-message

References:

- <https://www.conventionalcommits.org/en/v1.0.0-beta.4/>
- <https://stackoverflow.com/q/3523534/849365>
- <https://stackoverflow.com/q/37699261/849365>
- <https://coderwall.com/p/jp7d5q/create-a-global-git-commit-hook>
