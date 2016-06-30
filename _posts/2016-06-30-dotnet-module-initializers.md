---
layout: post
title: Using ModuleInit
tags:
- security
- .net
---

Code at [github](https://github.com/oddbear/ModuleInitTest).

Module Initializers is something most .Net developers has never heard about.
It's a part of .Net, but not supported in the C# language (as C# does not support global functions).
However, since .Net itself supports it, you should be aware that it exists.
A Module Initializer is a piece of code that runs before any other code in the .Net application, and can be triggered in some situations even with just reading metadata:

Either by:
<code>typeof(SomeProject.SomeClass).FullName</code>.

Or:

```csharp
var assembly = Assembly.Load("SomeProject"); //Use ReflectionOnlyLoad
var type = assembly.GetType("SomeProject.SomeClass");
var attributes = type.GetMethod("SomeMethod").GetCustomAttributes();
```

By using fody with ModuleInit [link](https://github.com/Fody/ModuleInit), you can actually create Module Initializers in a C# project.
What it does is copy the compiled IL of a special method, and creating a Module Initializer out of it.

```csharp
public static void Initialize()
{
    var ad = AppDomain.CurrentDomain;
    try
    {
        var ps = ad.PermissionSet;
        Console.WriteLine("Works Do bad stuff here!");
    }
    catch(MethodAccessException ex)
    {
        Console.WriteLine("Exeption Happend! :O");
    }
}
```

If you don't want this code to run for some reason, ex if want to setup a sandbox for some protection with partial trusted code.
It could be wise to use <code>Assembly.ReflectionOnlyLoad()</code> instead of <code>Assembly.Load()</code>.

{% include disqus.html %}
