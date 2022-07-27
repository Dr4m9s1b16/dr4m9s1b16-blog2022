---
layout: post
title:  "TCM_security_EthicalHacking Part 15_3"
author: haran
categories: [TCM , Cyber Security]
image: post_img/2021/01/01_1/tcm.png
beforetoc: "Attacking Active Directory Compromise Attack"
toc: true
---

Attacking Active Directory Compromise Attack

## Attacking AD Post Compromise attack

## PowerView overlook

https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/1.jpg)

## Domai Enumeration with PowerView

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/2.jpg)

- execution policy prevent us from accidently executing a script

```ps
powershell -ep bypass
. .\PowerView.ps1
```

https://gist.github.com/HarmJ0y/184f9822b195c52dd50c379ed3117993 =  PoweView Tricks

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/3.jpg)

```ps
Get-NetDomain
Get-NetDomainController
Get-DomainPolicy
(Get-DomainPolicy)."system access"
Get-
Get-NetUser | select cn
Get-NetUser | select samaccountname
Get-NetUser | select description
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/4.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/5.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/6.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/7.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/8.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/9.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/10.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/11.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/12.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/13.jpg)

```ps
Get-UserProperty
Get-UserProperty -properties pwdlastset
Get-UserProperty -properties logoncount
Get-UserProperty -properties badpwdcount
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/14.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/15.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/16.jpg)

- If the account not logged in before that is a honeypot account

```ps
Get-NetComputer
Get-NetComputer | select OperatingSystem
```
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/17.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/18.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/19.jpg)

```ps
Get-NetGroup
Get-NetGroup "Domain Admins"
Get-NetGroup *admin*
```
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/21.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/22.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/23.jpg)

```
Invoke-ShareFinder
Get-NetGPO
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/24.jpg)

- get to know about all the smbshare

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/25.jpg)

- tells abou all the grp policy

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/26.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/27.jpg)

```ps
Get-NetGPO | select displayname
Get-NetGPO | select displayname,whenchanged
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/28.jpg)

### BloodHound Overview and setup

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/29.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/30.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/31.jpg)

### Grabbing data with invoke bloodhound

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/32.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/33.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/34.jpg)

```ps
. .\SharpHound.exe

```

if ps1 script

```
. .\SharpHound.ps1
Invoke-BloodHound -CollectionMethod All -Domain MARVEL.local -ZipFileName file.zip
```

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/35.jpg)

## Enumerating Domain data with bloodhound

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/36.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/37.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/38.jpg)

- You want boxex where domain admins logged in

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/39.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_15_3/40.jpg)

- domain admin has a session