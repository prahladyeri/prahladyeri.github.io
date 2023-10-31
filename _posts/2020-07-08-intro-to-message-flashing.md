---
layout: post
title: Intro to Message Flashing: A handy way to send messages across page requests in Flask
tags: python flask flash
---

Message flashing is a very handy technique you must be aware of if you are a Flask developer. A common recurring pattern in web development is to send messages across web requests, especially in case of redirects when the route or controller that redirected wants to display some basic text message (such as "Login Successful!") on the target page after redirection.

![source code](/uploads/code.jpg)

Let's look at this simple example app which asks for a username/password, then redirects user to a special page ("/homepage") if the validation was successful.

```python
from flask import Flask, request, redirect, url_for

app = Flask(__name__)

@app.route("/homepage")
def homepage():
    message = "You have been logged in!"
    return message + "<br>Welcome to home page"
    

@app.route("/", methods=['GET','POST'])
def index():
    if request.method == 'POST':
        if request.form['username'] == 'admin' and request.form['password'] == 'admin':
            return redirect(url_for("homepage"))
        else:
            return "Incorrect username/password."
    elif request.method == 'GET':
        return """
<!doctype html>
<html>
<head></head>
<body>
    <form method="POST">
        <input name='username' placeholder='Username' required> <br>
        <input type='password' name='password' required> <br>
        <button type="submit">Login</button> <br>
    </form>
</body>
</html>
"""
	
if __name__ == "__main__":
	app.run(debug=True)
```

Now, there are two basic problems here. Firstly, the home page always displays "You have been logged in!" but what if I want to display it conditionally (i.e when the user has just performed a successful login) and not each time? Secondly, there is also the case that I may want to customize this message (with a user greeting, for example).

Before knowing about the message flashing technique, I used to use the cumbersome technique of storing such custom values to the session object, then reading the session object in the corresponding target route ("/homepage"). But now, I've found a much simpler and easier way which is message flashing. All you have to do is add an import to `flask.flash` and `flask.get_flashed_messages` class methods in your code and call it just before a redirection:

```python
from flask import flash
...
...
...
flash("You have been logged in!")
return redirect(url_for("homepage"))
```

You can also add a second parameter to `flash` call which is the category it is meant for (such as error, info, etc.). Once you flash a message, all you must do on the target route ("/homepage") is fetch the last flashed message like this:

```python
message = get_flashed_messages()[0]
return message + "<br>Welcome to home page"
```

Of course, if you happen to use a `jinja2` template for displaying output then `get_flashed_messages()` is [directly callable in that too](https://flask.palletsprojects.com/en/0.12.x/patterns/flashing/):

```python
{% with messages = get_flashed_messages(with_categories=true) %}
  {% if messages %}
    <ul class=flashes>
    {% for category, message in messages %}
      <li class="{{ category }}">{{ message }}</li>
    {% endfor %}
    </ul>
  {% endif %}
{% endwith %}
```

After playing with message flashing for some time, I came to know that it also uses the session object internally. For example, it won't work if you omitted the `app.secret_key` attribute before starting the app. As I said earlier, all of the above can be done using sessions too but message flashing is a more efficient way of doing it and requires less code. And the end, finding efficent ways of achieving things is what we programmers should be striving for, enjoy!