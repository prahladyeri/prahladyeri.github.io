---
layout: post
title: Backbone.Events+Promises+async/await is a great combination for building javascript apps
tags: backbone javascript
---

At the risk of being a contrarian, I'd like to show in this article how exactly can the Backbone's Events model be combined with the more modern constructs of Promises and async/await to build a killer app using JavaScript.<!--more-->

First, let's try to understand why do we need these constructs for asynchronous programming when JavaScript itself is a mostly asynchronous language featuring events and function callbacks. The [Promise API](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) was introduced in ES6 standard as a way of preventing callback hell:

    function someFunction(function anotherFunction(data){
      function yetAnotherFunction() {
        function reallyCoreFunction() {
          //readability sucks now!
        }
      }
    });

This is only three layers of callbacks, imagine what will happen when there are a hundred of them which is quite possible in a medium sized web app with multiple ajax calls and a dynamic interface. To solve this problem, functions started returning a "Promise" object instead of a callback function, so instead of multiple layers of callbacks, we can now use "function chaining" using the **then** keyword like this:

    someFunction()
    .then(function(){
      yetAnotherFunction();
    })
    .then(function(){
      reallyCoreFunction();
    })
    //readability is better now!

As you can see, the Promise API has improved the readability to a considerable extent. Instead of a callback mechanism, the callee returns an object called **Promise** which can be chained for further execution. For this to happen, the callee has to call resolve() in order for the caller to end the wait and trigger further execution in the next chain:

![Promise Model](/uploads/2018/07/promise_model.png){.size-full .wp-image-921 width="755" height="222"} 

**Promise Model**

But the async/await construct goes even further than this. You don't even need to do function chaining using **then**, but the **await** keyword itself is enough to do this. Internally, the async/await model uses the Promise API to achieve its end because even in this model, the callee has to make the resolve() call in order to return execution control to the caller and the process continues after the next await statement:

![async await Model](/uploads/2018/07/async_await_model.png){.size-full .wp-image-922 width="755" height="222"}

**async await Model**

However, one disadvantage of async/await is that the caller can only wait, it cannot receive a returned value which is possible in the Promise model. Another disadvantage is that the caller function itself who invoked the await statement needs to be declared as async which means it cannot be a part of a sequential statements in another process, but has to work independently as shown [in this example](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function#Examples):

	var sequentialStart = async function() {
	  console.log('==SEQUENTIAL START==');
	  const slow = await resolveAfter2Seconds(); // If the value of the expression following the await operator is not a Promise, it's converted to a resolved Promise.
	  const fast = await resolveAfter1Second();
	  console.log(slow);
	  console.log(fast);
	}

Finally, the most important thing here is to realize that both Promises and async/await are just one level of asynchrony, let's call this detail asynchrony or **micro asynchrony**, but there is also the other kind that works at the broader level which can be termed **macro asynchrony**, and this is where Backbone.Events comes into the picture.

Consider that you have a complex web application with several views and each component should be able to trigger a message or event to any other component asynchronously in order for the app to render and function properly. Consider an app with a **loginView** that needs to trigger an alert that a user has just signed in. Now, keeping the separation of concerns, the best practice here would be that the loginView shouldn't try to render that part of the DOM and leave it to the other component: **navbarView**. Now, how can our loginView be able to "tell" the navbarView asynchronously over the wire to display that alert? Both Promises and async/await are of no use here, and hence we need a macro-level all-purpose **Event Bus**, similar to the one that Backbone.js provides us:

![backbone.events Model](/uploads/2018/07/backbone.events_model.png){.size-full .wp-image-920 width="757" height="278"}

**backbone.events Model**

In this case, our caller and callee are inside separate components and don't even know each other. And separation of concerns imply that they cannot even contact each other directly. Now, Backbone provides this useful trigger/listen mechanism called **Backbone.Events** using which any object in your app can listen to the events triggered on any other object! In this case, the loginView triggers an event called "navbarView.alert" and thus "tells" the navbarView that it has to do something (in this case show an alert). This mechanism also supports passing of any kind of data along with the triggering of event (in this case the *message* parameter).

Thus, we can see that combining the power of all these asynchronous models, we can easily handle any level of complexity in our app, provided that our [app itself is structured in the right way from the start](https://prahladyeri.github.io/blog/2018/07/the-right-way-to-architect-single-page-web-applications.html).
