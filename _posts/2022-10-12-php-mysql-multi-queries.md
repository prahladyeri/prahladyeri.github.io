---
layout: post
title: "PHP/Codeigniter] Playing with multi-queries in MySQL"
tags: php mysql sql
---

Multi-queries are often discouraged with `mysqli` functions but there are times when you must use them. One obvious use case is initializing the database. One of the first things your app must do is determine if the database tables exist or not, and then run an initializing SQL script if they don't. This script may include multiple queries for creating tables, views, stored procedures, etc. and a few insert queries to populate default records (such as an admin user).

Running multiple queries with `mysqli` isn't an exact science though! The [`mysqli_multi_query`](https://www.php.net/manual/en/mysqli.multi-query.php) function is technically the way to do it but there are some quirks you must be aware of when using it.

A major challenge here is error handling. The above function sends the individual queries (separated by semi-colons) to server one by one and stops executing the moment it faces an error in one of them. As stated in [this stackoverflow answer](https://stackoverflow.com/a/7867175/849365), there is no official way to fetch errors in each and every one of your statements.

What you must do, in fact, is keep calling `mysqli_next_result()` again and again until each query result (or error) is fetched. This is how a proper implementation looks like (the code would probably be much shorter if it was implemented using some other technology like python or ADO.NET!):

```php
<?php
$data = array('error' => []);
if ($this->input->method() == 'post') {
	$sql = file_get_contents(APPPATH . '../init.sql');
	$result = mysqli_multi_query($this->db->conn_id, $sql);
	if (!$result) $data['error'][] = db_error(); //handle error
	while(mysqli_more_results($this->db->conn_id)) {
		$result = mysqli_next_result($this->db->conn_id);
		 if (!$result) $data['error'][] = db_error(); //handle error
	}
	if (count($data['error'])==0) {
		$data['info'][] = 'The system is successfully installed!<br><a href="/auth/login">Click here</a> to login!';
		$data['installed'] = true;
	}
}
```

Another quirk to be aware of with `mysqli_multi_query` is that you must ALWAYS fetch the results by calling `mysqli_next_result` subsequently until `mysqli_more_results()` returns true. Not doing so may introduce some inadvertent bugs in your code when you later try to fetch records through `mysqli_query`.

Happy coding and let me know through comments below how your implementation goes!