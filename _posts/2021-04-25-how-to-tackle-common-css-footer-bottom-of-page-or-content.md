---
layout: post
title: "Tackling a common CSS design problem: Footer placement at page or content bottom, whichever is lower"
tags: html css footer web-development
---

This is one of those commonly occurring nags in web development which I've solved several times before but still have to scavenge the googles and stack-overflows each time I run into it. That's why I've decided to document the simple solution to it in this brief article.

What happens is that if you position your footer div and fix it at bottom of the page (`position:fixed, bottom:0, width:100%`), it will work great on shorter content pages (where you don't have to scroll). But the problem is that on longer pages too, instead of moving to the bottom of the content, it will be stuck there at the viewport bottom like an idiot!

![stuck viewport bottom footer](/uploads/stuck_viewport_bottom_footer.png)

The above situation can be seen in action in [this fiddle](https://jsfiddle.net/dwe8t6c5/10/show) where multiple "lorem ipsum" blocks (`<p>` elements) are placed to simulate content growth. You'll find that the footer will work flawlessly when the content is short (only 1-2 "lorem ipsum" blocks) but the footer gets stuck at the viewport bottom as you keep adding the blocks and they extend beyond the viewport height!

On the other hand, instead of positioning your footer, if you just let it be (this is what about 90% of coders initially do), you have another problem. Your footer will now be placed correctly on longer content pages where you must scroll but on the shorter pages, they'll be hanging in the middle of the page where your content ends as shown in [this fiddle](https://jsfiddle.net/dwe8t6c5/11/show).

![middle of page footer](/uploads/middle_of_page_footer.png)

There could be multiple approaches to solve this problem. I personally prefer the old school method which is quite simple and easy to understand. Besides, it doesn't require adding of any blank HTML element like "#offset" or "#placeholder" above your footer. All it requires is that all your HTML elements above the footer must be wrapped up inside one container div element. So, the body should be structured something like this:

```bash
HTML
..BODY
....div.container
......header1,
......article1,
........p,
......etc, etc.
....footer
```

Then all you have to do is set your div.container's minimum height to viewport's height minus footer's height. Assuming your footer's height is 55px, all you have to do is:

```css
div.container {
	min-height: calc(100vh - 55px);
}
```

You can see a working demo of this in [this fiddle](https://jsfiddle.net/dwe8t6c5/14/show). Even as you start adding more and more "lorem ipsum" paragraph elements, the footer will always be placed at the "right" place irrespective of other element's positioning and content size! This is what you'd call a "properly placed footer":

![properly placed footer](/uploads/properly_placed_footer.png)