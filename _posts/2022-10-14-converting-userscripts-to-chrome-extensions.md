---
layout: post
title: "Converting Userscript to Chrome Extension: The monkeys are no longer needed"
tags: javascript userscripts extensions
---

[Userscripts](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/userScripts) are a very useful and handy tool in the hands of power users. Just like customized garnishing, salt and pepper, etc. we put on our food before we eat, we can add custom javascript tweaks on the websites we visit.

For example, you may want Reddit to automatically highlight the recently posted (unread) comments on a post or thread. Another example is that when you perform a Google search, you may want trusted sites highlighted specifically (based on a pre-filtered list if you have one).

The classical or traditional way of running these userscripts is by using the "monkey" extensions, the most popular of them being [Greasemonkey](https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/) and [Tampermonkey](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo?hl=en).

These extensions allow you to write scripts that execute when you visit the particular sites for them. While this is a great way of using userscripts, the better and more efficient way is to always convert them into browser extensions.

Extensions run natively in your browsers as you're using one less execution layer. Besides, some extensions like Tampermonkey also update themselves too frequently (perhaps to keep up with the browser updates) and that might cause compatibility issues.

While comprehensive extension development is beyond the scope of this blog post, the conversion from a userscript to a basic chrome extension is quite straightforward. All you have to create is a folder for your extension and create two files named `manifest.json` and `content.js`. The `content.js` is where you'll place the javascript code presently in your script file. Two important points to note here is that there should be no use of special `GM_*` functions and you must not use any `return` statement unless it's inside a function.

Here is a very basic `manifest.json` example.

```javascript
{
"manifest_version": 2,
"name": "Reddit Plus",
"description": "Highlight unread comments and mark them in blue.",
"version": "1.0",
"icons": {
	"16": "icon.png",
	"48": "icon.png",
	"128": "icon.png"
  },
"content_scripts":[
	{
	  "matches":[
		"https://*.reddit.com/*"
	  ],
	  "exclude_matches":[
		"https://*.reddit.com/test/*"
	  ],
	  "js": ["lib/jquery.min.js", "content.js"]
	}
  ],
"browser_action": {
	"default_icon": "icon.png",
	"default_popup": "popup.html"
  },
  
  "background": {
	  "scripts": ["background.js"],
	  "persistent": false
	},
"permissions": [
	"activeTab",
	"storage",
	"https://ajax.googleapis.com/"
  ]
}
```

My userscript also depends on jquery and instead of calling it through the CDN, I've included it as a separate script under "lib" folder as "lib/jquery.min.js". Having an `icon.png` helps you distinguish the extension form others. The `background.js` is required as an empty placeholder. So, there are 5 files in total (the last one being optional):

- manifest.json
- content.js
- icon.png
- background.js
- lib/jquery.min.js

Once you have this structure, just go to `chrome://extensions` on your browser and switch on the "Developer Mode". This will allow you to install unpacked extensions. Just click on the "Load Unpacked" and browse your extension folder.

That's it! You can now test your extension by visiting the site just like you did with userscripts and the monkey extensions. This was for chrome browser which I happen to use but extension development workflow for other browsers like firefox or edge shouldn't be much different than this. Let me know how your userscript to extension conversion goes in the comments below.