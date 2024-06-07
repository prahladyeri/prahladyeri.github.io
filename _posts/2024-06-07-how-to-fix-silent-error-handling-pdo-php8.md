---
layout: post
title: 'How to fix "silent error handling" of PDO errors after upgrading to PHP 8'
tags: php codeigniter pdo php-8
published: true
image: /uploads/code-php.jpeg
---

PHP 8.x is filled with hidden land mines which can suddenly trip the unaware PHP coder, especially when porting from legacy frameworks like CodeIgniter or CakePHP to PHP 8.x systems. One such issue is PDO's default exception handling method.

Prior to PHP 8, PDO's default exception handling mode was `PDO::ERRMODE_SILENT` which means our apps deployed on production never expected any actual PDO Exceptions, they instead handled database errors by looking up the error code after the fact with something like CodeIgniter's `$CI->db->error()` function, for instance.

But starting from PHP 8.0, the [default exception handling mode for PDO is changed to PDO::ERRMODE_EXCEPTION](https://www.php.net/manual/en/pdo.error-handling.php). This means most PHP apps developed with the prior mindset can expect sudden or subtle bugs depending on how they were coded!

If you usually keep PHP's `display_errors` INI setting to 0 to avoid unnecessary depreciation notices on your production, then you are in for a great nasty surprise on PHP 8.x! Because if any database error occurs, you will never come to know of it. Your usual error code based handling won't work here as PDO uses the exception handling mode by default. Which means PDO still raises this exception, only it won't be displayed anywhere due to your `display_errors` INI setting. It will silently crash your script execution with no output and a 500 HTTP status code.

In one of the companies where I contract, this is exactly what happened recently. The following CI3 code is highly dependent on error code based checking - which is done inside the `db_error()` helper function. But the sad thing is that the interpreter will never reach that point as `$this->db->query` will throw an exception and halt the process immediately.

```php
$this->db->query("insert into schedule(emp_id, place_id, sch_date, notes) values (?,?,?,?)", $data);
if ($err = db_error()) {
	$r['status']  = 'failure';
	$r['message'] = $err;
} else {
	$r['status']='success';
	$r['message'] = 'Successfully inserted record.';
}
echo json_encode($r);
```

I had to debug by placing multiple `error_log()` statements to find out what's going on here! Needless to say, even though Exception is the recommended way of handling PDO hiccups, we can't change the whole app and its workflow for that alone, the cost would be too prohibitive for larger PHP apps like these. What we did instead was updated CodeIgniter's database configuration and changed the PDO's error handling option back to `PDO::ERRMODE_SILENT` instead:

```php
# /application/config/database.php
#..
#..
$db['default']['options'] = array(PDO::ATTR_ERRMODE => PDO::ERRMODE_SILENT);
```

If you don't want to do this but take the righteous path of using PDO Exceptions instead, then make sure you report and display ALL errors (or at least all barring depreciation notices):

```php
//error_reporting(E_ALL);
error_reporting(E_ALL & ~E_NOTICE & ~E_DEPRECATED);
ini_set('display_errors', 1);
```

After that, you can handle PDO Exceptions in your code normally. But the important thing is that you'll now be able to see the errors and know what's going on. They won't be treated silently like before.

Happy Coding!