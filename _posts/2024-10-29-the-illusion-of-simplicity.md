---
layout: post
title: "The illusion of simplicity: how object-oriented programming overcomplicates simple problems"
tags: programming software-engineering agile
image: /uploads/the-illusion-of-simplicity.webp
---

Object-oriented programming (OOP) has been hailed as the savior of the software world, promising more manageable codebases and scalable applications. From encapsulation to inheritance, the paradigm offers a toolkit that is designed to make developers’ lives easier. Yet, over the years, OOP has gained its fair share of critics who argue that the principles it upholds can often lead to overcomplication—especially when applied to simple problems. So, is OOP truly the answer to every software challenge, or is it an illusion of simplicity, cloaking unnecessary complexity beneath a facade of best practices?

In this deep dive, we’ll explore why the abstraction and encapsulation principles of OOP might be overkill for simple problems and when sticking to basic solutions or alternative paradigms can lead to more effective and maintainable code.

## The promise of object-oriented programming: simplicity through abstraction

The core philosophy of OOP is to model software as a collection of objects that interact with each other. It’s akin to representing the real world in code. Principles like inheritance, polymorphism, and encapsulation provide a way to make code modular, reusable, and maintainable. In theory, this sounds like an absolute win.

Consider an example of a basic `Car` class:

```java
class Car {
    private String color;
    private int speed;

    public Car(String color, int speed) {
        this.color = color;
        this.speed = speed;
    }

    public void drive() {
        System.out.println("The car is driving at " + speed + " km/h.");
    }

    public void repaint(String newColor) {
        this.color = newColor;
    }
}
```

On the surface, it looks quite simple and intuitive. If you want to create a car, you instantiate an object with a color and speed, and you can make it drive or repaint it with a method. It's elegant—until complexity starts creeping in.

![the-illusion-of-simplicity](/uploads/the-illusion-of-simplicity.webp)

## When simple tasks become complex 

The illusion of simplicity in OOP begins to unravel when basic requirements evolve. Let's say we need to support a new vehicle type: a truck. Following OOP principles, you may introduce a `Truck` class that inherits from `Car`, or you might abstract both into a common superclass called `Vehicle`. It looks like a small addition, but such minor changes snowball over time.

### Layers of abstraction: How complexity multiplies

In larger OOP-based systems, creating classes for every concept or behavior quickly results in a deep inheritance hierarchy. A simple problem, like managing vehicles, might require dozens of classes and interfaces due to enforced abstraction.

For instance, to accommodate more types like electric cars and motorcycles, you might structure a hierarchy like this:

- **Vehicle** (superclass)
  - **Car** (inherits from Vehicle)
    - **ElectricCar** (inherits from Car)
  - **Truck** (inherits from Vehicle)
  - **Motorcycle** (inherits from Vehicle)

If you now need to add a behavior like `calculateMaintenanceCost()`, you could end up writing it in multiple places or creating an additional abstraction to handle it.

### Encapsulation and its trade-offs

Encapsulation is another tenet of OOP that often contributes to this complexity. While encapsulation helps in hiding internal states and only exposing necessary details, enforcing this for simple problems can create a tangled mess of getters, setters, and boilerplate methods. 

For instance, if the internal state of an object is simple, having strict getters and setters can lead to code that is difficult to refactor. It also creates an illusion that these methods are somehow necessary for safety or maintainability when the underlying data could be as simple as a couple of fields.

This proliferation of unnecessary boilerplate has even led to entire frameworks (like JavaBeans or Lombok in Java) existing solely to reduce the drudgery of writing these repetitive pieces of code. And at that point, you need to ask: Are we truly simplifying things?

## Why OOP may not be the best fit for simple problems

### Misalignment with the problem domain

In many cases, using an OOP approach to solve a simple problem can feel like over-engineering. If all you need is a script that calculates the sum of integers from 1 to 1000, writing a class named `IntegerSummationService` with multiple methods for "abstraction" is absurdly unnecessary. 

### Functional paradigms: Less fluff, more focus

