---
layout: post
title: An Introduction to Go - Elegance with Power and Simplicity
tags: go
---

Whilst I usually try to stick with only "bread-butter" languages (i.e. php, python, java & C\#), my last project involved the [Google appengine](https://developers.google.com/appengine) web app written in Google's own flagship [Go](https://en.wikipedia.org/wiki/Go_%28programming_language%29) language.<!--more-->

Being a polyglot who is always intrigued by new languages, I couldn't help being curious about how it was coding with Go, hence I took on the project. My experience of coding with Go was so gratifying that I couldn't help but share it with you.

 

Go has a unique blend of elegance combined with power: For coding and maintaining apps in any language, readability is a very important feature. As your project size grows bigger and bigger, this becomes more and more important. In fact, you are even prepared to sacrifice some performance gain achieved by low level languages like C to get the developer productivity achieved through more 'readable' languages like java and python. This factor partly explains why less and less programs are coded in C/C++ now and more in java. It also explains the recent popularity of python, an interpreted and relatively 'low performance' language compared to its siblings, Java and C++.

 

What Go brings to the table is a graceful combination of both readability and performance. Yes, unbelievable but true! It has the compiler and the strongest type system like that of C/C++ coupled with a syntax that feels home with dynamic languages like python. It even has the simplicity that is comparable to python.

 

Syntactically, Go is based on C++, but with lots of modifications that make it easy to use, such as:

 

1\. No semicolons (;) to end the statements;

2\. No type declaration needed like C (int i=2;). In Go, types are automatically “guessed” from value (i := 2).

3\. No containing braces required statements like for and if.

 

An example would be helpful here to grasp how Go is different and better. Consider a simple square-root calculation function in C++:

 

	float Sqrt(float x) {
		int z = 1.0;
		for (int i= 0; i < 1000; i++) {
			z -= (z*z - x) / (2 * z);
		}
		return z;
	}

 

Now here the same function written in Go:

 	package newmath

	func Sqrt(x float64) float64 {
		z := 1.0
		for i := 0; i < 1000; i++ {
			z -= (z*z - x) / (2 * z)
		}
		return z
	}
 

Did you notice a few things about Go? For instance:

 

*1. Less clunkiness:* No need of hashes, braces around the ifs/fors and no need of semicolons to end statements (some of you might argue about semicolons, saying it allows you to quickly combine multiple statements on one line, but do you realize how less readable code you are creating by doing that?)

 

*2. Dynamism:* The := is a “short assignment” operator in Go, meaning that you don't need to specify its type. “z:=1.0” is certainly more elegant compared to “float z = 10;”.

 

*3. Efficient compilation:* Despite the dynamic nature of this language that seems to suggest an interpreted nature, Go compiles and runs as efficiently as a low-level language such as C/C++.

 

Another reason for investing your skills in Go is that Go has [Google's backing](https://developers.google.com/appengine/docs/go/). Indeed, the language itself is a Google invention and Google has started implementing it in most of its projects such as the [Google Appengine](https://developers.google.com/appengine) cloud hosting service.

 

A controversy that might indirectly pave the way for Go's success is the looming high-profile [Oracle vs Google](https://en.wikipedia.org/wiki/Oracle_v._Google) lawsuit about Oracle's accusations that Google incorrectly used its copyrighted Java APIs for implementing its Android operating system. Its quite unlikely that Oracle is able to get away with its claims, but if the uncertainty regarding this stays for any time longer, its very much possible that Google will gradually start building its Android APIs in Go language slowly discarding the Java APIs.

 

Now I'm not a fortune-teller, but looking at the way things are currently positioned, Go doesn't look like a language that is going to fade anytime soon.

You can have a look at official Go docs, tutorials and a list of libraries and utilities provided in references below. Happy learning Go Language!

 

*Note: If you are running a debian based linux system like ubuntu, you can install golang using the CLI:*

*sudo apt-get install gccgo*

 

*References:*

<http://golang.org/help/>

[http://golang.org](http://golang.org/)

<https://code.google.com/p/go-wiki/wiki/Projects>

<http://golang.org/doc/faq>

<https://developers.google.com/appengine/docs/go/>

<https://en.wikipedia.org/wiki/Go_%28programming_language%29>

[ https://en.wikipedia.org/wiki/Oracle\_v.\_Google](https://en.wikipedia.org/wiki/Oracle_v._Google)
