---
layout: post
title: "A crash course in python packaging"
tags: python setup pypi crash-course
---

This guide isn't for the newbie who is just learning python programming (they are better off doing a "proper" reading of the [official docs](https://packaging.python.org/) instead). This is for the seasoned coder who dabbles in multiple technologies and needs a quick refresher on how to go about building a neat zip or tar.gz package from their existing python code, and optionally upload it to python package index (pypi).

![toolbox](/uploads/toolbox.jpg)

First of all, its necessary to encapsulate your individual python scripts into a python **package**. Individual *.py scripts can't be packaged on their own, you must add them to a directory which will represent your package. For example, the `foobar` package directory is as follows:

	...foobar\
		...main.py
		...util.py
		...__init__.py
		...etc.
	
The `__init__.py` is needed so that python treats your directory as a package. It can be either left totally blank or consist of helpful imports if you need them. The rest of your code also needs to be adjusted as every module is contained in a package now. So for example, the following main module won't work because the imported module (util) resides in a package now.

	import util

	if __name__ == "__main__":
		print(util.print_line())
	
This code must be re-factored so that it imports the util module from the foobar package instead:

	from foobar import util
	
Of course, this must be done in each module. When your package gets installed on the user's machine, the scripts will be inside a directory such as following:

	C:\Users\<username>\AppData\Local\Programs\Python\Python36-32\Lib\site-packages\foobar\
	
And the user may be running the scripts from any random directory such as `C:\source` and there won't be a `util.py` on their current path obviously! Hence, the module must be referred to by its global package naming convention. Since `foobar` package will be installed on the user's machine, the above directory will be recognized by the python interpreter as `foobar` package directory where it will find `util` and other installed modules.

Once you do that, you must create a `setup.py` in the root directory of your source, so your directory structure becomes like this:

	setup.py
	...foobar\
		...main.py
		...util.py
		...__init__.py
		...etc.

If you manage multiple projects in your source directory, you can put this whole bunch of files in a "foobar_project" or similarly named directory for organization.

You may add many other files at the root level such as `MAINFEST.in` which is only needed in case you want to add configuration or other files from different locations to your setup file. There could be other files too such as `README.md` for your project's description and your project's `LICENSE` file.

The contents of the `setup.py` should be as follows:

```python
#!/usr/bin/env python3
import foobar
from setuptools import setup, find_packages

s = setup(
	name=foobar,
	version="0.1",
	license="MIT",
	description="Dummy package called foobar",
	long_description="Dummy package called foobar, some longer description.",
	long_description_content_type='text/markdown',
	url='https://github.com/prahladyeri/%s' % pkg_name,
	packages=find_packages(),
	include_package_data=True,
	entry_points={
		"console_scripts": [
			"foobar = foobar.main:main",
		],
	},
	install_requires=['requests', 'colorama'],
	python_requires = ">= 3.4",
	author="Prahlad Yeri",
	author_email="prahladyeri@yahoo.com",
	classifiers=[
		"Programming Language :: Python :: 3",
		"License :: OSI Approved :: MIT License",
		"Operating System :: OS Independent",
	],
	)
```

The `setup` function takes some arguments which is basically the information needed to build and install your package. The most important argument is `name`, this is how your package will be identified by the pip installer and the python packaging index (pypi). For things like version number, license, description, etc., its a better idea to define those variables in `__init__.py` itself, so that you can directly import them like this instead of hard coding:

	from foobar import __version__, __description__, __license__
	
An important parameter here is `entry_points`. You must define the command line script name here which your user will use to run your script. If its going to be `foobar`, you must also specify which module's function must be called as entry point. In this case, when user runs `foobar`, the package foobar's main module will be called and from that, the main() function will run:

		entry_points={
			"console_scripts": [
				"foobar = foobar.main:main",
			],
		},
		
Of course, you must refactor your code so that it cannot simply start running from "__main__" check but must be placed in a separate main function:

	def main():
		pass # <your code goes here
		
	if __name__ == "__main__":
		main()
		
You can also pass command arguments arguments through this arrangement but its better to use the `argparse` module for that instead of parsing the CLI arguments manually. Once you've done this wiring of your code properly as described, you then have to just run the following command to test your build by going to the package root directory (where setup.py is located):

	python setup.py sdist
	
The `sdist` argument creates a source distribution (typically tar.gz file) under the `dist` subdirectory. It will be of the format:

	foobar-<version>.tar.gz
	
Here, <version> is whatever you provide in the setup argument. You can test the installation of this build by running:

	pip install dist\foobar-<version>.tar.gz
	
This must install your package on the local machine, it will have the same effect as if your package was installed by pip itself:

	pip install foobar

Of course, you cannot run the above command until you upload your foobar package to the python package index (pypi). If you don't want to do that and just distribute zipped installation files to your users/clients, what you've learned until now should suffice. But if you want to upload your own package to pypi, then you must install a dependency library called `twine` for that:

	pip install twine
	
Now you are ready to upload your own package to python package index (pypi). For that, you must first register an account at [python package index (pypi)](https://pypi.org). After that, its as easy as running the `twine upload` command!

	twine upload dist\foobar-<version>.tar.gz
	
The above command asks your pypi login credentials you just registered and then upload your package. Within a few minutes, your package will be available for the whole world to install through pip!

	pip install foobar