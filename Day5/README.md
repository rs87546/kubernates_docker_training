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
  

</pre>
