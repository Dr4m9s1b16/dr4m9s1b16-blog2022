---
layout: post
title:  "TCM_security_EthicalHacking Part 15_1"
author: haran
categories: [TCM , Cyber Security]
image: post_img/2021/01/01_1/tcm.png
beforetoc: "Active Directory Lab , Overview"
toc: true
---

Active Directory Lab , Overview

## Overview

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/1.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/2.jpg)

## Physical Active directory components

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/3.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/4.jpg)

```ps
%SystemRoot%\NTDS
```

## Logical AD components

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/5.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/6.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/7.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/8.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/9.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/10.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/11.jpg)

## Lab Overview and Requirements

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/12.jpg)

## Setting up the domain controller

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/13.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/14.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/15.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/16.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/17.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/18.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/19.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/21.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/22.jpg)


## Configure up users groups and policies

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/23.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/24.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/25.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/26.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/27.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/28.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/29.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/30.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/31.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/32.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/33.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/34.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/35.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/36.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/37.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/38.jpg)

```ps
setspn -a HARAN-DC/SQLService.MARVEL.local:60111 MARVEL\SQLService
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/39.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/40.jpg)

```ps
setspn -T MARVEL.local -Q */*
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/41.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/42.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/43.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/44.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/45.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/46.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/47.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/48.jpg)

## Joining our pc's to the domain

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/49.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/50.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/51.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/52.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/53.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/54.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/55.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/56.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/57.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/58.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/59.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/60.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/61.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/62.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/63.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/64.jpg)
21x machine

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/65.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/66.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_1/67.jpg)
