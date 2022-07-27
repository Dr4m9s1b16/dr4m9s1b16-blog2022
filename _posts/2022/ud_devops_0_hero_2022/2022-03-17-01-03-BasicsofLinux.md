---
layout: post
title:  "03-BasicsOfLinux"
author: haran
categories: [DevOps,DevOps Beginners to Advanced Course , linux]
image: post_img/2022/03/17_1/main2.png
beforetoc: "Basic of Linux"
toc: true
featured: true
comments: false
rating: 3.5
---

Basic Linux Introduction

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/1.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/2.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/3.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/4.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/5.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/6.jpg)



![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/7.jpg)



- kernel => read and understand harware signals 

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/8.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/9.jpg)

Diffrence between RPM based and Debian based

- From user’s point of view, there isn’t much difference in these tools. The RPM and DEB formats are both just archive files, with some metadata attached to them.
-  They are both equally arcane, have hardcoded install paths and only differ in subtle details. DEB files are installation files for Debian based distributions. 
- RPM files are installation files for Red Hat based distributions. Ubuntu is based on Debian’s package manage based on APT and DPKG. Red Hat, CentOS and Fedora are based on the old Red Hat Linux package management system, RPM.

- CentOs very similar to RHES
- CentOs is opensource RHES not

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/10.jpg)

- diffence between this to is packageing format
- like msi,dll,exe

- RPM - SAFE ,Cannot install software from outside the distro redhat only, redhat test and apply it security , server purpose great
- DEBIAN - easily usage , customizable , devops purpose ubuntu is great , latest softwares available

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/11.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/12.jpg)


## Directory structure in Linux

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/13.jpg)

---
- User Executables commands - Cat ,pwd , ls 

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/14.jpg)

 => only executed by user
 ---
 
- user add , apt , sudo only executed by this
System Execuatbles :- /sbin , /usr/sbin , /usr/local/sbin => only executed by root 
- /sbin => system admin comands
- /usr/sbin => system admin commands new root user
- /usr/local/sbin => craeted by particular user commands

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/15.jpg)

---

## other Mountpoints
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/16.jpg)

## Configuration

- /etc
 
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/17.jpg)

- server configuration , user configuration => most of the configuartion files situated here

## Temporary files 

### deleted when rebooted

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/18.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/19.jpg)


- pwd => present working directory

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/20.jpg)


## Switch to root user
```yaml
sudo -i
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/21.jpg)


username@hostname#root user yamlell

~ => stella in home directory

## Directory structure

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/22.jpg)

/ => top level directory in the linux os

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/23.jpg)

### /bin


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/24.jpg)

### /sbin
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/25.jpg)

### /etc


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/26.jpg)


### /tmp

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/27.jpg)

- used for temporary purpose

### /boot
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/28.jpg)



### /proc dynamic files change from system information

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/29.jpg)


- /uptime
-
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/30.jpg)

- how many people are using load average

## More commands

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/31.jpg)


```yaml
ls
pwd # present working directory
mkdir dev
mkdir ops backupdir
touch testfile1.txt
touch devopsfile{1..10}.txt # cretae 10 files
cp devopsfile1.txt dev/ 
ls dev/ # relative path
cd /tmp/ # absolute path
ls /home/vagrant/dev/
cp /home/vagrant/devops1.txt /home/vagrant/dev/ # source and destination as absolute path
cd ~ # home directory 
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/32.jpg)


```yaml
cp -r dev bakupdir/ # copy directory
cp -r ~/cpr  /fgh
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/33.jpg)


```yaml
mv ops dev/ #move file
mv file1.txt file2.txt #renaming
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/34.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/35.jpg)


## Vim Editor

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/36.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/37.jpg)


- i => insert mode
- : => extended command mode
- :w => write file
- :q => quit file
- i , o => one line below
- :wq => save and quit
- :q! => forecefully quitting without saving
- :se nu => set number
- yy => copy
- p => paste below
- 4yy =>  for line copy
- dd => delete line
- u => undo word
- U => undo line
- / => search

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/38.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/39.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/40.jpg)


## File Types

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/41.jpg)


-  regular file
textfile or binary file

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/42.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/43.jpg)

## /dev => contains device file

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/44.jpg)


- crw => c for character file (keyboard , tty )

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/45.jpg)

- b => block file
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/46.jpg)

- rtc0 is the original file

## Link Operations

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/47.jpg)

```yaml
mkdir /opt/dev/ops/devops/test # throws error
mkdir -p /opt/dev/ops/devops/test #cretae directory structure
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/48.jpg)


```yaml
ln -s /opt/dev/ops/test/commands.txt cmds # create link file s -> soft link
unlink cmds
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/49.jpg)

