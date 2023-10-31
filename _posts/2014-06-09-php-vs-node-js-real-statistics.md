---
layout: post
title: "PHP vs node.js: The REAL statistics"
tags: php javascript node
---

When it comes to web programming, I've always coded in ASP.NET or the LAMP technologies for most part of my life. Now, the new buzz in the city is [node.js](https://en.wikipedia.org/wiki/Node.js). It is a light-weight platform that runs javascript code on server-side and is said to improvise performance by using async I/O.<!--more-->

The [theory](http://notes.ericjiang.com/posts/751) suggests that synchronous or blocking model of I/O works something like this:

[![Blocking I/O](/uploads/old/nodejs-comp.png){.alignnone .size-full .wp-image-3070 width="506" height="354"}](/uploads/2014/06/nodejs-comp.png)

I/O is typically the costliest part of a web transaction. When a request arrives to the apache web server, it passes it to PHP interpreter for scripting any dynamic contents. Now comes the tricky part - If the PHP script wants to read something from the disk/database or write to it, that is the slowest link in the chain. When you call PHP function file\_get\_contents(), the entire thread is blocked until the contents are retrieved! The server can't do anything until your script gets the file contents. Consider what happens when multiples of simultaneous requests are issued by different users to your server? They get queued, because no thread is available to do the job since they are all blocked in I/O!

Here comes the unique selling-point of node.js. Since node.js implements async I/O in almost all its functions, the server thread in the above scenario is freed as soon as the file retrieval function (fs.readFile) is called. Then, once the I/O completes, node calls a function (passed earlier by fs.readFile) along with the data parameters. In the meantime, that valuable thread can be used for serving some other request.

So thats the theory about it anyway. But I'm not someone who just accepts any new fad in the town just because it is hype and everyone uses it. Nope, I want to get under the covers and verify it for myself. I wanted to see whether this theory holds in actual practice or not.

So I brought upon myself the job of writing two simple scripts for benchmarking this - one in PHP (hosted on apache2) and other in javascript (hosted on node.js). The test itself was very simple. The script would:

1\. Accept the request.\
2. Generate a random string of 108 kilobytes.\
3. Write the string to a file on the disk.\
4. Read the contents back from disk.\
5. Return the string back on the response stream.

This is the first script, index.php:

	<?php
	//index.php
	$s=""; //generate a random string of 108KB and a random filename
	$fname = chr(rand(0,57)+65).chr(rand(0,57)+65).chr(rand(0,57)+65).chr(rand(0,57)+65).'.txt';
	for($i=0;$i&lt;108000;$i++)
	{
		$n=rand(0,57)+65;
		$s = $s.chr($n);
	}

	//write s to a file
	file_put_contents($fname,$s);
	$result = file_get_contents($fname);
	echo $result;

And here is the second script, server.js:

	//server.js
	var http = require('http');    
	var server = http.createServer(handler);

	function handler(request, response) {
		//console.log('request received!');
		response.writeHead(200, {'Content-Type': 'text/plain'});

		s=""; //generate a random string of 108KB and a random filename
		fname = String.fromCharCode(Math.floor(65 + (Math.random()*(122-65)) )) +
			String.fromCharCode(Math.floor(65 + (Math.random()*(122-65)) )) +
			String.fromCharCode(Math.floor(65 + (Math.random()*(122-65)) )) + 
			String.fromCharCode(Math.floor(65 + (Math.random()*(122-65)) )) + ".txt";

		for(i=0;i&lt;108000;i++)
		{
			n=Math.floor(65 + (Math.random()*(122-65)) );
			s+=String.fromCharCode(n);
		}

		//write s to a file
		var fs = require('fs');
		fs.writeFile(fname, s, function(err, fd) {
				if (err) throw err;
				//console.log("The file was saved!");
				//read back from the file
				fs.readFile(fname, function (err, data) {
					if (err) throw err;
					result = data;
					response.end(result);
				});  
			}
		);
	}

	server.listen(8124);
	console.log('Server running at http://127.0.0.1:8124/');

And then, I ran the apache benchmarking tool on both of them with 2000 requests (200 concurrent). When I saw the time stats of the result, I was astounded:

	#PHP:
	Concurrency Level:      200
	Time taken for tests:   574.796 seconds
	Complete requests:      2000

	#node.js:
	Concurrency Level:      200
	Time taken for tests:   41.887 seconds
	Complete requests:      2000

The truth is out. node.js was faster than PHP by more 14 times! These results are astonishing. It simply means that node.js IS going to be THE de-facto standard for writing performance driven apps in the upcoming future, there is no doubt about it!

Agreed that the [nodejs](http://nodejs.org) ecosystem isn't that widely developed yet, and most node modules for things like db connectivity, network access, utilities, etc. are actively being developed. But still, after seeing these results, its a no-brainer. Any extra effort spent in developing node.js apps is more than worth it. PHP might be still having the "king of web" status, but with node.js in the town, I don't see that status staying for very long!

Update
------

After reading some comments from the below section, I felt obliged to create a C\#/mono version too. This, unfortunately, has turned out to be the slowest of the bunch (\~40 secs for 1 request). Either the Task library in mono is terribly implemented, or there is something terribly wrong with my [code](http://pastebin.mozilla.org/5406784). I'll fix it once I get some time and be back with my next post (maybe ASP.NET vs node.js vs PHP!).

Second Update
-------------

As for C\#/ASP.NET, this is the most optimum version that I could manage. It still lags behind both PHP and node.js and most of the issued requests just get dropped. (And yes, I've tested it on both Linux/Mono and Windows-Server-2012/IIS environments). Maybe ASP.NET is inherently slower, so I'll have to change the terms of this benchmark to take it into comparison:

	public class Handler : System.Web.IHttpHandler
	{
		private StringBuilder payload = null;

		private async void processAsync()
		{
			var r = new Random ();

			//generate a random string of 108kb
			payload=new StringBuilder();
			for (var i = 0; i &lt; 54000; i++)
				payload.Append( (char)(r.Next(65,90)));

			//create a unique file
			var fname = "";
			do{fname = @"c:\source\csharp\asyncdemo\" + r.Next (1, 99999999).ToString () + ".txt";
			} while(File.Exists(fname));            

			//write the string to disk in async manner
			using(FileStream fs = File.Open(fname,FileMode.CreateNew,FileAccess.ReadWrite))
			{
				var bytes=(new System.Text.ASCIIEncoding ()).GetBytes (payload.ToString());
				await fs.WriteAsync (bytes,0,bytes.Length);
				fs.Close ();
			}

			//read the string back from disk in async manner
			payload = new StringBuilder ();
			StreamReader sr = new StreamReader (fname);
			payload.Append(await sr.ReadToEndAsync ());
			sr.Close ();
			//File.Delete (fname); //remove the file
		}

		public void ProcessRequest (HttpContext context)
		{
			Task task = new Task(processAsync);
			task.Start ();
			task.Wait ();

			//write the string back on the response stream
			context.Response.ContentType = "text/plain";
			context.Response.Write (payload.ToString());
		}

		public bool IsReusable 
		{
			get {
				return false;
			}
		}
	}

*References:*

1. <https://en.wikipedia.org/wiki/Node.js>
2. <http://notes.ericjiang.com/posts/751>
3. <http://nodejs.org>
4. <https://code.google.com/p/node-js-vs-apache-php-benchmark/wiki/Tests>