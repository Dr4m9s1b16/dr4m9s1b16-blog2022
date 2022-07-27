---
layout: post
title:  "Cyber Mentor Linux Privilege Escaltion Part1"
author: haran
categories: [LinuxPrivSec]
tags: [LinuxPrivEsc]
image:
image:
  path: post_img/comman/privesc.jpg
  width: 800
  height: 500
  alt: Responsive rendering of  theme on multiple devices.
beforetoc: "Cyber Mentor Privilege Escaltion techniques"
toc: true
---

Cyber Mentor Privilege Escaltion techniques

Linux_Privilege_Escalation
Introduction
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/1.jpg)

01_System Enumeration
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/2.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/3.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/4.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/5.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/6.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/7.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/8.jpg)

To see what kernel it is using and what architecture is a important point.

some times hostname give hints that what hostname I am in.









02_User Enumeration

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/9.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/10.jpg)

It is only user privileges 1000

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/11.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/12.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/13.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/14.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/15.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/16.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/17.jpg)


03_Network Enumeration

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/18.jpg)

ip address 10.10.216.136   broadcast address 10.10.255.255  Mask 255.255.0.0
it also has two ip address.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/19.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/21.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/22.jpg)

127.0.0.1:686   open in udp port doing internally

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/23.jpg)

• means it is on the same network doesnt go anyware.
• default one is router which gateway is ip-10-10-0-1.eu

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/24.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/25.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/26.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/27.jpg)


04_Password Hunting_Enumeration

grep --color=auto -rnw ‘/’ -ie “PASSWORD” --color=always 2> /dev/null
grep --color=auto -rnw '/' -ie "PASSWORD" --color=always 2>/dev/null


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/28.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/29.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/30.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/31.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/32.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/33.jpg)

find / -name id_rsa 2>/dev/null




01_Automation tools


./opt/inpeas/linpeas.sh

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/34.jpg)

linenum
linpeas
linux-exploit-suggester
02_escalation path kernels

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/35.jpg)

https://github.com/lucyoa/kernel-exploits = kernel exploits github post
escaltion via kernel exploit

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/36.jpg)

debian 2.6.32-5-amd64 kernel version


Method 1

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/37.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/38.jpg)


2.6.22<3.9 === 2.6.32 inbetween them

Method 2

linux-exploiter-suggester

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/39.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/40.jpg)

download file

Curl -o downlaod-url

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/41.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/42.jpg)

TCM@debian:~/tools/dirtycow$ gcc -pthread c0w.c -o cow
TCM@debian:~/tools/dirtycow$ ls
c0w.c  cow
TCM@debian:~/tools/dirtycow$

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/43.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/44.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/45.jpg)


Escalation Path Passwords & File Permissions

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/46.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/47.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/48.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/49.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_16/50.jpg)


