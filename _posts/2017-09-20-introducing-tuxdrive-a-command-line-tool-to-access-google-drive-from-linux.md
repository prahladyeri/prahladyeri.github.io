---
layout: post
title: Tux Drive - A Command Line Tool to Access Google Drive from Linux
tags: google-drive linux python
---

One of the most boring things we need to perform in life is using the [Google Drive](https://drive.google.com/drive/). On one hand, so useful is this tool provided by Google (so many cloud GBs for free, yay!) but on the other hand, the web interface to access those files is not quite as intuitive, especially so for power users, and certainly so for linux users!<!--more-->

Unlike the good old FTP/SFTP where you could just run some geeky commands in a terminal (or use a super-intuitive GUI like FileZilla to just drag and drop files), the Google Drive web interface results in a crippled work flow. To top it, we don't even have a desktop client like the Windows folks do.

Tux Drive
=========

To solve this problem, I have written a console based python program called [**tuxdrive**](https://github.com/prahladyeri/tuxdrive).

![Tux Drive running on Ubuntu 16.04 LTS](https://raw.githubusercontent.com/prahladyeri/tuxdrive/master/screenshot.png){width="687" height="302"}

**Tux Drive running on Ubuntu 16.04 LTS**

Its nowhere as comprehensive as FTP/SFTP in flexibility (yet), but it does some basic things like ***ls (or dir)*** to list remote files and directories on your drive, ***get file\_name*** to download a file, ***cd remote\_dir*** to change the drive directory, etc.

Here is the entire list of vocabulary that **tuxdrive** is currently acquainted with:

	 help (or ?): Shows this help facility.
	 dir (or ls): Lists all files and folders on drive.
	 !dir (or !ls): Lists all files and folders in current directory.
	 get (or pull) <item>: Pulls the named file/folder from drive to current working directory.
	 put (or push) <item>: Pushes the named file/folder from current working directory to drive.
	 rm <item>: Delete the named file/folder on remote path.
	 pwd: Print working directory (remote/drive).
	 cd: Change working directory (remote/drive).
	 lpwd: Print working directory (local).
	 lcd: Change working directory (local).
	 rdcache: Show remote directory mapping of id and folder paths.
	 rfcache: Show remote files mapping of id and folder paths.
	 mkdir: Create a directory on remote path.
	 exit: Exits this program.

Instructions to download and run **tuxdrive** can be found on the [project github](https://github.com/prahladyeri/tuxdrive). I sincerely hope this tool becomes useful to as many users as possible. If something good comes out of this, I'll think about integrating dropbox too into this in future.

Have a Good Day.
