---
layout: post
title: 'How to create a custom email plugin for Wordpress'
tags: php
---

Last week, I suddenly stopped receiving email notifications for my [openshift](https://www.openshift.com/) hosted blog. I came to know after some [reading](http://stackoverflow.com/questions/17583205/sendmail-on-openshift-php-codeigniter/17598537#17598537) that commonly used cloud hosts such as openshift, aws, etc. are usually blacklisted by most email servers, hence its not a good idea to use them to send mails.<!--more-->

In any case, why should I depend on my hosting provider for email sending. Until now, I had never bothered about how mail sending worked in wordpress as it used to work out of the box. So last week, I pulled up my socks and decided to put my php [IDE](http://en.wikipedia.org/wiki/Geany) and [debugger](http://en.wikipedia.org/wiki/Xdebug) to some good work.

I decided to use my [sendgrid](https://sendgrid.com) account to send mails. All that\`s needed now is calling the web service with the credentials they've provided. But how to integrate this with my wordpress blog?

Once I located ***where*** the mail sending functionality is there in wordpress code, adding a new method was a piece of cake!! Turns out that wordpress, by default, just executes the "mail" command which is usually just a symlink on unix boxes actually pointing to */usr/bin/sendmail* or something. I found it in a pluggable function *wp\_mail()*. (see */wp-includes/pluggable.php*). I also came to know from the codex that [pluggable functions](http://codex.wordpress.org/Pluggable_Functions) can be easily overridden by plugins.

Now all I had to do was write a small plugin in the /wp-content/plugins/sendgrid/ folder and override this wp\_mail() function with whatever I want.

Lo and behold! I started receiving notifications for all comments and contact forms filled, by just writing this one plugin. I found the process so simple and easy to integrate with wordpress that I couldn't help sharing with you. Here are the two php snippets that you need to place in /wp-content/plugins/*your-plugin-name*/ and activate it. *Wordpress* will do the rest!

(First one is the main plugin php file that displays the plugin in your admin menu and overrides the wp\_mail function. The second php file contains the actual custom function that sends email via sendgrid.)

*wp-content/plugins/sendgrid/myplugin.php:*

	<?php /**
	 * Plugin Name: Sendgrid Plugin
	 * Plugin URI:  http://prahladyeri.github.io
	 * Description: Mail sending using Sendgrid Web API
	 * Version:     0.1
	 * Author:      Prahlad Yeri
	 * Author URI:  http://prahladyeri.github.io
	 * License:     MIT
	 */

	//namespace MailDemo;
	require_once('sendgrid.php');

	add_action( 'init', 'plugin_init' );

	/**
	 * Plugin Name: Prahlad's mail
	 * Description: Alternative way to send a mail
	 */
	if (!function_exists('wp_mail')) 
	{
		function wp_mail($to, $subject, $message, $headers = '', $attachments = array())
		{
			$sto = '';
			if (is_array($to))
			{
				$sto = implode(',',$to);
			} else {
				$sto = $to;
			}
			sendgridmail('wpadmin@mywebsite.com', $sto, $subject, $message, $headers);
		}
	}

	function plugin_init()
	{
	}

*wp-content/plugins/sendgrid/sendgrid.php:*

	<?php //wp-content/plugins/sendgrid/sendgrid.php
	function sendgridmail($from, $to, $subject, $message, $headers) {        
	$url = 'https://api.sendgrid.com/';
	$user='your-sendgrid-username';   
	$pass='your-sendgrid-password';       
		
	$params = array(       
	'api_user'  ?> $user,
			'api_key'   => $pass,
			'to'        => $to,
			'subject'   => $subject,
			'html'      => '',
			'text'      => $message,
			'from'      => $from,
		  );


		$request =  $url.'api/mail.send.json';

		// Generate curl request
		$session = curl_init($request);
		// Tell curl to use HTTP POST
		curl_setopt ($session, CURLOPT_POST, true);
		// Tell curl that this is the body of the POST
		curl_setopt ($session, CURLOPT_POSTFIELDS, $params);
		// Tell curl not to return headers, but do return the response
		curl_setopt($session, CURLOPT_HEADER, false);
		curl_setopt($session, CURLOPT_RETURNTRANSFER, true);

		print_r('obtaining the response');
		// obtain response
		$response = curl_exec($session);
		print_r('closing curl session');
		curl_close($session);
		
		// print everything out
		//print_r($response);
	}

	//only for testing:
	/*$to      = 'prahladyeri@yahoo.com';
	$subject = 'Testemail';
	$message = 'It works!!';
	echo 'To is: ' + $to;
	#wp_mail($to, $subject, $message, array() );
	sendgridmail($to, $subject, $message, array());
	print_r('Just sent!');*/

*References:*

1. <http://codex.wordpress.org/Pluggable_Functions>
2. <http://stackoverflow.com/q/17583205/849365#17598537>
3. <http://codex.wordpress.org/Pluggable_Functions>
4. <http://en.wikipedia.org/wiki/Geany>
5. <http://en.wikipedia.org/wiki/Xdebug>
6. <https://sendgrid.com>
7. <https://sendgrid.com/docs/>
8. <https://www.openshift.com/>
