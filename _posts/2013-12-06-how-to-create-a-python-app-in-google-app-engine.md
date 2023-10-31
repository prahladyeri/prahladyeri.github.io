---
layout: post
title: "How to create a Python app in Google App Engine"
tags: google-app-engine how-to python
---

Whilst the [official pythonic reference](https://developers.google.com/appengine/docs/python) for Google app engine is the way I learnt how to build my first GAE app, I found it a bit frustrating to go through [each](https://developers.google.com/appengine/docs/python/#Python_Selecting_the_Python_runtime) and [every](https://developers.google.com/appengine/docs/python/#Python_The_environment) link and understand large topics like caching and data stores in detail just to build a small hello world pythonic app in Google App Engine. What I wanted was a quick and dirty tutorial that let me build a small app first, and then let me improvise upon the areas that I needed to dig deeper.<!--more-->

[![How to Create a Pythonic app in Google App Engine](/uploads/old/gae_python.png){.alignnone .wp-image-301 width="150" height="150"}](/uploads/old/gae_python.png)

I couldn't find such a tutorial anywhere, so I'm writing this one.

1.  **Setup your Environment:** Download and install [python 2.7](http://www.python.org/getit/releases/2.7/) for your platform, if you haven't done so already (as of this writing, only 2.5 and 2.7 versions are supported) . Then, download and install the GAE API from [here](https://developers.google.com/appengine/downloads#Google_App_Engine_SDK_for_Python). MSI setups are available for windows platform. For linux, you can just unzip into a local folder like '\~/programs/'. The zip file will create a subdir called 'google\_appengine'. Practically, the only two python scripts you are ever going to need to develop a GAE app are:

	- `dev\_appserver.py`
	- `appcfg.py`

2.  **Register your app on appspot.com:** The next step is to register your subdomain on GAE by visiting [https://appengine.google.com](https://appengine.google.com/). Once you register your app there, you will get a subdomain called **http://*your-app-id*.appspot.com**. There are also options for redirecting your custom domain such as **www.mydomain.com** to your app subdomain.
3.  **Create your app on the local machine:** This is as simple as creating a folder on your machine such as \~/source/foo in linux or C:\\source\\foo in windows. Then just create a text file named app.yaml  with below contents inside this folder:

		application: your-app-id
		version: 1
		runtime: python27
		api_version: 1
		threadsafe: true
		
		handlers:
		- url: /.*
		  script: helloworld.application

Note that **your-app-id** is the name that you just registered for yourself, make sure that it is typed correctly. version parameter refers to the version of your app, while api\_version is the version of GAE SDK used to run this app. The line "script: helloworld.application" indicates that this wsgi handler will be invoked for your app.

4.  **Create the wsgi handler:** This is as simple as creating a python file named "helloworld.py" in the same folder as above, and add below contents to it:

		import webapp2

		class MainPage(webapp2.RequestHandler):

		    def get(self):
		        self.response.headers['Content-Type'] = 'text/plain'
		        self.response.write('Hello, World!')

		application = webapp2.WSGIApplication([
		    ('/', MainPage),
		], debug=True)

5.  **Test your app: **To test your app, open up your terminal and change directory to your GAE installation folder (alternatively, add the GAE installation folder to your PATH/\$PATH environment variable to avoid doing this each time), and then type the below command:

		python dev_appserver.py ~/source/foo
		#OR on windows:
		python dev_appserver.py C:\source\foo

6.  **Deploy your app:** Want to host this app on GAE and check it out? Just fire up your terminal as described above and issue this command:

		python appcfg.py update ~/source/foo
		#OR on windows:
		python appcfg.py update C:\source\foo

7.  **Test your app:** The above command should host your app on your appspot subdomain (It will ask for your google username/password before doing so). Once the app is successfully hosted, you can check it out by visiting http://your-app-id.appspot.com.
8.  **Furthur reading:** Now that you have a working app, you can actually visit the official reference to read more about:
    1.  [webapp2](https://developers.google.com/appengine/docs/python/gettingstartedpython27/handlingforms): The pythonic web framework used to handle requests and generate responses.
    2.  [Datastore](https://developers.google.com/appengine/docs/python/#Python_The_Datastore_and_services): The big data storage feature that GAE provides your app to store its data.
    3.  [Quotas and Limits](https://developers.google.com/appengine/docs/python/#Python_Quotas_and_limits): Learn about the various limits that google sets for your app to access resources (Don't worry, they are enough to suffice a small to medium scale app).
    4.  [App caching](https://developers.google.com/appengine/docs/python/#Python_App_caching): Learn how to take advantage of various caching mechanisms in GAE to speed up your app.
