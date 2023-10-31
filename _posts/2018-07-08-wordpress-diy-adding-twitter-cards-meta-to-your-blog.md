---
layout: post
title: 'WordPress DIY: Adding twitter cards meta to your blog without using an external plugin'
tags: php wordpress
---

Just like my [last article](https://prahladyeri.github.io/blog/2018/07/wordpress-diy-adding-google-analytics-script-to-your-blog.html), we won't be focusing on using a third party plugin, but write our own plugin. I'm a minimalist and don't prefer to use layer-2 solutions for really trivial things that can easily be achieved by writing code.<!--more-->

Now, though trivial to implement, the twitter cards support is a very important and useful thing for your blog. To understand why, consider the following example tweet from Python Software Foundation:

![Links had no Twitter Card Meta](/uploads/2018/07/no_twitter_card.png)

**Links had no Twitter Card Meta**

As you can see, the posted links on this tweet from the domain djangoproject.com didn't expand into a preview because they didn't have twitter card meta tags in their pages. Unlike Facebook who expands all posted links, Twitter doesn't do that automatically, but only after parsing some meta tags which should be in their required format. Only after that, the tweets expand into a full preview like this:

![Link had Twitter Meta](/uploads/2018/07/twitter_card.png)

**Link had Twitter Card Meta**

So as the owner of a WordPress blog, you'd be certainly interested in having the tweets containing links to your own site expand into these previews, right? So, let's go about doing it.

Essentially, your web page should contain the following meta tags that twitter parses in order to come up with a preview:

    <meta name="twitter:card" content="summary" />
     <meta name="twitter:site" content="@prahladyeri" />
     <meta name="twitter:creator" value="@prahladyeri" />
     <meta name="twitter:url" content="https://prahladyeri.github.io/blog/2018/06/people-migrating-from-github-to-gitlab-should-learn-about-these-details-first.html" />
     <meta name="twitter:title" content="People migrating from Github to Gitlab should learn about these details first" />
     <meta name="twitter:description" content="After &lt;a href=&quot;https://prahladyeri.github.io/blog/2018/06/microsofts-github-acquisition-an-unbiased-perspective.html&quot;&gt;Microsoft&#039;s recent acquisition of Github&lt;/a&gt;, a mass exodus has kind of begun and many small and large projects are moving their code bases to the much hyped &lt;a href=&quot;https://gitlab.com/&quot;&gt;Gitlab&lt;/a&gt; in a hurry, and these include both open and closed source projects. However, before migrating to Gitlab, they should take a pause and learn something about Gitlab and consider evaluating other alternatives too." />
     <meta name="twitter:image" content="https://secure.gravatar.com/avatar/3f253507b82dd33f352c08f649caaa54?rating=PG&size=75" />

All these meta tags have different meanings. For example, **twitter:url** is for the canonical URL of your page, **twitter:title** is for the title that should be displayed in the preview, etc.

Now, let's add a simple PHP plugin file that automatically adds these tags in all the pages of our WordPress blog. Firstly, create a text file called **"/wp-content/plugins/custom\_headers.php"** in your WordPress installation folder (no need to create if you had done already by following the last article).

After that, just add the below function and call it using **add\_action()**:

    function add_twitter_card_header() {
        #twitter cards hack
        global $post;
        if(is_single() || is_page()) {
            $twitter_url    = get_permalink();
            $twitter_title  = get_the_title();
            $content = get_extended( $post->post_content );
            $attch_id = get_post_thumbnail_id($post->ID);
            $twitter_thumbs = wp_get_attachment_image_src($attch_id, full);
            $twitter_thumb  = $twitter_thumbs[0];
            if(!$twitter_thumb) {
                $twitter_thumb = 'https://secure.gravatar.com/avatar/3f253507b82dd33f352c08f649caaa54?rating=PG&size=75';
            }
            ?>
            <meta name="twitter:card" content="summary" />
            <meta name="twitter:site" content="@prahladyeri" />
            <meta name="twitter:creator" value="@prahladyeri" />
            <meta name="twitter:url" content="<?php echo $twitter_url; ?>" />
            <meta name="twitter:title" content="<?php echo $twitter_title; ?>" />
            <meta name="twitter:description" content="<?php echo esc_html($content['main']); ?>" />
            <meta name="twitter:image" content="<?php echo $twitter_thumb; ?>" />
            <?php
        }
    }

    add_action('wp_head', 'add_twitter_card_header');

This simple block of code will pick up all required things such as the post's title content excerpt, etc. and supply them to twitter via the meta tags. Few important things you need to remember:

1\. Firstly, update the \$twitter\_thumb variable in the following block with your own gravatar:

    if(!$twitter_thumb) { $twitter_thumb = 'https://secure.gravatar.com/avatar/3f253507b82dd33f352c08f649caaa54?rating=PG&size=75'; }

This will show the gravatar by default if you haven't set a featured image in your post.

2\. You'll need to add the **"Read More"** meta tag in all your posts, otherwise **\$content\['main'\]** will return the whole thing instead of just the excerpt.

Once you do this and publish your post, head over to the [Twitter Cards Validator Service](https://cards-dev.twitter.com/validator) and test your link. Its as easy as that!
