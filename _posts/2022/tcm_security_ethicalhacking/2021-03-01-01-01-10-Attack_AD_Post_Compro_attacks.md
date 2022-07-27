---
layout: post
title:  "TCM_security_EthicalHacking Part 10"
author: haran
categories: [TCM , Cyber Security]
image: post_img/2021/01/01_1/tcm.png
beforetoc: "Attacking active directory post compromise attacks"
toc: true
---

Attacking active directory post compromise attacks

Attacking Active Directory Post-Compromise Attacks

Pass the hash password


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/1.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/2.jpg)

user fcastle is localadmin on spiderman machine
his machine punisher.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/3.jpg)



![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/4.jpg)


that numer is lastone
• -u = user 
• -H = Hash
• --local = pass locally

local admistrators reuse same password and hash again.

installing crackmpsec

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/5.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/6.jpg)

Pass the Password attacks


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/7.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/8.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/9.jpg)

• scanning all the network

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/10.jpg)

dumping hashes with secrectsdump.py

• metaspolit caught up by antivirus.
• It is part of the impacket toolkit.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/11.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/12.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/13.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/14.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/15.jpg)

pass attacks mitigations


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/16.jpg)



Token impersonate attacks


token =cookies for system.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/17.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/18.jpg)

incognito is part of meterpreter.

• list the token users

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/19.jpg)



mimikatz script = powershell script used to dump the hashes of windows credentials.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/20.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/21.jpg)



![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/22.jpg)



![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/23.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/24.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_10/25.jpg)


if we find a domian admin token imprsonate you have domain admin.


machine 1 fcatle
machine 2 spiderman
   - aadinstrator token is there succeded
