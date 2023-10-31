---
layout: post
title: "Rockstar Java Series: Learn type annotations and be a better coder"
tags: java
---

*Java SE 8* comes with a bundle of new features, and not many of them catch the attention of coders until they learn what they are and realize their usefulness. One such feature that can help you become a better Java coder is the ability to declare *type annotations* to any type use.<!--more-->

Before *Java SE 8* came out, *type annotations* could only be applied to declarations, but now they can be applied to any type use such as declarations of variables or methods, *class instance* creation, *casts*, *interface* creation, *implements* clauses, *throws* clauses, etc.

*Type annotations* were created to support improved analysis of Java programs by introducing stronger type checking. The more the *Java compiler* and *JVM* knows about your `bytecode`, the more equipped they are to perform better in the real world across all platforms.

What are Type Annotations?
--------------------------

In its basic form, an annotation looks like the following:

	@entity

The variable after `@` symbol tells the Java compiler that what follows is a type annotation. A standard example of a built-in type annotation is `@Override`:

	@Override
	public void talk()
	{
		System.out.println("I am an overridden method");
	}

The `@Override` type annotation tells the Java compiler that what follows is an overridden method from the base class. Of course, you can even place multiple type annotations for the same declaration:

	@Override
	@SuppressWarnings("unchecked")
	void myMethod() { ... }

*Java SE 8* is so flexible that it allows you to define your own type annotations!

How to create your own Type Annotations?
----------------------------------------

Imagine there is a Software firm called *Acme Corporation* that develops Java software for its large number of clients. The standard Java practice there is to declare header files in each and every Java source file (\*.java) like this:

    /**
     * @copyright Amce Corporation Inc.
     * @author Prahlad Yeri
     * @date 25-12-2015
     * @version 1.1
     * */
    class Duck 
    {
        public void talk() {}
    }

Sound familiar? This is a pretty much common header style nowadays. This same information could be structured by using your own type annotation and it becomes so, so simple:

    @Classinfo(
        author = "Prahlad Yeri",
        date = "25-12-2015"
    )
    class Duck 
    {
        public void talk() {}
    }

In order to use your `@Classinfo` type annotation, you must declare it. Annotation declaration in Java is similar to how interfaces are declared. In fact, annotations are a kind of interface themselves:

    @interface Classinfo 
    {
        String copyright() default "Acme Corporation Inc.";
        String author();
        String date();
        String version() default "1.1";
        String lastModified() default "";
        String lastModifiedBy() default "";
        String codeReviewBy() default ""; 
    }

You can see that default values are given for `copyright`, `version`, `lastModifiedBy`, etc. so they are not basically required. If you need multiple author declaration, you can turn it into a list:

	String[] author();

And then proceed to define multiple authors when using the type annotation in this manner:

    @Classinfo(
        author = {"Prahlad Yeri", "John Doe"},
        date = "25-12-2015"
    )

Built-in type annotations in Java
---------------------------------

Java comes with a bunch of type annotations pre defined. The ones we saw in this tutorial were `@Override` and `@SuppressWarnings`. Here is the entire list:

- @Deprecated annotation indicates that the marked element is deprecated and should no longer be used.
- @Override annotation informs the compiler that the element is meant to override an element declared in a superclass.
- @SuppressWarnings annotation tells the compiler to suppress specific warnings that it would otherwise generate.
- @SafeVarargs annotation, when applied to a method or constructor, asserts that the code does not perform potentially unsafe operations on its varargs parameter.
- @FunctionalInterface annotation, introduced in Java SE 8, indicates that the type declaration is intended to be a functional interface, as defined by the Java Language Specification.
- @Documented annotation (*only to be used in case of annotation declaration*) indicates that whenever the specified annotation is used those elements should be documented using the Javadoc tool. (By default, annotations are not included in Javadoc.)

*References:*

- [Official Oracle docs - Type Annotations](https://docs.oracle.com/javase/tutorial/java/annotations/index.html)
- [Official Oracle docs - Type Annotations Basics](https://docs.oracle.com/javase/tutorial/java/annotations/basics.html)
- [Official Oracle docs - Predefined Type Annotations](https://docs.oracle.com/javase/tutorial/java/annotations/predefined.html)