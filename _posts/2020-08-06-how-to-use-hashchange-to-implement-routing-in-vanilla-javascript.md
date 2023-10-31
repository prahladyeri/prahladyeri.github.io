---
layout: post
title: How to use window.hashchange event to implement routing in vanilla javascript
tags: javascript routing
---

The popular wisdom when it comes to implement routing in your client side apps or single page apps (SPA) as they are called these days, is to just grab an "off-the-shelf" framework like angular or vue and start using it. Well, that's the easy way out but you will never understand the nuts and bolts of how things like routing work at the low level. Besides, if routing is the only major requirement in your app, why riddle your app with unnecessary bloat of frameworks?

![source code](/uploads/code.jpg)

If you happen to agree with that wisdom, you can proceed further to learn how exactly to implement routing in vanilla javascript.

When it comes to routing, your app has two main options:

1. To use hash urls such as `http://localhost/#login` and `http://localhost/#register`
2. To use fully fledged or "proper" urls like `http://localhost/login` and `http://localhost/register`

As you can see, the major difference is that the former method uses hashes (`#`) which are used to control routing on the client side whereas the latter method uses complete urls without the hashes. The latter method requires you to use the `history.pushState` API method and while these urls look quite sexy and elegant, they come with a cost: your backend web server must support routing up to multiple path fragments too. This means that you will need a "proper" web-server on the backend such as apache or nginx, you can't do this with "simple" http servers such as the python's built-in `http.server` module or even static hosting facilities like github-pages and netlify. So, if you intend to host your app using github-pages or netlify, you must remember to use hash urls only!

Considering that hash urls method is compatible with all kinds of backend servers, its a good practice to use them in all apps, irrespective of the backend used. Once again, popular wisdom may not agree with that and most "experts" may in fact advise you to do the opposite!

Coming to the point, implementing hash urls is as easy as handling the `window.hashchange()` browser event. Using vanilla javascript, it can be as simple as this:

```javascript
window.addEventListener('hashchange', function(){
	switch(location.hash) {
		case "#index":
			doIndexStuff();
		case "#login":
			doLoginStuff();
		case "#register":
			doRegisterStuff();
		default:
			handleDefaultCase();
	}
});
```

You see how simple url routing is with `hashchange`? You want to have advanced routing features like path fragments and parameters? No problemo! You can use simple string.split() method to take care of that:

```javascript
var url = location.hash.substring(1); //#user/prahlad?view=profile
var parts = url.split("?");
var fragments = parts[0].split("/"); // user/prahlad
var paramParts = parts[1].split("&"),
	params = [];
for(var i=0;i<paramParts.length;i++) {
	var pair = paramParts[i].split('='),
		obj = {};
	obj[pair[0]] = pair[1];
	params.push(obj);
}
```

This simple piece of code will parse your hash url and fill the successive path fragments (`user/prahlad`) in the `fragments` array and the parameter pairs (`?view=profile`) as key-value objects in the `params` array. You can of course mix, match and customize this code as per your own scenario but this is all there is to routing in about 90% of use cases!

Enjoy and Happy Coding!