---
layout: post
title:  "What I hope for the future of Xamarin.Forms"
categories: [Xamarin, Xamarin.Forms, iOS, Android, Mobile, UI]
---

# It's time to redesign Xamrin Forms
First of all, Xamarin.iOS and Xamarin.Android is a piece of art. It's mature, robust, and a really impressive piece of work.
XF is currently in version 2.3 but is still young and buggy, however it has a great potential.
I have now worked a while with XF, and I see that it probably should have been made a little different.

Todays biggest problem with XF is the same as most cross platform frameworks: It tries to abstract to much.

The design gives you little control over navigation and layouting, and it feels a lot similar to WebForms.
This is really nice for those who just want a simple app fast, and does not care about the platform it's running on.
However, this is not the usecase for most developers. We just want a framework that does things easier for us, but we still have all the control we need.
And a possiblity to use just the parts of the framework we need.

If you develop with XF today, you will get a lot for free from the framework.
It's easy to start with, and easy to prototype with.
The amount of work needed to get something done, will be something like this:<br />
<img src="/images/2016-11-27-forms_graph.png" alt="image of a eddystone-url notification" width="200" />

However if you reach the point where it stops being a benefit, it would probably also be to late to switch to Xamarin Native.
This is where XF could be different from all the other frameworks, and give a huge benefit, if designed different.

## Open Sourceode

XF is now OpenSource, this is awesome.
However, we can easily see that this was not the planned at the design time.
There are so many internal logic and utils, that would be nice to work with, that is neither documented or set to public.

Xamarin do take Pull Requests, and there are several commits by the community.
However they do reject commits that breaks backward compatibility.
This is quite scary, as this is often a bad smell that the project is to tightly coupled together to resolve.
This could have been fixed with proper version management, or proper modulization.

However as of today, Xamarin tend to break something at every new version themselves, so having this strict backward compatibility policy does not make much sense.

## PlatformA != PlatformB

The architecture of iOS, Android, Windows and Mac is just too different to make one common framework. A button is not just a button, and a label is not just a label.
A cross platform framework should not try to hide this, since this is an impossible task.
It should however embrace it, and make it easier to work around the differences.

Today there are a lot of thing we as developer cannot change to easy, as there is a lot of magic going on inside XF.
The problem I often see, is hardcoded values that is not easy to replace.

Some examples of this is:

- Buttons on iOS that is hardcoded as RoundedRect.<br />
*Can be fixed with <code>SetNativeControl</code>, however this will skip some other internal setup code.*
- Buttons on Android.<br />
*When adding a border, it uses a custom drawable as background on the button*
- Page transitions on Android [see previous post]({% post_url 2016-06-25-xamarin-forms-transitions %}).<br />
*AppCompat can override the transition, but the page will be removed before you can do anything on back navigation.*<br />
*Modern/Material has hardcoded animations when pushing a page to the stack*

## My suggestion

When I look at XF, I would have liked to see this more like a service working side-by-side with the native code,
with the possible to replace as much of the native code you want to.

Then the developer team to work with, can find the exact sweetspot between abstraction and native, rather than replacing the whole application to the framework.

To do this I would suggest splitting XF into submodules.

The design should look something like this:<br />
<img src="/images/2016-11-27-xamarin-design.png" alt="image of a eddystone-url notification" />

**XF.Core:**<br />
The absolute minimum we need to make tooling, and the components working together.
This should be as fast as possible.

This module should be able to be a full stand alone module, with no other dependencies.
Therefor it must also include the renderer engine to convert XF Components into native ones.

Also the layout system should probably be here, at least part of it.
However, it should be redesigned to give more control to the developer, and then could be abstracted out in an other component.

**XF.Components:**<br />
A module to include common components like Buttons, Labels, etc.

If most of your code is custom, you would probably want to make your own components in stead.
Also you might want to do some funky stuff, like using SkiaSharp based components, this would not be needed.

**XF.Features:**<br />
Used together with *XF.Components* to provide extra features like:

- Effect
- Animations
- Gestures

**XF.Navigation:**<br />
A module for the navigation between pages.

This could also include common MVVM framework features like MessagingCenter, IoC etc.
The reason to not have this in the core, it that your favourite MVVM framework, would probably have their own implementation of this. In that case you skip this component all together.

## PCL vs Shared libraries
I love PCLs, and I hope for NetStandards support in Xamarin.
However, I don't think PCLs would be the correct place for UI code, as a components like a button should be limited to the platform.
Since PCLs don't know anything about the platform, XF should prefer having the shared UI in shared projects, and the background platform independent code like services in PCL.

If I work with a component, I would prefer to get a 100% working feature, instead of something that is hacked together to look similar as another platform.
If the developer however should want this code, this should be another components package.

## But I do love Xamarin.Forms
XF is easy to start with, and can do so much for you.
The layout system is awesome, however it would need to give more control to the developer.

The community is really helpful, and if you don't get answers there, you could always ask the iOS or Android community.
And it is not hard to port native code to Xamarin Native or XF.

XF is really helpful while prototyping, and work great especially on iOS.
However, the Android part of XF needs some polishing.
This is not to much of a problem after XF got Custom Renderers and possiblity to add native code directly, and it's easy to do partial Xamarin.Android or Xamarin.iOS develop where XF is not fast or powerfull enough.

I like XF, and with todays design, I would still use it in most cases, unless I know that the project would need a lot of custom graphics and animations.
XF is a impressive piece of work, however with todays it is not for everyone, but with a redesign, I think it would benefit more developers.

The Xamarin platform, is just a piece of art, and I love so much about it. :)

What they have achieved with the tools, and how easy it is to use TestCloud, Azure and other providers.
It's so nice and neat. You don't need Xamarin to use it, but it sure gives that little extra.

{% include disqus.html %}
