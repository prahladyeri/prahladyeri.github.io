---
layout: post
title: "How to fix TypeError: 'autocommit' unexpected keyword argument in Python sqlite3"
tags: python sqlite database
published: true
image: /uploads/code-python.jpg
description: "Fix the Python sqlite3 'autocommit' TypeError in Python 3.11 and older versions. Learn how to use isolation_level instead of the autocommit argument for batch inserts."
---
So there I was, writing a quick script to churn through an array of items and throw them into a local SQLite database. Standard stuff. Because I didn't want the script to crawl at a snail's pace by writing to the disk on every single loop iteration, I decided to do the sensible thing: turn off `autocommit` mode and just batch-commit the whole thing at the end.

I confidently typed out the connection string, hit run, and the Python interpreter immediately slapped me in the face with this beautiful piece of performance art:

> TypeError: sqlite3.connect() got an unexpected keyword argument 'autocommit'

*Excuse me?*

Modern versions of python (3.12 and above) let you pass the `autocommit` argument directly like this:

```python
con = sqlite3.connect('findpkg.db', autocommit=False)
```

But legacy python versions like the 3.8 one I'm running don't have this feature yet. Instead, it uses the `isolation_level` argument to control the transaction behavior. The documented values are as follows:

```bash
None        # autocommit mode on (Python None, not a string)
'DEFERRED'  # default
'IMMEDIATE'
'EXCLUSIVE'
```

Examples:

```python
con = sqlite3.connect('findpkg.db', isolation_level='DEFERRED') # default, autocommit = False
con = sqlite3.connect('findpkg.db', isolation_level=None) # autocommit = True
```

Remembering this simple python quirk can save you a lot of headache while maintaining legacy production code that needs batch inserts like this:

```python
con = sqlite3.connect('findpkg.db', isolation_level='DEFERRED')
cur = con.cursor()

items = [
    {"full_name": "pkg1", "description": "First package", "stars": 10, "language": "Python"},
    {"full_name": "pkg2", "description": "Second package", "stars": 42, "language": "Go"}
]

for i, item in enumerate(items):
	sql = "insert into repositories (full_name, description, stars, language) values (?,?,?,?)"
	cur.execute(sql, [item['full_name'], item['description'], item['stars'], item['language'] ])
	# autocommit here makes things slow.
	
con.commit() # manual commit
```

Running into autocommit issues on older Python versions? Hope this saved you some debugging time. Let me know in the comments if you hit other sqlite3 gotchas.