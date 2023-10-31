---
layout: post
title: Why you should never use the dict.get() method in python
tags: python dictionary
---

There is an increasing trend towards using the `dict.get()` method in Python, it's very widely used in many tutorials and examples too. Consider the below example for instance:

```python
>>> dd = {'a': 1}
>>> dd.get('a')
1
```

This simple dictionary dd has only one key ('a') and its corresponding value is 1. The proper way of accessing this key is to refer it as `dd['a']` but you need to be sure that the dictionary has that key otherwise it'll throw an error! Hence, as a shortcut way, programmers have started using `dd.get()` method instead. This method simply returns the key value if it's present and `None` if there is no such key in the dictionary.

Seems good enough, right? Well, don't fall into that trap so soon! In the real world, you'll come across a situation sooner or later when you'll have to handle a dictionary key who's value is `None`! What will you do then? Consider this example:

```python
>>> dd = {'a': None}
>>> dd.get('a')
```
In this case, you'll never know whether a key was present in the dictionary or one was there and its value was `None`. Knowing the difference could be crucial in some situations and not doing so might cause subtle bugs in your program which will be very hard to trace later. The best habit to access a dictionary is this:

```python
>>> if 'a' in dd:
>>>     x = dd['a'] # do whatever
>>> else:
>>>     pass # handle this
```

Or you can even simply refer its key directly if you are sure that the key exists:

```python
>>> x = dd['a'] # do whatever
```

Similarly, there are two different ways to remove an item from dictionary but there is nothing wrong in using either of them (except of course that you need to be sure that the key is present and use an exception handler if you aren't):

```python
>>> dd.pop('a')
>>> del dd['a']
```
