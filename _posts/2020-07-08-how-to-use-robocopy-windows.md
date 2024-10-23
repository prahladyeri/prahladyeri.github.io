---
layout: post
title: 'How to use robocopy for taking regular backups on windows'
tags: windows robocopy
---

Having switched from linux to windows recently, I was looking for an `rsync` alternative. `rsync` is a popular tool in the linux world used for taking routine backups and also general file transfer. But since I use it mostly for backups and I'm mostly a command line dude, I was trying to find a windows equivalent which can do the same. That's when I came across the `robocopy` command.

![robot](/uploads/robot.jpg)

Despite its trivially sounding name, `robocopy.exe` is a versatile tool found in almost all windows installations at `C:\windows\system32` and does a great job of taking incremental file backups. The best way to configure a `robocopy` backup is to create a simple batch file called `backup.bat` such as the one below:

```bat
@echo off
if not exist "e:\source\" (
	echo "backup drive not found. make sure e:\ corresponds to backup usb drive"
	goto :halt
)
echo Welcome!
echo ***

robocopy c:\source e:\source /E /PURGE /ndl /Z
:halt
```

This example assumes that you have a directory located at `c:\source` and you want to backup that entire directory to another drive (for example, a USB pen-drive) at `e:\source`. If you have more directories to backup, you can add them before the `:halt` statement like this:

```bat
robocopy c:\docs e:\docs /E /PURGE /ndl /Z
robocopy c:\music e:\music /E /PURGE /ndl /Z
```

Now, let's look at what those parameters to `robocopy` command do. The source and destination folders are obvious, here is what follows:

```bat
/E		Copy subdirectories (similar to --recursive option in rsync)
/PURGE	Delete destination files that no longer exist in source (--delete rsync option)
/ndl	Don't log directory names while copying
/Z		Copy files in restartable mode
```

You can run `robocopy /?` to see a full list of options available in this tool. If you want to schedule backups (like once a week or month), simply go to Task Scheduler from `Control Panel -> Administrative Tools` and schedule the above script to run accordingly.

Enjoy, your DIY backup solution for Windows is ready!