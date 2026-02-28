---
layout: post
title: "Readymade template engine using the function constructor trick in JavaScript"
tags: javascript
published: false
image: /uploads/code.jpg
---
One of my favorite features in JavaScript is the backtick string interpolation technique:

```javascript
let name = "Prahlad";
let greeting = `Hello, ${name}`;
```

The backtick string can be extraordinarily long and quite versatile, folks often use it like a mini-template engine. And what's more, it's built right into the core JS language and you get all the goodies without installing an extra package like handlebars or mustache or ejs.

But what will you do if it's not a literal string constant but something dynamically retrieved html file like this one:

```html
<ul>
	<li>User: Prahlad</li>
	<li>Role: Engineer</li>
</ul>
```

There are many ways to handle this but my favorite is what is called the `function constructor trick`.

```html
<!-- part.html -->
<ul>
	<li>User: ${this.name}</li>
	<li>Role: ${this.role}</li>
</ul>
```

```javascript
/**
 * Simple Template Compiler
 * @param {string} templateString - The raw HTML with ${this.prop} placeholders
 * @returns {Function} - A function that accepts a data object
 */
const createTemplate = (templateString) => {
  // 1. Escape backticks in the source to prevent breaking the wrapper
  const sanitized = templateString.replace(/`/g, '\\`');
  
  // 2. Return a function that uses .call() to bind "this" to the data
  return new Function("data", `return (function() { 
    return \`${sanitized}\`; 
  }).call(data);`);
};

// Usage with Async/Await
async function renderUserCard() {
  try {
    const response = await fetch('/parts/part.html');
    const html = await response.text();
    
    const template = createTemplate(html);
    const userData = { name: "Prahlad", role: "Engineer" };
    
    const finalOutput = template(userData);
    console.log(finalOutput);
  } catch (err) {
    console.error("Failed to load or compile template:", err);
  }
}
```
The only thing you want to ensure is that the source is good (`/parts/part.html` in this case). But otherwise, it's a highly utilitarian and mind blowing technique which will enhance your JavaScript productivity by leaps and bounds.

### Comparison Table

| Feature | Function Constructor Trick | Dedicated Engine (EJS/Mustache) |
| --- | --- | --- |
| **Footprint** | 0kb (Native JS) | 10kb - 50kb+ |
| **Logic** | Full JS Power | Often restricted (Logic-less) |
| **Security** | High Risk (Same as `eval`) | Higher (Built-in escaping/sanitization) |
| **Speed** | Extremely fast | Slightly slower due to parsing |


⚠️ A Note on Security: Because this technique executes strings as code, only use it with templates you control (like your own server-side components). Never use this to render untrusted user input, as it could open the door to XSS attacks.