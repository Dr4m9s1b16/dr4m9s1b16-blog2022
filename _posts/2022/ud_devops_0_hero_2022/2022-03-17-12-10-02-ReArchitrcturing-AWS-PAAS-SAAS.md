---
layout: post
title:  "10-02-Rearchitecturing on AWS PAAS & SAAS"
author: haran
categories: [DevOps,DevOps Beginners to Advanced Course,aws]
image: post_img/2022/03/17_11/saas.gif
beforetoc: " Beanstalk Endpoint,Buld and deploy artifact , Cloud front"
toc: true
comments: false
rating: 3.5
---

 Beanstalk Endpoint,Buld and deploy artifact , Cloud front

# 10_07_Beanstalk endpoint

- MySql is up and running , elastc ccahe up and running.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/1.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/2.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/3.jpg)

- port is 5671

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/4.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/5.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/6.jpg)

- Our backend is up and running -> we will create beanstalk.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/7.jpg)

- Our artifacts are uploaded to beanstalk.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/8.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/9.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/10.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/11.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/12.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/13.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/14.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/15.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/16.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/17.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/18.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/19.jpg)

- We have mulyiple instance.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/21.jpg)



- to create custom ami you have to read the documenation to create it.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/22.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/23.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/24.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/25.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/26.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/27.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/28.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/29.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/30.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/31.jpg)

# How do you like to do deployments

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/32.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/33.jpg)

- We have 2 EC2 instances when we upgrade when we deploy new application  versions , then it will do both instance at a time -> So there is a downtime.
- Rolling with additonal batch -> Extra instances added and old instances will be removed.
- Immutable -> It is create same amount of instances at the point of upgrading.
- There are different deployments policies -> Read more on the documenation.

- Rolling -> one instance updated ata time.
- you can mention that in percentage.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/34.jpg)

- 50% of two instance one instance at a time.
- good number is 25% for production. ->  so you have to have minimum four instances.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/35.jpg)


# Security

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/36.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/37.jpg)

# Monitoring

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/38.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/39.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/40.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/41.jpg)

# Tags

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/42.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/43.jpg)

- this tag will be on the EC2 instance.


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/44.jpg)


- You can create RDS from here also but for production -> decouple RDS with elastic beanstalk.


# Network

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/45.jpg)

- If you put beanstalk instance in different VPC you have to select that well.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/46.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/47.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/48.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/49.jpg)



# Create more environments

- If we want we can make more environment like this -> dev , production ,QA environment.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/50.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/51.jpg)

- then ,We want to updte  Vprofile artifact successfully .

# Update backend security group


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/52.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/53.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/54.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/55.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/56.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/57.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/58.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/59.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/60.jpg)

# Add  port 443 load balancer https connection

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/61.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/62.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/63.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/64.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/65.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/66.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/67.jpg)

- Target grp will do the health check in port 80  /login.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/68.jpg)

# 10_08_Build and Deploy Artifact


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/69.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/70.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/71.jpg)

- rds enpoint start with `vprofile-rds-mysql.c9em1dvcc2dr.us-east-1.rds`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/72.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/73.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/74.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/75.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/76.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/77.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/78.jpg)

- updated the artifact into the S3 bucket automatically.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/79.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/80.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/81.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/82.jpg)

- we selected rolling update our environment never got down.


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/83.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/84.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/85.jpg)

- rolling update we have 2 instance 1 instance at at time.
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/86.jpg)


# Make a DNS entry with godaddy

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/87.jpg)


- wait foer some time to ISBN can capture the new resolution.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/88.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/89.jpg)

# make stickyness policy enabled

##  make changes to BEANSTALK CONFIGURATION before accessing the database.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/90.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/91.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/92.jpg)

- make stickyness policy enabled

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/93.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/94.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/95.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/96.jpg)

- verified beanstalk , RDS 

# 10_09_Cloud front

- Global content delivery network - website is cached against 200 datacenters around the world.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/97.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/98.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/99.jpg)

- We can point it to the laod balancer or S3 bucket. Point it to the domain

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/100.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/101.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/102.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/103.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/104.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/105.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/106.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/107.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/108.jpg)

- Behind the scenes Cloud watch is also using S3 bucket. Low operational overhead 

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/109.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/110.jpg)


- rather than godaddy.
- You can use both route 53 for subdomain and godaddy for domain.

# 10_10_Validate and Summarize

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/111.jpg)

- User cannot understand rquest is coming from load balancer or cloudfront.
- Inspect using element in browser.


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_12/112.jpg)


- Our website is saved from cloud front distributed network.




