---
layout: post
title:  "21-05-Kubernates Replication Controller Part 5"
author: haran
categories: [DevOps,Kubernates,DevOps Beginners to Advanced Course]
image: post_img/2022/02/23/kubernates1.jpg
beforetoc: "Replication Controller"
toc: true
comments: false
rating: 3.5
---
Replication Controller

## 21-05-Replication Contoller

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/1.jpg)

- If you maintain pods with replication controller , it will automatically replaced if it is failed or deleted

- If too many ports it will terminates the extra pods also
- If there are too few , the replication controller starts more pods

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/2.jpg)


### Pod without Replication controller

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/3.jpg)

- for some reason the pod goes down

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/4.jpg)

- or te container runnning inside is corrupted for some reason , then user cannot able to access your port , that will bad for business , so we need high availability on that , It should be able to tolearte that fault.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/5.jpg)

- So that we use a replication controller.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/6.jpg)

- if we run with a replication controller, we can mention the replicas also , even if we give even single replica , make sure our pod is always up and running , it something go beyond it will launch the replacement.

- I f you tell 3 pods , it will make sure three pods are running , this is similar to autoscaling grp - the policies, no policies here  to auto scale it will maintain the number of replicas.

- Moreover when gives the information about the scheduler , schedulser will distributed to multiple worker node, if the node goes down, your pods are maintained by the replication controller.
- Replication controller will find that out and it will launch the replacemnet of the pod , In helathy worker node, so you get the high availability in the pod level and also at the node level.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/7.jpg)

- Let's see it's definition file

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/8.jpg)

- 2-Replication controller - `R capital c capital`
- 3-metadata - `you will give name and labels`
- 4-template - that will be the template of the pod actually ,as you can cretae pod definition file similar to that, 
- `replicas` : even with templates you will how many replicas you will give 
- `selector` : consider if you have pod with same label running one single pod , you give `replica here 2`, so the replication controller will launch one pod, the pod which was already running will be included in your replication controller. that what selector does, selector look for the label and included in the controller.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/9.jpg)

- Port `spcifications` and `meta data` are same
- If you know how to run a pod

### Create & View Replication controller

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/10.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/11.jpg)

```yaml
kubectl create -f tom-app-rc.yml // create application controller
kubectl get rc // view application controller
kubectl get pod // get pods in the application controller
```

### Edit & Scale RC (Replication controller)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/12.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/13.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/14.jpg)

```yaml
kubectl edit rc app-controller
kubectl scale rc app-controller --replicas=4
kubectl get pod
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/15.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/16.jpg)

```yaml
vim vproapp-repl-controller-yaml
```


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/17.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/18.jpg)


- --wait=false => It will not wait until pod get deleted , it return backs the shell basically

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/19.jpg)

```yaml
kubectl delete pod vproapp-controller-nzksp --wait=false
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/21.jpg)

- you can see how fast is that for auto scaling.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/22.jpg)

```yaml
kubectl get rc
kubectl edit rc controller name
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/23.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/24.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/25.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/26.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/27.jpg)

```yaml
kubectl scale --replicas=1 rc vproapp-controller
```

- scale down with command prompt

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/28.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_3/29.jpg)

Note:
replication controller alternative =>? easily do `deployment object`

### Deployment Object


