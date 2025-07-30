# Day 3

## Demo - Installing a HA Kubernetes cluster with 3 worker nodes
```
cd ~
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray

sudo apt-get install python3-pip
pip3 install -r requirements.txt

cp -r inventory/sample inventory/mycluster

declare -a IPS=(192.168.56.10 192.168.56.11 192.168.56.12 192.168.56.21 192.168.56.22 192.168.56.23)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
```

Create inventory/mycluster/inventory.ini
<pre>
[all]
master1 ansible_host=192.168.56.10
master2 ansible_host=192.168.56.11
master3 ansible_host=192.168.56.12
worker1 ansible_host=192.168.56.21
worker2 ansible_host=192.168.56.22
worker3 ansible_host=192.168.56.23
haproxy ansible_host=192.168.56.10
  
[kube_control_plane]
master1
master2
master3

[etcd]
master1
master2
master3

[kube_node]
master1
master2
master3
worker1
worker2
worker3

[loadbalancer]
haproxy    
  
[k8s_cluster:children]
kube_control_plane
kube_node
</pre>
