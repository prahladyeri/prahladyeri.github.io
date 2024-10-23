---
layout: post
title: 'Seamlessly migrate disqus comments to WordPress: a step-by-step guide'
tags: blogging disqus wordpress
---
If you’re switching from a platform using Disqus to WordPress, migrating your comments can seem daunting. Disqus was once a popular choice for blog comments, but with WordPress's built-in commenting system and more robust plugins, many are making the switch. In this guide, I’ll walk you through how to easily migrate your Disqus comments to WordPress using updated scripts and tips to ensure a smooth transition. 

This is an updated follow-up to my previous guide on [Importing Disqus Comments into WordPress](/blog/2017/09/demystifying-comments-migration-from-disqus-to-wordpress.html). The process remains largely the same, but I’ve made tweaks and improvements to make it easier for first-time users. Let’s dive in!

---

### Why Migrate from Disqus to WordPress?

Disqus was once a go-to for comment management, but its reliance on third-party services and recent issues like increased ads and slow performance have prompted many bloggers to look for alternatives. Migrating to WordPress's native system means faster load times, more control over your data, and fewer dependencies on external services.

If you’re ready to switch, follow this guide to migrate your comments efficiently.

---

### Step-by-Step: Migrating Disqus Comments to WordPress

I've updated the migration scripts to reflect changes in both WordPress and Disqus. Below is a breakdown of the process, as well as the script updates that make it easier.

---

#### 1. Adjusting the URL Matching Logic

The previous migration process required exact URL matches between your Disqus and WordPress posts, which could cause issues. I've now optimized the script to compare only the URL paths (ignoring domains) using the `parse_url` function:

```php
$cpath = parse_url($comment['url'], PHP_URL_PATH);
$tpath = parse_url($t_url, PHP_URL_PATH);
if ($cpath === $tpath) {
    ...
}
```

This change makes it easier to match URLs across different domains, streamlining the migration process.

![php code](/uploads/code-php.jpeg)

---

#### 2. Handling Comment Flooding Errors

WordPress sometimes throws a *"You are posting comments too quickly"* error when bulk importing comments. To mitigate this, I've added a `$sleep_interval` parameter (default value is 2 seconds) to slow down the import:

```php
$sleep_interval = 2;
```

If you encounter this error, you can increase the `$sleep_interval` or temporarily disable the comment flood protection by adding the following line to your `functions.php` file (remember to revert it after the migration):

```php
add_filter('comment_flood_filter', '__return_false');
```

---

#### 3. Parsing Comment Author Names

Sometimes the Disqus comment author's name is stored in an array. The updated script accounts for this with a simple check:

```php
if (is_array($comment['name'])) {
    $comment_author = (string)$comment['name'][0];
} else {
    $comment_author = (string)$comment['name'];
}
```

This prevents issues when migrating comments from authors with complex names.

---

#### 4. Passing the Avoid Die Parameter to `wp_new_comment`

In some cases, the `wp_new_comment()` function would stop execution if there were issues with a comment. By passing the `$avoid_die` parameter as `true`, we ensure the script continues to run smoothly:

```php
wp_new_comment($comment_data, true);
```

This change helps prevent the script from stopping prematurely.

---

### Updated Migration Scripts

The latest versions of the scripts can be found below. These updates ensure smoother migrations with fewer errors and better compatibility with different WordPress setups. 

- **[console.php](https://gist.github.com/prahladyeri/e22e4e232416ff841be670601b396c62)**
- **[disqus_parse.php](https://gist.github.com/prahladyeri/d1e19d8a6d0c7ff23fe3e15f9050b6d3)**

Place these files inside a plugin directory such as `/wp-content/plugins/your-plugin/` and run them from there to begin the migration process.

---

### Final Thoughts

Migrating comments from Disqus to WordPress might seem complex, but with these updated scripts and adjustments, you’ll have your comments fully migrated in no time. WordPress offers better flexibility, performance, and security when compared to third-party comment systems, and this switch is a great step toward streamlining your blog management.