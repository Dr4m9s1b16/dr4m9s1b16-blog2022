---
layout: post
title:  "22-01-App deployment on Kubernates cluster Part 1"
author: haran
categories: [DevOps,Kubernates,DevOps Beginners to Advanced Course]
image: post_img/2022/03/21_4/main.jpg
beforetoc: "Introduction , Volume prerequest for db pod , Spin K8s cluster , Source code , Db Deployment definition"
toc: true
comments: false
rating: 3.5
---
Introduction , Volume prerequest for db pod , Spin K8s cluster , Source code , Db Deployment definition

## 22-01-Introduction

### Deploying webapps on Kubernatives cluster

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/1.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/2.jpg)

- Running Containers for production little bit different.

### Requirement

- you need high availability
- Requirement also for fault toloearnce => If something happen for contatiners they have to auto heal.
- Easily Scalable => It was able to scale and compute resource on which the containers are running
- Platform Independent
- Portable & Flexible , Agile

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/3.jpg)


- We are using container orchestration tool kubernatives, Kubernatives is the best available tool in the market,It very mature and rock solid platform to run your containers for production.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/4.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/5.jpg)

- redshift and Rancher also bult top on Kubernatives.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/6.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/7.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/8.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/9.jpg)

- In vprofile application there is a mysql link `store data` , which is persistent data , so we `create EBS` volume for `DB Pod`.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/10.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/11.jpg)

- we are going to create EBS volume in a zone, we need our pod to be running on the same node or the same zone, where we created the EBS volume, so for it is we are label our nodes with zone names

- so when we run our DBPod we will select based on the zones , once we are ready with all these steps

###### then we are going to write kubernatives definition file to create our objects in the kubernaive cluster

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/12.jpg)


- having a kubernatives cluster created with the kops

## 22-02-03-Volume Prereqs for DB POD

- we have to create a volume for our db pod wher it can store the mysql data  which stores in `var/lib/mysql` to EBS volume.

- Let's create a EBS volume

```yaml
aws ec2 create-volume --availability-zone=us-east-2a --size=3 --volume-type=gp2
```

- --availability-zone=us-east-2a
- --size=3 (3Gb)
- - --volume-type=gp2

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/13.jpg)

- We got the volume id
- when we run our db pod,it should be running  on the same  availability zone.
- we can define it through `node selection` option from our `definition file`
- `node selector` works with `labels`, so we are going to `create our own label.`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/14.jpg)

- here we can see the available labels

 ```yaml
 kubectl get nodes --show-labels
 ```
 
![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/15.jpg)

- There are existing labels we can use them but we are creating our own labels

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/16.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/17.jpg)

```yaml
kubectl describe node ip-172-20-47-16. us-east-2.compute.internal | grep us-east-2
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/18.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/19.jpg)

- This node is good for run our db pod (sql pod) , because both of them are in the `us-east-2`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/20.jpg)

```yaml
kubectl label nodes ip-172-20-47-16.us-east-2.compute.internal zone=us-east-2a
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/21.jpg)

```yaml
kubectl label nodes ip-172-20-67-99.us-east-2.compute.internal zone=us-east-2b
```

- done with our setup we have prerequest to run our service 

### 22-02-Spin K8s cluster

- I am in the aws instance , I have a EC2 instance called `kops` I have did all the prerequest for kops
- so with the two commands I am going to launch kubernative cluster.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/22.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/23.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/24.jpg)

- create kubernatives cluster configuration

```yaml
kops create cluster --name=vprokube.groophy.in --state=s3://vprofile-kops-state --zones=us-east-2a,us-east-2b --node-count=2 --node-size=t2.micro --master-size=t2.micro --dns-zone=vprokube.groophy.in
```

- --name => name of the cluster
- --state => that is the S3 bucket where I am saving the stats of kops command
- --zones => these are the zones what we are using
- --node-count => two worker nodes
- --node-size =>  worker node size
- --master-size => master node size
- --dns-zone => my dns zone name

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/25.jpg)

- with `kops update` command I am going to launch the kubernatives cluster

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/26.jpg)

```yaml
kops update cluster --name vprokube.groophy.in --state=s3://vprofile-kops-state --yes
```

- and that is going to take some time

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/27.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/28.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/29.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/30.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/31.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/32.jpg)


### Let's validate kubernative cluster

