---
layout: post
title: "EB Code explained"
tags: [dotnet]
---
For a long time I, had a block of code on my [web site](http://eurobear.net), that for many was hard to understand:

```csharp
static unsafe void Main()
{
    string a = "a";

    fixed (char *p = a)
    {
        p[0] = 'b';
    }

    Console.WriteLine("a"); //"b"
}
```

What happens here is a little bit of optimization magic in the .Net CLR.
When having two equal strings hardcoded, the address in memory will be the same.
This is because .Net uses a string table, aka. an [intern pool](https://msdn.microsoft.com/en-us/library/system.string.intern).

By default, a new string created in runtime does not reference the same address, but you can put (or get the old) string on the pool by using the <code>string.Intern</code> keyword.

Se example:

```csharp
string a = "A", b = "B";

Object.ReferenceEquals(a, "A").Dump(); //True
var ab = a + b; //"AB"
Object.ReferenceEquals(ab, "AB").Dump(); //False
Object.ReferenceEquals("A" + "B", "AB").Dump(); //True
var internString = string.Intern(a + b).Dump(); //"AB"
Object.ReferenceEquals(internString, "AB").Dump(); //True
```

String are [immutable](https://msdn.microsoft.com/en-us/library/ms228362.aspx), but by using the <code>unsafe</code> keyword, you can actually manually change the content of it.
Be aware, as this opens for some attacks from libraries (or a colleague that want to mess with you) when it comes to things like reflection and connection strings.

