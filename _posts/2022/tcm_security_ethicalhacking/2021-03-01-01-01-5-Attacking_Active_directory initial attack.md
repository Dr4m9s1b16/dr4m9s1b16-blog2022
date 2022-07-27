---
layout: post
title:  "TCM_security_EthicalHacking Part 5"
author: haran
categories: [TCM , Cyber Security]
image: post_img/2021/01/01_1/tcm.png
beforetoc: "Attacking active directory initial attack"
toc: true
---

Attacking Active Directory Initial Attack Vectors

Introduction


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/1.jpg)

• post attack = we have to have credenials to attack.
 
• how to attack features of windows (not misconfiguration)

• user accounts , credentials.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/2.jpg)


• https://adam-toscher.medium.com/top-five-ways-i-got-domain-admin-on-your-internal-network-before-lunch-2018-edition-82259ab73aaa

LLMNR Poisoing

•LLMNR - Link local multicaste name resolution.
•identify when dns failed.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/3.jpg)

• previously called as NETBIOS
• KEY FLAW => Service utilize user's username and NTLMv2

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/4.jpg)

1= victim send request to connect \\hackm
2= server respond with dns resolution failed
3= victim send a broadcast request to identify the host
4= hacker capture that broadcast address and send back to victim.
5= victim send username and hash to the attacker for dns resolution.


Responder

responer is part of impacket packages.
it will respond to that request.
best time to run morning and right after the lunch.(run before nmap scan and nessus scan)
=>because namp and nessus take a lot of traffic.

1.Running responder

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/5.jpg)

• waiting for the responses and try to capture hashes.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/6.jpg)

this is victim machine.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/7.jpg)

• taking this hash and try to crack it.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/8.jpg)

password => Password1

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/9.jpg)

long sentences above 14
non sequence sentences.


Capturing ntlm2 hashes with responder

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/10.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/11.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/12.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/13.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/14.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/15.jpg)


fcastle machine


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/16.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/17.jpg)


marvel =  domain
fcastle = user

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/18.jpg)

70% running LMNR FOR DNS resolution
try to turnoff this LMNR.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/19.jpg)


NEST INSTALL HASHHAT.


password cracking with hashhat

Hashcat used to crack hashes


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/21.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/22.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/23.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/24.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/25.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/26.jpg)

wordlist => usr/share/wordlists

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/27.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/28.jpg)

best password download.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/29.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/30.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/31.jpg)

--force => run on gpu or graphics card.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/32.jpg)

some of gpu problem it doesnot run.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/33.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/34.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/35.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/36.jpg)

-O => optimize it .


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/37.jpg)


LLMNR attacking defence

Netwok access control =>
plugin in any where in the network and get network access control.
mac filter to mitigate and allow computers.

setup if any other computers connected shutdown.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/38.jpg)

SMB relay attacks overview

SMB relay attacks

• smb sigining is  a packet level protocol.
• smb signing disabled able to let them in without checking
• only with ntlm hashes.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/39.jpg)


1.responder to capture
2.relay tool to relay
3.respond back.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/40.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/41.jpg)
 
 NTLM RelayX
 
 1.take the relay 
 2.passes to target file you specify.
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/42.jpg)
 
 waiting for an event to happen.
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/43.jpg)

•  10.8.0.2 => our machine
•  respnder kicks in respond to that machine.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/44.jpg)

• smb reklay captured other credentials and .

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/45.jpg)

1.Waiting for event to occur
2.received victim machine 10.0.3.7 , relay that credentials to other machines in the 
  network
3.MARVEL/Fcastle succed because he is a local administrator.
6.hashes are dumbed local administartor,It is like shadow socks files (SAM Hashes)
Quick lab update for smb relay attack

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/46.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/47.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/48.jpg)

•  Do to the next machine also discoverable
Discovering hosts with smb signing disabled


what is smb signing enabled and what has disabled?

1. running nessus scan over the network and tell these are the machines smb 
   signing disabled.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/49.jpg)

• smb script to check.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/50.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/51.jpg)

• we can't relay to that machine because message signing enabled are required.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/52.jpg)

we still do a relay attack because of non requirements.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/53.jpg)

smb relay attack demonstration part1


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/54.jpg)

relay credentials from 141 to 142.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/55.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/56.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/57.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/58.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/59.jpg)

set up the relay 

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/60.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/61.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/62.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/63.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/64.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/65.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/66.jpg)

dumbed the sam hashes which is look like shadow file in linux systems.
copy this hashes .
smb relay attack demonstration part2


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/67.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/68.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/69.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/70.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/71.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/72.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/73.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/74.jpg)

we are in smb shell.
we can do file share etc 

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/75.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/76.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/77.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/78.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/79.jpg)

setup meterpreter listener and get shell on the metaspolit with multihandler.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/80.jpg)




smb relay attack defences


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/81.jpg)


Gaining shell access

what we do with the credentials?

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/82.jpg)


if smb open and we have username and password.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/83.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/84.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/85.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/86.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/87.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/88.jpg)


it is sometimes not authenticate in first go.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/89.jpg)


virus infected machine.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/90.jpg)


another tool.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/91.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/92.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/93.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/94.jpg)


familiarize with smbexec.py and wmiexec.py
IPV6 attacks overview

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/95.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/96.jpg)

IPV6 Attacks

IPV6 ADDRESS DNS not resulted by anyone 
spoof machine to resulte dns 
capture the ntlm hashes 
to login to domain controller use that hashes using LDAP
IF THAT NTLM HASH  A local adminstrator create an account and login

tools used

responder
mitm6 => man in the middle
installing mitm6

github mitm6

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/97.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/98.jpg)

setting up LDAP

LDAP

 LDAP stands for Lightweight Directory Access Protocol. As the name suggests, it is a lightweight client-server protocol for accessing directory services, specifically X.
 
 500-based directory services. LDAP runs over TCP/IP or other connection oriented transfer services.
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/99.jpg)
 
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/100.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/101.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/102.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/103.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/104.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/105.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/106.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/107.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/108.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/109.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/110.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/111.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/112.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/113.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/114.jpg)

IPV6 DNS Takeover via mitm6

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/115.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/116.jpg)

-6 = IPV6
-T = Target domain controller
-wh = folder fake
-l = setup loot credentials.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/117.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/118.jpg)

restarting need the machine to sign in in again

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/119.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/120.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/121.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/122.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/123.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/124.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/125.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/126.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/127.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/128.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/129.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/130.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/131.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/132.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/133.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/134.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/135.jpg)

https://dirkjanm.io/

https://dirkjanm.io/worst-of-both-worlds-ntlm-relaying-and-kerberos-delegation/

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/136.jpg)

IPV6 Attacks defences


 Web Proxy Auto-Discovery Protocol (WPAD)

• The Web Proxy Auto-Discovery Protocol is a method used by clients to locate the URL of a configuration file using DHCP and/or DNS discovery methods.
 
• Once detection and download of the configuration file is complete, it can be executed to determine the proxy for a specified URL. 

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/137.jpg)

Other attack  vectors and strategies


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/138.jpg)

8:00 and after lunch attack time
use nmap or nessus to find 
websites in scope if ntlmnr not found.

nmap

lokk for any smb that open 
take targets for smb relay attacks.q


sometimes there are no 
1.smb
2.LMNR

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_5/139.jpg)

• IMAP (Internet Message Access Protocol) is a standard email protocol that stores email messages on a mail server, but allows the end user to view and manipulate the messages as though they were stored locally on the end user's computing device(s)