```yaml
kops validate cluster --name vprokube.groophy.in --state=s3://vprofile-kops-state
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/33.jpg)

## 22-04-Source code Overview

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/34.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/35.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/36.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/37.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/38.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/39.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/40.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/41.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/42.jpg)

- we are not ging to use `vprofile/vprofileweb` => we are going to spinning up `elastic load balancer` instead of that.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/43.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/44.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/45.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/46.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/47.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/48.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/49.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/50.jpg)


- we copid a artifact inside that 

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/51.jpg)

- this artifact is generated

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/52.jpg)

- this is `application.properties file`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/53.jpg)

- when container comes up from this image , it look for the backend services with these names

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/54.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/55.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/56.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/57.jpg)

- Please note down the port numbers thease are very usefull information, before creating our definition files

- Because we have to define these information, so our application can access the back end services.

- there are two sensitive information out there
- `database password` and `rabbitmq password`
- It will not ideal to put the password in text format.
- first we want to encrypt the password with secret and with the pod definition we can access this encrypted paswords (encoded)


## 22-05-Kube-Secret-for-Passwords

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/58.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/59.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/60.jpg)


- 2 -What kind of file : `Secret`
- 3-give name to that secret : `app-secret`
- 3-type : `Opaque`
- db-pass : `name in the pod definition file`
- rmq-pass: we can give any key also we can mention it as `rmq-pass`
- first we are going to encode the values of our password and then we are going to mention it over here.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/61.jpg)

- first encode the above password.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/62.jpg)

```yaml
echo -n "vprodbpass" | base64
```

- which can be used in our definition file.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/63.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/64.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/65.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/66.jpg)

- save and commit htis file

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/67.jpg)

- we have to fetch it in our `kops VM`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/68.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/69.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/70.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/71.jpg)

- you can see the detail information and you can see that.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/72.jpg)

- this will saved in the kubernative cluster and it prevent the accidential exposes of your passwords

## 22-06-db Deployment Definition

- write db definition file

- `app:vprodb` => this is for the service definiton file , so we are going to create a service of `cluster ip` , and our cluster will be route the request to any port which  have the above label.
- `replicas` => there is one db we are not going to do clustering here

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/73.jpg)

- we are going to use `image` from the containerization project

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/74.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/75.jpg)

- Our mysql service run on `port 3306`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/76.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/77.jpg)

- `db_pass` assigned to this variable in the conatiner

- I have created a volume so `dbpod` should be run the same zone , where I am created volume `EBS`.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/78.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/79.jpg)

```go
kubectl get nodes --show-labels
```


- `volumes` : volume name
- `awsElasticBlockStore`: give the volume id here
-  `fsType` : file system type , this is `extension4`

> Problem

- pod will not be able to attach to this `EBS volume` , because in kuberantives we have to give a `tag` to the volume which we want to attach.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/80.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/81.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/82.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/83.jpg)

- `pod` or `node` is going to attach with this volume , othrwise you can get `permission denied errors`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/84.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/85.jpg)

- while creating `kubernative cluster` we gave the name as `--name` => that is the name of the cluster.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/86.jpg)


- `mountpath` => where we going to mount the volume `/var/lib/mysql`
- `name` => name of the mounting volume 

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/87.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/88.jpg)

- this is the name of the `volume` we created in the volumes
- volume created in `volumes ` and mounted over `containers - volumeMounts`

> error
- you will get one more  eror if you just roll this out
- the error will come from the pod `kubectl podname logs` you can see the error `Volume or storage is not empty` it alrady have data:
- when we created `extension4` => ext4 it will cerate a directory over there `lost+found` it happens in linux , if the volume mounts find there is already in the data then it will not mounted.

- you have to pass an argument to pod/containers `ignore-db-dir=lost+found` if it there taht will ignore it and attach the volume
![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/89.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/90.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/91.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/92.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/93.jpg)

### Test the file

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/94.jpg)

```go
kubectl create -f vprodbdep.yaml
```


### Deploy the file 

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/95.jpg)

```go
kubectl get deploy
```

- the real information come from the pod , if any issue in creating the pod and mounting the volume , you can find it through `describe` command

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/96.jpg)

```go
kubectl describe pod podname
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/97.jpg)

- It is still at `pulling image state`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/98.jpg)

- we are getting an error warning `BackOff` => It is restarting the conatiner for some reason.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/99.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/100.jpg)

```go
kubectl logs podname
```

- there is an issue with the option `lost+found`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/101.jpg)

- `--` it should be -- ignore

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/102.jpg)

- this is successful success messages are
- `Attached Volume`, `container image created`,  `started container`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_4/103.jpg)

