---
layout: post
title: "Troubleshoot the 'Invalid Package' error on Android APK installation"
tags: android apk mobile-development guide troubleshooting
published: true
image: /uploads/android-package-error.jpg
description: "Struggling with 'Package Invalid' errors when installing Android APKs? Discover practical solutions for this common issue with our step-by-step guide."
discuss:
    - https://reddit.com/r/androiddev/comments/1c0hnyc/how_to_fix_the_dreaded_package_appears_to_be/
    - https://tildes.net/~comp/1fiv/how_to_fix_the_dreaded_package_appears_to_be_invalid_error_when_installing_apks
---

When you try to manually install an Android APK on your phone, you are typically stuck with an error similar to this:

![screenshot showing Android package invalid error](/uploads/android-package-error.jpg)

Stack Overflow is filled with posts like [this](https://stackoverflow.com/q/77749878/849365), [this](https://stackoverflow.com/q/46973058/849365) and [this one](https://stackoverflow.com/q/76145397/849365) but apparently, there seems to be no consensus regarding the cause or even a generally accepted fix for this problem.

The very obvious thing to first do is clean the project and rebuild the APK in Android Studio. Many answers suggest this and if it works for you then well and good. But if rebuilding the APK doesn't resolve this problem, there are three other solutions you can try based on my practical experience with Android development so far:

1. If you are signing the final APK with a key, it could be an issue depending on how you sign. Some older android versions may not support the newer V2 signature format, so it's recommended to sign your APK using [both V1 and V2 formats](https://stackoverflow.com/a/46973194/849365).
2. I found another solution from [this post](https://android.stackexchange.com/q/252577/38760) and it often works in many situations. What values you've set for `minSdkVersion` and `targetSdkVersion` properties (typically in the app's build.gradle file) are often the culprit here due to the way android works. Apparently, [some newer phones don't like APKs which support versions lower than M](https://www.xda-developers.com/android-14-block-outdated-apps/). In my case, I had kept `minSdkVersion` to 19 (KitKat) and once I changed it to 23 (Marshmallow), this package error mysteriously disappeared! If your user base consists of older android versions, you'll have to release multiple APKs to cater to that segment in this case.
3. Apparently, another way this error goes away is by setting the `exported` attribute for your main Activity in the `AndroidManifest.xml` like below:

```xml
<activity android:name=".LoginActivity"
	android:exported="true"
	>
	<intent-filter>
		<action android:name="android.intent.action.MAIN" />
		<category android:name="android.intent.category.LAUNCHER" />
	</intent-filter>

</activity>
```

Please let me know whether this resolves your APK package error through comments. Also let me know if you know some other way to fix this error.