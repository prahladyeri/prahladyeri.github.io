---
layout: post
title: 'How to create a Google Drive App in Flask'
tags: flask python tutorial
---

This is the first in a series of articles for web programmers that explain in detail about using the Google Drive API in your web applications to access files/folders on behalf of the users of your application. In my last project, I had to develop a python flask app for my users that required to access the files stored in their google drive account.<!--more-->

The major challenge for me was to authenticate to google and access the drive on the user’s behalf once they grant permission to my app. This method of authentication is called [OAuth](https://en.wikipedia.org/wiki/OAuth) and is very much needed for implementing the drive api.

However, a good documentation to implement this in a backend app, especially a python web-based app is very much lacking. The so called [quickstart for drive api](https://developers.google.com/drive/v3/web/quickstart/python) shows some example code, but what I needed was a step-by-step tutorial of how to go about doing it. Since I couldn’t find any such tutorial online, I thought about writing one myself.

### I: Register a google app by visiting the [Google API console](https://console.developers.google.com/):

The way the latest version (V3) of drive API works is only through OAuth. It means you cannot put a password or API key inside your code and access the drive files. You need to register your backend app and generate OAuth credentials for the app, so that it can access the drive on the user’s behalf once the user grants permission to the app. So the first step is going to the [Google API console](https://console.developers.google.com/), registering the app itself and generating OAuth credentials. The registration process is pretty straightforward, you just select “Create Project” from the dropdown and give a nice name for your project such as `Flask Drive Example App` in our case.

![Register Google App](/uploads/old/google-apis/drive_api_steps.png)

### II: Configure the credentials and download the client\_id.json file: {#ii-configure-the-credentials-and-download-the-client_idjson-file}

This is the credential file that validates to Google who you are (as a developer) and also your app that acts on your behalf. Download and save it as `client_id.json` in the same directory as the flask app.

![Configure Credentials](/uploads/old/google-apis/configuration_steps.png)

### III: Write your back-end app:

The most important thing to know before building your app is to install these dependencies:

	pip install flask google-api-python-client


You can replace flask with django, pylons or any other framework you use, but this tutorial and code example is based on flask. The principle of accessing the drive api should still apply, so you should be able to make use of this code.

The first thing to do is create a flask object and handle the home page url. It could in fact be any other url in your app, but in this example, I’ve used the home page url (/) to do the OAuth authentication on behalf of the logged in user.

    app = flask.Flask(__name__)

    @app.route('/')
    def index():
        credentials = get_credentials()
        if credentials == False:
            return flask.redirect(flask.url_for('oauth2callback'))
        elif credentials.access_token_expired:
            return flask.redirect(flask.url_for('oauth2callback'))
        else:
            print('now calling fetch')
            all_files = fetch("'root' in parents and mimeType = 'application/vnd.google-apps.folder'", sort='modifiedTime desc')
            s = ""
            for file in all_files:
                s += "%s, %s<br>" % (file['name'],file['id'])
            return s

We first check whether we have the drive access credentials for the user locally stored in a file. This is done by the `get_credentials()` function that checks the local access token file credentials.json (not to be confused with client\_id.json we downloaded earlier which is for developer credentials). Again, we are assuming a single user scenario here. If your drive app needs to authenticate with multiple users, you’ll have to store separate credentials.json for each logged-in user in the database, and access that through a session or something.

Further, if credentials aren’t found locally or have expired, we direct them to `/oauth2callback`, so google will authenticate them and send us the token for accessing the drive, post which, we will put that token into the local file, credentials.json and redirect the user back to this index site. Finally, if the credentials are valid, we call the `fetch()` function that displays the list of all root folders in that user’s drive along with their IDs. Here is the code for `oauth2callback`:

    @app.route('/oauth2callback')
    def oauth2callback():
        flow = client.flow_from_clientsecrets('client_id.json',
                scope='https://www.googleapis.com/auth/drive',
                redirect_uri=flask.url_for('oauth2callback', _external=True)) # access drive api using developer credentials
        flow.params['include_granted_scopes'] = 'true'
        if 'code' not in flask.request.args:
            auth_uri = flow.step1_get_authorize_url()
            return flask.redirect(auth_uri)
        else:
            auth_code = flask.request.args.get('code')
            credentials = flow.step2_exchange(auth_code)
            open('credentials.json','w').write(credentials.to_json()) # write access token to credentials.json locally
            return flask.redirect(flask.url_for('index'))

Once you have the credentials locally (in the form of `credentials.json`), you can just use it to access the drive API. Thus, the result of this whole exercise is that only on first page load is the user redirected to google site to authenticate themselves. Once the app has the access token (credentials.json), its no longer required, the result is displayed directly on the page from then on. If all goes well, you should be able to see a screen such as this when you test this example app for the first time:

![Google OAuth Screen](/uploads/old/google-apis/oauth_screen.png)

I’ve also included the functions to download and upload files to the drive as they will be very useful:

    def download_file(file_id, output_file):
        credentials = get_credentials()
        http = credentials.authorize(httplib2.Http())
        service = discovery.build('drive', 'v3', http=http)
        #file_id = '0BwwA4oUTeiV1UVNwOHItT0xfa2M'
        request = service.files().export_media(fileId=file_id,mimeType='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
        #request = service.files().get_media(fileId=file_id)
        
        fh = open(output_file,'wb') #io.BytesIO()
        downloader = MediaIoBaseDownload(fh, request)
        done = False
        while done is False:
            status, done = downloader.next_chunk()
            #print ("Download %d%%." % int(status.progress() * 100))
        fh.close()
        #return fh
        
    def update_file(file_id, local_file):
        credentials = get_credentials()
        http = credentials.authorize(httplib2.Http())
        service = discovery.build('drive', 'v3', http=http)
        # First retrieve the file from the API.
        file = service.files().get(fileId=file_id).execute()
        # File's new content.
        media_body = MediaFileUpload(local_file, resumable=True)
        # Send the request to the API.
        updated_file = service.files().update(
            fileId=file_id,
            #body=file,
            #newRevision=True,
            media_body=media_body).execute()


------------------------------------------------------------------------

I’ll leave the more comprehensive use of these functions as an exercise to the reader who wants to develop a more fully featured app out of this. Click the below link to download the `flask_drive_example.py` script for this example implementation from the Github gist:

- [ flask\_drive\_example.py](https://gist.githubusercontent.com/prahladyeri/0b92b9ca837a0f5474c732876220db78)
