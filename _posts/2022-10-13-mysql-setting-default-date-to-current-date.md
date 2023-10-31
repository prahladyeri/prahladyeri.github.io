---
layout: post
title: "MySQL] Setting default date to current date"
tags: mysql php
---

The most typical way people set default values to mysql date fields is by using the `CURRENT_TIMESTAMP` constant as follows:

```sql
create table ledger_entries (
	id int(11) not null auto_increment,
	entry_date datetime default CURRENT_TIMESTAMP
);
```

This will obviously work if you need both date and time parts in the value. But in most cases (like entry_date here), we only need the date part and would happily like to save that extra space. Even if you don't want to save extra space, you may want to use the `date` data type for widget compatibility on the front-end . In few such situations, we prefer to use the `date` mysql data type instead of `datetime`.

The obvious constraint here is that you can't then use `CURRENT_TIMESTAMP` as the default value to the newly added rows. Following isn't allowed in MySQL as no pre-defined constant (except `CURRENT_TIMESTAMP`) is even permitted as a default value in the first place:

	entry_date datetime default CURRENT_DATE


Now what will you do in such situations? As stated in some stack overflow posts like [this](https://stackoverflow.com/q/20461030/849365), [this](https://stackoverflow.com/q/64756590/849365) and [this one](https://stackoverflow.com/q/36374335/849365), a new (2018) MySQL version does allow a default date like this but I don't recommended this as the practice won't be compatible with universal MySQL installations or versions:

	CREATE TABLE INVOICE(
		INVOICEDATE DATE DEFAULT (CURRENT_DATE)
	)

Another way to handle this is to write a trigger. When new rows are inserted to the table, you may want to set the value to `CURRENT_DATE`. You may prefer this approach if you're already writing a trigger but it's a tad extra code and inefficiency to keep adding triggers just for this one need though.

I felt the best way is to handle this at the application level, that's what I preferred to do when I came across this problem recently.

Happy coding and let me know your experience with mysql date/time values in comments below.

References:

- <https://stackoverflow.com/q/20461030/849365>
- <https://stackoverflow.com/q/64756590/849365>
- <https://stackoverflow.com/q/36374335/849365>
- <https://stackoverflow.com/q/168736/849365>
