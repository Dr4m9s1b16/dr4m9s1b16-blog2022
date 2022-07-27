---
layout: post
title:  "21-03-Kubernates Service Part 4"
author: haran
categories: [DevOps,Kubernates,DevOps Beginners to Advanced Course]
image: post_img/2022/02/23/kubernates1.jpg
beforetoc: "Kubernates Service"
toc: true
comments: false
rating: 3.5
---
Kubernates Service


## Service

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/1.jpg)

- service is similar to load balancer , you want to expose the pod , pod communicating with each other , you need service infront of your pod

### 1.Why service created without port mapping

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/2.jpg)

- Pods (Containers) are disposable same thing with pod , so if you want to change , we give different container image name , we created different port for that , when we make change we upgrade the pod nad replace the pod ,
- so pods are mortal , they have ip address , but it is not static , so you need a static , like an endpoint , behind the endpoint you can change things,
- so service give that endpoint , what elb does (**elastic load balancer does**) to EC2 instances , give static end point we can access elastic load balancer,
- behind the scenes creating and editing EC2 instances , similar way service does it in kubernatives

### Service type
- we have three types of srvice
- **Node port** => which is similar to port mapping ,a host port you pickup and map it with the container port , **it is for non production purpose**.
	- Not for exposing the front end for production , this is only for exposing your pod for outside network

- **Cluster Ip** => if you won't need to expose to outside network but  internal like tomcat connecting to mysql , mysql you need a static endpoint , you can create a service of cluster ip , cluster ip for internal communication, so here no port mapped to your node internal communication.

- **Load Balancer** => This is again to expose to outside network , network for production use cases, we are running a tomcat pod, I want users from the internet to access that will create the service of type load balancer on AWS it will create a actual elastic load balancer and map my port to it.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/3.jpg)


- so every pod or cluster of pod that are running , you need a service infront of that if it is a network, it is providing a network service , like a front end we have a service.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/4.jpg)

- so backend rabbit mq, elasticcache we have a service infront of it , mysql you have a service infront of it , that's how communication happen betweeen pods , between user to the pods.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/5.jpg)


### Node Port

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/6.jpg)

- service is like a load balancer , which have a static ip address , which will not change until you delete it.
- If we have front end port like load balancer have a front end port `100.50.10.20:80` => this is internal front end port , for internal communication , and the backend port which is port number of container obviously `Backend Port 80`.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/7.jpg)

- so how does it know which pot route the request to , if a 100 of pods running like this
- **It is going to match the label selector** any port which have the label `App:Frontend` which will forward the request to that port in `port 80`

- so here we have two pods , if we have third pod same port with same label , my third pod is automatically included in this service `auto discovery`, this is internal.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/8.jpg)

- Node Port `30001` is mapped your service 
- when you access the node `172.20.34.67:30001` by giving it's IP address, and node port , the request will be forwarded to the service , service will forward the requested to the pod , and pod will sent it to the container, and the same way it is comes back.
- There are so many port s over her `30001` is exposed to outside network , sevrice has a internal front end port `80`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/9.jpg)

Important

- Label selector should be match withh the label of the pod
- matching the backend port `80`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/10.jpg)


- 4- type => Node Port , I want to create a **NodePort**
- 5- target port => backend port (80)
- 6-port 80  => **internal front end port** you cannot access it from the outside network
- 7-nodePort => for the outside network 30005
- It is forward the requested to any pods that have the label `app: frontend` on `port 80`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/11.jpg)

```yaml
kubectl create -f service-defs.yml
kubectl.exe get SVC
kubectl.exe describe svc webapp-service
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/12.jpg)

- Tom cat Pod running one singlie , I am going to create a service infront of it, `Node Port`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/13.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/14.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/15.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/16.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/17.jpg)

- Now we are going to write the service definition file.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/18.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/19.jpg)

- 1-api Version : `v1`
- 2-Kind : `Service`
- 3-Metadata name : `name of the service`
- spec : `spec contains all the ports information`
- port : internal Port 8090 (Internal means internal communication between pods in the worker node)
- nodeport : `external front end port 30001 (It starts from 30000)` , this is the port exposed to user
- target Port :`8080 that is the container port running in the pod`
- protocol : tcp
- selector: `app:vproapp : we created label as vprpo app in the port`
- type : Node Port

-   **Port** exposes the Kubernetes service on the specified port within the cluster. Other pods within the cluster can communicate with this server on the specified port.
- **TargetPort** is the port on which the service will send requests to, that your pod will be listening on. Your application in the container will need to be listening on this port also.
- **NodePort** exposes a service externally to the cluster by means of the target nodes IP address and the NodePort. NodePort is the default setting if the port field is not specified.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/20.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/21.jpg)

- give the name in the service definition file

### Create the service

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/22.jpg)

```yaml
kubectl create -f vproapp-nodeport.yaml
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/23.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/24.jpg)

