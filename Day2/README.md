# Day 2

## Info - Container Orchestration Platform Overview
<pre>
- in real-world, i.e in Software industry we almost never try to manage container ourselve
- we make use of Container Orchestration Platforms
- We can only deploy containerized applications into Container Orchestration Platforms
- it has inbuilt 
  - monitoring tools to check the health, readiness & liviness of your application
  - it can repair your applications in case your application stops responding
  - it can help you scale up/down your application instances depending user traffic to your application
  - you can upgrade your already live application from one version to other without any download using rolling update feature
  - you could also rollback to older stable version in case you found the new version with faults
  - you can expose your application for internal only use or to external world using services
  - also it provides an environment with necessary tools to make your application Highly available (HA)
- examples
  - Docker SWARM
  - Kubernetes
  - Openshift
</pre>

## Info - Docker SWARM
<pre>
- it is Docker's native Container Orchestration Platform
- it generally works as a group of servers(cluster)
- some of those servers will act as master and rest of them will act as worker nodes
- it is lightweight, ideal for Developer/QA/learning purpose
- can be easily installed on your laptop with basic system configuration
- it is not production grade
- it only supports docker container application workloads
- it is free tool from Docker Inc
</pre>

## Info - Kubernetes
<pre>
- opensource container orchestration platform from Google
- it is production grade and robust
- supports only command-line interface
- works as a cluster ( group of servers )
- the servers can be 
  - Virtual Machines running locally or on private/public/hybrid clouds
  - Physical server on your data center
  - any cloud machines
  - each of those server(aka nodes in Kubernetes) must be installed with some Linux OS
  - each of those servers should also have some container runtime installed
  - each of those servers will have kubeadm, kubectl and kubelet tools installed
  - the nodes are 2 types
    1. Master and
    2. Worker
  - Master Node
    - a special set of components called Control Plane Components will be running in these nodes
    - Control Plane
      - API Server
      - etc key/value distributed database
      - Scheduler
      - Controller Managers - group of controllers
    - Control Plane components only runs in the master node
    - generally the master node will not allow deploying user applications
    - if required can be configured to allow deploying user applications 
  - Worker Node
    - this is where user containerized applicaitons will be running
  - tools
    - kubeadm
      - is a Kubernetes administration tool
      - it is used to bootstrap(setup) master nodes
      - it is also used to add additional master/worker nodes to the Kubernetes cluster
      - it is also useful incase you wish to remove some nodes from the Kubernetes cluster
    - kubelet
      - is service that runs in all Kubernetes Master & Worker Nodes
      - we will not directly interact with it
      - this component interacts with the Container Runtime
      - this component will download required container image, create and manage Pods, etc., 
    - kubectl
      - client tool that helps us interact with Kubernetes cluster
  
</pre>

## Demo - Install minikube kubernetes cluster
```
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
minikube start
```

Expected 
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/5ff35a42-b332-43cb-9dc5-43bc404c001e" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/0b0efb46-ea36-49be-8f57-7c8ed956465a" />

## Info - Kubernetes Resources/Objects
<pre>
- Pod
- ReplicaSet
- Deployment
- DaemonSet
- StatefulSet
- Job
- CronJob
- Service
</pre>

#### Pod
<pre>
- is a group of related containers
- all containers that are part of a Pod shares the same IP Address
- all containers that are part of a Pod shares the same Port Range ( 0 to 65535 Ports )
- every container has its own filesystem though they are part of a Pod
- Pod is a logical grouping of containers
- though technically we can run many containers/applications, ideally only one main application should be ther per Pod
- the smallest unit that can be deployed into Kubernetes
- every Pod has one secret infra-container called pause container
- the job of pause container to provide network to the application container with the Pod
- every Pod will have one pause-container
- every Pod should have just one main application
</pre>

## Lab - Creating a Pod using Docker
Create a pause container to support network for nginx web server container
```
docker run -d --name nginx-pause --hostname nginx registry.k8s.io/pause:latest
docker ps
```

Let's create the nginx web server container and connect it with the nginx-pause container's network
```
docker run -d --name nginx --network=container:nginx-pause nginx:latest
docker ps
```

Let's find the IP address of the nginx-pause container
```
docker inspect nginx-pause | grep IPA
```

Let's get inside the nginx container shell
```
docker exec -it nginx /bin/sh
hostname
hostname -i
exit
```

<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/6a7cf01a-a916-430c-b10e-2ac095bb44e0" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/4eb85229-0d73-43be-9bf3-a59ff1804890" />

## Lab - Listing the nodes in a Kubernetes cluster
```
kubectl get nodes
kubectl describe node/minikube
```

<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/6c3dfaca-bfb3-42ce-813b-900e6b9d21fb" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/bee7211c-7c5b-42cb-b029-5eeab642cd68" />

<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/2f24600e-faa9-49c4-9290-3105635b2a98" />
