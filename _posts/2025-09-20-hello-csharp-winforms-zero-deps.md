---
layout: post
title: "Create a C# Windows Desktop App in 9 Lines — No Visual Studio Needed"
tags: dotnet open-source tutorial
---

If you're new to C# and especially desktop development, here's how easy it is to get started on a modern Windows 10/11 PC. This way of creating a Hello World C# program doesn't involve installation of any heavy IDE like Visual Studio or the .NET 8/9 SDK.

In fact, most recent Windows versions already come with .NET Framework 4.x preinstalled, including the classic C# compiler at a location like this:

	C:\Windows\Microsoft.NET\Framework\v4.0.30319
	
The exact folder may differ depending on your system but it usually contains `csc.exe`, the built-in compiler that can compile simple console or desktop apps. You can add this folder to your `PATH` environment variable (temporarily or permanently) so that `csc` is available from the command line:

	set PATH=C:\Windows\Microsoft.NET\Framework\v4.0.30319;%PATH%
	
We will be using this classic, old-school style of programming (similar to writing C programs with `gcc` or `turboc`) — a great way to get acquainted with a new language.

### Step 1: Create the source file

Make a new folder anywhere on your drive. Inside it, create a file named Program.cs using Notepad, VS Code, or any editor you like:

```csharp
using System;
using System.Windows.Forms;

class Program {
	public static void Main() {
		Form frm = new Form();
		frm.Text = "Hello";
		frm.ShowDialog();
	}	
}
```

In just nine lines of C# code, without using any IDE, you now have a working “Hello World” desktop app with no additional dependencies.

### Step 2: Compile and run

Open Command Prompt in your project folder and run:

	csc Program.cs
	Program
	
The first line tells the C# compiler (csc.exe) to build the app into Program.exe. The second one runs it. You can also double-click Program.exe in File Explorer.

![Screenshot of Hello World WinForms app](/uploads/csharp-hello.png)

By default, a console window appears behind the form. To build a GUI-only app without the console, recompile with the `/target:winexe` parameter:

	csc /target:winexe Program.cs
	
### What’s next?
	
In upcoming posts, we’ll add more features such as menus, buttons, event handlers, and even database access with ADO.NET. But for now, enjoy this milestone: you’ve built your very first Windows desktop app in C#!