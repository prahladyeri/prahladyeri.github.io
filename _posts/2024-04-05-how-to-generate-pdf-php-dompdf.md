---
layout: post
title: 'Intro to DOMPDF - lightest and simplest PHP library to generate PDF documents'
tags: php dompdf
published: true
image: /uploads/code.jpg
---

Generating PDF documents out of your app's HTML output is a very common requirement and there are several open source libraries to accomplish this. I came across this need for my project recently and I evaluated many popular ones such as [TCPDF](https://github.com/tecnickcom/TCPDF), [mpdf](https://github.com/mpdf/mpdf), [FPDF](https://github.com/Setasign/FPDF), etc. But the one that truly stood up to my evaluation in terms of efficiency (minimal footprint), ease of implementation, etc. was [DOMPDF](https://github.com/dompdf/dompdf).

![code](/uploads/code.jpg)

DOMPDF is a pure PHP component which can be seamlessly installed using composer with:

`composer require dompdf`

This will pull the dompdf component in your vendor folder, it occupies just about 8 MB of disk space which is great for the kind of work it does! Once you add this component with composer, you can start generating PDFs right away using the `Dompdf\Dompdf` object:

```php
//$url = "https://prahladyeri.github.io/";
$url = "https://stallman.org/articles/necessary-changes.html";

$options = new Dompdf\Options();
$options->set('isRemoteEnabled', true);
$options->set('isHtml5ParserEnabled', true);

$dompdf = new Dompdf\Dompdf($options);
$dompdf->set_protocol($url);
//$dompdf->setBasePath($url);
$dompdf->loadHtml(file_get_contents($url));
$dompdf->setPaper('a4', 'portrait');
//$dompdf->setPaper( array(0,0,822,848), 'portrait' );
$dompdf->render();
$output = $dompdf->output();
file_put_contents("output.pdf", $output);
//$dompdf->stream();
echo "Done";
```

Needless to say, an important caveat or limitation here is that like most other libraries, dompdf will not support any and every latest feature in the CSS specification. It is mostly a CSS 2.1 compliant library but supports a few CSS 3 properties. In practices, I've seen most simple HTML tables and paragraphs set with attributes like bg/fg colors, fonts, margins, etc. work flawlessly. Bootstrap 3.x works perfectly but 4 and above still has some issues.

In the above example, I've taken [an article from Richard Stallman's website](https://stallman.org/articles/necessary-changes.html) which has very basic CSS. [Here is the generated PDF output](/uploads/dompdf-output.pdf).

We first set the options for PDF generation using `Dompdf\Options` object. I've enabled `isRemoteEnabled` as my HTML content uses external CSS links. I've also enabled `isHtml5ParserEnabled` as I need some HTML5 features. You can find more details on their [wiki page](https://github.com/dompdf/dompdf/wiki).

After that, you create a `Dompdf\Dompdf` object and load the HTML. In this case, I'm just fetching content from my blog's home page as an example here:

```php
$dompdf->loadHtml(file_get_contents("https://prahladyeri.github.io/"));
```

After that, you set any other options you need like paper size and call the `render()` method followed by `output()` method. Lo and behold, your PDF document is now generated! You can either generate the output to use internally by calling `$dompdf->output()` or just output the PDF to the browser window by calling `$dompdf->stream()`.

That's it, so simple! Enjoy your pdf generation process using dompdf and if you face any issues, let me know using the discussion links. Happy Coding.