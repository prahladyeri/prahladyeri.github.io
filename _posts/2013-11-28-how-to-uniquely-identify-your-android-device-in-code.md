---
layout: post
title: How to uniquely identify your Android device in code
tags: android how-to java
---

My last android project involved tracking each device where the app is installed and storing the information to a database. It is quite a common need to uniquely identify your android device in code.<!--more-->

![droid-man](/uploads/old/droid-man.png)

Now, had it been a PC, it would have been easy to track the MAC-address of the NIC or an HDD serial to uniquely identify and track that device. But what is the equivalent for android?

My research first led me to IMEI number (*TelephonyManager.getDeviceId()*). IMEI is a unique number associated with your device (pretty much like a vehicle's chassis number) and is widely used for tracking cellphones. The android API provides this ready-made function to uniquely identify your device if you wish to go this route:

	public static String getDeviceIdTm(Context context)
	{
		TelephonyManager tm=(TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
		return tm.getDeviceId();
	}

But wait, not all devices are equipped with Telephony. What about tablets and amazon kindle devices? It so happens, that this is just one way to track your device, but it is not full-proof. It will work only for phones and for other devices this function will return null.

This led me to another way of tracking an Android device: An in-built variable that the Android system itself provides you: ANDROID\_ID. In theory, this variable is all you need to know to identify your device uniquely:

	public static String getDeviceIdAndroid(Context context)
	{
		return Secure.getString(context.getContentResolver(),Secure.ANDROID_ID);
	}

But Alas! Even this is not full-proof. It will work on most modern versions of android (HoneyComb and above). Again, due to a manufacturer bug, it will not return a unique value, but a constant value "9774d56d682e549c" on some handsets.

This led me to a third way of identifying my device which was a bit hackish. I prefer not to use this method if any of the prior two methods worked.

	public static String getDeviceIdPseudo(Context context)
	 {
		 String tstr="";
		 if (Build.VERSION.SDK_INT > Build.VERSION_CODES.FROYO) {
			 tstr+= Build.SERIAL;
			 tstr += "::" + (Build.PRODUCT.length() % 10) + (Build.BOARD.length() % 10) + (Build.BRAND.length() % 10) + (Build.CPU_ABI.length() % 10) + (Build.DEVICE.length() % 10) + (Build.MANUFACTURER.length() % 10) + (Build.MODEL.length() % 10);
			 return tstr;
		}
	 }

This method computes a Pseudo-id for your device taking reference to some hardware values. If the previous two methods don't work, then this is all you are left with for device identification.

I then integrated the above three methods to create a generic method called ***getDeviceIdUnique()*** that will work on all android devices - irrespective of whether its a phone/tablet or what make it is:

	public static String getDeviceIdUnique(Context context)
	 {
		 try {
			 String a = getDeviceIdTm(context);
			 String b = getDeviceIdAndroid(context);
			 String c = getDeviceIdPseudo(context);

			 if (a!=null && a.length()>0 && a.replace("0", "").length()>0) 
				 return a;
			 else if (b!=null && b.length()>0 && b.equals("9774d56d682e549c")==false) 
				 return b;
			 else if (c!=null && c.length()>0) 
				 return c;
			 else
				 return "";
			 }
		 catch(Exception ex)
		 {
			 return "";
		 }
	 }

*References:*

- <http://stackoverflow.com/q/2785485/849365>
- <http://stackoverflow.com/q/4468248/849365>
