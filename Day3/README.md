# Day 3

## Demo - Installing a HA Kubernetes cluster with 3 worker nodes

#### Install KVM Hypervisor in Ubuntu Server
```
sudo apt update
sudo apt-get install -y curl gnupg software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update

sudo apt-get install -y qemu-system libvirt-daemon-system libvirt-clients ebtables dnsmasq \
                        libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev \
                        bridge-utils libguestfs-tools gcc make virt-manager guestfs-tools \
                        qemu-kvm virt-viewer cloud-image-utils vagrant -y

sudo usermod -aG libvirt $(whoami)
sudo usermod -aG kvm $(whoami)     
vagrant plugin install vagrant-libvirt
vagrant plugin list

sudo apt install net-tools neovim tree iputils-ping tmux git

sudo adduser root kvm
sudo systemctl enable --now libvirtd
sudo systemctl status libvirtd
```

Let's clone the kubespray

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

Edit vim inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml
```
# A stable, highly available endpoint for the API server.
apiserver_loadbalancer_domain_name: "k8s.rps.com"

# The IP addresses of all your master nodes for the load balancer to route to.
kube_master_ips:
  - 192.168.56.10
  - 192.168.56.11
  - 192.168.56.12

# The port of the API server
apiserver_loadbalancer_apiserver_port: 6443
```
