---
layout: post
title: 'Migrating Disqus comments into Wordpress'
tags: blogging disqus wordpress
---

Further to my earlier blog post about [How to Import Disqus comments into Wordpress](/blog/2017/09/demystifying-comments-migration-from-disqus-to-wordpress.html), I've found that script solution to be a bit trickier for first time users who want to migrate disqus comments from their earlier blog to the new wordpress blog.

![PHP Code](/uploads/code-php.jpeg)

The `disqus_parse.php` is exactly the same as it is because the parsing logic hasn't changed. However, a lot has changed in actual running of the console script (`console.php`), so I've updated the same as follows:

1. Modified the URL check which ensures that disqus post's URL path is the same as Wordpress post's URL path. I've found that its much more effective to match only the "path" portions of the respective URLs instead of including the entire domain, so I used `parse_url` PHP function accordingly:

	$cpath = parse_url($comment['url'], PHP_URL_PATH);
	$tpath = parse_url($t_url, PHP_URL_PATH);
	if ($cpath === $tpath) {
	...


2. Added a `$sleep_interval` parameter at the top of the script (default value is 2), this is needed sometimes because some Wordpress installations throw the error *"You are posting comments too quickly"* when you try to append comments through a script. If this happens, you'll have to increase this parameter's value to 6 or sometimes 11 depending on the commenting user's status. If you want to avoid this check altogether and insert comments quickly, you can temporarily add the below line to the bottom of your `functions.php` (but remember to revert back later once your comments are migrated!).

		add_filter('comment_flood_filter', '__return_false');
		
3. The `$post->author->name` XML value may be in the array form sometimes, so I've added that check:

	if (is_array($comment['name'])) {
		$comment_author = (string)$comment['name'][0];
	}
	else {
		$comment_author = (string)$comment['name'];
	}

4. Passed the `$avoid_die` parameter as `true` to the [wp_new_comment](https://developer.wordpress.org/reference/functions/wp_new_comment/) function as its more useful and practical.


Below are the links to the latest scripts which you must run from inside a plugin directory such as `/wp-content/plugins/test/`:

**console.php:**

[https://gist.github.com/prahladyeri/e22e4e232416ff841be670601b396c62](https://gist.github.com/prahladyeri/e22e4e232416ff841be670601b396c62)

**disqus_parse.php:**

[https://gist.github.com/prahladyeri/d1e19d8a6d0c7ff23fe3e15f9050b6d3](https://gist.github.com/prahladyeri/d1e19d8a6d0c7ff23fe3e15f9050b6d3)
