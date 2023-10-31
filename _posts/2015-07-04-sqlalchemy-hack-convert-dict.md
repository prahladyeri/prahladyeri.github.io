---
layout: post
title: "Sqlalchemy Hack - How to convert a table to dict on the fly"
tags: sqlalchemy python
---

In on of my recent projects, I came across the need to develop a JSON based REST API to fetch data from the `sqlalchemy` objects. Now, the `Query` object is a great way to access data using the powerful `sqlalchemy orm`, but it doesn’t give any built-in way to convert the result-set into a python `dict`.<!--more-->

For instance, I have a `Professor` table in my `models.py`. Here is what I get when I query the `Professor` model using `sqlalchemy` ORM:

	>>> session.query(models.Professor).all()
	2015-07-05 11:07:57,282 INFO sqlalchemy.engine.base.Engine SELECT professors.id AS professors_id, professors.name AS professors_name,
	partment, professors.email AS professors_email, professors.password AS professors_password, professors.phone AS professors_phone
	FROM professors
	2015-07-05 11:07:57,282 INFO sqlalchemy.engine.base.Engine ()
	[<Professor(name=`Albus Dumbledore`)>, <Professor(name=`Severus Snape`)>]

At the end, I got the two Professors’ name in a collection, but they are still `sqlalchemy` objects. How can I convert it to a python dict, so that it can be deserialized to JSON or be used for any other purpose. To solve this, just add the below code to your `models.py` module, and just call the `models.to_dict()` method to convert an sqlalchemy models collection to a dict (or alternatively, call `models.from_dict()` to build the model object collection from an existing dict!):

	def to_dict(model_instance, query_instance=None):
		if hasattr(model_instance, '__table__'):
			return {c.name: str(getattr(model_instance, c.name)) for c in model_instance.__table__.columns}
		else:
			cols = query_instance.column_descriptions
			return { cols[i]['name'] : model_instance[i]  for i in range(len(cols)) }

	def from_dict(dict, model_instance):
		for c in model_instance.__table__.columns:
			setattr(model_instance, c.name, dict[c.name])

The usage is as follows:

	q = dbsession.query(models.Application).filter(models.Application.id==id)
	professors = q.all()
	di = models.to_dict(professors) #for converting a single table resultset

	q = dbsession.query(models.Application)
	application = q.first()
	dd = models.to_dict(app)
	dd['student'] = models.to_dict(application.student, q) #for converting a relationship object which refers to another table. 

The reason we have to use a slightly different approach for the relationship objects (like `application.student` which refers to the `student` model) is that the instance doesn’t have an `__table__` object which is required to build the dict. Hence, the query instance is passed. This is just one approach I’ve used to convert `sqlalchemy` objects to `dict`. If you have any other approach, please let me know.
