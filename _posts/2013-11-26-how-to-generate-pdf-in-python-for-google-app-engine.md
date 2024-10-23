---
layout: post
title: 'How to Generate PDFs in Python for Google App Engine'
tags: google-app-engine python
---

One of my last projects based on google app engine and python involved storing form data in GAE datastore and generating PDF documents that the user can download. Whilst data storing was the easier part as google's big data API it is pretty [well documented](https://developers.google.com/appengine/docs/python/datastore/), the trickier aspect was to convert it to PDF using python.<!--more-->

[![pdf](/uploads/old/pdf-300x300.png){.alignnone .wp-image-164 width="108" height="108"}](/uploads/old/pdf.png)

This was especially difficult in the face of GAE not providing an easy mechanism for disk writing that most PDF generation libraries require. To share my endeavors, I'm writing this post about how to generate pdfs in python for Google app engine.

The solution I came across was, as far as I know, the only possible way of generating PDFs in python! There are about three PDF generation utilities in python, each differing in terms of their area of usage:

-   [**Reportlab PDF library**](http://www.reportlab.com): This is the ideal library, if you want to create a pdf from scratch. It provides objects like canvas, pdfmetrics and ttfonts that help you with stuff like adding lines, shapes, images and paragraphs. This is pretty much comparable to the comprehensive iText java library or its C\# port, iTextSharp. Their [documentation](http://www.reportlab.com/software/documentation/) is also good.
-   [**xhtml2pdf**](http://www.xhtml2pdf.com/): If you want to simply convert an existing html document to pdf, the xhtml2pdf library comes in very handy.
-   [**pyPDF**](https://pypi.python.org/pypi/pyPdf): If all you want to do is merge two PDFs page by page quickly, this library is the way to go.

I figured out after researching the above three libraries that a combination of xhtml2pdf and pyPDF is what I needed. Since I already had the html document template ready, I just put placeholders for my form data like \_\_name\_\_ , \_\_occupation\_\_, etc so that I can fill these before converting to PDF.

Now, I could fill these values from my python program, but the real challenge was storing the resulting PDF to disk, which was not allowed by google app engine! Turns out, we don't need to actually store anything to disk. By sending the CreatePDF() output to a [StringIO](http://docs.python.org/library/stringio.html) object, which is stored in memory instead of the filesystem, I could bypass the need to actually store anything to disk!!

	f=open('template.htm','r')
	sourceHtml = unicode(f.read(), errors='ignore')
	f.close()
	sourceHtml = template.render(tvals)
	sourceHtml = sourceHtml.replace('__name__',sname)
	sourceHtml = sourceHtml.replace('__address__',saddress)
	sourceHtml = sourceHtml.replace('__occupation__',will.occupation)
	packet = StringIO.StringIO() #write to memory
	pisa.CreatePDF(sourceHtml,dest=packet)

Now, it would have been simple to just self.response.write(packet) to send this pdf download to the user, but in my case, I had to merge this generated pdf with another template-pdf which contained information like symbols, images and page-numbers that for some reason, could not be placed into the html document. So, I had to create a PdfFileReader object (coutesy of PyPDF library!), and then merge each page of my generated document with this template document. Then where do I write this merged output? Any guesses? - another StringIO object!! And then finally, write this StringIO object to self.response, so the user can download it.

	packet.seek(0)
	new =PdfFileReader(packet) #generated pdf
	template = PdfFileReader(file("template.pdf", "rb")) #template pdf
	output=PdfFileWriter() #writer for the merged pdf
	for i in range(new.getNumPages()):
		page=template.getPage(i)
		page.mergePage(new.getPage(i))
		output.addPage(page)

	outputStream = StringIO.StringIO()
	output.write(outputStream) #write merged output to the StringIO object

	self.response.headers['Content-Type'] = 'application/pdf'
	fname = (will.name if mirror=='n' else will.partner)
	self.response.headers['Content-Disposition'] = 'attachment; filename=' + str(fname).replace(' ','_') + '.pdf'
	self.response.write(outputStream.getvalue())

Remember to add and include the below libraries before you do this:

	import StringIO
	import xhtml2pdf.pisa as pisa
	from pyPdf import PdfFileWriter,PdfFileReader
	from reportlab.pdfgen import canvas
	from reportlab.lib.pagesizes import A4
	from reportlab.pdfbase import pdfmetrics,ttfonts

 
*References:*

- <https://developers.google.com/appengine/docs/python/datastore/>
- <http://www.reportlab.com/software/documentation/>
- <http://www.xhtml2pdf.com/>
- <https://pypi.python.org/pypi/pyPdf>
- <http://stackoverflow.com/q/4899885/849365>
- <http://stackoverflow.com/q/13522638/849365>
- <http://docs.python.org/library/stringio.html>
