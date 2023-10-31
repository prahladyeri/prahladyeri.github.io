---
layout: post
title: 'The right way to serve static files when using django with gunicorn'
tags: django gunicorn python
---

Yesterday, I learned during deployment that your `Django` app when used in combination with `gunicorn` will refuse to serve static files, do whatever you may. I looked up almost every Stack Overflow answer post on this topic including [this](https://stackoverflow.com/q/59857966/849365), [this](https://stackoverflow.com/q/54972837/849365) and [this](https://stackoverflow.com/q/59857966/849365).

![python-source-code](/uploads/code.jpg)

I meddled with almost every hopeful setting including `STATICFILES_DIRS[]`, `STATIC_ROOT` and `STATIC_URL` but to no avail. Its as if Django is designed to refuse serving of static files when using `gunicorn` and that's what I started to suspect after everything failed.

And my suspicion was almost confirmed by [this post](https://stackoverflow.com/q/20175243/849365) which says that:

> Gunicorn will only serve the dynamic content, i.e. the Django files

But I know that's not strictly true because I've used Gunicorn with Flask in the past and it serves static files of your Flask app without any issues at all!

But then I thought that its better to handle static files using `nginx` anyway and since I was already using `nginx` as the front proxy on my server anyway, I thought of trying that post's suggestion. As mentioned, I added a new location section to my `nginx` configuration file as follows:

```bash
location /static {
		autoindex on;
		alias /path/to/staticfiles;
	}
```

And that's exactly what worked! I bypassed `gunicorn` entirely and static files are now being served directly by the front server and I think this is a more efficient setup than having `gunicorn` serve the static files.

But why `gunicorn/django` refuse to serve static files directly still remain a mystery. I think the problem lies somewhere in Django and not gunicorn because as I said, I've seen gunicorn serve Flask static files before.