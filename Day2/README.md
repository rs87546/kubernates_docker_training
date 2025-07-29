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


## Demo - Install minikube kubernetes cluster
```
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
minikube start
```
