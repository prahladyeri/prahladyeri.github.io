---
layout: post
title: 'How to handle long-polling of XHR requests in PHP'
tags: xhr apache codeigniter php
---

A common need you often face in PHP scripting these days is writing a long-polling endpoint for things like sending notifications or other kinds of responses back to the client. While using something dedicated like node, cometd or websocket makes ideal sense for such things, there are use-cases when you want to accomplish this in PHP itself and don't want to add any extra dependencies or components to your project.

![php xhr long polling](/uploads/php-xhr-long-polling.png)

In this post, I'll show you how to achieve this to a limited extent in PHP. But how scalable this solution will be will depend on the threading model and configuration of your web-server (apache/nginx). The basic problem with long-polling is that unlike short-polling, the client won't exit immediately. The client keeps waiting for a response and this will inevitably block a thread on your web server. The same principle applies even when you go for other solutions like websocket, cometd, etc. but these libraries or components hide this "wait" implementation away from your code.

A notable exception here is node.js. Due to its uniquely architectured single-threaded event based model, this problem isn't faced. Anyway, coming back to PHP implementation, here is how I handled it in my code. Please note that it's extremely important to call `session_write_close()` as early as possible in your code and it's also important to override the default `max_execution_time` php configuration at the beginning of your php script or framework configuration with something like this:

```php
ini_set('max_execution_time', '300');
```

Once you ensure this, this is how you can handle it on php side:

```php
<?php
public function fetch_long() {
	session_write_close();
	error_log('LONG POLLING');
	$start = time();
	error_log("LONG POLLING LOOP STARTS...");
	while((time()-$start) <= 300) {
		$sql = "select * from notifications where id=1";
		error_log("NOW QUERYING...");
		$r = $this->db->query($sql)->result_array();
		if (count($r)>0) {
			error_log("GOT NOTIFS, ESCAPING...");
			echo json_encode($r);
			return;
		}
		else {
			error_log("I KEEP POLLING ...".(time()-$start));
		}
		sleep(5);
	}
	error_log("ESCAPING ANYWAY...");
	echo json_encode([]);
}
```

Please note that once you call `session_write_close()`, you won't be able to write to any session variables. However, you'll still be able to read them. What I then do is create a blocking loop with a maximum limit of 300 seconds (you can increase it to as much as you want subject to what value you configured in `max_execution_time` earlier). If a notification is fetched before that time, I simply return it and exit the function. If not, the loop just times out in the end and I return a blank array.

Finally, this is how my AJAX call on front-end looks:

```javascript
function fetchNotifications() {
	$.ajax({
		url: "/home/fetch_long",
		type: 'GET',
		cache: false,
		error: function() {
			setTimeout(fetchNotifications, 3000);
		},
		success: function(data) {
			handleNotif(data);
			setTimeout(fetchNotifications, 3000);
		}
	});
}

$(document).ready(function(){
	fetchNotifications();
});
```

Once the client receives a response from server, it keeps calling it again and again ad-infinitum to keep fetching the notifications.

The obvious limitation of this method is that a thread is blocked for every "waiting" request on the server side, so it isn't ideal for scaling. In my case, I had only 30-40 users at most who used this app, so it wasn't a big issue. Even then, I've added a pause of 3 seconds on client side before making the next request, just so as to give some breathing space to the server.

Despite the limitation, the app is working decently on the apache server without any configuration tweaks required. And besides, this is an architectural limitation which will always be there as I said, even in case of third party solutions like cometd and websocket.

Were you able to scale your PHP app with long polling by using this method? Please comment and let me know.