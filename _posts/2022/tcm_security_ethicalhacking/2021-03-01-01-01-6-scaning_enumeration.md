---
layout: post
title:  "TCM_security_EthicalHacking Part 6"
author: haran
categories: [TCM , Cyber Security]
image: post_img/2021/01/01_1/tcm.png
beforetoc: "Scanning and Enumeration"
toc: true
---

Scanning and Enumeration
Scanning with Nmap

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/1.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/2.jpg)

sudo netdiscover -r 192.168.8.0/24                                                                                                                   

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/3.jpg)

SYN SYNACK ACK = ACKNOWLEDGED PORT

-sS = stealth scanning undetetctable

SYN SYNACK RST = NOT ACKNOWLEDGED CLOSED PORT

nmap -T4 -p- -A 

-T4 = speed of testing (1 slow - 5fast)
-p- = scan all ports (leave this scan top 10000 ports)
      nmap -p 80,443 ipaddress
      
-A  = version information , operating system information anything

-sU = UDP Port scan

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/4.jpg)

•while scanning with UDP scan 10000 ports only becayse udp coonectionless take a lot of time

[sudo] password for ahl: 
Starting Nmap 7.91 ( https://nmap.org ) at 2020-12-31 09:59 GMT
Nmap scan report for 192.168.8.167
Host is up (0.0011s latency).
Not shown: 65528 closed ports
PORT     STATE    SERVICE     VERSION
22/tcp   open     ssh         OpenSSH 2.9p2 (protocol 1.99)
| ssh-hostkey: 
|   1024 b8:74:6c:db:fd:8b:e6:66:e9:2a:2b:df:5e:6f:64:86 (RSA1)
|   1024 8f:8e:5b:81:ed:21:ab:c1:80:e1:57:a3:3c:85:c4:71 (DSA)
|_  1024 ed:4e:a9:4a:06:14:ff:15:14:ce:da:3a:80:db:e2:81 (RSA)
|_sshv1: Server supports SSHv1
53/tcp   filtered domain
80/tcp   open     http        Apache httpd 1.3.20 ((Unix)  (Red-Hat/Linux) mod_ssl/2.8.4 OpenSSL/0.9.6b)
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Apache/1.3.20 (Unix)  (Red-Hat/Linux) mod_ssl/2.8.4 OpenSSL/0.9.6b
|_http-title: Test Page for the Apache Web Server on Red Hat Linux
111/tcp  open     rpcbind     2 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2            111/tcp   rpcbind
|   100000  2            111/udp   rpcbind
|   100024  1           1024/tcp   status
|_  100024  1           1024/udp   status
139/tcp  open     netbios-ssn Samba smbd (workgroup: MYGROUP)
443/tcp  open     ssl/https   Apache/1.3.20 (Unix)  (Red-Hat/Linux) mod_ssl/2.8.4 OpenSSL/0.9.6b
|_http-server-header: Apache/1.3.20 (Unix)  (Red-Hat/Linux) mod_ssl/2.8.4 OpenSSL/0.9.6b
|_http-title: 400 Bad Request
| ssl-cert: Subject: commonName=localhost.localdomain/organizationName=SomeOrganization/stateOrProvinceName=SomeState/countryName=--
| Not valid before: 2009-09-26T09:32:06
|_Not valid after:  2010-09-26T09:32:06
|_ssl-date: 2020-12-31T11:02:27+00:00; +1h01m54s from scanner time.
| sslv2: 
|   SSLv2 supported
|   ciphers: 
|     SSL2_DES_64_CBC_WITH_MD5
|     SSL2_RC4_128_EXPORT40_WITH_MD5
|     SSL2_RC2_128_CBC_EXPORT40_WITH_MD5
|     SSL2_RC2_128_CBC_WITH_MD5
|     SSL2_RC4_128_WITH_MD5
|     SSL2_RC4_64_WITH_MD5
|_    SSL2_DES_192_EDE3_CBC_WITH_MD5
1024/tcp open     status      1 (RPC #100024)
MAC Address: DC:53:60:42:81:E1 (Intel Corporate)
Device type: general purpose
Running: Linux 2.4.X
OS CPE: cpe:/o:linux:linux_kernel:2.4
OS details: Linux 2.4.9 - 2.4.18 (likely embedded)
Network Distance: 1 hop

Host script results:
|_clock-skew: 1h01m53s
|_nbstat: NetBIOS name: KIOPTRIX, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
|_smb2-time: Protocol negotiation failed (SMB2)

TRACEROUTE
HOP RTT     ADDRESS
1   1.12 ms 192.168.8.167

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 78.54 seconds
kiopetrix-note-http

Port and scan result

• 80/tcp open http Apache PHP images\52-1.png
• Default Page

Information Disclosure

http://192.168.8.167/manual/mod/core.html#documentroot = Document root

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/5.jpg)


nikto scanning

-h = host
run on web server running ip

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/6.jpg)

- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          192.168.8.167
+ Target Hostname:    192.168.8.167
+ Target Port:        80
+ Start Time:         2020-12-31 10:26:57 (GMT0)
---------------------------------------------------------------------------
+ Server: Apache/1.3.20 (Unix)  (Red-Hat/Linux) mod_ssl/2.8.4 OpenSSL/0.9.6b
+ Server may leak inodes via ETags, header found with file /, inode: 34821, size: 2890, mtime: Thu Sep  6 04:12:46 2001
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ OpenSSL/0.9.6b appears to be outdated (current is at least 1.1.1). OpenSSL 1.0.0o and 0.9.8zc are also current.
+ Apache/1.3.20 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ mod_ssl/2.8.4 appears to be outdated (current is at least 2.8.31) (may depend on server version)
+ OSVDB-27487: Apache is vulnerable to XSS via the Expect header
+ Allowed HTTP Methods: GET, HEAD, OPTIONS, TRACE 
+ OSVDB-877: HTTP TRACE method is active, suggesting the host is vulnerable to XST
+ OSVDB-838: Apache/1.3.20 - Apache 1.x up 1.2.34 are vulnerable to a remote DoS and possible code execution. CAN-2002-0392.
+ OSVDB-4552: Apache/1.3.20 - Apache 1.3 below 1.3.27 are vulnerable to a local buffer overflow which allows attackers to kill any process on the system. CAN-2002-0839.
+ OSVDB-2733: Apache/1.3.20 - Apache 1.3 below 1.3.29 are vulnerable to overflows in mod_rewrite and mod_cgi. CAN-2003-0542.
+ mod_ssl/2.8.4 - mod_ssl 2.8.7 and lower are vulnerable to a remote buffer overflow which may allow a remote shell. http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2002-0082, OSVDB-756.
+ ///etc/hosts: The server install allows reading of any system file by adding an extra '/' to the URL.
+ OSVDB-682: /usage/: Webalizer may be installed. Versions lower than 2.01-09 vulnerable to Cross Site Scripting (XSS).
+ OSVDB-3268: /manual/: Directory indexing found.
+ OSVDB-3092: /manual/: Web server manual found.
+ OSVDB-3268: /icons/: Directory indexing found.
+ OSVDB-3233: /icons/README: Apache default file found.
+ OSVDB-3092: /test.php: This might be interesting...
+ /wp-content/themes/twentyeleven/images/headers/server.php?filesrc=/etc/hosts: A PHP backdoor file manager was found.
+ /wordpresswp-content/themes/twentyeleven/images/headers/server.php?filesrc=/etc/hosts: A PHP backdoor file manager was found.
+ /wp-includes/Requests/Utility/content-post.php?filesrc=/etc/hosts: A PHP backdoor file manager was found.
+ /wordpresswp-includes/Requests/Utility/content-post.php?filesrc=/etc/hosts: A PHP backdoor file manager was found.
+ /wp-includes/js/tinymce/themes/modern/Meuhy.php?filesrc=/etc/hosts: A PHP backdoor file manager was found.
+ /wordpresswp-includes/js/tinymce/themes/modern/Meuhy.php?filesrc=/etc/hosts: A PHP backdoor file manager was found.
+ /assets/mobirise/css/meta.php?filesrc=: A PHP backdoor file manager was found.
+ /login.cgi?cli=aa%20aa%27cat%20/etc/hosts: Some D-Link router remote command execution.
+ /shell?cat+/etc/hosts: A backdoor was identified.
+ 8724 requests: 0 error(s) and 30 item(s) reported on remote host
+ End Time:           2020-12-31 10:27:45 (GMT0) (48 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/7.jpg)

