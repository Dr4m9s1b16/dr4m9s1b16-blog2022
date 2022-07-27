---
layout: post
title:  "22-02-App deployment on Kubernates cluster Part 2"
author: haran
categories: [DevOps,Kubernates,DevOps Beginners to Advanced Course]
image: post_img/2022/03/21_4/main.jpg
beforetoc: "DB Service definiton , Memcached Deployment Service ,Rabbitmq deployment service , TomCat deployment service & init,Provision stack on K8s cluster , URL-for WebSite & wrapup"
toc: true
comments: false
rating: 3.5
---
DB Service definiton , Memcached Deployment Service ,Rabbitmq deployment service , TomCat deployment service & init,Provision stack on K8s cluster , URL-for WebSite & wrapup

## 22-07-DB-Service-Definition
- we have to cerate a service for this db, so our application pod can access it.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/1.jpg)

- this is only for the internal traffic , we didnot expose to the outside world
- all our services are based on our application properties file , for our application.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/2.jpg)

- and the port number `3306` 
- service should accept the request on 3306 , and send it back to our `db pod`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/3.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/4.jpg)


- send back to the `backend port 3306`. 

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/5.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/6.jpg)

- so you have to give the same label over there.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/7.jpg)

## 22-08-MemcachedDeployment&Service

- Pod definition file or deployment definition file for the memcache.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/8.jpg)

- this is the simple deployment definition file.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/9.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/10.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/11.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/12.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/13.jpg)

# Service definition file for memcache

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/14.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/15.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/16.jpg)


- the service is running in this name  and listening to the request at `11211`
- and forwarding it to `vpromc-port`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/17.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/18.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/19.jpg)

## 22-09-RabbitMq Deployment pod
![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/20.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/21.jpg)

- this is an offical image from docker hub ; `port 15672` that is the name of the pod

- we have to set two envronmental variable over here ;
- `rabbitmq user` and `rabbit mq password`.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/22.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/23.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/24.jpg)



## 22-09-RabbitMq Deployment Service

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/25.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/26.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/27.jpg)

## 22-10-TomCat Deployment,Service&Init

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/28.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/29.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/30.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/31.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/32.jpg)

- In this `pod` we have multiple conatiners.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/33.jpg)

- other two containers are `init` containers or `supporting` containers .
- I want `db container` created `first` then `the pod created`
- so I want a shell script executed from  `busybox`
- `busybox` is also an image.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/34.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/35.jpg)

- main container halted until `initContainer` do the work.
- the `busybox` containers utility is to check the `db Service`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/36.jpg)

```yaml
until nslookup vprodb;do echo waiting for mydb; sleep 2; done ; 
```

- this is look for `vprodb` to  ready until it will loop ; echo "waiting for mydb"
- It will sleep for 2 seconds and execute again.
- It doesnot return true it will loop , doesnot meat the value it keep on running.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/37.jpg)

- when you have dependency like that you can link by init conatiners.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/38.jpg)

- we have added another dependency , vprocache0  check

- when command run successfully `initContainers` are dead and main container will be launched

## Create service definition file for tomcat

- we would have a load balancer before this.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/39.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/40.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/41.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/42.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/43.jpg)

- this is going to launch a elastic load balancer

## 22-11-Provision stack on K8s cluster

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/44.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/45.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/46.jpg)

```go
kubectl create -f .
```

- It will load all the `yaml` files

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/47.jpg)

- deploy all the things
- vproapp still not up

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/48.jpg)

- It is up

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/49.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/50.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/51.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/52.jpg)

## 22-12-URL-for WebSite & wrapUp

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/53.jpg)

- we put CNAME entry to the `root 53`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/54.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/55.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/56.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/57.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/58.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/59.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/60.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/61.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/62.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/63.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/64.jpg)

- Successfully deployed in kubernative cluster.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/65.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/66.jpg)

- clear everything.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/67.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_5/68.jpg)

- cluster deleting

```go
kops delete cluster --name vprokube.groophy.in --state=s3://vprofile-kops-state --yes
```
