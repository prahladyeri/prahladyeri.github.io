---
layout: post
title: "Working with multi-queries in CodeIgniter"
tags: php codeigniter
published: true
image: /uploads/code-php.jpeg
---

Running multi-queries (a bunch of text containing arbitrary DML/DDL statements) is highly unreliable and not an exact science in CodeIgniter or even PHP for that matter. The Internet is filled with posts like [this](https://stackoverflow.com/questions/8999959/executing-multiple-queries-in-codeigniter-that-cannot-be-executed-one-by-one), [this](https://stackoverflow.com/questions/51257526/how-to-run-multi-queries-at-once-in-codeigniter), and [this](https://stackoverflow.com/questions/21869603/running-multiple-queries-in-model-in-codeigniter) but you can't depend on these solutions in most situations due to the difference between how each database driver handles it.

Most of the `query()` or `exec()` statements often don't run at all due to the batch structure (begin and commit trans) not handled properly as per that driver's liking. It may also happen that due to one error in a single SQL statement, the whole text is ignored and yet, there is no error prompt, the folks will think that multi-query executed successfully when, in fact, it didn't. Hence, it is often so tempting to do something like this in CodeIgniter but doesn't always work (especially with SQLITE databases):

```php
$sql = file_get_contents(APPPATH . '/core/init.sql');
$this->db->query($sql);
```

The only approach that is guaranteed to work reliably here is to break your multi query into individual SQL chunks by splitting the semicolon and then run each individual statement like this:

```php
$sqls = explode(';', $sql);
array_pop($sqls);
foreach($sqls as $statement){
	$statment = $statement . ";";
	//echo $statement;
	$this->db->query($statement);   
}
```

This will naturally rule out adding of any comments or whitespaces above or below the statements as you would in a script because that might cause an error. However, a simple and clean SQL script such as this one will work flawlessly:

```sql
drop table if exists settings;
drop table if exists prices;
drop table if exists quantities;

create table settings (
	id integer primary key,
	key varchar(2000),
	value varchar(2000)
);

create table update_status (
	id integer primary key,
	idx int,
	last_update datetime
);

create table prices (
	id integer primary key,
	price decimal(9,2),
	price_dt datetime
);

create table quantities (
	id integer primary key,
	idx integer,
	qty decimal(9,2),
	qty_dt datetime
);
```