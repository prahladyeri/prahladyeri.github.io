---
layout: page
title: "A Crash Course in CSS Layouts & Styling"
order: 3
date: 2026-06-15
---

### From "I know HTML" to "I can design clean, modern websites"

{% assign words = page.content | number_of_words %}
**Prahlad Yeri** · June 15, 2026 · {% if words < 360 %}1 min{% else %}{{ words | divided_by: 180 }} min{% endif %} read

> **Note:** This article was written with AI assistance.

---

# 1. What Makes a Website Look Good?

Most beginners think beautiful websites come from:

* Fancy animations
* Complex JavaScript
* Thousands of lines of CSS

In reality, good design usually comes from:

1. Consistent spacing
2. Good typography
3. Visual hierarchy
4. Proper alignment
5. Simplicity
6. Mobile responsiveness

Consider these two examples:

### Bad

```html
<h1>My Blog</h1>
<p>Hello World</p>
<button>Read More</button>
```

Everything touches each other.

### Better

```html
<div class="hero">
    <h1>My Blog</h1>
    <p>Thoughts on technology and open source.</p>
    <button>Read More</button>
</div>
```

```css
.hero {
    padding: 60px;
}

.hero h1 {
    margin-bottom: 16px;
}

.hero p {
    margin-bottom: 24px;
}
```

The content is identical.

Only spacing changed.

Yet it feels professional.

---

# Design Principles Every Developer Should Know

## 1. Alignment

Things should line up.

Bad:

```text
Title
      Paragraph
 Button
```

Good:

```text
Title
Paragraph
Button
```

---

## 2. White Space

Do not fear empty space.

Apple, Stripe, Linear and Notion use huge amounts of whitespace.

Bad:

```css
padding: 5px;
```

Better:

```css
padding: 40px;
```

---

## 3. Contrast

Make important things stand out.

```css
h1 {
    font-size: 3rem;
}

p {
    color: #666;
}
```

---

## 4. Consistency

Pick a spacing system:

```text
4px
8px
16px
32px
64px
```

Use those everywhere.

---

# 2. The CSS Box Model

Everything in CSS is a box.

```text
+-------------------+
|      Margin       |
| +---------------+ |
| |   Border      | |
| | +-----------+ | |
| | | Padding   | | |
| | | Content   | | |
| | +-----------+ | |
| +---------------+ |
+-------------------+
```

Example:

```css
.card {
    margin: 20px;
    padding: 20px;
    border: 1px solid #ddd;
}
```

---

# Margin vs Padding

## Margin

Outside spacing.

```css
margin-bottom: 20px;
```

Creates distance between elements.

---

## Padding

Inside spacing.

```css
padding: 20px;
```

Creates distance between content and border.

---

# 3. Widths and Heights

Avoid fixed widths whenever possible.

Bad:

```css
width: 1200px;
```

Good:

```css
max-width: 1200px;
width: 100%;
```

Typical page container:

```css
.container {
    max-width: 1100px;
    margin: auto;
    padding: 20px;
}
```

The magic:

```css
margin: auto;
```

Centers the container.

---

# 4. Typography

Typography alone can make a website feel premium.

## Font Stack

```css
body {
    font-family:
        system-ui,
        sans-serif;
}
```

Uses the user's native font.

---

## Comfortable Reading

```css
body {
    line-height: 1.7;
}
```

Avoid:

```css
line-height: 1;
```

Looks cramped.

---

## Blog Content Width

```css
article {
    max-width: 700px;
}
```

Long lines are difficult to read.

---

# 5. Positioning

## Static (Default)

```css
position: static;
```

Normal flow.

---

## Relative

```css
position: relative;
left: 10px;
```

Moves relative to original position.

---

## Absolute

```css
position: absolute;
top: 0;
right: 0;
```

Placed relative to nearest positioned parent.

---

## Fixed

```css
position: fixed;
top: 0;
```

Stays visible while scrolling.

Useful for navbars.

---

## Sticky

```css
position: sticky;
top: 0;
```

Acts normal until scrolling reaches it.

Then sticks.

Great for sidebars.

---

# 6. Floats (Legacy Layout)

Before Flexbox and Grid, layouts used floats.

Example:

```html
<div class="sidebar">
Sidebar
</div>

<div class="content">
Content
</div>
```

```css
.sidebar {
    float: left;
    width: 25%;
}

.content {
    float: left;
    width: 75%;
}
```

Problems:

* Difficult to maintain
* Clearing issues
* Responsive headaches

Today floats are mainly used for:

```html
<img src="photo.jpg">
```

```css
img {
    float: left;
    margin-right: 20px;
}
```

Text wraps around image.

---

# 7. Flexbox (Modern Layout)

Flexbox changed everything.

Think:

```text
Row
Column
Centering
Navigation bars
Cards
Toolbars
```

---

## Horizontal Layout

```html
<div class="row">
    <div>A</div>
    <div>B</div>
    <div>C</div>
</div>
```

```css
.row {
    display: flex;
}
```

---

## Space Between

```css
.row {
    display: flex;
    justify-content: space-between;
}
```

Result:

```text
A           B           C
```

---

## Centering

```css
.hero {
    display: flex;
    justify-content: center;
    align-items: center;
}
```

Perfect centering.

---

## Gap

Instead of margins:

```css
.row {
    display: flex;
    gap: 20px;
}
```

Cleaner.

---

## Vertical Layout

```css
.column {
    display: flex;
    flex-direction: column;
}
```

---

# Blog Layout Using Flexbox

```html
<div class="layout">
    <aside>Sidebar</aside>
    <main>Content</main>
</div>
```

