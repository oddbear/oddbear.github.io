---
layout: post
title:  "Faster context switching with Chrome profiles"
categories: [Guide, Google Chrome, Chrome Profiles]
---

# Faster context switching with Chrome profiles
I have used Chrome profiles for a while. This is really good to seperate and isolate things like credentials between different instances of chrome. And when I mention this for other people, there are a lot that does not know about this gem of a feature.

I currently use 3 profiles, personal, work, and customer.

By using profiles I can now use the same portal for different rols, ex. the Azure Profile. I don't need to log out and in between sessions. Just open the browser from the right shortcut.

This is all nice, however. One issue happend every time when I open links, ex. from Slack. Those whould be sent to my Default browser (was Edge).

My taskbar currently looks like this:<br />
<img src="/images/2018-06-01-taskbar.png" alt="my browsers in the taskbar" />

The shortcuts goes to:
- Edge (default)
- Personal Profile
- Customer Profile
- Work Profile

## Better browser switching

By using this nice tool called [BrowserChooser](https://browserchooser2.com/), I can now choose my browser with the right profile directly when open link.
<img src="/images/2018-06-01-switcher.png" alt="Welcomescreen of browserchooser2" />

That is all nice, but it also supports automaticly choosing a profile based on patterns in the link, ex. customer domain etc.

Another nice feature, is that I can automaticly choose the right browser based on patterns in the link, ex. customers domain etc.

Now we are talking. :)

## Setup browser switching

First download the applications, this is a portable exe, so I manually put it in _'C:\Program Files\Browser Chooser'_.
Then you will need to setup it as your default browser. Open the application, go to the setup (right top link), click on _'Windows Default'_, then _'Add to Default programs'_ and _'Show Defaults Dialog*'_.

<img src="/images/2018-06-01-default.png" alt="Add as default" />

Now you should be able to make BrowserChooser as your default browser.

<img src="/images/2018-06-01-default_windows.png" alt="Windows default dialog" />

Since BrowserChooser cannot use the same icons as in the taskbar directly from Chromes folders, you must copy them over to a place where it can find them.

To copy the Profile icons from Chrome, go to '%userprofile%\AppData\Local\Google\Chrome\User Data\Profile #', where '#' is profile number. Copy the 'Google Profile.ico' as the '<profilename>.ico' to the 'BrowserChooser Folder'.

<img src="/images/2018-06-01-copyicon.png" alt="Copy the correct icons" />

Now go to the Shortcuts settings, and clone up chrome to the number of profiles.

<img src="/images/2018-06-01-shortcuts.png" alt="Shortcuts dialog" />

Edit them manually like this:

<img src="/images/2018-06-01-shortcut_settings.png" alt="How to set up a shortcut to a profile" />

To add URL patterns go to 'Auto URLs'. With wildcards this can be very powerfull.

<img src="/images/2018-06-01-autourl.png" alt="Auto choose browser based on url patterns" />

Now when you click on a configured link, it should open chrome with the right profile automaticly.

So...

Time Saved...Is Time Earned...<br />
Work smarter, not harder...<br />
...<br />
You know... all that. :)

{% include disqus.html %}
