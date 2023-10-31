---
layout: post
title: 'Rockstar Java Series: Using Lambda expressions to up your game'
tags: java
---

**Java 8** comes with a lot more improvements and features than most people seem to realize. One such feature that can boost your productivity as a Java Programmer is **Lambda expressions**.<!--more-->

To learn just how beneficial this oft less understood feature is, lets take a very simple example: A `Product search function`, and see how various traditional approaches to this problem fare out. Since eCommerce stores and shopping cart apps have become quite a buzzword of late, lets make a simple implementation of product search by name:

    //Navie approach
    public static List<Product> search(List<Product> stock, String name) 
    {
        ArrayList<Product> r = new ArrayList<Product>();
        for (Product p : stock)
        {
            if (p.name.compareTo(name)==0) {
                r.add(p);
            }
        }
        return r;
    }

This is the naivest approach a programmer can possibly take when writing a product search method. The assumption here is that name is going to be the only criteria to search the product catalog. Suppose, you were working as a Java Programmer for a small eCommerce store and you wrote this function, only to realize that your users want a price comparison feature too. So, you add two extra parameters for price range to the search method like this:

    //Classic Java Programmer approach
    public static List<Product> searchWithRange(List<Product> stock, String name, double minValue, double maxValue)
    {
        ArrayList<Product> r = new ArrayList<Product>();
        for (Product p : stock)
        {
            if (p.name.compareTo(name)==0 && (p.price>=minValue && p.price<=maxValue)) {
                r.add(p);
            }
        }
        return r;
    }

This is the classic Java Programmer pattern - if you want to change behavior of a class, just add more parameters to methods. Even a lot of experts do this forgetting the repercussions. For one, each and every change impacts the `public interface` of your class. Meaning, if you have distributed this class as part of a library `jar` to any fellow programmers, you must recompile your library package again just for adding one extra parameter. Expert programmers realize this, so they come up with `Interfaces`. In this example, an Expert programmer will try to separate out the search comparison logic from the search scanning (for loop) and define a `ProductFilter` interface such as this:

    interface ProductFilter
    {
        public boolean run(Product p);
    }

This interface is just a “contract” that asks users to define a `run` method for comparing a product and return a matching boolean result to include it in the result or not. With this interface, our search method becomes lot more flexible:

    //Expert Java Programmer approach
    public static List<Product> searchWithInterface(List<Product> stock, ProductFilter filter)
    {
        ArrayList<Product> r = new ArrayList<Product>();
        for (Product p : stock)
        {
            if (filter.run(p)) {
                r.add(p);
            }
        }
        return r;
    }

You see, the class is more generic and flexible now. It can take up whatever new criteria like product size (“15+ inch LCD screens”) or product ratings (“four stars plus”) you come up with. Here is a simple example of using this search method:

    List<Product> r =  Product.searchWithInterface(list,new ProductFilter(){
        public boolean run(Product p) {
                return (p.name=="foo" && (p.price>=10 && p.price<=50) && p.size=="15in");
            }
        });

This is how you would have done things if you were an Expert Java programmer until JDK 7.0, but JDK 8.0 has changed everything! With *lambdas*, the above implementation becomes even more flexible and powerful. Firstly, because the interface `ProductFilter` has only one method, it is a `functional interface`. With functional interfaces, you can directly assign them `lambda expressions`, so the above search application becomes as simple as this:

      List<Product> r =  Product.searchWithLambda(list,
        (Product p) -> (p.name.equals("foo") && (p.price>=10 && p.price<=50) && p.size.equals("15in"))); //rockstar2

The syntax for a lamdba is as follows: Arguments in braces, followed by the arrow symbol, followed by statements that return a value:

	(arguments) -> (statements)


In fact, a Rockstar Java programmer will think that he/she no longer needs the `ProductFilter` interface now. That’s because the package `java.util.function` comes bundled with several generic interfaces that are pretty easy to use with lambdas. For instance, using the `Predicate<T>` Interface, our search method no longer needs an interface now!

	//Rockstar Java Programmer approach
	public static List<Product>  searchWithLambda(List<Product> stock, Predicate<Product> filter) 
	{
		ArrayList<Product> r = new ArrayList<Product>();
		for (Product p : stock)
		{
			if (filter.test(p)) {
				r.add(p);
			}
		}
		return r;
	}

The interface `java.util.function.Predicate` is a generic interface that contains a generic method named `test()` (notice we changed `run` to `test` in order to use this interface). The package `java.util.function.*` contains several other useful interfaces like `Predicate` that can help you in many such situations.

Good programming is all about minimalism and reducing code-bloat. Whilst implementing a new paradigm in your existing code might sometime clash with your other constraints like delivery time and number of available developers, I personally think that in the long run, all these efforts spent usually pay off. The pay-off could be in the form of more re-usability, more readability of code, fewer bugs and in most cases all of them.

[Here](https://gist.github.com/prahladyeri/0577b5a01ccaa8206e80) is the complete implementation of `Product.java`. Today we learned about Lambda expressions, an important new feature in Java 8. In the next part of the series we will learn about `default methods`, another great Java feature to make your life easier!

*References:*

- <https://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html>
- <https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html>
