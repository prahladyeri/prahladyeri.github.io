---
layout: post
title: "How to host your own mail server using Google appengine"
tags: python google-app-engine how-to
---

Google has an outstanding habit of bringing the power of elites to the masses. Firstly, they took over the world of smartphones with android, and now the buzzword everywhere is Google Appengine.<!--more-->

Once you get the basics of GAE and start looking beyond your first [HelloWorld](/blog/2013/12/how-to-create-a-pythonic-app-in-google-app-engine/ "How to create a Python app in Google App Engine") application, you will start appreciating the sheer power it provides compared to other paid hosting providers. GAE provides you the ability to send mails from your app without paying a single penny. Only if your app starts exceeding the usage quotas, you will have to pay in order to continue using the services.

An application of the above is creating and hosting your own email server through your app. Below is a single python script which acts as an http mail server that can route your email requests. It also doubles up as a test server so you can test the hosted service by appending the "/test" subdirectory to the url. You may pass http POST requests to your app including fields like username, to, cc, subject etc. once you build this script and host your app in the google cloud.

	#main.py
	import webapp2
	import urllib2
	from google.appengine.api import users,mail

	class TestPage(webapp2.RequestHandler):
		def get(self):
			body = """
			&lt;form method="post" action="http://your-app-id.appspot.com">
			Full Name: &lt;input name="fullname" />&lt;br />
			user: &lt;input name="username" />&lt;br />
			to: &lt;input name="to" />&lt;br />
			cc: &lt;input name="cc" />&lt;br />
			bcc: &lt;input name="bcc" />&lt;br />
			subject: &lt;input name="subject" />&lt;br />
			body: &lt;textarea name="body">&lt;/textarea>&lt;br />
			&lt;input type="submit" />
			&lt;/form>
			"""
			self.response.write(body)

	class MainPage(webapp2.RequestHandler):
		def post(self):
			#TODO: check if password is correct.

			#From will actually be a placeholder, since only your own appspotmail addresses would be allowed.
			tfullname = self.request.get('fullname')
			tusername = self.request.get('username')
			tto = self.request.get('to')
			tcc = self.request.get('cc')
			tbcc = self.request.get('bcc')
			tsubject = self.request.get('subject')
			tbody = self.request.get('body')
			tattachment = self.request.get('attachment')
			send_mail(fullname=tfullname,username=tusername,to=tto,subject=tsubject,body=tbody,cc=tcc,bcc=tbcc,attachment=tattachment)
			self.response.write("success")
			#self.response.write(tto)
			
		def get(self):
			#self.response.headers['Content-Type'] = 'text/plain'
			self.response.out.write("""your-app-id http mail service version 1.0.&lt;br />
			post vars:
			[password]
			[fullname]
			[username]
			[to]
			[cc]
			[bcc]
			[subject]
			[body]
			[attachment]
			
			&lt;br />
			&lt;br />
			
			&lt;a type="button" href="test">Click here for a demo&lt;/a>
			""")

	def send_mail(fullname,username,to,subject,body,cc=None,bcc=None,attachment=None):
		sender=fullname + " &lt;" + username + "@your-app-id.appspotmail.com>"
		message = mail.EmailMessage(sender=sender)
		message.to = to
		if cc!=None and cc!='':
			message.cc=cc
		if bcc!=None and bcc!='':
			message.bcc = bcc
		message.subject = subject
		message.body = body
		message.send()

	application = webapp2.WSGIApplication([
										   ('/', MainPage),
										   ('/test', TestPage)
										   ], debug=True)

So now, you may bid farewell to third party mail services like mail-chimp and others - since you have your own mail server.
