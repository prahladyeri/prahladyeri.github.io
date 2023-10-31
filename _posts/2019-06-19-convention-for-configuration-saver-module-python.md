---
layout: post
title: 'Building a convention for configuration saver and reader module in Python'
tags: open-source configuration python
---


I maintain several [python projects](https://github.com/prahladyeri) on github and some of them like [VTScan](https://github.com/prahladyeri/vtscan) has a need for user configuration. Now python has a plethora of [ways and standards](https://martin-thoma.com/configuration-files-in-python/) for *parsing* of configuration files like json, *.ini files, etc., but there is no standard about where to save them on the user's machine post installation.

![code-unix](/uploads/code-unix.jpeg)

One method used by many coders is to save it to the "app path" or the location where your python package itself is installed. On windows machines, this happens to be something like this:

	C:\Users\<username>\AppData\Local\Programs\Python\Python36-32\Lib\distutils\<package_name>
	
This approach has several problems. First, its a location for storing programs and shouldn't be mixed with data or configuration. Secondly, if your user uninstalls your program in future or even upgrades it (which is a very common scenario), this entire location will simply vanish along with your user's configuration data! When you upgrade a package like this, pip first removes the old package and then starts to install the new one:

	pip install --upgrade package_name
	
The linux standard way of storing config files for users is ~/.app-name and even ~/.config/app-name where the tilde (~) represents the user's home directory (which typically expands to /home/username/). This is the way I like the most as its readable and accessible to both apps and humans! There is also the /etc/app-name location on linux but that's for apps installed with root privileges but as typical python devs, we don't need to worry about that. If your app requires root, most probably you won't be using pip/pypi in the first place but choose a proper linux packaging system like apt/dnf/pacman instead.

But storing your configuration files to that location through setup.py upon installation isn't easy! In fact, you'll have to import the install class from setuptools.command.install and subclass it to override the post installation process if you wish to go that route!

	from setuptools.command.install import install

	class PostInstallCommand(install):
		"""Post-installation for installation mode."""
		def run(self):
			install.run(self)
			fpath = os.path.join(self.install_lib, pkg_name)
			fpath = os.path.join(fpath, "cfg.json")
			cfg_dir = os.path.join(os.path.expanduser("~"), ".config/%s" % pkg_name)
			if not os.path.isdir(cfg_dir): os.makedirs(cfg_dir)
			tpath = os.path.join(cfg_dir, "cfg.json")
			shutil.move(fpath, tpath)

However, you can create certain conventions like keeping a standard name (like cfg.json) for all your configurations and storing them to a standard location like ~/.config/app-name as the above code does.

Another thing to take care is that the way to include this configuration file in your setup file is to include it in MANIFEST.in and that thing doesn't read anything from outside the app's source directory! You can't assign it a path like ~/.config/pkg_name/cfg.json, so you'll have to manually copy cfg.json to your source directory in order to build your package. Then you can set it [like this in MANIFEST.in](https://github.com/prahladyeri/gar-cron/blob/master/MANIFEST.in):

	include gar_cron/cfg.json

Of course, I can't automate the whole thing and turn this into a fully "plug and play" library module because things like above are app specific and each dev has to do it for her setup process specifically. But other things I can do like saving and retrieving data from this standard location:

	def save(pkg_name, cfgobject, cfgpath=None):
		if cfgpath == None:
			cfgpath = os.path.expanduser("~/.config/%s" % pkg_name)
		if not os.path.isdir(cfgpath):
			os.makedirs(cfgpath)
		cfgpath = os.path.join(cfgpath,  "cfg.json")
		ss = json.dumps(cfgobject)
		open(cfgpath, 'w').write(ss)
		return True


	def get(pkg_name , cfgpath=None):
		if cfgpath == None:
			cfgpath = os.path.expanduser("~/.config/%s" % pkg_name)
		if not os.path.isdir(cfgpath):
			os.makedirs(cfgpath)
			return None
		cfgpath = os.path.join(cfgpath,  "cfg.json")
		if not os.path.isfile(cfgpath):
			return None
		ss = open(cfgpath).read()
		return json.loads(ss)

The first function allows you to save your config object (typically a python dict) to this standard location by serializing it to json and writing it to cfg.json. You can also override the cfgpath argument to store it in a non-standard location but you shouldn't do that unless there is any specific reason.

The second function similarly fetches your config data by reading and deserializing the cfg.json file. Finally, I've also written a get_from_cmd() function which is helpful in getting the config directly from the user through command line by passing it a predefined list of config keys:

	def get_from_cmd(pkg_name, keys):
		print("Configuration Saver version %s\n" % cfgsaver.__version__)
		obj = {}
		for key in keys:
			try: 
				obj[key] = input("Enter %s: " % key)
			except KeyboardInterrupt as ex:
				return None
		save(pkg_name, obj)
		return obj
		
	config_keys = ['github_username', 'alert_email']
	config = cfgsaver.get_from_cmd(pkg_name, config_keys)

	
If you want to use this whole functionality right away, I've written a library called [cfgsaver](https://github.com/prahladyeri/cfgsaver) which you can install and get started!

	pip install cfgsaver
	
The [project README](https://github.com/prahladyeri/cfgsaver) also has special instructions for the specific problems - setting up your MANIFEST.in and customizing the setup.py script. You may also fork or copy this library and create your own version that adapts to your own build process.

Finally, you can also keep using a non-standard method of dealing with config files but that path is riddled with agony and headaches. Besides, if every dev starts following a standard way of saving config files, the world will be so much a better place to live, both for humans and apps!