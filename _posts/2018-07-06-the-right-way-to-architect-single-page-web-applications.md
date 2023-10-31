---
layout: post
title: The right way to architect single page web applications
tags: javascript html web-development
---

Lets face it, Web Apps are a complex and complicated beast, both on the front end and back end. The reason we had to come up with so many frameworks and libraries (angular/backbone/react/vue/marionette/require.js/etc.) is that the whole process is quite difficult and convoluted.<!--more-->

Once your app starts to scale in complexity, even the best of ideas and best practices in this field cannot prevent your app code from becoming a spaghetti of JavaScript and jQuery callbacks and DOM manipulation functions. Turning into a mess is essentially the nature of JavaScript when left to its own mechanism (event callback model and high asynchrony do ensure that). If you only use jQuery to architect your app, this is what it'll soon end up becoming:

![The Spaghetti Way](/uploads/2018/07/spaghetti-way.png){.size-full .wp-image-816 width="956" height="254"}

**The Spaghetti Way**

Once your app.js ends up with millions of these jQuery functions, it will soon become beyond understanding and sanity even for you as the author of the code. And that's exactly why we need to understand this complexity and architect some structure and foundation in our apps.

One way of handling this complexity is the easy way - just delegate this whole thing to another complex beast of an opinionated framework such as angular or vue, and work with simple abstractions like angular views and controllers. This strategy does work to an extent (and you do get some mental sense of achievement too) but only as long as your app is limited in functionality and doesn't scale in size and complexity. The problem with opinionated frameworks is that they are opinionated - they work only as long as your app is pigeonholed and fits in their own way of typically doing things, but the moment you step outside and want to do something that doesn't confirm to that way (like rendering a complex DOM element or work with a difficult third-party UI library), then you are hit with a wall - unless you are prepared to venture too deeply into that framework and learn advanced stuff (like creating complex directives or providers in angular). But if you had to resort to that at the end, then why use an opinionated framework at all!

![The Opinionated Framework Way](/uploads/2018/07/opinionated-way.png){.size-full .wp-image-818 width="1089" height="400"}

**The Opinionated Framework Way**

As you can see in above diagram, using an opinionated framework is like driving a car with automatic gear system. You cannot control the speed or acceleration, nor can you synchronize the clutch action, its the black box of the automatic gear that does it for you. But unlike this simple gearbox analogy where speed and clutch synchrony are the only two variables, your web app has lots of variables, so the chances of going wrong and getting stuck with this approach drastically increases as your web app starts to scale in complexity. Manually doing things using the Backbone way may appear to be difficult or complex initially, but that's a much better way than trading off that complexity for an opinionated black-box framework about who's inner workings you don't understand anything at all.

The first step towards building a single page app should be deciding what your app is going to do and how its going to do it. Every app is different in features, functionality and work flow, hence it pays to use an uber-light framework such as Backbone instead of any heavy and opinionated ones. Backbone in the frameworks world is pretty much like what jQuery is in the libraries world, it doesn't do much on its own besides giving you methods and objects for creating a layer of structure and organization (just as jQuery doesn't do much on its own besides adding a sugar-syntax wrapper for native DOM manipulation functions of JavaScript).

Now, because of this exact flexibility and freedom, there is no one correct way to build Backbone apps. Backbone is heavy in philosophy and light in implementation, and the philosophy being simple:

1.  Separation of concerns (models, views and other components should be kept separate).
2.  Separation of roles (Organizers and implementors should do their own thing, one shouldn't step into the shoes of others).

Personally, I think that if you follow only these two principles sincerely and stick to them, then you can handle whatever amount complexity life throws at your app. Of course, to architect such an app is an art in itself and you may not get it right the first time. The architecture itself may even need to evolve with time and complexity as your app grows and scales. One global event coordinator (or organizer) can be enough initially, but later on, you may have to add a DOM coordinator for handling DOM events, a data coordinator for handling connections to the database objects, etc. as you scale.

Here is a basic example architecture that you can probably use for an app of low to medium complexity:

![The Backbone Way](/uploads/2018/07/backbone-way1.png){.size-full .wp-image-831 width="884" height="536"} 

**The Backbone Way**

And [this is an example implementation](https://github.com/prahladyeri/experimental-backbone) which I'm developing as a side project. Of course, the app doesn't do much presently besides user management and routing to dummy pages,

Of course, this isn't the only Backbone way to build apps, but I think its a good one for a start. The primary problem you'll face if you stick to doing things your own way and not use an opinionated framework is that of organization. You need an organizer/coordinator object to co-ordinate with various components of your app and keep them in sync with each other and this is where the Backbone.Events API provided by the framework shines. The Backbone.View object also plays a great part in ensuring the separation of DOM manipulation code from rest of your app, and along with the underscore template library, it becomes a power combination for rendering DOM! With underscore templates, you can actually use javascript functions and variables inside a template, not just clumsy tags like ng-something!

	<% if(modal['buttons']) { %>
	  <div class="ui-button-container">
		<% _(model['buttons']).each(function(button) { %>
		  <a class="ui-button ui-button-pill <%= button.extra_class %> " href="<%= button.href %>">
			<span class="label">
			  <span class="section"><%= button.label %></span> 
			</span>
		  </a>
		<% }) %>
	  </div>
	<% } %>

Of course, its not a very good practice to mix javascript with templates, but it just shows the power and flexibility of using backbone+underscore compared to other vendor frameworks.

Ultimately, it all comes down to your preference, you can use angular or vue or react if you really want to. However, always understand the reason why you are hooking to a third party framework. If it is just for escaping the complexity of your app, then no amount of framework or libraries in the world are going to help you. Passing on the complexity to a black box like angular or vue is just a band-aid solution that will fall apart the moment you scale in complexity and you'll get stuck by the limitations of the framework. At that point, you'll have to make one of these two decisions:

1\. Abandon the framework and do everything right from scratch using the manual way of Backbone.

2\. Understand the framework internals too deeply and customize it to achieve what you want (but then what was the point of using this framework in the first place?)

Ultimately, its your decision to choose a framework. Consider it wisely after weighing in all the pros and cons. Best of luck!