Functional programming (FP) has gained traction as an alternative to OOP precisely because of its emphasis on simplicity and immutability. FP offers the flexibility of defining isolated functions, leading to more straightforward code for many straightforward problems.

For instance, consider how a vehicle maintenance cost might be handled in a functional style:

```python
def calculate_maintenance(vehicle_type, age):
    if vehicle_type == 'car':
        return 200 + (age * 10)
    elif vehicle_type == 'truck':
        return 500 + (age * 20)
    else:
        return 100 + (age * 5)
```

No need for a sprawling class hierarchy; the logic is contained within a small, easy-to-understand function.

### Procedural simplicity for simple needs

Sometimes, basic procedural programming—writing simple scripts and functions—can be more than adequate. For tasks like file reading, processing CSVs, or generating reports, there's often no tangible benefit to wrapping the logic in classes or objects. The code remains more readable and easier to maintain without the OOP overhead.

## The pitfalls of enforced best practices

The notion that OOP is the *only* way to organize code is a fallacy that often leads developers to overthink basic solutions. A classic example of this can be seen in frameworks that enforce design patterns, such as Model-View-Controller (MVC). While MVC is great for complex applications, forcing it on a simple CRUD application can lead to unnecessary classes, interfaces, and abstract factories.

It’s like forcing every home cook to set up a professional kitchen just to make a bowl of cereal.

### An anecdote: The battle with classes and interfaces

Here’s a story that many developers can relate to. I once worked on a project where a senior developer insisted that every single domain object needed an accompanying factory class. For example, to instantiate an order, we had to go through an `OrderFactory`. This was justified as a best practice, and when I inquired about what it achieved, the answer was always the same: *“It’s good design.”*

What it ended up achieving was hundreds of lines of boilerplate code and confused junior developers who spent more time understanding factories than solving actual business problems.

## When OOP works, and when it doesn’t

Of course, there are situations where OOP shines. For large-scale systems with numerous entities and relationships—such as banking systems, e-commerce platforms, or content management systems—OOP can help manage the complexity effectively. The benefits of encapsulation, polymorphism, and inheritance pay off in these scenarios.

However, using the same hammer for every nail isn’t always the right strategy. For smaller projects or simple tasks, other paradigms like functional programming, scripting, or procedural code can be more straightforward, easier to maintain, and require less boilerplate.

## The key takeaway: balance over zealotry

The takeaway here is not to discard OOP altogether. It’s a valuable tool, but one that needs to be wielded judiciously. Treating it as a panacea can lead to an illusion of simplicity that hides layers of unnecessary complexity. As developers, we must remain adaptable, choosing the right paradigm based on the problem at hand rather than blindly adhering to OOP principles.

The next time you’re about to design a new system or refactor an existing one, ask yourself: *Is OOP truly the simplest solution?*

## Sources:

1. **Gamma, Erich, Richard Helm, Ralph Johnson, and John Vlissides. *Design Patterns: Elements of Reusable Object-Oriented Software.* Addison-Wesley, 1994.**

2. **Martin, Robert C. *Clean Code: A Handbook of Agile Software Craftsmanship.* Prentice Hall, 2008.**

3. **Hunt, Andrew, and David Thomas. *The Pragmatic Programmer: Your Journey to Mastery.* Addison-Wesley, 1999.**

4. **Meyer, Bertrand. *Object-Oriented Software Construction.* Prentice Hall, 1997.**

5. **Chiusano, Paul, and Rúnar Bjarnason. *Functional Programming in Scala.* Manning Publications, 2014.**

6. **Gupta, Aditya. "A Comparative Study of Object-Oriented and Functional Programming Paradigms." *International Journal of Computer Science and Information Technologies (IJCSIT).***

7. **Saini, Vaibhav, and Sameer Pradhan. "Object-Oriented vs. Functional Programming: A Comparative Study of Common Software Design Patterns." *ResearchGate.***

8. **Grogono, Peter. "Reflections on the Teaching of Object-Oriented Programming." *ACM SIGCSE Bulletin.***

9. **Brooks Jr., Frederick P. *The Mythical Man-Month: Essays on Software Engineering.* Addison-Wesley, 1975.**