---
layout: post
title: dateutil.relativedelta: A must have tool in your python kitty
tags: datetime python
---

Making additions or subtractions to `datetime` variables is one of the most commonly encountered programming endeavors and that's what the built-in [datetime.datetime.timedelta](https://docs.python.org/3/library/datetime.html#datetime.timedelta) object is for in python. Its very useful in adding hours or days to your `datetime` variables as follows:

```python
import datetime

now = datetime.datetime.now()

tea_time = now + datetime.timedelta(hours=2)
next_week = now + datetime.timedelta(weeks=1)
```

But the `datetime.timedelta` objects have one serious limitation. You can add hours, days or even weeks to a `datetime` variable but not months! And there is a reason for that. As per the science of Horology (study/measurement of time), "months" isn't a fixed quantity of time. There could be "long" or 31 day months like January/March, there could be 30 day months like April/June or even 28 day months like February. 

However, apart from this theoretical concept of month, we also have a practical concept which we commonly rely on for our usual tasks. For example, if today is 25th of April, a month from now would be 25th of May. This practical concept just considers the difference between current date and the same day of next month (25th in this case) as one month while disregarding the fact that the actual duration of this difference may not exactly be a fixed quantity like 30 days. It could be 30, 31 or even 28/29 depending on which month you are counting from and whether its a leap year.

Computing this practical difference is also a very common programming endeavor but unfortunately, there is no easy way to do this in python using the built-in `datetime` package. But thankfully, the folks have invented this library called [dateutil](https://github.com/dateutil/dateutil) which does exactly that! Installing this package is pretty trivial and in most environments, you might be already having it as hundreds of popular python libraries rely on it.

	pip install python-dateutil

After that, you can straightaway start using it to add or subtract months using the `relativedelta` object:

```python
from dateutil.relativedelta import relativedelta

today = datetime.datetime.now().replace(hour=0,minute=0,second=0,microsecond=0)
epoch = today + relativedelta(months=6)
```

Of course, `relativedelta` is just one of the gems from the dateutil project, there are several others you can explore at [https://dateutil.readthedocs.io/en/latest/](https://dateutil.readthedocs.io/en/latest/).

Happy Coding!