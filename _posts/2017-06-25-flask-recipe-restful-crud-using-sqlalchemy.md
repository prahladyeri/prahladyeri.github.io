---
layout: post
title: 'Flask Recipe - RESTful CRUD using sqlalchemy'
tags: flask python sqlalchemy how-to
---

RESTful apps are a thing these days. When your application’s userbase gets quite large and the client could vary from a laptop to an android device to an iOS device, it pays to keep the backend code separate and use the server only for making RESTful calls using HTTP methods that pertain to basic OLTP transactions: SELECT, INSERT, UPDATE and DELETE.<!--more-->

Popular third-party apps like [Firebase](https://en.wikipedia.org/wiki/Firebase#Realtime_Database) essentially provide you this same thing - A REST based front to a database that could be accessed online using simple HTTP methods. But in this tutorial, we will learn how to create such a backend ourselves using Python’s `flask`{.highlighter-rouge} framework and `sqlalchemy`{.highlighter-rouge}, a light-weight but powerful ORM library that can access ANY database using its flexible *sql expression language*.

![RESTful CRUD App](/uploads/old/restful-crud.png)

Rather than using firebase, if you develop your own implementation of your back-end, not only will it help you learn and become a better programmer, but also give you a flexible solution that you can scale and change as per your needs. Its also much cheaper to host your own solution on Amazon EC2 (or Lambda) compared to other costlier alternatives.

Contrary to popular thinking, its not very difficult to create a database agnostic backend such as the one represented in the above diagram. With a minimal and powerful web framework such as `flask`{.highlighter-rouge}, combined with the power of `sqlalchemy`{.highlighter-rouge}, you can get up and running within minutes. In fact, I’ve developed a prototype version called [Tiddly](https://github.com/prahladyeri/tiddly) that essentially does the same thing as above using just 172 lines of Python code. You can refer to that github repository for reference as we proceed through this tutorial, or directly start using it. But make sure you install the following dependencies before running it:

	pip install flask
	pip install sqlalchemy

The first step towards creating the app is creating your database models. Once you’ve done the brainstorming and decided what tables and fields you are going to need, you can create a `models.py`{.highlighter-rouge} source file with something like this:

	import sqlalchemy
	from sqlalchemy import create_engine
	from sqlalchemy import Column, String, Integer
	from sqlalchemy.orm import sessionmaker
	from sqlalchemy.ext.declarative import declarative_base

	#TODO: Change as needed:
	engine = create_engine("sqlite:///tiddly.db", echo=True)
	Base = declarative_base()

	Session = sessionmaker(bind=engine)
	dbsession = Session()

	class User(Base):
		__tablename__ = "user"
		id = Column(Integer, primary_key=True)
		email = Column(String)
		password = Column(String)
		name = Column(String)
		def repr(self):
			return "<User(name=%s, email=%s, )>" % (name, email)
			
	class Dual(Base):
		__tablename__ = "dual"
		id = Column(Integer, primary_key=True)
		text = Column(String)
		def repr(self):
			return "<Dual(id=%s, text=%s, )>" % (id, text)

I’m using sqlite database for example here, but you can use any one of your choice. A `user`{.highlighter-rouge} table is a pretty basic one in almost every app as it is used for authentication. Apart from that, I’ve also created a `dual`{.highlighter-rouge} table just to play around with.

After that, create the second file `app.py`{.highlighter-rouge} that contains our application code. Define the following import statements along with your models as they will come very handy:

	import flask
	from flask import request, jsonify, session
	import sqlalchemy
	from sqlalchemy import inspect, desc
	import json
	import models
	from models import engine, dbsession

Now, the only thing that remains to be done is the plumbing the `HTTP`{.highlighter-rouge} methods to their respective database operations. You can either create a separate view function for each one or use a single one for all of them. In this example, I’m using a single function for simplicity.

	@app.route("/<table_name>", methods=["POST", "PUT", "DELETE", "FETCH"])
	def fetch(table_name):
		print("verb: %s, tablename: %s" % (request.method, table_name))
		if request.method == "POST" or request.method == "PUT":
			data = request.get_json(force=True)
			print("data:", data)
			try:
				TableClass = models.get_class_by_tablename(table_name)
				if TableClass == None: raise Exception("Table not found: %s" % table_name)
				if request.method == "POST": #insert data
					object = TableClass(**data)
					dbsession.add(object)
					dbsession.commit()
				else: #update data
					object = dbsession.query(TableClass).filter_by(**{"id":id}).first()
					if object == None: raise Exception("No data found.")
					#object.update(**data)
					for key in data.keys():
						setattr(object, key, data[key])
					#dbsession.add(object)
					dbsession.commit()
				return jsonify({
					"status": "success",
					"id": object.id,
					})
			except Exception as e:
				return jsonify({
					"status": "error",
					"error": str(e),
					})
		elif request.method == "DELETE":
			try:
				TableClass = models.get_class_by_tablename(table_name)
				if TableClass == None: raise Exception("Table not found: %s" % table_name)
				object = dbsession.query(TableClass).filter_by(**{"id":id}).first()
				if object == None: raise Exception("No data found.")
				dbsession.delete(object)
				dbsession.commit()
				return jsonify({
					"status": "success",
					"id": object.id,
					})
			except Exception as e:
				return jsonify({
					"status": "error",
					"error": str(e),
					})
		elif request.method == "FETCH":
			try:
				data = request.get_json(force=True)
				data = json.loads(data)
				print("data: ", data)
				print("data-type: ", type(data))
				TableClass = models.get_class_by_tablename(table_name)
				if TableClass == None: raise Exception("Table not found: %s" % table_name)
				
				query = dbsession.query(TableClass).filter_by(**data['where'])
				if 'orderby' in data:
					for cname in data['orderby'].split(','):
						reverse = False
						if cname.endswith(' desc'):
							reverse = True
							cname = cname[:-5]
						elif cname.endswith(' asc'):
							cname = cname[:-4]
						print("cname: ", cname)
						column = getattr(TableClass, cname)
						if reverse: column = desc(column)
						query = query.order_by(column)
				if 'limit' in data:
					query = query.limit(data['limit'])
					query = query.offset(data['offset'])
				object = query.all()
				data = [object_as_dict(t) for t in object]
				return jsonify({
					"status": "success", 
					"data": data
					})
			except Exception as e:
				return jsonify({
					"status": "error",
					"error": str(e),
					})
		else:
			return jsonify({
				"status": "error", "error": "Unrecognized verb.",
				})

I’ve used a non-standard HTTP method, `FETCH`{.highlighter-rouge} for the `SELECT`{.highlighter-rouge} action. That’s because if you use the `GET`{.highlighter-rouge} method, you aren’t allowed to actually post data (as in actual posting, don’t confuse with `POST`{.highlighter-rouge} method) as per the HTTP specification. The other methods, viz `POST`{.highlighter-rouge}, `PUT`{.highlighter-rouge} and `DELETE`{.highlighter-rouge} are self-apparent and they stand for `INSERT`{.highlighter-rouge}, `UPDATE`{.highlighter-rouge} and `DELETE`{.highlighter-rouge} actions respectively.

As you can see, the app makes good use of the sql expression language of sqlalchemy to dynamically query any kind of data, not only using the usual `where`{.highlighter-rouge} clause, but also using ordering and pagination (limit/offset) parameters:

	if 'orderby' in data:
		for cname in data['orderby'].split(','):
			reverse = False
			if cname.endswith(' desc'):
				reverse = True
				cname = cname[:-5]
			elif cname.endswith(' asc'):
				cname = cname[:-4]
			print("cname: ", cname)
			column = getattr(TableClass, cname)
			if reverse: column = desc(column)
			query = query.order_by(column)
	if 'limit' in data:
		query = query.limit(data['limit'])
		query = query.offset(data['offset'])

The front-end sends whatever it needs to the back-end using JSON format and the result is also in JSON. For example, the following JSON when posted to `/user`{.highlighter-rouge} endpoint using `FETCH`{.highlighter-rouge} method, returns the record from user table where `name`{.highlighter-rouge} field matches `admin`{.highlighter-rouge} and orders the results by email in descending order.

	{"where": {"name":"admin"}, "orderby": "email desc"}

Adding the `limit`{.highlighter-rouge} and `offset`{.highlighter-rouge} clauses to the same can help the front-end with pagination.

	{"where": {"name":"admin"}, "orderby": "email desc", "limit":2, "offset": 2}

Its also pretty trivial to implement user authentication with this design. I haven’t done it in this example for simplicity, but you can find it in the [github code](https://github.com/prahladyeri/tiddly).

All code in this tutorial and on github is `MIT`{.highlighter-rouge} licensed and free to use. So, enjoy coding, build your own RESTful CRUD app!