- dead link
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/50.jpg)

- unlink a file


- sort is in to time stamp and reverse it
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/51.jpg)
```yaml
ls -ltr /etc/
```


## changing host name
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/52.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/53.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/54.jpg)


# Input output Filters and redirection

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/55.jpg)


```yaml
grep -i Firewall anaconda-ks.conf # -i -> ignore case sensitivity
```

#### input redirection

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/56.jpg)

```yaml
grep -i firewall < anaconda-ks.conf
```

## Searching inside the directory

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/57.jpg)


```yaml
grep -iR firewall * # R search inside the directory files also
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/58.jpg)


```yaml
grep -R SELINUX /etc/*
```


exclude a line contains 

```yamlell
grep -vi firewall anaconda.ckg

```

## less command

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/59.jpg)


```yaml
less  anaconda-ks.cfg
more anaconda-ks.cfg
```

## tail command
```yaml
tail fiename # yamlow lat ten lines of code
tail -2 filename #yamlow last two files
tail -f filename # yamlow dynamic changing content of a file
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/60.jpg)


- log sile => messages => contain login informations

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/61.jpg)

- Contain user information => cat /etc/passwd

## cut command

```yaml
cut -d: -f1 /etc/passwd
```
-d => delimeter
-f1 => field 1 

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/62.jpg)


## awk command

```yaml
awk -F ':' '{print $1}' /etc/passwd
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/63.jpg)


## search and replace

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/64.jpg)

sed### vim editor to replace

```yaml
:%s/coronavirus/covid19 # replace in first file
:%s/coronavirus /covid19/g # change it globally
:%s/corona//g #repalce with nothing
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/65.jpg)


### sed command

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/66.jpg)

```yaml
sed 's/coronavirus/covid19/g' *.txt
```

- actually change the file

```yaml
sed -i 's/coronavirus/covid19/g' *.txt
```

# I/O redirection

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/67.jpg)

```SH
uptime > /tmp/sysinfo.txt # redirect the output to sysinfo.txt file
cat /tmp/sysinfo.txt
uptime >> /tmp/sysinfo.txt # out put in the terminal and redirection
```

#### read the ram memory space information

```yaml
uptime
```

#### yamlow harddisk partition utilization

```yaml
df -h
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/68.jpg)



#### "echo" command to insert in a file

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/69.jpg)


```yaml
echo "###############" > /tmp/sysinfo.txt
date > /tmp/sysinfo.txt
uptime >> /tmp/sysinfo.txt
```

#### /dev/null


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/70.jpg)

```yaml
apt-get update > /dev/null # doesn't output anything
cat dev/null > /tmp/sysinfo.txt # make file contents null
```

> standard error 2 , standard output 1


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/71.jpg)



```yaml
cat /tmp/error.log
free -m 1>> /tmp/error.log # output 
cat /tmp/error.log
free -m 2>> /tmp/error.log # output error
free -m &>> /tmp/error.log # output anything

```


#### /var/log (log files)

#### Count lines

```yaml
wc -l /etc/passwd
wc -l < /etc/passwd # input to the command coming inside
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/72.jpg)


#### pipe the output

```yaml
ls | wc -l
ls | grep host
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/73.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/74.jpg)


```yaml
tail -20 /var/log/messages | grep -i vagrant
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/75.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/76.jpg)


#### Find command

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/77.jpg)


```yaml
find /etc -name host*
```

#### not real time search

```yaml
locate host
```

# Users & Groups

## Users

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/78.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/79.jpg)

- Every file on the system is owned by a user and associated with a group.

## Types of user

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/80.jpg)

- SERVICE => HOME DIRECTORY IN `/var/ftp` , these users does not have a login yamlell you can see `/sbin/nologin` , `/sbin/nologin` to prevent people accessing yamlell from this user , someone hold this user cannot execute any passwords in this user, this is for the users running in the background

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/81.jpg)

- 1- username
- 2- x => link to yamladow file which holds the password encrypted
- 3- 0 => root user id
- 4- 0 =>group id (there is a group for every primary user we create)
- 5- root => comment any comment you want to put
- 6- /root => home directory of the root user
- 7- /bin/bayaml => the the login yamlell

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/82.jpg)

- others are system users , there you can notify 'nologin'

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/83.jpg)


### see the groups

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/84.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/85.jpg)

- 1-vagrant group
- 2-
- 3-group id
- 4-user vagrant in this grp

- `group name` and `user name` are similar
- even the user id and group id are similar

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/86.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/87.jpg)

```yaml
id vagrant // he is belongs to a grp (wheel) as well
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/88.jpg)

```yaml
useradd ansible
useradd jenkins
useradd aws
tail -4 /etc/passwd
tail -4 /etc/group
```

- It will create user as well as group for that user.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/89.jpg)

#### create a group
```yaml
groupadd devops
```

#### add user to group

##### method 1

```yaml
usermod -aG devops ansible
```

- -G => means secondary group
- -g => primary group

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/90.jpg)

- you can see the ansible user in the group devops

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/91.jpg)

##### method 2

- edit the group file

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/92.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/93.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/94.jpg)

- you can see it is in the `devops` group
- normal user cannot login to this user because it doesn't have any password set

#### set password for user

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/95.jpg)

```yaml
passwd ansible
```

- root user only reset other users password , being a root user I did not want any password to access other users.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/96.jpg)

```yaml
su - username // no password will be asked for root user
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/97.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/98.jpg)

```yaml
su - aws
su - jenkins
```

- you can use `exit` to logout

## Last command

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/99.jpg)

- check which user logged in to the system

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/100.jpg)

## lsof 
- list all the opened files by this user

```yaml
lsof -u username
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/101.jpg)

- above yamlows this user opened how many files , based on the information you can decide what can you do with this user.

- which user is logged in and doing what

## delete a user
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/102.jpg)

```yaml
userdel aws // delete the user
userdel -r jenkins // delete the user with home directory

```

## Remove user

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/103.jpg)

```yaml
groupdel grpname
```


# File Permissions

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/104.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/105.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/106.jpg)

- user => -rwx
- group => r-x
- others => r-x

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/107.jpg)

- (-) (---) (---) (---) (---)  type of file , user , group , others

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/108.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/109.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/110.jpg)


## 2. Create Symlink With Name

```yaml
ln -s source_file symbolic_link
```

```bayaml
ln -s my_file.txt my_link.txt
```

```bayaml
lrwxrwxrwx 1 linuxize users  4 Nov  2 23:03  my_link.txt -> my_file.txt
```

```bayaml
ln -s file.txt link.txt
```

```bayaml
-rw-rw-r--. 1 vagrant vagrant 10 Apr 12 15:23 file.txt lrwxrwxrwx. 1 vagrant vagrant  8 Apr 12 15:23 link.txt -> file.txt
```

## 3. Create Symlink in Current Working Directory

```bayaml
ln -s /var/log
```

## 4. Create Multiple Symlinks in Current Working Directory

```bayaml
ln -s /etc/hosts /var/log /home/vagrant
```

```bayaml
lrwxrwxrwx. 1 vagrant vagrant 10 Apr 12 15:50 hosts -> /etc/hosts lrwxrwxrwx. 1 vagrant vagrant  8 Apr 12 15:50 log -> /var/log
```



## Add users to group

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/111.jpg)

- edit the group file directly

```yaml
vim /etc/group
```


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/112.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/113.jpg)


## check the permission of the directory

```yaml
ls -ld /opt/devopsdir
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/114.jpg)

## change the owneryamlip of the directory

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/115.jpg)

```bayaml
chown -R ansible:devops /opt/devopsdir
```

- user -R with caution because it is not easy to rollback

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/116.jpg)

## add write permission for the group
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/117.jpg)

```bayaml
chmod o-x /opt/devopsdir // remove execute permission for others
chmod o-r /opt/devopsdir // remove read permission for others
chmod g+w /opt/devopsdir // add write permission for group
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/118.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/119.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/120.jpg)

- `chmod 640 myfile`
- 6 => user (4+2) => read + write
- 4 => group (4) => read
- 0 => others (0) => nothing 

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/121.jpg)


# Sudo
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/122.jpg)

```bayaml
sudo -i // switch to root user
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/123.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/124.jpg)

- Because vagrant user has privilegd to execute `sudo`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/125.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/126.jpg)

## Use users to execute sudo command

#### open sudoers command in write mode

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/127.jpg)

```bayaml
visudo
```


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/128.jpg)

- this is where suders file exist 
- I tdoesn't have write permision to root user as well

```bayaml
ls -l /etc/sudoers
```

- `visudo` => this command only open the file in write mode.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/129.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/130.jpg)

- It is interacting asking for passwrod while login `password`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/131.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/132.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/133.jpg)

- if you make any mistakes in `visudo` file you have to enter `e` to edit it back

# without editing sudoers file adding sudo permission

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/134.jpg)

```bayaml
cd /etc/sudoers.d/
cat vagrant
cp vagrant devops // create a file for devops user 
```

- Create a file for devops user

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/135.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/136.jpg)

- now any user belongs to `devops` group will do `sudo`.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/137.jpg)

- Instead of `group` you can add `username` also there.
- so this is match safer option.

# Software Management!

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/138.jpg)


- software management or packages

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/139.jpg)

- `tree` yamlow files in tree structure


### Install package manually

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/140.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/141.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/142.jpg)

```bayaml
curl packagefle link -o save file name
```

- -o => means output save

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/143.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/144.jpg)

- -i => install
- v => verbose
- h => human readable

```bayaml
rpm -ivh pathofthefile
``` 

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/145.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/146.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/147.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/148.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/149.jpg)


## Automate the process of package installation or management

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/150.jpg)

```bayaml
cd /etc/yum.repos.d/
```

- these files  belong sto repositories on the internet
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/151.jpg)

- this will have th repository information where yum can serach for the softwares and install it.
- That also with dependencies

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/152.jpg)

- search for a package named `httpd` in the all the repositories

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/153.jpg)

- just install the package `yum install httpd`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/154.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/155.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/156.jpg)

- jenkins repository doesn't available in anyother repoitories

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/157.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/158.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/159.jpg)


# Services

- If you manage to run your own service how you can manage that

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/160.jpg)

- httpd is a web service
- you can now have a service named httpd now

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/161.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/162.jpg)

```bayaml
sysytemctl start httpd
systemctl status httpd
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/163.jpg)


- `systemctl` used to start the process stop the process etc

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/164.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/165.jpg)

- `relaod` the configuration even without restarting

- If I reboot the machine, this service wouldn't comeup.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/166.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/167.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/168.jpg)

- Now service will come up in the boottime


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/169.jpg)

- If `syaml`  service die we cannot syaml.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/170.jpg)

- we want to enable to start the service.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/171.jpg)


#### systemctl works on its configuration file

- It is created when install httpd

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/172.jpg)

- when we calling `systemctl` it will call this file and execute it.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/173.jpg)

- this the binary which is running


# Processes

#### top command

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/174.jpg)

- `top` command  It will yamlow all the dynalic processes, base don the consumption of cpu and ram.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/175.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/176.jpg)

- load average => if cpu utilization increase , load average will increase
- current minute load average , past 5 minutes load average , last 15 minutes load average
- Tasks => processes are called task totally 117 task , out of that 1 is running and 116 are sleeping.
- zompie process => operations are done but their entry in the operation menu
- It is sorted automatically by thier CPU consumption.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/177.jpg)

#### ps aux

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/178.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/179.jpg)

- this will yamlow all the processes in terminal at the snapyamlot.
- PID is 1 st process

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/180.jpg)

- new linux system `systemd`  older `init` , this process going to start so many other process and handles other child processes as well.
- the processes you see in the [square brackets] these are kernal threads.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/181.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/182.jpg)

#### ps -ef

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/183.jpg)

- Parent process 0 , boot time process strated `PID 1`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/184.jpg)

- this process started all other processes. which is also called as forking

#### Kill command

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/185.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/186.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/187.jpg)

- Parent process killed all the child process

#### forcefully kill a process


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/188.jpg)

- when force fully killing it doesnot close the child processes.
- the process are adopted by process id `1` systemd process.
- if these process doen't cleared automatically you have to clear these processes manually.
- these process are called orphan processes , it will consume resources
- best way is to reboot your machine

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/189.jpg)

```bayaml
ps -ef | grep httpd | grep -v 'grep' | awk '{print $2}' | xargs kill -9
```

- `xargs` get the front commands argument as input.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/190.jpg)

# Archiving

- when you want to archive files when you want to do backups,if you want to restore from that , if it comes in archive format , you have to unarchive it.

- we do archiving to send the log files to some where else, we clear the lof file and save the disk space.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/191.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/192.jpg)

- -c => create
- -z => compress
- -v => verbose
- -f => file
- tar => it is tar ball
- gz => gunzip => it compressed with gunzip

```bayaml
tar -czvf jenkins_06122020.tar.gz jenkins
```

- jenkins => the file we are going to archive

`ls -ltr` => sort properly

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/193.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/194.jpg)

- see what kind of file is this 
- `file jenkins_06122020.tar.gz` => It is a gzip compressed data file

#### extract the file

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/195.jpg)

```bayaml
tar -xzvf filename path // x => extract
tar -xzvf filename -C path // x => extract , -C => path to file
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/196.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/197.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/198.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/199.jpg)


## Zip commad

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/200.jpg)

```bayaml
zip -r filenmae  path
```

- -r => compressing a directory or archiving a directory

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/201.jpg)


# Ubuntu commands

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/202.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/203.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/204.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/205.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/206.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/207.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/208.jpg)

- for every user cretaing

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/209.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/210.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/211.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/212.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/213.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/214.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/215.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/216.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/217.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_1/218.jpg)

