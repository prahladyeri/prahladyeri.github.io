---
layout: post
title: 'How to set your blogspot blog for twitter card validation'
tags: blogspot blogging
---

One of the first things you want to do after publishing your blog is to share it with rest of the world and twitter is how most of you folks do it, right? But when you share your link in a tweet, you want it to expand into a proper card like this. But with Google's Blogspot blogs, it doesn't happen by default (at least as of today) even though it should be.

![twitter-card-blogger](/uploads/twitter-card-blogger.png)

This is what you must do in order for your blog's links to expand on twitter in the card format. Please note that if you change your theme later, you must redo this exercise each time as the new theme entirely rewrites the HTML template.

1. Go to Theme => Customize => Edit HTML and open the HTML editor window for the blog template.
2. Press "Control+F" and search for this phrase:

```html
<b:includable id='post' var='post'>
```

3. Search it multiple times to make sure. In some templates, there are more than one of these sections and in those cases, we are interested in the last one.

4. Just hit `<enter>` to create some blank space just below this tag start line and enter the following code:

```html
	<!-- Twitter Card Tags -->
	<meta content='@prahladyeri' name='twitter:site'/>
	<meta content='@prahladyeri' name='twitter:creator'/>
	<b:if cond='data:post.firstImageUrl'>
	   <meta content='summary_large_image' name='twitter:card'/> <!-- summary_large_image or any other your card types -->
	   <meta expr:content='data:post.firstImageUrl' name='twitter:image'/> 
	<b:elseif cond='data:blog.postImageUrl'/>
	   <meta content='summary' name='twitter:card'/>
	   <meta expr:content='data:blog.postImageUrl' name='twitter:image'/> 
	<b:elseif cond='data:blog.postImageThumbnailUrl'/>
	   <meta content='summary' name='twitter:card'/>
	   <meta expr:content='data:blog.postImageThumbnailUrl' name='twitter:image'/> 
	<b:else/>
	   <meta content='summary' name='twitter:card'/>
	  <meta content='https://1.bp.blogspot.com/-vCbJYZxPF80/XErJHU_gi7I/AAAAAAAACGU/WGznlnB-K8AnpZunzlHYuaxg6c1TA5UfwCPcBGAYYCw/s320/pexels-photo-261577.jpeg' name='twitter:image'/> 
	</b:if>
```
	
5. Please remember to change the `twitter:site`, `twitter:creator` and the last `twitter:image` meta tags (which is for the default image in case none is found in your post) as per what suits you.

6. Once you do this and save the template, visit the [Twitter Card Validation Page](https://cards-dev.twitter.com/validator) to verify that your blog link expands into a proper card.

7. After that, you are ready to publish your blogspot link through a tweet and share it with the rest of the world!