---
layout: post
title: "Unpopular Opinion: Implicit Usings are an Anti-Pattern"
tags: dotnet csharp open-source
image: /uploads/code-python.jpg
published: true
---

As someone who has coded across Python, PHP, Java, and C#, I've learned to borrow patterns from each language to improve workflow and maintainability. One principle that has consistently stood the test of time is Python's aphorism: **"Explicit is better than implicit."** It usually leads to robust, readable, and maintainable code.

From this perspective, explicit `using` statements in C# have always been a good practice. They make it immediately clear which namespaces are being used, which is helpful both for current development and for future maintenance.  

.NET Core introduced **implicit usings** by default, and while they aim to reduce boilerplate, I've found several downsides:

### 1. Readability suffers

When you open a C# file in a text editor, you no longer have a clear overview of the namespaces it relies on. For example, compare a traditional explicit block:

```csharp
/**
 * StringHelper.cs
 * 
 * @author Prahlad Yeri
 */
using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
```

…to a file where all these usings are implied. Without the explicit statements, you lose instant visibility into dependencies, making the code harder to reason about, especially months later.

### 2. Potential for ambiguity

Consider calling `Path.Combine()`. Which `Path` does the compiler use—`System.IO.Path` or `iTextSharp.text.pdf.parser.Path`? With explicit usings, you always know. Implicit usings rely on namespace resolution rules, and while the compiler will enforce correctness, it can still lead to maintainability headaches when multiple libraries define similar types.

### 3. Convenience should not trump maintainability

The motivation behind implicit usings—reducing boilerplate—is understandable. Modern tooling like Visual Studio, VS Code, Copilot, and ChatGPT already make adding usings almost effortless. Embedding this convenience into the language itself, however, can encourage less maintainable code.

### My preferred approach

Since moving to .NET Core, I habitually disable implicit usings in new projects. It might seem minor, but it gives me **mental peace** and ensures that my code remains explicit, readable, and maintainable:

```xml
<ImplicitUsings>disable</ImplicitUsings>
```

**Conclusion**

Implicit usings may save a few keystrokes, but they come at the cost of clarity and maintainability. For developers who care about clean, understandable code, explicit usings remain the safer choice.