```css
.layout {
    display: flex;
    gap: 30px;
}

aside {
    width: 250px;
}

main {
    flex: 1;
}
```

---

# 8. CSS Grid

For 2D layouts.

Example:

```css
.grid {
    display: grid;
    grid-template-columns:
        1fr 1fr 1fr;
    gap: 20px;
}
```

Produces:

```text
A B C
D E F
```

---

## Responsive Cards

```css
.grid {
    display: grid;

    grid-template-columns:
        repeat(auto-fit, minmax(250px,1fr));

    gap: 20px;
}
```

Automatically adjusts.

---

# 9. Responsive Design

The web is mobile-first now.

---

## Viewport Tag

```html
<meta
    name="viewport"
    content="width=device-width, initial-scale=1">
```

Always include it.

---

## Responsive Images

```css
img {
    max-width: 100%;
}
```

---

## Media Queries

```css
@media (max-width: 768px) {

    .layout {
        flex-direction: column;
    }

}
```

Desktop:

```text
Sidebar | Content
```

Mobile:

```text
Sidebar
Content
```

---

# Mobile-First Design

Start small.

```css
.card {
    width: 100%;
}
```

Then enhance:

```css
@media (min-width: 768px) {

    .card {
        width: 50%;
    }

}
```

---

# 10. Color Theory for Developers

You don't need to be an artist.

Use:

### One Primary Color

```css
--primary: #2563eb;
```

### Neutral Grays

```css
--text: #222;
--muted: #666;
--border: #ddd;
```

### Background

```css
--bg: #fafafa;
```

---

# Popular Combinations

### GitHub

```css
#24292e
#ffffff
#0969da
```

---

### Notion

```css
#ffffff
#37352f
#eb5757
```

---

### Dark Theme

```css
#111827
#1f2937
#f9fafb
```

---

# 11. Tailwind CSS

Tailwind is a utility-first CSS framework.

Instead of writing:

```css
.card {
    padding: 20px;
    border-radius: 10px;
    background: white;
}
```

You write:

```html
<div
class="
p-5
rounded-lg
bg-white
">
```

---

## Traditional CSS

```html
<button class="btn">
Click
</button>
```

```css
.btn {
    background: blue;
    color: white;
    padding: 10px 20px;
}
```

---

## Tailwind

```html
<button
class="
bg-blue-600
text-white
px-4
py-2
rounded
">
Click
</button>
```

---

# Why Developers Love Tailwind

### Faster

No switching between files.

### Consistent

Spacing scale is predefined.

### Responsive

```html
<div
class="
w-full
md:w-1/2
">
```

---

### Easy Flexbox

```html
<div
class="
flex
justify-between
items-center
">
```

---

# Why Some Developers Dislike Tailwind

Large class lists:

```html
<div
class="
flex
justify-center
items-center
bg-white
rounded
shadow
p-4
">
```

Can become verbose.

---

# 12. Case Study: Elegant Jekyll Theme

Imagine building a blog theme.

Goal:

```text
Minimal
Fast
Readable
Timeless
```

---

## Layout

```html
<body>

<header>
Site Name
</header>

<div class="container">

    <main>
        Articles
    </main>

    <aside>
        About
    </aside>

</div>

<footer>
Copyright
</footer>

</body>
```

---

## Base Styling

```css
body {
    font-family: system-ui, sans-serif;
    line-height: 1.7;
    color: #222;
    background: #fafafa;
}
```

---

## Container

```css
.container {
    max-width: 1100px;
    margin: auto;
    padding: 20px;
}
```

---

## Header

```css
header {
    padding: 40px 20px;
    border-bottom: 1px solid #ddd;
}
```

---

## Two Column Layout

```css
.container {
    display: flex;
    gap: 40px;
}

main {
    flex: 1;
}

aside {
    width: 280px;
}
```

---

## Mobile

```css
@media (max-width: 768px) {

    .container {
        flex-direction: column;
    }

    aside {
        width: auto;
    }

}
```

---

## Article Typography

```css
article h1 {
    font-size: 2.5rem;
}

article h2 {
    margin-top: 2rem;
}

article p {
    margin-bottom: 1rem;
}
```

---

## Links

```css
a {
    color: #2563eb;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}
```

---

## Code Blocks

```css
pre {
    overflow-x: auto;
    padding: 20px;
    background: #111827;
}

code {
    font-family: monospace;
}
```

---

# A Simple Design Checklist

Before publishing any site, ask:

* Is everything aligned?
* Is spacing consistent?
* Is line-height comfortable?
* Are paragraphs readable?
* Does it work on mobile?
* Does it have a clear visual hierarchy?
* Is the color palette simple?
* Is the layout uncluttered?

If the answer is yes, the website will already look better than a large percentage of sites on the internet.

---

# Modern CSS Layout Recipe (2026)

For most blogs, documentation sites, portfolios, and Jekyll themes:

```css
body
{
    font-family: system-ui, sans-serif;
    line-height: 1.7;
}

.container
{
    max-width: 1100px;
    margin: auto;
    padding: 20px;

    display: flex;
    gap: 40px;
}

main
{
    flex: 1;
}

img
{
    max-width: 100%;
}

@media (max-width: 768px)
{
    .container
    {
        flex-direction: column;
    }
}
```

Mastering just:

* Box Model
* Typography
* Flexbox
* Grid
* Responsive Design
* Color & Spacing

will get you roughly 90% of the way toward building professional-looking blogs, documentation sites, portfolios, SaaS landing pages, and Jekyll themes without needing advanced CSS tricks.
