---
layout: post
title: "How to install composer packages locally or offline"
tags: php web-development guide
published: true
image: /uploads/code-php.jpeg
---

The usual way of installing composer packages with `composer require <foo>` is the standard. But occasionally, we might want to install the packages from our local computer to save Internet bandwidth or some other reason.

Unlike Python's pip, PHP's composer doesn't offer us a straightforward path to install from an archived package file here by running something like `pip install -i <package-file-name>`. However, there are two paths or workarounds to achieve this as follows:

**[1] The artifact way.**

This is [the more preferable way](https://aaronsaray.com/2021/install-composer-package-from-local-zip/), especially if your goal is to store the composer package files (*.zip) on your storage drive for long term use. But do note that if you go this route, you will be responsible for installing any dependency packages your app may have.

To do this, just edit your app's composer.json file and add your storage path in the repositories section:

```bash
"repositories": [
  {
    "type": "artifact",
    "url": "./packages"
  }
]
```

The ./packages could be any arbitrary local path on your computer. When you specify this path, composer will look in this path before trying to fetch the packages from <https://packagist.org> when you run the `composer require` command. However, you can also disable the [packagist.org repository completely](https://getcomposer.org/doc/05-repositories.md#disabling-packagist-org) if you want.

Now where to get the actual composer packages? If you have recently installed any package, you can find them in the composer cache directory which is usually at `C:\Users\<username>\AppData\Local\Composer\files`. Otherwise, you can run `composer require foo` command so that the file is saved there and you can save it to your storage. In theory, simply packaging the parent directory of the repo source containing `composer.json` file should also work but I haven't tried that.

But remember that while installing, you must ensure to install dependencies first. For example, if foo package depends on bar, you must install bar first.

**[2] The "copy package" way**

This one is a bit [tricky and hackish](https://stackoverflow.com/a/60531553) way and only recommended for experienced coders. Sometimes, you will want to just "copy" the package directory from one project to another. As the linked post suggests, you can just edit your app's composer.json, go to the autoload section and add the mapping to this newly copied package as follows:

```bash
  "autoload": {
    "psr-4": {
      "App\\": "src/",
      "Funtastic\\FooBar\\": "lib/foobar/src"
    }
```

After that, you can run `composer dump-autoload` so that composer will integrate this package and it becomes available in your app.