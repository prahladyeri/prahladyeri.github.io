---
layout: post
title: "How to use Bash+rsync to automate your periodical backups on Linux"
tags: backup linux ubuntu how-to
---

**Linux** is all about simplicity. Simple and time-tested tools like `iptables`, `netstat` and `rsync` can be called for help for basic tasks instead of untrusted third-party tools as happens in case of Windows. If you are a desktop user, then taking frequent backups of your data to a pen-drive or external disk is a typical problem to solve.<!--more-->

In this article, I'll show how I solved this problem using a combination of **bash scripting** and **rsync**, the basic tooling available on any linux distro these days, be it Ubuntu, Debian or Fedora.

One of the things you may want to do is determine what folder(s) you want to backup to which device. You may want to copy the source code folder only to your pen drive and your images and documents to only external drive, for instance. Here is where identifying the disk label through bash comes in handy in the backup script:

	if [ -d "/media/prahlad/DATA128" ]; then
		device_name="DATA128"
		folder_name="/media/prahlad/DATA128"
	elif [ -d "/media/prahlad/extHD" ]; then
		device_name="extHD"
		folder_name="/media/prahlad/extHD"
	else
		echo "No Drive Found"
		exit
	fi

In the above example, **DATA128** is a pen-drive and **extHD** is an external hard-drive and the above script determines which disk is inserted in the USB drive. You can then use the **\$folder\_name** bash variable to dynamically copy to that device instead of hard-coding that path unnecessarily. You can also use **\$device\_name** bash variable to include or skip specific folders when running the rsync command:

	rsync -va /home/prahlad/source "$folder_name/source"

	if [ "$device_name" = "extHD" ]; then
	 rsync -va /home/prahlad/Pictures "$folder_name/home/Pictures"
	 rsync -va /home/prahlad/Documents "$folder_name/home/Documents"
	fi

The **rsync** command itself is also versatile enough to do a lot of things which are not possible using a simple copy-paste-replace using a file manager. For instance, the "a" or "--archive" option intelligently archives (copies) files while skipping identical ones based on checksum or modification date automatically. Further, the "--delete" option deletes files which are present on the destination backup device, but not on the source device which is typically the case when you want to backup your data. Run "man rsync" to see the full range of options exposed by this wonderful command.

Finally, another advantage of using a script for backup automation is that you can implement custom actions through the script. For example, compressing the mozilla firefox user folder before taking its backup:

	echo "backing up firefox..."
	tar czf ~/firefox-backup.tar.gz ~/.mozilla/firefox/
	rsync -va ~/firefox-backup.tar.gz "$folder_name/home/firefox-backup.tar.gz"

Below is a typical example of how you might implement a script to automate backup of your home folder and set this as a cron job to run say weekly or fortnightly:

``` bash
#!/bin/sh

if [ -d "/media/prahlad/DATA128" ]; then
 device_name="DATA128"
 folder_name="/media/prahlad/DATA128"
elif [ -d "/media/prahlad/extHD" ]; then
 device_name="extHD"
 folder_name="/media/prahlad/extHD"
else
 echo "No Drive Found"
 exit
fi

echo "Device: $device_name"
echo "Folder: $folder_name"

#start copying 

#home
rsync -va ~/.bashrc "$folder_name/home/" --delete
rsync -va ~/.profile "$folder_name/home/" --delete
rsync -va ~/Downloads/ "$folder_name/home/Downloads/" --delete
rsync -va ~/Documents/ "$folder_name/home/Documents/" --delete
rsync -va ~/Pictures/ "$folder_name/home/Pictures/" --delete
rsync -va ~/.ssh/ "$folder_name/home/.ssh/" --delete
rsync -va ~/.gnupg/ "$folder_name/home/.gnupg/" --delete
rsync -va ~/.thunderbird/ "$folder_name/home/.thunderbird/" --delete
rsync -va ~/.mozilla/ "$folder_name/home/.mozilla/" --delete

echo "Done"
```

You can customize the above script by adding custom actions or if conditions to skip or include specific folders based on the device label.