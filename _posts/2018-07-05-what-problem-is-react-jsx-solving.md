---
layout: post
title: 'What problem is React/JSX solving in your App?'
tags: backbone javascript react web-development
---

Framework wars and debates are very much a thing these days, be it Angular vs Backbone or Angular vs React, but the real debate isn't about these frameworks. The real debate essentially comes down to which is the most efficient way of structuring your app and more importantly, rendering and managing your DOM.<!--more-->

Whilst the traditional jQuery/Backbone way is to render the DOM directly using methods like \$(component).html("DOM Code"), React considers it an anti-pattern and recommends the way of virtual DOM - a concept where you don't render the DOM directly as it is, but keep a virtual copy of it and render only the differential which is essentially *patching* the DOM.

![JavaScript Frameworks](/uploads/2018/07/js-frameworks.jpeg)

One thing that comes to mind is that more than an improvement over the former approach, you are basically trading off CPU overhead for lesser memory usage. The former jQuery approach is more **memory intensive** as the browser needs to keep large amount of DOM structural code in memory until its rendered (yeah, it gets pretty large in a non-trivial app with lots of widgets that may need to be rendered in a complex array of patterns). However, what exactly are we gaining by using the JSX virtual DOM method? The JSX approach is just as much **CPU intensive** as the jQuery approach is RAM intensive because it takes just as many CPU cycles to compute the differential and come up with a "patch" version of the DOM. In fact, the trade-off may be even worse considering that React is more of a library overhead than jQuery which is just a light "write less do more" wrapper over JavaScript DOM manipulation functions.

The real question we should be asking ourselves is why do we keep looking for that holy-grail JavaScript framework every now and then? Yesterday it was angularjs, today its React and tomorrow it will be vue.js. Instead of running after the shiny new framework, why not sit down and see what you are doing wrong with the present tools you have. After all, these tools are industry proven and they still exist for a reason.

I think most of the issues with using jQuery come from incorrect usage patterns than any problems associated with actual rendering. Consider the following often used pattern for rendering view blocks:

    $.get("partials/navbarTemplate.html", function(data){
      $("#div-navbar").html(data); //render a template
      ..
    });

This coding pattern is typically abhorred by most React experts as they feel that rendering a whole bunch of html code (data argument in this case) is an anti pattern as the browser has to repeatedly render a lot of boiler-plate DOM unnecessarily. However, that's only true if you do this often times and repeatedly call this function. If you use a good architectural pattern for structuring your app (like the one provided by Backbone.js), you can render this same DOM in a very idempotent way:

    app.NavbarView = Backbone.View.extend({
        el: "#div-navbar",
        initialize: function() {
            var temp = this;
            $.get("partials/navbarTemplate.html", function(e){
                temp.template = _.template(e, {});
            });
        },
        render: function() {
            this.$el.html(this.template());
        },

    });

In above code, we are still using jQuery.get, but in a more organized and structured way. Firstly, we call jQuery.get only in the initialization of the view to get the template and store it in the cache, so the network overhead isn't involved each time we need to use a template. Furthermore, backbone itself caches and stores the block element to be rendered (this.\$el), so that we don't have to trouble the browser with other areas of the DOM where rendering isn't required. Finally, we just call the underscore template and render the element:

    this.$el.html(this.template());

Of course, this could be probably further optimized by using jQuery.empty().append() instead of jQuery.html() if you want to tweak the last drop of performance!

    this.$el.empty().html(this.template());

However, I don't think this kind of premature optimization is really needed unless you are building a really complex app and even then this isn't required in about 90% of the cases, the browsers have become considerably fast in recent years, at least in the area of DOM rendering.

And this is exactly why I think that using virtual DOM libraries like React is an anti-pattern. You are essentially stepping into the shoes of the browser, isn't it? If the kind of partial patching implemented by React is really efficient, wouldn't the browsers be doing it themselves? Maybe they will take some of the best ideas from React and JSX, and implement it themselves in the coming future, but why should *you* (as a programmer) be bothered with that is what I don't understand.

This whole debate about frameworks is pretty much centered on separation of concerns essentially (models, views and controllers/organizers should all be cleanly separated) and to some extent, React is going against that separation by doing what the browser is supposed to do.
