---
layout: post
title: 'Rockstar Java Series: Use default methods and be a better coder'
tags: java
---

**Java 8** comes with a lot more improvements and features than most people seem to realize. One such feature that can help you become a better Java coder is **Default methods**.<!--more-->

To learn just how useful this feature is, lets take a very plain simple example: A `Product Interface`. Suppose that you are a Java Engineer who is just appointed as the Backend Developer in Acme Trading Corporation to develop their new eCommerce system. Suppose Acme has a range of electronic products ranging from computers to cell phones and hard drives to printers. Being a design-oriented programmer, you develop a `Product` Interface and a generic `BaseProduct` class for all products:

	//Product.java
	interface Product
	{
		String getName();
		void setName(String value);
		
		String getDescription();
		void setDescription(String value);
		
		double getRate();
		void setRate(double value);
		
	}

	//BaseProduct.java
	class BaseProduct implements Product
	{
		private String name;
		private String description;
		private double rate;
		
		
		public void setDescription(String value) {
			description = value;
		}
		
		public String getDescription() {
			return description;
		}
		
		public void setName(String value) {
			name = value;
		}
		
		public String getName() {
			return name;
		}
		
		public void setRate(double value) {
			rate = value;
		}

		public double getRate() {
			return rate;
		}

		public static void main(String[] args)
		{
			BaseProduct product = new BaseProduct();
			product.setName("Foo");
			System.out.println(product.getName());
		}
	}

You realize that all products have at least these three things in common: `Name`, `Description` and `Rate`. Then, you start implementing the `Laptop` class based on the `BaseProduct` class:

    //Laptop.java
    class Laptop extends BaseProduct
    {
        private String cpuType;
        private int usbPorts;
        
        public String getCpuType() {
            return cpuType;
        }
        
        public void setCpuType(String value) {
            cpuType = value;
        }

        public int getUsbPorts() {
            return usbPorts;
        }
        
        public void setUsbPorts(int value) {
            usbPorts = value;
        }
        
        
        public static void main(String[] args)
        {
            Laptop laptop = new Laptop();
            laptop.setName("Dell Inspiron");
            System.out.println(laptop.getName());
        }
    }

Now imagine that you have created lots of classes for all Acme products in this manner including `Television`, `Refregerator`, `Keyboard`, etc.

Now, you are just 10 days from releasing the final version of your mind-blowing Product Management System when suddenly your boss tells you that you also need a `Rating`, but only for some products. Naturally, you being a techie who just sips coffee in front of the computer screen the whole day just didn’t realize how the end customers might interact with your system. So, how will you add `Rating` to the system now?

The classic approach in Java is to just add a `Rating` property to each and every individual product class of yours that needs a `Rating`:

	//Laptop.java
	class Laptop
	{
		//Classic Java Programmer Approach
		public String getRating() {}
		public void setRating(float value) {}
		
		//.....
	}

This is a pretty naive approach to this problem. For one, you already have about 100 classes for various products and you will have to go to each one and implement this method. Secondly, you will also break binary compatability with existing versions of your system, so you cannot release this one backend class without replacing your entire system. Another approach is to convert the `Product` interface to an abstract class, but again, why unnecessarily involve private state when it isn’t needed in the first place. Secondly, a `BaseProduct` can derive from only one abstract-class but multiple interfaces, so what will you do when you will have to implement more interfaces in future?

The most apt solution to this problem is that provided by `Java 8`: *default method*. Just add default methods for `Rating` to your interface as follows and problem solved!

	//Product.java
	interface Product
	{
		//Rockstar Java Programmer Approach
		default String getRating() {
			System.out.println("I am the default method for getRating!");
			return "";
		}
		
		default void setRating(String value) {
			System.out.println("I am the default method for setRating!");
		}
		
		String getName();
		void setName(String value);
		
		String getDescription();
		void setDescription(String value);
		
		double getRate();
		void setRate(double value);
	}

The single most important advantage of `default method` is `interface evolution` - meaning that your existing code won’t loose ABI (`Application Binary Interface`) with the new class. If your interface is a part of a libary jar that you distribute to your users, you can release the newer version without affecting the already running code that might be referring to older jars.

The inspiration for this came when Oracle themselves had to extend the `Collection` interface and add a new `stream` method in `Java 8`. The `Collection` interface is very generic and a large number of classes implement that. If Oracle had to implement a `stream` method in each and every class derived from `Collection` interface, it would have taken them ages to release Java 8! Rather, they invented this helpful new feature, `default method` to extend their `Collection` interface. And now, they don’t have to worry about ABI. Old code referring to JDK 8 libraries will not fail because they are now binary compatible thanks to default methods!

*References:*

- <http://stackoverflow.com/q/19998454/849365>
- <http://programmers.stackexchange.com/q/233053/849365>
- <http://examples.javacodegeeks.com/java-basics/java-8-default-methods-tutorial/>