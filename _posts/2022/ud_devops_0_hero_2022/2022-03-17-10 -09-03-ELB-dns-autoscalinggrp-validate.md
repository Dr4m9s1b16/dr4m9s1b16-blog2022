---
layout: post
title:  "09-03-AWS-Project"
author: haran
categories: [DevOps,DevOps Beginners to Advanced Course , aws]
image: post_img/2022/03/17_8/AWS.gif
beforetoc: "Loadbalancer , DNS , Auto Scaling group, Validation"
toc: true
comments: false
rating: 3.5
---

Loadbalancer , DNS , Auto Scaling group, Validation

# 09_05_LoadBalancer and DNS

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/1.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/2.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/3.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/4.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/5.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/6.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/7.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/8.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/9.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/10.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/11.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/12.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/13.jpg)

- We need an http and https connection for load balancer, 
- "Internet facing" we are hosting it on the internet.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/14.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/15.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/16.jpg)

- then remove port 80

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/17.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/18.jpg)

- Minimum two zones needs to be selected

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/19.jpg)


- We will select https so we need certificate for that -> we have an certificate in ACM so we willl directly tell choose one from AWS Certificate Manager.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/20.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/21.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/22.jpg)

- which allow port 80 and port 443 from anywhere.
- Route the request our , load balancer route the request to the target group , which have our application server.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/23.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/24.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/25.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/26.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/27.jpg)

# CREATE CNAME RECORD POINTING TO AWS INSTNCE

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/28.jpg)

- `vprofileapp.groofy.in` is our URL with https

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/29.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/30.jpg)

- This is pointing to the load balancer and load balancer will be routed the request to the tomcat

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/31.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/32.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/33.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/34.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/35.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/36.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/37.jpg)


# 09_06_Autoscaling Group

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/38.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/39.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/40.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/41.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/42.jpg)

- We will create lauch configuartion for auto scaling grp.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/43.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/44.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/45.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/46.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/47.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/48.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/49.jpg)

- Our instance can download artifact from there.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/50.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/51.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/52.jpg)

- Lauch configuration created ,Let's create auto scaling group.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/53.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/54.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/55.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/56.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/57.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/58.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/59.jpg)

- Instances will be automatically updated in the target groups

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/60.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/61.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/62.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/63.jpg)

# Automatically scaling in and slaing out you can use automatic tracking scaling policy

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/64.jpg)


- According to the CPU Utilization add instance delete instances


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/65.jpg)


- If we donot want our instance terminated automatically

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/66.jpg)

- If you want to see the log files you have to enable this thing
- If you have any dynamic instance check that checkmark on.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/67.jpg)

- to an ssn topic

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/68.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/69.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/70.jpg)

- This will create instance automatically

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/71.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/72.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/73.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/74.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/75.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/76.jpg)

# 09_07_Validation and Termination

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/77.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/78.jpg)


# If you want to create autoscaling grp for mem cache , rabbitmq , databases

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/79.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/17_10/80.jpg)

- We can do better things in AWS using auto scaling groups and EC2 instances , where we can use some PAAS , SAAS services.