- Ports , selector, and type in same level

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/25.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/26.jpg)


- 8090 - Internal front end port
- 30001 -  external front end port

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/27.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/28.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/29.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/30.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/31.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/32.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/33.jpg)

- Because I will be accessing it from different different port 
- It doesn't matter which node our pod is running , we are going to access the service.
- Service is throughout all the node , even in the master node.
- You can even access the master node also

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/34.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/35.jpg)

- But it is running through `node port` , we will see now load balancer, which is much more convenient for productions.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/36.jpg)

- we deleted services because we are now going to create a service of type `load balancer`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/37.jpg)

### Load balancer definition file

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/38.jpg)

- Once the load balancer cretaed you can access it in port 80, it should route the requests your pod.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/39.jpg)

```yaml
kubectl create -f vroapp-loadbalncer.yml
```

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/40.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/41.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/42.jpg)

- but they will be mapped into a port number.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/43.jpg)

- There is a `node port` but we couldn't mention it.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/44.jpg)

### Understand how the service of type load balancer works

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/45.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/46.jpg)

- You access the load balncer, load balancer `route` the request to nay of the worker node on the `Node port`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/47.jpg)

- we didnot specify the node port, it will  pick up the random `nodeport` It has a range, It will pick up from that random port number and assign it to the worker node.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/48.jpg)


#### work flow
- Load balancer we route the requests to the internal servce and that is going to forward the request to your pod.
- Service is across your cluster,It is not in the worker node,It is not the pod,It is not the container,It is some rule, proxy rules, so it is created across all your nodes.
- Even the master node having the rules, that if the request comes in the port, it will route it to right port.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/49.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/50.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/51.jpg)

- This is type of Load Balancer
- and this is type of node port

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/52.jpg)


#### cluster Ip

- Cluster Ip is without any external port , No `node port` will be there,
-  It is mostly used to refer front end service to refer to backend service, so our backend service interacting with each other, so they need service of type `cluster ip`

- Nginx referring back to tomcat port you need to create a type cluster ip.

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/53.jpg)

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/54.jpg)
![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/55.jpg)

- mention `type` as a `cluster ip` instead of `node port` or `load balancer`. you give the `target port` and the `front end port`.
- No `NodePort` `Nonode balancer`
- Internally if any other pod wants to interact with your `tomcat pod`, it can access the port in `port 8080`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/56.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/57.jpg)

- In the front end you have service of type `node port` or `loadbalancer`
- In the backend you have service of type `cluster Ip`
- Load balancer for production use cases

#### clean your services

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/58.jpg)


![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/59.jpg)

- everything running in the current `name space`

![dockerengine]({{ site.baseurl }}/post_img/2022/03/21_2/60.jpg)

```yaml
kubectl delete pod/vproapp
kubectl delete service/helloworld-service
kubectl get all
```


Resources

1-vproapppod.yml

```yml
---
apiVersion: v1
kind: Pod
metadata:
  name: vproapp
  labels:
    app: vproapp
spec:
  containers:
    - name: appcontainer
      image: imranvisualpath/freshtomapp:V7
      ports:
        - name: vproapp-port
          containerPort: 8080

```

2-vproapp-nodeport.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: helloworld-service
spec:
  ports:
  - port: 8090
    nodePort: 30001
    targetPort: vproapp-port
    protocol: TCP
  selector: 
       app: vproapp
  type: NodePort
```

3-vproapp-loadbalancer.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: helloworld-service
spec:
  ports:
  - port: 80
    targetPort: vproapp-port
    protocol: TCP
  selector: 
       app: vproapp
  type: LoadBalancer

```

4-vproapp-repl-controller.yaml

```yaml
---
apiVersion: v1
kind: ReplicationController
metadata:
  name: vproapp-controller
spec: 
  replicas: 2
  selector:
     app: vproapp
  template:
    metadata:
      labels:
        app: vproapp
    spec:
     containers:
      - name: appcontainer
        image: imranvisualpath/freshtomapp:V7
        ports:
          - name: vproapp-port
            containerPort: 8080
```

