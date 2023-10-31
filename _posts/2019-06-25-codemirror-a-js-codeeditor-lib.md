---
layout: post
title: "CodeMirror - A simple and efficient code editor component for your web applications"
tags: internet open-source editor javascript
---

I'm a huge fan of simple things in life, things that achieve a lot with minimal efforts or configuration from the user's end. And whenever I come across such simple things, I like to share it with everyone and that's what I'm doing now.

In my recent flask based web project, one requirement was to provide a code editor in the app itself. The web app has a main system and a subsystem, and the user wanted the subsystem part to be dynamically scripted so that she can change that part of the code later and customize it herself. The web-based editor looks something like this (except that it contains the actual code instead of this Hello World placeholder):

![CodeMirror Demo](/uploads/CodeMirror_demo.png)

This was possible due to [CodeMirror](https://codemirror.net/) which is an open source javascript library, they have a [github repository](https://github.com/codemirror/CodeMirror/) too. You don't even have to download this library, its available on CDNJS, so you can simply link the stylesheet and two scripts in your html `head` tag like this:

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.47.0/codemirror.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.47.0/codemirror.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.47.0/mode/python/python.min.js"></script>
```

The first two resources are necessities (`codemirror.min.js` and `codemirror.min.css`), whereas the last one for mode (`python.min.js`) depends on which language or mode you want the editor for. In my case, it was python but there are dozens of modes available for different languages like java, php, ruby, html, css, etc.

The best thing about using this component is getting started itself! All you have to do is create a html `textarea` (which I already had as a dumb code editor!) and you are good to go:

```javascript
$(document).ready(function(){
	console.log('adding codeMirror object');
	window.myCodeMirror = CodeMirror.fromTextArea(document.getElementById("txtScript"), {
	   lineNumbers: true,
		mode: 'python',
	});
	window.myCodeMirror.on('change', editor => {
		//console.log(editor.getValue());	
	});
	window.myCodeMirror.on('keydown', editor => {
		//do whatever you want
	});
});
```
	
The `CodeMirror.fromTextArea()` is the important method which directly converts your `textarea` to a code editor, so simple and so effective! But note that after that, it totally makes your `textarea` element vanish (`display: none`) and you'll have to use the CodeMirror object variable (`window.myCodeMirror` in this example) to read or write text to it:

```javascript
var code = window.myCodeMirror.getValue(); //get value from editor
window.myCodeMirror.setValue(code); //set value to editor
```

This component also has tons of [configuration options](https://codemirror.net/doc/manual.html#config) like tabSize, theme, direction (ltr/rtl), lineNumbers, etc. I hope this editor component will help you if you ever come across a web project that requires it.

Happy coding, code and prosper!