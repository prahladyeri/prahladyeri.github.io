---
layout: post
title: Linux DIY: How to identify your MTP file-transfer device (such as smart-phone) in Bash
tags: linux bash mtp how-to
---

In the good old days, USB file-transfer between your laptop and smart-phone used to happen through the much easier "mass storage" mode which works just as if you had inserted an external pen-drive. But these days, most smart-phones and tablets have shifted to the MTP (Media Transfer Protocol).

Unlike a mass storage device, the MTP device doesn't show up in the usual `/media/<user>/<device-label>` folder in a linux distro which makes backup automation or other file transfer tasks more difficult as you cannot simply hard-code this path and write bash scripts based on that.

This isn't possible in case of MTP because the label is dynamically determined using two important bits of information called *BusID* and *DeviceID*, and the file-system path works out to be something like this:

/run/user/1000/gvfs/mtp:host=%5Busb%3A**001**%2C**010**%5D/Internal shared storage
	
In this example, `001` is the BusID whereas `010` is the DeviceID. You can find these two values by running the `lsusb` command before and after the MTP device is inserted:

![bash lsusb](/uploads/lsusb1.png)

However, these two numbers (BusID and DeviceID) are dynamically determined depending on when and where you inserted the MTP device. Hence, if you are writing an automation script for backup, etc., you need to calculate it using other two static bits of information which are always constant for your device, they are called *VendorID* and *ProductID*.

In this example (for my Redmi Y2 phone), they happen to be `2717:ff40` (displayed right next to the BusID and DeviceID in above screen). Now that you have these two static bits of information which are always going to be in a given format (`VendorID:ProductID`), you can pass it to a bash function to determine the path dynamically:

```bash
function get_mtp_path() {
	str=$(lsusb|grep "$1")
	bus=`echo $str | awk '{split($0,a," "); print a[2]}'`
	dvc=`echo $str | awk '{split($0,a," "); print a[4]}' | sed 's/://g' `
	echo "mtp:host=%5Busb%3A$bus%2C$dvc%5D"
}

redmi_y2="2717:ff40"
redmi_y2_path=`get_mtp_path "$redmi_y2"`
folder="/run/user/1000/gvfs/$redmi_y2_path"
```

In above script, `$redmi_y2` variable is hard-coded which is then passed to the `get_mtp_path` bash function to determine the actual path which is then stored in the `$folder` variable.

Now that you have `$folder`, you can do anything with it. For example, you can use rsync to backup your smart-phone pics in the `DCIM` folder to your laptop:

```bash
rsync -vrt "$folder/Internal storage/DCIM/" "~/Pictures/"
```

Alternatively, you can run a normal backup of your `Documents` folder to your smart-phone:

```bash
rsync -vrt  "~/Documents/" "$folder/Internal storage/Documents/"
```

The possibilities of this are immense!