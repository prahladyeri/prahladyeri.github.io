---
layout: post
title: 'How to implement URL routing in vanilla javascript'
tags: url productivity javascript
---

In this post, I'll show you how to implement dynamic URL routing in vanilla JavaScript without using any heavy frameworks like angular, vue, react, ember, etc. in less than 30 lines of code!

The important attributes you need to know are `window.location` and more specifically to our purpose, `window.location.hash`. This built-in property basically tells us what page URL or route we are presently in (ex: `index.html#something`). This property is blank if there is no hash URL and you are on the main URL (ex: `index.html` or `index.html#`). In that case, you may assume a default hash such as `_index` to maintain consistency:

```javascript
function displayHash() {
  var theHash = window.location.hash;
  if (theHash.length == 0) { theHash = "_index"; }
  var elems = document.querySelectorAll("#caption");
  elems[0].innerText = "Current Hash: " + theHash;
  return true;
}
```

This simple function displays the current hash in a heading element named `#caption`. If you want this to fire each time the hash changes (user navigated to a different page in your app), you can do that using the `hashchange` window event:

```javascript
window.addEventListener("hashchange", function() {
  console.log("hashchange event");
  displayHash();
});
```
	
And finally, in order to display the heading initially when the user first loads the URL in their browser, you can call `displayHash()` in the `DOMContentLoaded` event call too:

```javascript
window.addEventListener("DOMContentLoaded", function(ev) {
  console.log("DOMContentLoaded event");
  displayHash();
});
```

That's all folks! URL Routing is so easy to implement without using any heavy and bloated frameworks at all. The demo for this example can be found at [prahladyeri.github.io/learn-js/url-routing](https://prahladyeri.github.io/learn-js/url-routing). You can see that as you click the individual hyper-links, the heading label changes to display the current hash.

The complete source code for this can be found at my github repo, [prahladyeri/learnjs](https://github.com/prahladyeri/learn-js/blob/master/url-routing/index.html) (its less than 30 lines ;-).

I came across this solution through this [StackOverflow post by Tulio Faria](https://stackoverflow.com/a/41426078/849365) which uses jquery but I adapted it for vanilla JavaScript.
