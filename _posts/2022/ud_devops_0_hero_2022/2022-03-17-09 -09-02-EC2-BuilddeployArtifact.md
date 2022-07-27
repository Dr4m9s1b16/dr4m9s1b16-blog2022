---
layout: post
title:  "09-02-AWS-Project"
author: haran
categories: [DevOps,DevOps Beginners to Advanced Course , aws]
image: post_img/2022/03/17_8/AWS.gif
beforetoc: "EC2 instances - Build deploy artifacts"
toc: true
comments: false
rating: 3.5
---

EC2 instances - Build deploy artifacts

# 09_03_EC2 Instances

# Provisioning MySql service

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/1.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/2.jpg)

- Checkout new branch in local computer.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/3.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/4.jpg)

-> install mariadb on centos
-> start the my sql service and enable it.
-> Clone the mysql server
-> Initialize the database

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/5.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/6.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/7.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/8.jpg)

## Create an instance for my sql service

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/9.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/10.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/11.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/12.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/13.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/14.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/15.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/16.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/17.jpg)

- Instance will come quick but user data shell scripts nees to be executed  to provision mysql service.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/18.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/19.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/20.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/21.jpg)

## check provisioning is running or not

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/22.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/23.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/24.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/25.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/26.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/27.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/28.jpg)

---
---
# Provisioning memcache

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/29.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/30.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/31.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/32.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/33.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/34.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/35.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/36.jpg)

# Provision RabbitMq

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/37.jpg)

> same configuartion as above

************************************************************************

# Validate memcache and Rabbitmq instances.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/38.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/39.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/40.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/41.jpg)

```sh
curl http://169.254.169.254/latest/user-data
ss -tunpl | grep 11211
```

## check rabbit mq provisioning and running

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/42.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/43.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/44.jpg)

# Update private IP of these three instances on route53 dns zone services

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/45.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/46.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/47.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/48.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/49.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/50.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/51.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/52.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/53.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/54.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/55.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/56.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/57.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/58.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/59.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/60.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/61.jpg)

-  this is used by tomcat EC2 Instance in application.properties file. these names rather than mentioning IP addresses.
- If we replace the backend server and if we give same name, we didnot want to make nay changes to application server.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/62.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/63.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/64.jpg)

- we will build tomcat server llocally and push the artifacts on the server  through S3 bucket , we will use ubuntu 18 AMI for that.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/65.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/66.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/67.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/68.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/69.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/70.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/71.jpg)

- Port 22 will not accept we define after instance is launched.

# 09_04_Build and Deploy Artifacts

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/72.jpg)

- we will build the artifacts now.

- we will  need jdk and maven want to install in our instances.
- windows machine chocolety used to install jdk 

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/73.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/74.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/75.jpg)

## Time to build the artifacts

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/76.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/77.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/78.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/79.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/80.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/81.jpg)

- If above entries are fine we can build source code with artifacts.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/82.jpg)

- Which will generate our artifact -> This process take some time 
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/83.jpg)

- we store this war artifact to s3 bucket and we download from there to our EC2 instances.

## Inorder to send to S3 Bucket we need AWS command line cli.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/84.jpg)

# Create an IAM user which is used for authentication for AWS CLI

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/85.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/86.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/87.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/88.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/89.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/90.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/91.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/92.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/93.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/94.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/95.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/96.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/97.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/98.jpg)

```sh
aws s3 mb s3://vprofile-artifact-storage
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/99.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/100.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/101.jpg)
```sh
aws s3 cp vprfile-v2.war s3://vprofile-artifact-storage/vprofile-v2.war
aws s3 ls s3://vprofile-artifact-storage/
```

## Inorder to downlaod artifact in EC2 instance we will create an role.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/102.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/103.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/104.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/105.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/106.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/107.jpg)

- app01 have authentication to access S3 bucket by that role we gave.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/108.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/109.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/110.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/111.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/112.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/113.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/114.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/115.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/116.jpg)
```sh
aws s3 ls s3:vprofile-artifact-storage
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/117.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/118.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/119.jpg)

```sh
cp vprofile-v2.war /var/lib/tomcat8/webapps/ROOT.war
```

- then this will become our defualt application.
- Let's start tomcat8 service.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/120.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/121.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/122.jpg)

- there we will have the application.properties file

```sh
ls /var/lib/tomcat8/webapps/ROOT/WEB-INF/classes
application.properties
```
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/123.jpg)

# validate network connectivity

- Install telnet

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/124.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_9/125.jpg)

```sh
telnet db01.vprofile.in 3306
```


## Telnet

Telnet is an application protocol used on the Internet or local area network to provide a bidirectional interactive text-oriented communication facility using a virtual terminal connection

- If you are unable to connect causes
	-> host
	-> ip
	-> port numbers

- validat with telnet


