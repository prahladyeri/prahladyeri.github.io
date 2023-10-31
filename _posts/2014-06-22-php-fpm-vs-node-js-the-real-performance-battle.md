---
layout: post
title: 'PHP-FPM vs node.js - The REAL Performance Battle'
tags: php javascript node
---

Even after my last [article](/blog/2014/06/php-vs-node-js-real-statistics.html) about PHP and node.js benchmarking, my search for the holy grail of performance truth still continues. However, I do understand now that pitting PHP running on apache against a stand-alone node was a bit unfair with PHP for it was limited by what the apache configuration could handle.<!--more-->

[![Benchmark](/uploads/old/benchmark.png){.alignnone .size-full .wp-image-3082 width="1021" height="622"}](/uploads/old/benchmark.png)

No, this time I went with nginx, a light and performance oriented server that was specifically designed to solve the [C10K](https://en.wikipedia.org/wiki/C10k) problem from the ground-up. And who better than [PHP-FPM](http://php-fpm.org/), the enhanced Fastcgi process manager that implements asynchronous features (at least in theory) to take on [node.js](http://nodejs.org/). node.js is the one server that implements all its features primarily using callbacks in javascript, and thus drastically improvising performance by leveraging the benefits of [functional programming](https://en.wikipedia.org/wiki/Functional_programming) (again, in theory).

I used the same code I had used earlier but did a small improvement to it so that the random filenames generated for performing I/O are unique:

	<?php 
	//asyncdemo.php
	$s=""; //generate a random string of 108KB and a random filename
	$filename="";
	//generate a random filename
	do {
		$fname = rand(1,99999).'.txt';
	} while(file_exists($fname));

	//generate a random string of 108kb
	for($i=0;$i<108000;$i++)
	{
		$n=rand(0,57)+65;
		$s.=chr($n);
	}

	//write the string to disk
	file_put_contents($fname,$s);

	//read the string back from disk
	$result = file_get_contents($fname);

	//write the string back on the response stream
	echo $result;

And here is the Javascript version:

	//server.js
	var http = require('http');    
	var server = http.createServer(handler);
	var fs = require('fs');

	function handler(request, response) {
		response.writeHead(200, {'Content-Type': 'text/plain'});

		//generate a random filename
		do{fname = (1 + Math.floor(Math.random()*99999999))+'.txt';
		} while(fs.existsSync(fname));

		//generate a random string of 108kb
		var payload="";
		for(i=0;i&lt;108000;i++)
		{
			n=Math.floor(65 + (Math.random()*(122-65)) );
			payload+=String.fromCharCode(n);
		}

		//write the string to disk in async manner
		fs.writeFile(fname, payload, function(err) {
				if (err) console.log(err);

				//read the string back from disk in async manner
				fs.readFile(fname, function (err, data) {
					if (err) console.log(err);
					response.end(data); //write the string back on the response stream
				});  
			}
		);
	}

	server.listen(8080);
	console.log('Running on localhost:8080');

So, what happens when we run a piece of web application code performing async I/O for two thousand times (with two hundred concurrent) using a tool like apache-bench? Who is faster - PHP-FPM or node.js? Here is the answer.

So, moral of the story is that even the latest and greatest of PHP world falls behind node.js (though by a much smaller margin than before). Now, I do understand that PHP's market is very large, and with so many opensource CMSes like wordpress, mediawiki and drupal already powered by PHP, it is quite difficult to shake PHP's market share in the near future.

On the other hand, with the performance advantage that node.js offers, its a very lucrative option for startups small businesses that don't have the funding to develop high-end enterprise apps in say, Java or SAP. More importantly, if tommorrow I were to given a task of developing a performance-driven app, is there one reason why I should not write it in node.js and go for PHP-FPM instead? Some food for thought. Comments are Welcome!

	Summarized results:
	PHP-FPM: 64.447 secondsnode.js: 42.441 seconds

	The Machine:
	Intel Pentium Dual-Core 2.30GHz running Linux 3.2.0

	The Configurations:
	PHP-FPM: PHP 5.4.23 (fpm-fcgi) (built: Jun 22 2014 14:51:15
	NODE: node v0.10.28

	Detailed Results:
	--PHP-FPM-----
	ab -c 200 -n 2000 http://localhost:8080/asyncdemo/asyncdemo.php

	Concurrency Level:      200
	Time taken for tests:   64.447 seconds
	Complete requests:      2000
	Failed requests:        6
	   (Connect: 0, Receive: 0, Length: 6, Exceptions: 0)
	Write errors:           0
	Non-2xx responses:      6
	Total transferred:      215649378 bytes
	HTML transferred:       215355222 bytes
	Requests per second:    31.03 [#/sec] (mean)
	Time per request:       6444.742 [ms] (mean)
	Time per request:       32.224 [ms] (mean, across all concurrent requests)
	Transfer rate:          3267.70 [Kbytes/sec] receive


	--NODE-----
	ab -c 200 -n 2000 http://localhost:8080/

	Concurrency Level:      200
	Time taken for tests:   42.441 seconds
	Complete requests:      2000
	Failed requests:        1
	   (Connect: 0, Receive: 0, Length: 1, Exceptions: 0)
	Write errors:           0
	Total transferred:      216155440 bytes
	HTML transferred:       215953440 bytes
	Requests per second:    47.12 [#/sec] (mean)
	Time per request:       4244.115 [ms] (mean)
	Time per request:       21.221 [ms] (mean, across all concurrent requests)
	Transfer rate:          4973.69 [Kbytes/sec] received