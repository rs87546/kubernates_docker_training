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
  

</pre>
