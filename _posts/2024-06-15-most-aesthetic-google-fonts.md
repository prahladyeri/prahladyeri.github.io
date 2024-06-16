---
layout: post
title: "Seven most aesthetically pleasing fonts for your Web Apps"
tags: webdev php bootstrap
published: true
image: /uploads/grocery-cart.jpg
---

Without Google Fonts, our typography would be in limbo! Now, I'm neither a web designer nor have an eye for the pixel perfect and aesthetic design which a pro designer usually does. Instead, my usual workflow is to cobble together web components like bootstrap, jquery, codeigniter, etc. and try to build something useful out of it.

<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Rubik|Inter|Mulish|Roboto|Libre+Baskerville|Open+Sans|Lato">

<style>
.Rubik {	font-family: Rubik; }
.Inter {	font-family: Inter; }
.Mulish {	font-family: Mulish; }
.Roboto { 	font-family: Roboto; }
.Lato { 	font-family: Lato; }
.OpenSans { 	font-family: "Open Sans"; }
.LibreBaskerville { font-family: "Libre Baskerville"; }
</style>

As for fonts, I happen to use the open source Google Fonts of which there are a zillion varieties. But what I've found over the years is that a few of them outshine the rest when it comes to actual web and mobile applications (as opposed to other kind of websites such as static sites and blogs).

<p class='Rubik'><b>Rubik</b> is one of my favorite fonts when it comes to app development. The combination of Rubik font and a comprehensive CSS framework like Bootstrap is quite powerful and formidable. You'll see many professional open source apps using this font in the wild. The popular software ERPNext used it extensively until very recently, only now they've switched to Inter.</p>

<p class='Inter'><b>Inter</b> is yet another aesthetically pleasing font, especially for web applications. Its <a href='https://fonts.google.com/specimen/Inter'>fonts page</a> says, <i>"Inter is a variable font family carefully crafted & designed for computer screens."</i> I've largely found this font quite readable on app screens.</p>

<p class='Mulish'><b>Mulish</b> is the Google's open source equivalent of Adobe's original Muli font. It looks quite elegant and aesthetic on web apps. I've used the Mulish font in my open source side project called <a href="https://github.com/prahladyeri/comment-monk">Comment Monk</a>, a self-hosted comments CMS for static blogs.</p>

![cm-dashboard](/uploads/cm/cm-dashboard.png)

<p class='Roboto'><b>Roboto</b> is the most downloaded font on the internet. According to its <a href='https://fonts.google.com/specimen/Roboto'>fonts page</a>, <i>"Roboto has a dual nature. It has a mechanical skeleton and the forms are largely geometric. At the same time, the font features friendly and open curves."</i>.</p>

<p class='OpenSans'><b>Open Sans</b> is often touted as the <i>open source humanist sans-serif typeface</i>. Designed by Steve Matteson under commission from Google and published in 2011, Open Sans is a successor to the other popular font called Droid Sans which was specifically crafted for android mobile devices.</p>

<p class='Lato'><b>Lato</b> is yet another humanist sans-serif typeface designed by Łukasz Dziedzic. Published in 2010, the name Lato is Polish translation for "summer" and indeed, one could almost feel that warmth in this font.</p>

<p class='LibreBaskerville'><b>Libre Baskerville</b> is yet another elegant web font. Based on the American Type Founder's Baskerville from 1941, Libre Baskerville is optimized for body text (approximately 16px) and looks beautiful on typical web apps as well.</p>

To include a font from Google Fonts in your app, just link to their stylesheet with the "family" querystring parameter set to whatever you want as I've done on this very page. If there are multiple, you can separate them using the filter character (\|).

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Rubik|Inter|Mulish|Roboto|Libre+Baskerville|Open+Sans|Lato">
```

```bash
@todo: Create a placeholder app on github.io using bootstrap components to test these fonts.
```