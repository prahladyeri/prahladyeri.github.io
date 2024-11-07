---
layout: post
title: '3 Steps to integrate barcode scanning in your Android app'
tags: android java
---

Whilst barcode scanning is a pretty complex and non-trivial task in itself, it could be overwhelming sometimes with android programming. Lucky for us, there exists an opensource project called [*ZXing (pronounced Zebra-crossing)*](https://github.com/zxing/zxing) that solves this problem for us.

![Barcode](/uploads/old/barcode.png)

The ZXing project has already done the heavy lifting by programming the core java components required to scan a 1d/2d barcode or even a PR-code in the form of a [Google-play app](https://play.google.com/store/apps/details?id=com.google.zxing.client.android). All you have to do is send an intent to this app and receive the scanned results that you may use in your app.

The ZXing project is Apache licensed, so it is free to use without any kind of restrictions. Follow these steps to integrate ZXing with your app:

***Step 1:*** Download the source for IntentIntegrator.java and IntentResult.java from [here](http://code.google.com/p/zxing/source/browse/trunk#trunk%2Fandroid-integration%2Fsrc%2Fmain%2Fjava%2Fcom%2Fgoogle%2Fzxing%2Fintegration%2Fandroid) and add the files to your android project sources.

***Step 2:*** Start an intent in that part of your code where you would like to initiate the barcode scanning (such as a menu handler):

	IntentIntegrator integrator = new IntentIntegrator(yourActivity);
	integrator.initiateScan();

***Step 3:*** All that remains now is to handle the result of this activity in your onActivityResult() handler. This is how I did it in my code:

	if (requestCode==IntentIntegrator.REQUEST_CODE)
	{
		IntentResult scanResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
		if (scanResult != null)
		{
			// handle scan result
			//MessageBox.run(this, "", "toString() returns: " + scanResult.toString());
		}
		else
		{
			// else continue with any other code you need in the method
			MessageBox.run(this, "", "scanResult is null.");
		}
	}

That\`s all! The above code not only returns the barcode scanning result to your app, but even prompts the user to install a barcode scanner app in case one isn't there. This is the easiest and recommended way of integrating barcode scanning in your android app.

In case you want to embed the entire ZXing component in your app and don't want to install an app separately for it, refer to the relevant links in the references section. However, this method is not recommended as your app won't get the updates from ZXing.

*References:*

- <http://stackoverflow.com/q/11205183/849365>
- <http://stackoverflow.com/q/4854442/849365#4854637>
- <http://stackoverflow.com/q/16433860/849365>
- <https://github.com/zxing/zxing>
- <http://code.google.com/p/zxing/wiki/ScanningViaIntent>