---
layout: post
title: "Unlocking Text from Embedded-Font PDFs: A pytesseract OCR Tutorial"
tags: python tutorial pytesseract ocr
image: /uploads/unlocking-text-from-embedded-font-pdf-pytesseract.webp
---
Extracting text from a PDF is usually straightforward when it's in English and doesn't have embedded fonts. However, once those assumptions are removed, it becomes challenging to use basic python libraries like `pdfminer` or `pdfplumber`. Last month, I was tasked with extracting text from a Gujarati-language PDF and importing data fields such as name, address, city, etc., into JSON format.

If the font is embedded in the PDF itself, simple copy-pasting won't work, and using `pdfminer` will return unreadable junk text. Therefore, I had to convert each PDF page to an image and then apply OCR using the `pytesseract` library to "scan" the page instead of just reading it. This tutorial will show you how to do just that.

![unlocking-text-from-embedded-font-pdf-pytesseract](/uploads/unlocking-text-from-embedded-font-pdf-pytesseract.webp)

## Things you will need

- `pdfplumber` (Python library)
- `pdf2image` (Python library)
- `pytesseract` (Python library)
- [tesseract-ocr](https://tesseract-ocr.github.io/tessdoc/Downloads.html)

You can install the Python libraries using `pip` commands as shown below. For Tesseract-OCR, download and install the software from the official site. `pytesseract` is just a wrapper around the tesseract software.

```bash
pip install pdfplumber
pip install pdf2image
pip install pytesseract
```

## Converting the PDF page to an image

The first step is to convert your PDF page to an image. This `extract_text_from_pdf()` function does exactly that-you pass the PDF path and the `page_num` (zero indexed) as parameters. Note that I'm converting the page to black and white first for clarity, this is optional.

```python
# Extract text from a specific page of a PDF
def extract_text_from_pdf(pdf_path, page_num):
    # Use pdfplumber to open the PDF
    pdf = pdfplumber.open(pdf_path)
	print(f"extracting page {page_num}..")
	page = pdf.pages[page_num]
	images = convert_from_path(pdf_path, first_page=page_num+1, last_page=page_num+1)
	image = images[0]
	# Convert to black and white
	bw_image = convert_to_bw(image)
	# Save the B&W image for debugging (optional)
	#bw_image.save("bw_page.png")
	# Perform OCR on the B&W image
	e_text = ocr_image(bw_image)
	open('out.txt', 'w', encoding='utf-8').write(e_text)
	#print("output written to file.")
	try:
		process_text(page_num, e_text)
    except Exception as e:
        print("Error occurred:", e)
	print("done..")
	
# Convert image to black and white
def convert_to_bw(image):
    # Convert to grayscale
    gray = image.convert('L')
    # Apply threshold to convert to pure black and white
    bw = gray.point(lambda x: 0 if x < 128 else 255, '1')
    return bw
	
# Perform OCR using Tesseract on a given image
def ocr_image(image_path):
    try:
        # Perform OCR
        custom_config = r'--oem 3 --psm 6 -l guj+eng'
        text = pytesseract.image_to_string(image_path, config=custom_config)  # --psm 6 treats the image as a block of text
        return text
    except Exception as e:
        print(f"Error during OCR: {e}")
        return None

```

The `ocr_image()` function uses `pytesseract` to extract text from the image through OCR. The technical parameters like `--oem` and `--psm` control how the image is processed, and the `-l guj+eng` parameter sets the languages to be read. Since this PDF contained occasional English text, I used `guj+eng`.

## Processing the text

Once you've imported the text using OCR, you can parse it in the format you want. This works similarly to other PDF libraries like `pdfplumber` or `pypdf2`.

```python
nums = ['0', '૧', '૨', '૩', '૪', '૫', '૬', '૭', '૮', '૯']

def process_text(page_num, e_text):
    obj = None
    last_surname = None
    last_kramank = None
    print(f"processing page {page_num}..")
    for line in e_text.splitlines():
		line = line.replace('|', '').replace('[', '').replace(']', '')
        parts = [word for word in line.split(' ') if word]
        if len(parts) == 0: continue
        new_rec = True
        for char in parts[0]:
            if char not in nums:
                new_rec = False
                break
        if len(parts) < 2: continue
        
        if new_rec and len(parts[0]) >= 2: # numbered line
            if len(parts) < 9: continue
            if obj: records.append(obj)
            obj = {}
            last_surname = parts[1]
            obj['kramank'] = parts[0]
            last_kramank = parts[0]
            obj['full_name'] = ' '.join(parts[1:4])
            obj['surname'] = parts[1]
            obj['pdf_page_num'] = page_num + 1
            obj['registered_by'] = parts[4]
            obj['village_vatan'] = parts[5]
            obj['village_mosal'] = parts[6]
            if parts[8] == 'વર્ષ':
                idx = 7
                obj['dob'] = parts[idx] + ' વર્ષ'
                idx += 1
            elif len(parts[7]) == 8 and parts[7][2] == '-':
                idx = 7
                obj['dob'] = parts[idx]
            else:
                print("warning: no date")
                idx = 6
            obj['marital_status'] = parts[idx+1]
            obj['extra_fields'] = '::'.join(parts[idx+2:-2])
            obj['blood_group'] = parts[-1]
        elif parts[0] == last_surname: # new member in existing family
            if obj: records.append(obj)
            obj = {}
            obj['kramank'] = last_kramank
            obj['surname'] = last_surname
            obj['full_name'] = ' '.join(parts[0:3])
            obj['pdf_page_num'] = page_num + 1
            obj['registered_by'] = parts[3]
            obj['village_vatan'] = parts[4]
            obj['village_mosal'] = parts[5]
            if len(parts) <= 6: continue
            if parts[7] == 'વર્ષ': # date exists
                idx = 6
                obj['dob'] = parts[idx] + ' વર્ષ'
                idx += 1
            elif len(parts[6]) == 8 and parts[6][2] == '-':
                idx = 6
                obj['dob'] = parts[idx]
            else:
                print("warning: no date")
                idx = 5
            obj['marital_status'] = parts[idx+1]
            obj['extra_fields'] = '::'.join(parts[idx+2:-2])
            obj['blood_group'] = parts[-1]
        elif obj: # continuation lines
            if ("(" in line and ")" in line) or "મો.ઃ" in line:
                obj['extra_fields'] += ' ' + '::'.join(parts[0:])
    if obj: records.append(obj)        
    jstr = json.dumps(records, indent=4)
    open("guj.json", 'w', encoding='utf-8').write(jstr)
    print(f"written page {page_num} to json..")
```

Every PDF has its own nuances that must be accounted for. In this case, a new serial number (like 0૧ or 0૨) in the first field signaled a new group when the subsequent field (surname) changed.

`pytesseract` is a testament to the evolution and advancement in IT technology. About a decade ago, reading or parsing a PDF image using OCR in a non-English language on a modestly configured PC or laptop would have been nearly impossible. This is truly progress! Happy coding, and let me know how it goes in the comments below.

## References

- [Tesseract installation in windows](https://stackoverflow.com/q/46140485/849365)
- [Use pytesseract OCR to recognize text from an image](https://stackoverflow.com/q/37745519/849365)
- [How to configure pytesseract to support text detection for non English language in windows 10?](https://stackoverflow.com/q/65572698/849365)