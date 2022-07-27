---
layout: post
title:  "TCM_security_EthicalHacking Part 2"
author: haran
categories: [TCM , Cyber Security]
image: post_img/2021/01/01_1/tcm.png
beforetoc: "Information Gathering"
toc: true
---

Information Gathering

Information Gatehering
Passive Reconniance

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/1.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/2.jpg)

 Identifying Our Target
Email Gathering with Hunter.io

Hunter.io

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/3.jpg)

Hunter.io - Email Reconniance
https://github.com/hmaverickadams/breach-parse =  email roconnisannce heath adams 44GB


https://github.com/hmaverickadams/breach-parse/blob/master/breach-parse.sh

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/4.jpg)

Utilizing theharvester

Harvester

• The Harvester can be used to search Google, Bing, and PGP servers for e-mails, hosts, and subdomains.
  
• It can also search LinkedIn for user names. Most people assume their e-mail address is benign.
 

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/5.jpg)

theharvester  -d tesla.com -l 500 -b google

-d = domain
-l = how many results.
-b = search engine
Hunting Subdomains Part 1

sublist3r

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/6.jpg)

apt install sublist3r

sublist3r -d tesla.com

crt.sh

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/7.jpg)

crt.sh ======   website ====== certificate fingerprinting
Hunting Subdomains Part2 

OWASP Amass

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/8.jpg)

OWASP AMASS = SEARCH IN GOOGLE

https://github.com/OWASP/Amass = SUB DMIAN SEARCH MOSTLY USED TOOL IN BUG BOUNTY

https://github.com/tomnomnom/httprobe = see sites are active or not
                                        put the list and search
Identifying Website Technologies

Wappalayzer

https://builtwith.com/ = search which technologies the system bult with


https://chrome.google.com/webstore/detail/wappalyzer/gppongmhjkpfnbhagpmjfkannfbllamg?hl=en = chrome extension 

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/9.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/10.jpg)

what web

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/11.jpg)

whatweb


Information Gathering with Burp Suite

Burp_suite

http://burp = issue CA certificate

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/12.jpg)

Intercepting traffic.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/13.jpg)

Google Fu

Google fu
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_2/14.jpg)

site:tesla.com = only give query about tesal.com

site:tesla.com -WWW = eleiminate tesla.com

site:senzmate.com -WWW filetybe:docx = getting document files

