---
layout: post
title: 'PHP/Codeigniter] Getting multi-queries right with SQLITE'
tags: php sqlite sql
---

My [earlier article](/blog/2022/10/php-mysql-multi-queries.html) dealt with multi-query issues of MySQL, this one is dedicated to SQLITE. Multi-queries are often discouraged to begin with but there are times when you find yourself using them. One typical use case is populating the database initially when it's empty. You do this by running an SQL script which may include multiple queries for creating tables, views, stored procedures, etc. and a few insert queries to populate default records (such as an admin user).

```php
$sql = file_get_contents(APPPATH . 'core\\install.sql');
$this->db->query($sql);
```

The above is what you typically do when it comes to Codeigniter framework but when I tried this (using `sqlite3` database driver), I was shocked to know that the multi-query didn't work at at all. Only the first SQL statement (among a soup of them separated by semi-colon) was working.

So I googled it and came to know that it was [an old bug](https://bugs.php.net/bug.php?id=28264). Apparently, they have now fixed it in later versions of PHP but only if you use `sqlite_exec()` instead of `sqlite_query()` function to run the query. Now, obviously our Codeigniter's database abstraction layer was running the latter because I was still facing this same bug as of PHP 7.

So I tried to scavenge and find out what exact function Codeigniter was running for sqlite3 driver by studying the file `system\database\drivers\sqlite3\sqlite3_driver.php`. And here I found out that the driver was running the `sqlite_exec()` or `sqlite_query()` based on the very weirdest logic! Apparently, this driver tries to find out the first **word** in your whole soup of SQL and only if it starts with one of these (DDL) statements, it ran the `sqlite_exec()`, otherwise it ran the `sqlite_query()`:

```php
public function is_write_type($sql)
{
	return (bool) preg_match('/^\s*"?(SET|INSERT|UPDATE|DELETE|REPLACE|CREATE|DROP|TRUNCATE|LOAD|COPY|ALTER|RENAME|GRANT|REVOKE|LOCK|UNLOCK|REINDEX|MERGE)\s/i', $sql);
}
```

Now, my `install.sql` actually started with a bunch of comments explaining what the whole thing was about, I had to remove this comment block and ensure that it started with a `CREATE` statement, only then the multi-query worked with Codeigniter.