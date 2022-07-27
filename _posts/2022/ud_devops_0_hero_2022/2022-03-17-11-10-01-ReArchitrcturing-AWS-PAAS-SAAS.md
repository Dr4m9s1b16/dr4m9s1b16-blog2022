---
layout: post
title:  "10-01-Rearchitecturing on AWS PAAS & SAAS"
author: haran
categories: [DevOps,DevOps Beginners to Advanced Course , aws]
image: post_img/2022/03/17_11/saas.gif
beforetoc: "Security group and keypairs , RDS ,Elastic Cache ,Amazon mq , DB Initialization "
toc: true
comments: false
rating: 3.5
---

Security group and keypairs , RDS ,Elastic Cache ,Amazon mq , DB Initialization 

# 10_01_Introduction

- From previous project we can know how to deploy web application in AWS cloud.]

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/1.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/2.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/3.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/4.jpg)

- We use platform as a service, Software as a service approaches
- We can code our infrastructure
	-> Very flexible , Elastic in service
	-> Scaling mostly taken care by the cloud vendor.
	-> Pay as you go model.
	-> don't need huge team.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/5.jpg)

- BeanStalk will create an EC2 instance and run the tomcat server on this.
- We don't need to install manually , Beanstalk service will take care of it.

# Front Usage

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/6.jpg)

- that is all about front end

# Backend Usage

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/7.jpg)

- if you have audience all over the world then cloud content delivery network will be very easy and useful.


## Let's talk about backend

- It will be a platform as a service , you can get a platform to choose from.
- You fill in the requirements and database is up and running in no time.
- Scaling will be easy
- Reglular backupd done oftenly

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/8.jpg)



![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/9.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/10.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/11.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/12.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/13.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/14.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/15.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/16.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/17.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/18.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/19.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/21.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/22.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/23.jpg)

# 10_02_Security group and keypairs

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/24.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/25.jpg)

- Trouble shoot the BEANSTALK Ec2 instance we need a login.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/26.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/27.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/28.jpg)

# Create security grp for backend services

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/29.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/30.jpg)


- All the backend services we are using elastic cache,rds,active mq will create in a private network , so any way we don't need to access from our public ip

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/31.jpg)

- all the backend services needs to interact with each other -> so all traffic allowed by its own security group id.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/32.jpg)

- one more rule needs to be added here allow access to beanstalk EC2 instance , before that we need to create beanstalk EC2 instance -> then changes in security group rules.

# 10_03_RDS(SQL - Cre back services)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/33.jpg)

# 1.Create sunet grp for RDS instance

- Place the RDS instance in that subnet grp

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/34.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/35.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/36.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/37.jpg)

What is AWS VPC?

- A **virtual private cloud** (VPC) is a virtual network dedicated to your AWS account. 
- It is logically isolated from other virtual networks in the AWS Cloud. 
- You can specify an IP address range for the VPC, add subnets, associate security groups, and configure route tables. 
- A subnet is a range of IP addresses in your VPC

- this is default VPC in later project we are going to make our own custom VPC.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/38.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/39.jpg)

- So rds instance is placed in any of this subnet
- we also has security grp for our rds instance.

# 2.Create special parameters for RDS (DB administrator job)

- You have recommendation for performance tuning , then you will create a parameter group.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/40.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/41.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/42.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/43.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/44.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/45.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/46.jpg)

- Amazon aurora runs faster than this,

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/47.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/48.jpg)

## 2.1 In production u have

- multi AC instance
- production IOPS

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/49.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/50.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/51.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/52.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/53.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/54.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/55.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/56.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/57.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/58.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/59.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/60.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/61.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/62.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/63.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/64.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/65.jpg)

# 10_04_ElasticCache

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/66.jpg)

# 1.Create elastic cache parameters

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/67.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/68.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/69.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/70.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/71.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/72.jpg)

- He select all of them



# 2. Memcache creation

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/73.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/74.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/75.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/76.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/77.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/78.jpg)

# 10_05_ Amazon mq

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/79.jpg)

# 1.Create Amazon mq broker
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/80.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/81.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/82.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/83.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/84.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/85.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/86.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/87.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/88.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/89.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/90.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/91.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/92.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/93.jpg)

# 10_06_DB Initialization

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/94.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/95.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/96.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/97.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/98.jpg)

- Make sure we can create in the same VPC other than that we can not login to the RDS engine.


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/99.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/100.jpg)

- This instance is  for just temporary purpose

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/101.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/102.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/103.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/104.jpg)

- get the public ip and login to it.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/105.jpg)

- Install mysql client so access the RDS endpoint from here.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/106.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/107.jpg)

```go
mysql -h vprofile-rds-mysql-> endpoint -u username -p password
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/108.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/109.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/110.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/111.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/112.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/113.jpg)

- switch to branch `aws-Refactor`.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/114.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/115.jpg)

```go
cd /src/main/resources/
mysql -h endpoint -u username -p password table_name < Schema_db_backup.sql
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_11/116.jpg)


