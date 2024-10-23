---
layout: post
title: 'How to create android dialogs in a reusable manner'
tags: android java
---

Creating dialogs is a very common need in your app to show a dialog box to the user in order to fetch a value, be it a mobile, desktop or even a web application. Furthermore, the values can range from anything like simple *OK-Cancel* dialog results to a list of "check-able" values or even a date-range.<!--more-->

[![droid-man](/uploads/old/droid-man.png){.alignnone .wp-image-209 width="60" height="70"}](https://prahladyeri.github.io/uploads/old/droid-man.png)

I experienced the need to create an android dialog for each one of those for showing reports in a recent android app project. Whilst the java api offers maximum flexibility in creating dialog interface elements, there is no ready-made method that can be called to get, say a result for a message-dialog like this:

	result = MessageBox.Show();

Other languages like C\# and VB provide such methods to show modal dialog boxes that return values after waiting for a modal dialog. But unfortunately, there is no concept of "modal" in android. A thread cannot just sit idle waiting for input as the resources are too valuable for that. Instead, there is the concept of callbacks, so that instead of you waiting for the dialog to return, the method calls back a function reference you have passed it:

	AlertDialog.Builder builder=new AlertDialog.Builder(context);
	builder.setTitle("Milk supply tracker");
	builder.setMessage(message);
	builder.setPositiveButton("Yes",listener);
	builder.setNegativeButton("No",listener);
	builder.create().show();

The listener here is the referece to a function that will be called when the Yes or No button will be clicked. This not only complicates your code, but makes it very difficult to reuse code for handling different situations like getting a selection from a range of values or getting a date/time range. To solve this problem, I created a separate java class called Dialog and added variations of ShowDialog() methods to handle each type of dialog:

	class Dialog
	{
		public static void ShowMessageDialog(Context context, String message)
		{
			ShowDialog(context,message,MessageBoxType.OKOnly,new String[]{},false, null,null);
		}

		public static void ShowMessageDialog(Context context, String message, MessageBoxType type , OnClickListener listener)
		 {
			 ShowDialog(context,message,type,new String[]{},false, listener,null);
		 }

		public static void ShowListDialog(Context context, String message, String[] listItems, boolean isMultiChoice, OnClickListener listener)
		 {
		 if (isMultiChoice)
			 ShowDialog(context, message, MessageBoxType.OkCancel , listItems, isMultiChoice, listener,null);
		 else
			 ShowDialog(context, message, MessageBoxType.OKOnly , listItems, isMultiChoice, null,listener);
		 }

		public static void ShowDateDialog(Context context,String message,OnDateSetListener listener)
		{
			Calendar c=Calendar.getInstance();
			int y=c.get(Calendar.YEAR);
			int m=c.get(Calendar.MONTH);
			int d=c.get(Calendar.DAY_OF_MONTH);

			DatePickerDialog dlg=new DatePickerDialog(context, listener, y, m, d);
			dlg.setTitle(message);
			dlg.show();
		}

	}

As you can see, the ShowMessageDialog() accepts different parameters depending on whether a listener is required or not. ShowListDialog(), on the other hand passes an array of strings to create a dialog displaying a list of values from which a user may select. The isMultiChoice parameter tells whether a checkbox is required or not against each value in the select list. All this is actually implemented in the ShowDialog() private method, whereas the ShowDateDialog() has its own implementation. Here is the source for ShowDialog():

	private static void ShowDialog(Context context, String message, MessageBoxType type , String[] listItems, boolean isMultiChoice, OnClickListener listener,OnClickListener selectedItemListener)
	{
		AlertDialog.Builder builder=new AlertDialog.Builder(context);

		if (listItems.length>0 && isMultiChoice==false)
		{
			CheckedItems=new ArrayList();//won't be used in this case.
			builder.setTitle(message);

			builder.setItems(listItems, selectedItemListener);
		}
		else if (listItems.length>0 && isMultiChoice==true)
		{
			CheckedItems=new ArrayList();
			builder.setTitle(message);

			builder.setMultiChoiceItems(listItems, null, new OnMultiChoiceClickListener() 
			{
				@Override
				public void onClick(DialogInterface dialog, int which, boolean checked) 
				{
					if (checked)
						CheckedItems.add(which);
					else
					{
						if (CheckedItems.contains(which))
							CheckedItems.remove(which);
					}
				}
			});
		}
		else
		{
			builder.setTitle("Milk supply tracker");
			builder.setMessage(message);
		}

		if (listItems.length==0 || isMultiChoice)
		{
			switch(type)
			{
			case OKOnly:
				builder.setPositiveButton("OK",listener);
				break;
			case OkCancel:
				builder.setPositiveButton("OK",listener);
				builder.setNegativeButton("Cancel",listener);
				break;
			case YesNo:
				builder.setPositiveButton("Yes",listener);
				builder.setNegativeButton("No",listener);
				break;
			}           
		}

		builder.create().show();
	}

So hopefully, this class should suffice all your needs related to showing a dialog on your android app. Here is a working example of how the ShowListDialog() is actually called with checkboxes on:

	selItems=new String[]{"apples","oranges","grapes"};
	Device.ShowListDialog(this,"Select a fruit" ,this.selItems, true, new DialogInterface.OnClickListener() {

			@Override
			public void onClick(DialogInterface dialog, int which) 
			{
				if (which==DialogInterface.BUTTON_POSITIVE)
				{
					for(int i:Device.CheckedItems)
					Dialog.ShowMessageDialog(ReportsActivity.this, "selected:" + selItems[i]);
				}
			}
		});
	}

 
