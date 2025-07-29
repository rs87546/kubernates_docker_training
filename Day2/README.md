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
  - Worker Node
    - this is where user containerized applicaitons will be running
    
</pre>

## Demo - Install minikube kubernetes cluster
```
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
minikube start
```
