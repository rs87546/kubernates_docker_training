# Day 5

## Info - Red Hat Openshift Overview
<pre>
- is a Red Hat's distribution of Kubernetes with many additional features 
- is built on top of Google Kubernetes
- it is an enterprise container orchestration platform from Red Hat ( an IBM company )
- it is licensed product, comes with world-wide support from Red Hat
- it supports both CLI and Webconsole
- it support user management
  - you can create users, teams and apply policy and permission for each team or user-level
- it also comes with pre-integrated prometheus & graphana to analyse application and cluster performance
- it comes with internal openshift image registry, from this registry application can be deployed with openshift
- apart from this, each nodes has its own local registry just like Kubernetes
- Starting from Openshift v4.x
  - Docker support was removed
  - Master Node only support Red Hat Enterprise Core OS (RHCOS) operating system, earlier it used to support RHEL
  - Worker Nodes can choose between Red Hat Enterprise Core OS (RHCOS) or RHEL
  - The RHCOS Operating System is optimized for Container Orchestration Platform 
    - there is a opensource CoreOS called Fedora CoreOS can be used in K8s cluster
    - is more secure compared to other Linux distros, provides equivalent or slightly better security than RHEL
    - it is also possible to upgrade Openshift using oc commands if RHCOS is installed in all nodes ( master & workers ), which is recommended by Red Hat 
    - it enforces best practices are followed
    - some of the folders are ready-only, hence we won't be able to modify anything on read-only folder
    - ports below 1024 are reserved for Openshift's internal usage, hence user applications won't be able to use those ports
    - applications can only run as non-administrator (rootless) user
    - in case any application attempts to run as adminstrator or attempts to modify anything outside home directory as admin, those Pods will be knocked off ( wont't be allowed to run )
    - RHCOS comes with pre-installed CRI-O container runtime and Podman container engine
    - comes with crictl client tool
- Openshift additional features added on top Kubernetes
  - Webconsole GUI
  - User Management
  - Internal Image Registry
  - Pre-integrated Prometheus & Graphana for Performance Monitoring
  - Pre-integrated Red Hat Marketplace to download & install Openshift Operators from within Openshift webconsole
  - a new feature called Project ( based on Kubernetes namespace )
  - a new feature called Route ( based on Kubernetes ingress )
  - BuildConfigs & Build
  - S2I ( Source to Image )
    - application can be deployed from source code from Version Control ( GitHub, etc )
    - kubernetes only allows deploying application from readily build container images
    - supports different strategies like docker, source, etc
  - ImageStream
    - a new feature introduced in Openshift
    - is an object ( a folder that maps to Intenal Openshift Container Registry )
    - within an imagestream many version(tag) of the same image can be stored
</pre>

## Lab - Listing the Openshift nodes
```
oc get nodes
kubectl get nodes

oc get nodes -o wide
kubectl get nodes -o wide
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/5edc2c93-1d2b-4cba-898b-9d1fb19189ad" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/d2ccac31-29fd-4589-b630-958ed17b8968" />

## Lab - Finding more details about an Openshift node
```
oc describe node/master01.k8s.rps.com
```

## Lab - Creating a project to deploy our applications
Replace 'jegan' with your name
``
oc new-project jegan
``

Find your currently active project
```
oc project
```

Switching between projects
```
oc project default
oc project jegan
```

Listing projects
```
oc get projects
oc get project

oc get namespaces
oc get ns
```

## Lab - Let's deploy our first applicaiton into openshift
```
oc project jegan
oc create deploy nginx --image=bitnami/nginx:latest --replicas=3 -o yaml --dry-run=client > nginx-deploy.yml
```
#### Edit the nginx-deploy.yml and make sure you add imagePullPolicy: IfNotPresent before applying
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/0e3eaf09-8292-4077-a719-08f48719ca63" />

Let's deploy
```
oc apply -f nginx-deploy.yml

oc expose deploy/nginx --port=8080 -o yaml --dry-run=client > nginx-svc.yml
oc apply -f nginx-svc.yml

oc expose svc/nginx -o yaml --dry-run=client > nginx-route.yml
oc apply -f nginx-route.yml

oc get route
```

## Lab - Deploying your application from GitHub source code using S2I docker strategy
<pre>
- In this case, Openshift will clone the repository and looks for a Dockerfile in your source code repo.
- Based on the Dockerfile it builds your application to application binary 
- it then prepares a custom container image with your application binary
- Pushes the application binary into the Openshift Internal Image Registry
- Using your Custom Image from Openshift's Internal registry, it deploys the application into Openshift
- It also creates a service, just need to create an external route to click and access your application
</pre>
```
oc new-project jegan
oc new-app --name=hello https://github.com/tektutor/spring-ms.git --strategy=docker
```

## Lab - Deploying your application from GitHub source code using S2I source strategy
<pre>
- In this case, Openshift will clone the repository and it will generate a Dockerfile using your image suggestion on the command
- Based on the auto-generated Dockerfile it builds your application to application binary 
- it then prepares a custom container image with your application binary
- Pushes the application binary into the Openshift Internal Image Registry
- Using your Custom Image from Openshift's Internal registry, it deploys the application into Openshift
- It also creates a service, just need to create an external route to click and access your application
</pre>

```
oc new-project jegan
oc new-app --name=hello https://github.com/tektutor/spring-ms.git --strategy=source
```


