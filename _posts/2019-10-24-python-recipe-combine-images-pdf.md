---
layout: post
title: Python recipe: Combine multiple images into one PDF
tags: productivity how-to python
---

Many a times, you come across the need to combine multiple image files (.jpg, .png, etc.) into one single portable document format (.pdf). Maybe, you have a bunch of handwritten notes which you want to organize into one file. Doing that is very trivial if you know python. To being with, you must have the `fpdf` library installed:

```python
pip install fpdf
```
	
The first thing you do is create the `FPDF()` object and set the source directory where you have the images stored. `sdir` is that variable. You also need to set two variables to capture the height and width of the images respectively.

```python
import os
from PIL import Image
from fpdf import FPDF
pdf = FPDF()
sdir = "imageFolder/"
w,h = 0,0
```
	
Then comes the looping part. This makes things easier if you have the image files named serially in numeric order (IMG001.png, IMG002.png, etc.). Otherwise, you can adapt this code to manually or sequentially process them one after another by setting the `fname` variable:

```python
for i in range(1, 100):
	fname = sdir + "IMG%.3d.png" % i
	if os.path.exists(fname):
		if i == 1:
			cover = Image.open(fname)
			w,h = cover.size
			pdf = FPDF(unit = "pt", format = [w,h])
		image = fname
		pdf.add_page()
		pdf.image(image,0,0,w,h)
	else:
		print("File not found:", fname)
	print("processed %d" % i)
pdf.output("output.pdf", "F")
print("done")
```

The output of the above process will be stored in a single "output.pdf" file. So, that's pretty nice and easy, isn't it? Here is the entire code.

```python
import os
from PIL import Image
from fpdf import FPDF
pdf = FPDF()
sdir = "imageFolder/"
w,h = 0,0

for i in range(1, 100):
	fname = sdir + "IMG%.3d.png" % i
	if os.path.exists(fname):
		if i == 1:
			cover = Image.open(fname)
			w,h = cover.size
			pdf = FPDF(unit = "pt", format = [w,h])
		image = fname
		pdf.add_page()
		pdf.image(image,0,0,w,h)
	else:
		print("File not found:", fname)
	print("processed %d" % i)
pdf.output("output.pdf", "F")
print("done")
```
