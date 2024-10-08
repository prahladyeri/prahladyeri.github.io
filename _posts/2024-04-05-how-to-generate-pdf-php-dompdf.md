---
layout: post
title: 'Intro to DOMPDF - light and simple PHP library to generate PDF documents'
tags: php pdf
published: true
image: /uploads/code.jpg
discuss:
    - https://reddit.com/r/webdev/comments/1bw9p2a/intro_to_dompdf_lightest_and_simplest_php_library/
    - https://tildes.net/~comp/1fep/intro_to_dompdf_lightest_and_simplest_php_library_to_generate_pdf_documents
---

Generating PDF documents from your HTML output is a very common requirement and there are several open source libraries to accomplish this in PHP. I came across this need for my project recently and I evaluated many popular ones such as [TCPDF](https://github.com/tecnickcom/TCPDF), [mpdf](https://github.com/mpdf/mpdf), [FPDF](https://github.com/Setasign/FPDF), etc. But the one that truly stood up to my evaluation in terms of efficiency (minimal footprint) and ease of implementation was [DOMPDF](https://github.com/dompdf/dompdf).

DOMPDF is a pure PHP component which can be seamlessly installed using composer:

`composer require dompdf`

This will pull the dompdf component in your vendor folder, it occupies just about 7 MB of disk space which is great for the kind of work it does. Once you add this component with composer, you can start generating PDFs right away using the `Dompdf\Dompdf` object:

```php
$url = "https://example.com/";

$options = new Dompdf\Options();
$options->set('isRemoteEnabled', true);
$options->set('isHtml5ParserEnabled', true);

$dompdf = new Dompdf\Dompdf($options);
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

Needless to say, an important caveat or limitation here is that like most other libraries, dompdf will not support any and every latest feature in the CSS specification. It is mostly a CSS 2.1 compliant library and supports a few CSS 3 properties. In practice, I've seen most simple HTML tables and paragraphs set with attributes like bg/fg colors, fonts, margins, etc. work flawlessly. Styling with Bootstrap 3.x works too but 4 and above still has some issues.

In the above example, I've taken the HTML output of [example.com](https://example.com/) which has very basic styling to generate the PDF. [Here is the generated PDF output](/uploads/dompdf-output.pdf).

In this code, we first set the options for PDF generation using `Dompdf\Options` object. I've enabled `isRemoteEnabled` as my HTML content uses external CSS links. I've also enabled `isHtml5ParserEnabled` as I often need some HTML5 features. You can find more details on their [wiki page](https://github.com/dompdf/dompdf/wiki) about these options.

After that, you create a `Dompdf\Dompdf` object and load the HTML.

```php
$dompdf->loadHtml(file_get_contents($url));
```

After that, you set any other options you need (such as paper size) and call the `$dompdf->render()` method followed by `$dompdf->output()` method. Lo and behold, your PDF document is now generated!

You can either save the generated result using `file_put_contents()` as I've done in this example or you can also optionally call the `$dompdf->stream()` in which case the PDF will be output to the browser window directly.

That's it, so simple! Enjoy your pdf generation process using dompdf and if you face any issues, let me know using the discussion links. Happy Coding.