---
layout: post
title: "Announcing gh_announce - A python bot that posts a tweet each time you make a release on github"
tags: github twitter tweepy open-source python
---

I happen to maintain a lot of python projects on github such as [distroverify](https://github.com/prahladyeri/distroverify) and [vtscan](https://github.com/prahladyeri/vtscan). And each time I make a tagged release on Github, I have to make a status tweet like this to let people know:

![distroverify tweet](/uploads/distroverify_tweet.png)

So today I thought why not automate this process by writing a python bot that:

1. Runs as a background cron on my computer.
2. Keeps checking my github release tags.
3. Post a new tweet in the above format for me whenever there is a new release.

The result of this endeavor is [gh_announce](https://github.com/prahladyeri/gh_announce). I used the popular [tweepy](https://github.com/tweepy/tweepy) library for the twitter api and my own written package [cfgsaver](https://github.com/prahladyeri/cfgsaver/) to handle the configuration data such as my github username, twitter api credentials, etc.

Once that is done, its only a matter of cruising through the github user events api and check whether a new tagged release has come:

```python
def check_activity():
	url = "https://api.github.com/users/%s/events" % config['github_username']
	resp = requests.get(url)
	acts = json.loads(resp.text)
	if len(acts) == 0:
		print("Zero events found, is this the correct github repo I'm looking at?")
		print("Run the program again with --config parameter to set the correct values")
		return
	for i in range(len(acts)):
		act = acts[i]
		if act['type'] == 'CreateEvent': #latest tag
			payload = act['payload']
			if payload['ref_type'] != 'tag':
				continue
			repo = act['repo']
			repo_url = "https://github.com/" + repo['name']
			tag_name = payload['ref']
			
			dt = parse_date(act['created_at'])
			delta = datetime.now() - dt
			days = delta.days
			hrs = delta.seconds // 3600
			mins = (delta.seconds // 60) % 60
			
			if delta.days >= 2: #this push is more than two days old, so just ignore
				continue
				
			tweet = False
			#check local config data to know whether we've already tweeted for this release
			if not 'pushes' in config:
				pushes = [act['id']]
				tweet = True
			else:
				pushes = config['pushes']
				if act['id'] in pushes:
					pass #do nothing
				else:
					tweet = True
					pushes.append(act['id'])
			if tweet:
				try:
					tw_announce(tag_name, repo['name'], repo_url)
				except Exception as ex:
					print("Error occurred: ", str(ex))
			config['pushes'] = pushes
			cfgsaver.save(pkg_name, config)
```

As you can see, I've ignored the pushes which are more than two days old as they may already have been tweeted or discussed, and can be ignored on the first run. For making the actual tweet, I use the `tweepy` library's `OAuthHandler` for authentication, then call the `api.update_status()` method to make the actual tweet.

```python
def tw_announce(tag_name, repo_name, repo_url):
	ss = "I have" if (config['Full_Name'] == None or config['Full_Name'] == "") else config["Full_Name"] + " has"
	ss += " just released version %s of %s on Github. Check it out! %s" % (tag_name, repo_name.split("/")[1], repo_url)
	#print("TWEETING: " + ss)

	if config['twitter_consumer_api_key'] == "":
		print("twitter api credentials missing")
		return
	auth = tweepy.OAuthHandler(config['twitter_consumer_api_key'], 
		config['twitter_consumer_secret'],
		)
	auth.set_access_token(config['twitter_access_token'], config['twitter_access_token_secret'])
	api = tweepy.API(auth)
	api.update_status(ss)
	print("successfully updated status for repo: %s, tag: %s" % (repo_name, tag_name))
```
	
You need to register your own app on <https://developer.twitter.com/apps> and get these four credentials if you intend to use the tweepy library for posting tweets on your behalf:

	'twitter_consumer_api_key',
	'twitter_consumer_secret',
	'twitter_access_token',
	'twitter_access_token_secret',

The app prompts for doing this on the first run of course. The wording of the tweet is kept in a manner that takes care of whether the `Full_Name` configuration setting is entered. If its there, the status starts with "`Full_Name` has just released version `tag` on Github...", otherwise as "I have just released version <tag> on Github...". So, you can leave `Full_Name` setting blank depending on how you want the status structure to be.

Because I love the open source community so much, I want to just give this away to you! `gh_announce` is open source and MIT licensed, you can install it by simply running:

	pip install gh_announce
	
Please let me know if you like this tool, it'll encourage me to keep writing more such tools in future!