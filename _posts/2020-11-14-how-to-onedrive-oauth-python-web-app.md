---
layout: post
title: "How to perform Microsoft OneDrive OAuth sign-in and authorization in a python web app"
tags: onedrive microsoft azure cloud python
---

The methods and examples given in this article are based on flask framework but they should apply to django or something similar too with a little tweak. Few weeks ago, I had landed myself on a project of similar nature and though I found several helpful articles and blog posts (such as [this one](https://dev.to/jsnmtr/automating-files-upload-to-microsoft-onedrive-unexpected-challenges-and-a-success-story-2ini)), none of them explained this process in a simple but comprehensive manner, so I'm writing one myself.

![python code](/uploads/code-python.jpg)

The first and foremost step is to visit the [Azure developer portal](https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade) and register your app there. Just make sure that you select "All Microsoft account users" for supported account types and not just personal Microsoft accounts. This is needed in case you want your web app to perform OneDrive file transfers on behalf of the signed in user.

Make note of the `client_id` and `client_secret` values and store them somewhere as you're going to need them while writing your app code.

Its also important to add the following permissions by clicking the "API permissions" link, and then add a scope for them by visiting the "Expose an API" link on the developer console screen:

 **API/Permissions** | **Type** | **Description** 
---------------------------|----------|---------------
Files.ReadWrite.All | Delegated | Have full access to all files user can access
offline_access | Delegated | Maintain access to data you have given it access to
User.Read | Delegated | Sign in and read user profile

Also note that if you couldn't set the supported account types to "All Microsoft account users" in the initial setup for some reason, you can later change it by updating the following XML setting after visiting the "Manifest" link on the app console:

	"signInAudience": "AzureADandPersonalMicrosoftAccount",
	
Finally, its also important to configure redirect URIs by visiting the "Authentication" screen. This is the URL endpoint where our signed-in user will be redirected to and our app receives the "code" request argument which is needed to complete the OAuth process. In my case, I configured two redirect URIs, one for testing and one for production respectively:

	- http://localhost:5000/post_onedrive
	- https://example-app.com/post_onedrive

Once the registered app is configured thus, we focus on our python app. Its important to provide the two URL endpoints here:

1. First, where our signed in user visits (by clicking a link/button that says "Authorize OneDrive" or "Link OneDrive"), and thus starts the OAuth process:

```python
@app.route('/link_onedrive', methods=['GET'])
def link_onedrive():
    conn, cursor = db.opendb()
    settings = cursor.execute("select * from settings").fetchone()
    url = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id={client_id}&scope={scope}&response_type=code&redirect_uri={redirect_uri}"
    #scopes = "wl.basic onedrive.readwrite wl.offline_access"
    scopes = "Files.ReadWrite.All offline_access"
    url = url.format(client_id=settings['od_client_id'], scope=scopes, redirect_uri=OD_REDIRECT_URI)
    print("url: ", url)
    return redirect(url)
```

In this case, I've already stored the app credentials like client_id, etc. in a `sqlite` table called settings from which I'm fetching them using a database connection. After that, its only a matter of calling the oauth URL with those specific parameters.

2. Second, where the OneDrive's redirection is handled (/post_onedrive in above example):

```python
@app.route('/post_onedrive', methods=['GET', 'POST'])
def post_onedrive():
    conn, cursor = db.opendb()
    settings = cursor.execute("select * from settings").fetchone()
    print("One Drive: HERE HERE!")
    print("now calling finish url")
    url = "https://login.microsoftonline.com/common/oauth2/v2.0/token?client_id={client_id}&redirect_uri={redirect_uri}&client_secret={client_secret}&code={code}&grant_type=authorization_code"
    data = {'client_id': settings['od_client_id'], 'client_secret': settings['od_client_secret'], 'redirect_uri': OD_REDIRECT_URI, 'code': request.args['code'], 'grant_type':'authorization_code'}
    url = url.format(client_id=data['client_id'], redirect_uri=data['redirect_uri'] , client_secret=data['client_secret'], code=data['code'])
    headers = {'Content-type': "application/x-www-form-urlencoded"}
    resp = requests.post(url, data=data, headers=headers)
    print("json response:", resp.text)
    obj = json.loads(resp.text)
    
    print("saving tokens")
    cursor.execute("delete from user_creds where user_id=? and auth_type='onedrive'", (session['user']['id'],))
    cursor.execute("insert into user_creds(user_id, auth_type, access_token, refresh_token) values (?,?,?,?)", (session['user']['id'], 'onedrive', obj['access_token'], obj['refresh_token']))
    cursor.execute("update users set od_auth='y' where id=?", (session['user']['id'],))
    session['user']['od_auth'] = 'y'
    conn.commit()
    flash("Your One Drive account was linked successfully!")
    return redirect(url_for("index"))
```	

Once OneDrive redirects me to the `/post_onedrive` endpoint, I just have to complete the process using the code (`request.args['code']`) parameter, so that I can get `access_token` and `refresh_token` values. Once I get these values, I can store them as credentials against that user's account (`user_creds` sqlite table in this case). Once that is done, I (or my app) can access that user's drive any time. The `access_token` credential has a expiration limit of one hour but after that we can get a new `access_token` using the `refresh_token` parameter.

Here is a part of `cron.py` background script which keeps accessing each user's drive by using the `access_token` and `refresh_token` received thus. In this case, the function is used to create a new folder on the user's drive at a given path:

```python
def create_folder_in_od(settings, creds, dst_path, folder_name): # create folder in onedrive
    write_log(0,0,"creating folder in onedrive: %s/%s" % (dst_path, folder_name))
    headers = {'Authorization':'bearer ' + creds['access_token'], "Content-Type": "application/json"}
    drive_url = 'https://graph.microsoft.com/v1.0/me/drive/root:%s:/children' % dst_path
    data = {'name': folder_name, "folder": { }}
    resp = requests.post(drive_url, data=json.dumps(data), headers=headers)
    write_log(0,0,"success!")
```

Here, settings and creds correspond to sqlite rows in settings and user_creds table respectively, which store the app settings (client_id and client_secret) and user settings (access_token and refresh_token) respectively.

The `drive_url` variable consists of two parts: The Microsoft Graph site URL which provides the Drive API (graph.microsoft.com/v1.0) and the particular API endpoint for creating a new folder on the drive (/me/drive/root:<path>:/children). Similarly, there are OneDrive API endpoints for doing other things, they are thoroughly documented, [here](https://docs.microsoft.com/en-us/onedrive/developer/rest-api/resources/driveitem?view=odsp-graph-online) you can find various API endpoints for uploading, downloading, etc.

In the next couple of days, I'll try to put up a demo repo for this whole thing on Github. Until then, Happy Coding!