+ mod_ssl/2.8.4 - mod_ssl 2.8.7 and lower are vulnerable to a remote buffer overflow which may allow a remote shell. http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2002-0082, OSVDB-756.


outdated versions

Vulnerabilities found

+ OSVDB-4552: Apache/1.3.20 - Apache 1.3 below 1.3.27 are vulnerable to a local buffer overflow which allows attackers to kill any process on the system. CAN-2002-0839.

dirbuster

dirbuster& = command

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/8.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/9.jpg)

Information disclosure problem (header file exposed)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/10.jpg)

http://192.168.8.167/usage/usage_200909.html

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/11.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/12.jpg)



kiopetrix-note-smb


Enumerating SMB

smb = file sharing protocol

NMAP Results

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/13.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/14.jpg)

Using Metaspolit

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/15.jpg)

Command

search smb 
use auxiliary/scanner/smb/smb_version 
info 
options 
set RHOSTS 192.168.16.7
run

RHOSTS = Remote hosts; multiple hosts put /24 to define ranges
LHOSTS = Local hosts


![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/16.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/17.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/18.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/19.jpg)

samba version found

[*] 192.168.8.167:139- SMB Detected (versions:) (preferred dialect:(signatures:optional)
[*] 192.168.8.167:139-   Host could not be identified: Unix (Samba 2.2.1a)
[*] 192.168.8.167:- Scanned 1 of 1 hosts (100% complete)

smbclient 

smbclient connect to server like ssh.

command

smbclient -L \\\\192.168.8.167\\
-L = List

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/20.jpg)

Note

"Protocol negotiation failed: NT_STATUS_IO_TIMEOUT". How do I resolve?
On Kali, edit /etc/samba/smb.conf
Add the following under global:
client min protocol = CORE
client max protocol = SMB3

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/21.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/22.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/23.jpg)

logged in by enter

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/24.jpg)

access denied


Enumerating SSH
SSH Enumeration

22/tcp   open     ssh         OpenSSH 2.9p2 (protocol 1.99)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/25.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/26.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/27.jpg)

ssh 192.168.8.167 -oKexAlgorithms=+diffie-hellman-group1-sha1                                                                                        255 ⨯
Unable to negotiate with 192.168.8.167 port 22:
 no matching cipher found. Their offer: aes128-cbc,3des-cbc,blowfish-cbc,
 cast128-cbc,arcfour,aes192-cbc,aes256-cbc,rijndael128-cbc,rijndael192-cbc,
 rijndael256-cbc,rijndael-cbc@lysator.liu.se

ssh 192.168.8.167 -oKexAlgorithms=+diffie-hellman-group1-sha1 -c aes128-cbc                                                                          255 ⨯
The authenticity of host '192.168.8.167 (192.168.8.167)' can't be established.
RSA key fingerprint is SHA256:VDo/h/SG4A6H+WPH3LsQqw1jwjyseGYq9nLeRWPCY/A.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.8.167' (RSA) to the list of known hosts.
ahl@192.168.8.167's password: 


Researching Potential Vulnerabilities

   Researching Potential Vulnerabilities


80/http mod_ssl/2.8.4 - mod_ssl 2.8.7 and lower are vulnerable to a remote buffer overflow

• https://www.exploit-db.com/exploits/21671
• Apache mod_ssl < 2.8.7 OpenSSL - 'OpenFuck.c' Remote Buffer Overflow
• https://github.com/heltonWernik/OpenLuck



139/samba Samba 2.2.1

Rapid7 make metaspolit
https://www.rapid7.com/db/modules/exploit/linux/samba/trans2open/


https://www.exploit-db.com/exploits/22469

searchspolit cve search

searchsploit samba 2

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/28.jpg)

remote mean = remote code execution
Our Notes So Far

![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/29.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2021/01/01_6/30.jpg)
