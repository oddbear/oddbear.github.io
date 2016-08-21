---
layout: post
title: Running Jekyll in Docker for Windows
tags: [docker, kitematic, jekyll, github-pages, windows]
---

I recently formated my computer to install Windows 10 and lost my jekyll installation.
Instead of installing jekyll again, I wanted to test how it is to run it from a docker image.
As I am new to docker, I wanted to see if I could do everything from the UI, before learning the commands.

## Prerequisites
 1. Have installed Windows 10 Anniversary Update
 2. Have installed [Docker for Windows](https://docs.docker.com/docker-for-windows/)
 3. Have installed [Kitematic](https://github.com/docker/kitematic/releases)

The first thing you need to do, is to download the jekyll image: [jekyll/jekyll](https://hub.docker.com/r/jekyll/jekyll/)

You can do this directly from kitematic.
I assigned a fixed port (settings/ports), and pointed my volume (settings/volumes) to my local github repository.

After this it should be able to run, but I got some permission errors:

<img src="/images/2016-08-21-permission.png" alt="Error: Permission denied @ dir_s_mkdir - /srv/jekyll/_site" />

To fix this, you can open the docker settings, go to "shared drives", then check C and enter your credentials.

After this, my "hello world" jekyll service was running in a linux VM (MobyLinuxVM) on Windows 10.
