---
layout: post
title:  "09-01-AWS-Project"
author: haran
categories: [DevOps,DevOps Beginners to Advanced Course , aws]
image: post_img/2022/03/17_8/AWS.gif
beforetoc: "Project Introduction-Security group and KeyPair"
toc: true
comments: false
rating: 3.5
---

Project Introduction-Security group and KeyPair

# 09_AWS Cloud Project setup _ Lift and Shift


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/1.jpg)

- Shift the VProfile application on AWS cloud.
- after this you can learn how to handle application workload using Lift and shift startegy.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/2.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/3.jpg)

## We need several teams for this.

- Virualization team - virualization problem
- Data center operation team
- Monitor 24x7
- System admin team

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/4.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/5.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/6.jpg)

## Solution 

- There is no any cost for procurring devices or system.
-  Consuming Infrastructure as a service.
- Flexibility -> Scale  out or Scale in we can manage our cost.
- Ease of Infra Management.
- We can do automationa and save human errors and time.
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/7.jpg)

## We are using these services

- EC2 instances is a VM for TomCat , RabbitMQ ,Memcache ,MySql servers.
- Elastic Load balancer which is used as NGINX service in cloud.
- Autoscaling which is automatically scale in ,scaleout instances , which is automatically control our resources also our cost.
- For storage we are using S3 OR EFS Storage.
- Route 53 for our private DNS Service.
- IAM/EBS/EBS Etc .

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/8.jpg)

# Objective

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/9.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/10.jpg)

# Our Stack from previous project

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/11.jpg)

- Shift this stack to AWS cloud.
- Users will access our url with using the url.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/12.jpg)

- DNS resolution  happen here

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/13.jpg)

- Resolved url poin to aws load balancer.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/14.jpg)

- Certificate for this issed by Amazon Certifiacte Manager (ACM).
- User will access load balancer application endpoint 
	-> Our load baancer only allow https request through security group 
	-> AWS load balancer route the request to tomcat instances 
	-> Apache tomcat service will run on set of EC2 instances which will be managed by our autoscaling grp
	-> According to the laod aws security capacities expanded and shrinked.
	-> These EC2 instances running in a different security groups and only allowed traffic from port 8080 from load balancer only. 
	-> Other servers running RABBIT MQ , MEmcache, SQL these are defined in Route 53 DNS zones. (Backend service ip addresses are mentioned here). 


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/15.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/16.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/17.jpg)


### Other servers are mentioned in different security group.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/18.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/19.jpg)

## AWS Services used here

- ACM -> Amazon certificate manager
- Application Load Balancer
- Set Of EC2 instances for tomcat memcache , sql ,rabbit mq
- Three different security groups
- Amazon route 53 for dns private zones.
- Amazon S3 bucket to store our software artifacts

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/21.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/22.jpg)

## Flow of Execution

- Security group for tomcat ,load balancer , ec2instances

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/23.jpg)

- After we create auto scaling for tomcat instances.

# 09_02_Security group and KeyPairs

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/19.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/23.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/26.jpg)

- ssl certificates used for https connections through load balancer

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/27.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/28.jpg)

# Create security group for load balancer

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/29.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/30.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/31.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/32.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/33.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/34.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/35.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/36.jpg)

- Allow traffic only from the load balancer.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/37.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/38.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/39.jpg)
- Create security grp for backend services. (Rabbit mq , memcache , mysql )

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/40.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/41.jpg)
- add memcache and rabbit mq also
- memcache  port 11211
- rabbit mq port   5672

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/42.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/43.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/44.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/45.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/46.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/47.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/48.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_8/49.jpg)

