---
layout: post
title:  "TCM_security_EthicalHacking Part 9"
author: haran
categories: [TCM , Cyber Security]
image: post_img/2021/01/01_1/tcm.png
beforetoc: "Attacking active directory post compromise Enumeration "
toc: true
---


Attacking Active Directory Post-Compromise Enumeration

Introduction

• we compromised the system

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/1.jpg)

Power view = enumerate active directory
power shell 

bloodhound = enumeration tool
Powerview Overview

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/2.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/3.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/4.jpg)

Domain enumeration with powerview


-ep = execution policy

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/5.jpg)

this is not for security purposes.
stop us from executing scripts.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/6.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/7.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/8.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/9.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/10.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/11.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/12.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/13.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/14.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/15.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/16.jpg)

password last set.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/17.jpg)

The account that is not logged in properly  the honeypot account.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/18.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/19.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/21.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/22.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/23.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/24.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/25.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/26.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/27.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/28.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/29.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/30.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/31.jpg)

Bloodhound overview and setup

download the data on active directory.
very quickly execute.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/32.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/33.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/34.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/35.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/36.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/37.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/38.jpg)

grabbing data with invoke bloodhound

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/39.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/40.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/41.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/42.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/43.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/44.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/45.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/46.jpg)

Enumerating domain with bloodhound


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/47.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/48.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/49.jpg)

9 users
3 computers 

created using sessions login in to the domain 

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/50.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/51.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/52.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/53.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/54.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_9/55.jpg)
