---
layout: post
title: "Thoughts on PHP routing strategies"
tags: php webdev
published: true
image: /uploads/code-php.jpeg
---

Routing is a tricky business in PHP simply because there is no one standard way of doing it. Starting from the most simple and benign (but inflexible) routing strategy of handling every incoming request in the `index.php` script to the highly flexible (but arcane and opinionated) routing libraries of Symfony, Laravel and the likes, there are all kinds of options in between and it's up to you, as a developer, what routing strategy to use.

As a freelance programmer, while considering a routing strategy for the long term, it helps to remember two major deployment constraints on your production server:

1. Your client may want the PHP app to be installed to a specific subfolder like `http://xyz.com/subfolder/` instead of the root domain or subdomain.
2. Your client may not give you full permission to override the `.htaccess` file, hence any strategy to rewrite all URL paths to `index.php` may not work.

Especially for the second point, the common or usual approach is to simply override your .htaccess like this:

```bash
DirectoryIndex index.php
RewriteEngine On
RewriteBase /
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ /index.php/$1 [L]
```

This simple Apache rewrite rule will send all script requests to your index.php where your routing component can easily handle it with something like this:

```php
$router.get("/", function(){
	echo "Hello, World";
});
```

But what if you're not allowed to override the .htaccess file? I imagine many modern PHP routing libraries will fall apart if that happens! But some frameworks like CodeIgniter provide useful functions to handle this situation. The `site_url()` function is especially useful here. Using it, I can refer to a URL route irrespective of whether the request came by overriding the index.php or not. Your user may have typed `xyz.com/index.php/foo/bar` instead of just `xyz.com/foo/bar` but in both cases, the request will arrive at the foo controller's bar method. And if you want to redirect to the `foo/bar` URL, you can simply do it by using site_url() function:

```php
header('Location: '. site_url("foo/bar"));
exit;
```

Instead of hard-coding the URL or making any assumptions, this is a better approach as it will work irrespective of whether .htaccess was allowed to be overridden or not.

Similarly, for the first issue of using a subfolder, there is the `base_url()` function in CodeIgniter. You configure this one time variable initially and use it throughout your code like this:

```html
<link rel="stylesheet" href="<?=base_url()?>static/css/app.css">
```

I don't have to hard code any static path here and the web app becomes extremely portable. I'm sure other modern frameworks like Symfony and Laravel must be providing equivalent features and I'm yet to look at them. But overall, I find these OOP frameworks much too complex, which is almost like using nuclear energy to ignite a kerosene lamp! Maybe Big Tech and large IT firms who are into scaling might find them useful but for small freelancers and bloggers, I think the old school PHP frameworks still work the best. What do you think?