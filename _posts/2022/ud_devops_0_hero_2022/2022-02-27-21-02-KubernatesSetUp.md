---
layout: post
title:  "21-02-Kubernates SetUp (kops) Part 2"
author: haran
categories: [DevOps,Kubernates,kops,DevOps Beginners to Advanced Course]
image: post_img/2022/02/27/kops.jpg
beforetoc: "Kops, is an open source project used to set up Kubernetes clusters easily and swiftly. It's considered the “kubectl” way of creating clusters. Kops allows deployment of highly available Kubernetes clusters on AWS and Google (GCP) clouds"
toc: true
comments: false
rating: 3.5
---

Kops, is an open source project used to set up Kubernetes clusters.

## SetUp with Kops

- Multi node Kubernates Cluster on AWS
- Most good way to run the kubernative cluster
- Now supported on multiple cluster

We have to setup , domain for Kubernates DNS records. Login to AWS account and setup:
- S3 bucket
- IAM User for AWSCLI
- Route53 Hosted Zone

SeUp base machine for kubernative cluster,It's a base machine which is not in the  kubernative  cluster, We are installing :
- Kops
- KubeCtl
- ssh keys
- AWS CLI

In aws account we need an S3 bucket and I am user for AWS cli , we need route 53 hosted zone, which will be our subdomain.

## Create NS records

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/1.png)

- Login to Domain Registrary in GoDaddy
- Cretae NS records for subdomain pinting to Route53 hosted zone NS servers.
- After creating hosted zone we will give an entry , we will give NS server name server URL's, we are going to give entry in our domain, we use godaddy.
- We create 4 NS records, which is going to pointout to the subdomain from name server to aws route 53
- Domain in godaddy subdomain in amazon route 53

## Create t2 instance in AWS

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/2.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/3.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/4.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/5.png)

## Create S3 bucket in AWS
- S3 bucket save the state of kops -> so we can run the kops command from anywhere as pointed to our s3 bucket

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/6.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/7.png)

- We have an bucket now

## Create an IAM user in AWS

- This is for our CLI usage

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/8.png)

- Move it to local user bin
- Because It is going to access various services like VPC , It is oing to create , autoscaling grp,route 53.

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/9.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/10.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/11.png)


## Create route 53 hosted zone

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/12.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/13.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/14.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/15.png)

- We add this entry to our domain registrar

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/16.png)

- I am going to add four NS records => points to our NS server four.

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/17.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/18.png)

- name server which points to aws route 53
- Now we have Iam user and S3 bucket

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/19.png)

## Login with ssh key (pem)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/20.png)

- first generate the ssh key , that used by kops.

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/21.png)

- Public key will be pushed to all our instances.

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/22.png)

## Install aws cli

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/23.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/24.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/25.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/26.png)

```go
sudo apt install awscli
aws configure
```

## Install kube ctl

- Now aws cli configured, now we need kubectl and kops.

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/27.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/28.png)

- And move it to local user bin.
- when we move it to there , we can access it from anywhere.

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/29.png)

## Install kops

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/30.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/31.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/32.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/33.png)

- Let's give executable permission.

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/34.png)

- move that file.

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/35.png)

- Now we run the kops command and create our cluster.

## Verify the domain records

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/36.png)

- That is verify our our domain server.

## Create kubernative cluster with kops

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/36.png)

```go
kops create cluster --name=kubevpro.groophy.in --state=s3://vprofile-kops-state --zones=us-east-2a, us-east-2b --node-count=2 --node-size=t2.micro --master-size=t2.micro
--dns-zone=kubevpro.groophy.in
```

- I want  two worker node and one master node
- master node doesn't run any workload
	- but it runs services like controller manager , scheduler , api-server

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/37.png)

- It will not create the cluster , but it creates the configuration for the cluster in our S3 bucket.

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/38.png)

 - If we are confident with the configuration we can run 

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/39.png)

```go
kops update cluster --name kubevpro.groophy.in --yes
```

- but we have to give the bucket state every time

- after entering this command it creates cluster for me.

```go
kops update cluster --name kubevpro.groophy.in --state=s3://vprofile-kops-state --yes
```
1. Upart from that it will create VPC , It will create autoscaling groups and mange our EC2 instances our worker 
2. Load EC2 instances and master node from auto scaling grp.
3. at any time we need another node we can edit / add the node by using the kops command;every time we run the kops command we have to state the bucket path.
4. As long as you have access to that bucket you can run that command from anywhere , from your computer , laptop and any EC2 instances.
5. S3 bucket save the state of kops -> so we can run the kops command from anywhere as pointed to our s3 bucket.

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/40.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/41.png)

- distributed in two availability zone

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/44.png)

- we can do all the changes from our kops command.

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/42.png)

- EC2 instance is part of this VPC

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/43.png)

- api.internal => it points to fake address first , but that will be changed when your kubernative master is stable.

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/45.png)

- In the records over here.

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/46.png)

## Validating the cluster

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/47.png)

```go
kops validate cluster --state=s3://vprofile-kops-state
```

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/48.png)

- you can see three kubernative cluster that is going to live.

## kube config files

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/49.png)

```go
cat .kube/config
```

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/50.png)

- name of the cluster
- user information

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/51.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/52.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/53.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/54.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/55.png)

- used by control plane and our worker node services.

## Check it through kube ctl now

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/56.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/57.png)

```go
kubectl get nodes
```

- delete the cluster


```go
kops delete cluster --name=kubevpro.groophy.in --state=s3://vprofile-kops-state --yes
```

- that will delete the kubernative cluster

![dockerengine]({{ site.baseurl }}/post_img/2022/02/27/58.png)