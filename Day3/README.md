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

#### Create Custom Network for Kubernetes
Let's create a custom network for Kubernetes using file virt-net.xml
```
<network>
  <name>k8s</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='k8s' stp='on' delay='0'/>
  <domain name='k8s'/>
  <ip address='192.168.100.1' netmask='255.255.255.0'>
  </ip>
</network>  
```
Using the above file, let's create the custom k8s network
```
sudo virsh net-define --file virt-net.xml
sudo virsh net-autostart k8s
sudo virsh net-start k8s
sudo virsh net-list
```

#### Let's create the HAProxy Virtual Machine
```
sudo virt-builder debian-12  --format qcow2 \
  --size 1000G -o /var/lib/libvirt/images/haproxy.qcow2 \
  --root-password password:Root@123

sudo virt-install \
  --name haproxy \
  --ram 4096 \
  --vcpus 4 \
  --disk path=/var/lib/libvirt/images/haproxy.qcow2 \
  --os-variant debian12 \
  --network bridge=k8s \
  --graphics none \
  --serial pty \
  --console pty \
  --boot hd \
  --import
```

#### Let's create the Master1 Virtual Machine
```
sudo virt-builder debian-12  --format qcow2 \
  --size 1000G -o /var/lib/libvirt/images/master01.qcow2 \
  --root-password password:Root@123

sudo virt-install \
  --name master01 \
  --ram 131072 \
  --vcpus 10 \
  --disk path=/var/lib/libvirt/images/master01.qcow2 \
  --os-variant debian12 \
  --network bridge=k8s \
  --graphics none \
  --serial pty \
  --console pty \
  --boot hd \
  --import
```

#### Let's create the Master2 Virtual Machine
```
sudo virt-builder debian-12  --format qcow2 \
  --size 1000G -o /var/lib/libvirt/images/master02.qcow2 \
  --root-password password:Root@123

sudo virt-install \
  --name master02 \
  --ram 131072 \
  --vcpus 10 \
  --disk path=/var/lib/libvirt/images/master02.qcow2 \
  --os-variant debian12 \
  --network bridge=k8s \
  --graphics none \
  --serial pty \
  --console pty \
  --boot hd \
  --import
```

#### Let's create the Master3 Virtual Machine
```
sudo virt-builder debian-12  --format qcow2 \
  --size 1000G -o /var/lib/libvirt/images/master03.qcow2 \
  --root-password password:Root@123

sudo virt-install \
  --name master03 \
  --ram 131072 \
  --vcpus 10 \
  --disk path=/var/lib/libvirt/images/master03.qcow2 \
  --os-variant debian12 \
  --network bridge=k8s \
  --graphics none \
  --serial pty \
  --console pty \
  --boot hd \
  --import
```

#### Let's create the Worker1 Virtual Machine
```
sudo virt-builder debian-12  --format qcow2 \
  --size 1000G -o /var/lib/libvirt/images/worker01.qcow2 \
  --root-password password:Root@123

sudo virt-install \
  --name worker01 \
  --ram 131072 \
  --vcpus 10 \
  --disk path=/var/lib/libvirt/images/worker01.qcow2 \
  --os-variant debian12 \
  --network bridge=k8s \
  --graphics none \
  --serial pty \
  --console pty \
  --boot hd \
  --import
```

#### Let's create the Worker2 Virtual Machine
```
sudo virt-builder debian-12  --format qcow2 \
  --size 1000G -o /var/lib/libvirt/images/worker02.qcow2 \
  --root-password password:Root@123

sudo virt-install \
  --name worker02 \
  --ram 131072 \
  --vcpus 10 \
  --disk path=/var/lib/libvirt/images/worker02.qcow2 \
  --os-variant debian12 \
  --network bridge=k8s \
  --graphics none \
  --serial pty \
  --console pty \
  --boot hd \
  --import
```

#### Let's create the Worker3 Virtual Machine
```
sudo virt-builder debian-12  --format qcow2 \
  --size 1000G -o /var/lib/libvirt/images/worker03.qcow2 \
  --root-password password:Root@123

sudo virt-install \
  --name worker03 \
  --ram 131072 \
  --vcpus 10 \
  --disk path=/var/lib/libvirt/images/worker03.qcow2 \
  --os-variant debian12 \
  --network bridge=k8s \
  --graphics none \
  --serial pty \
  --console pty \
  --boot hd \
  --import
```

#### Configure HAProxy Virtual Machine
From the Ubuntu Server, login to HAProxy VM
```
ssh root@192.168.100.10
```

Login Credentials are
<pre>
username - root
password - Root@123
</pre>

Once you have logged to HAProxy Virtual Machine, configure the network and assign static IP to the VM
```
ip link
sudo ip link set enp1s0 up
sudo ip addr add 192.168.100.10/24 dev enp1s0
sudo ip route add default via 192.168.100.1
echo "nameserver 8.8.8.8" | tee /etc/resolv.conf
ping 8.8.8.8
ping google.com
apt install sudo net-tools iputils-ping vim tree haproxy -y
export TERM=linux
```

Let's edit /etc/hosts append the below at the end of the file without deleting any existing entries
```
192.168.100.10 haproxy.k8s.rps.com
192.168.100.11 master01.k8s.rps.com
192.168.100.12 master02.k8s.rps.com
192.168.100.13 master03.k8s.rps.com
192.168.100.13 worker01.k8s.rps.com
192.168.100.13 worker02.k8s.rps.com
192.168.100.13 worker03.k8s.rps.com
```

Configure the HAProxy Load Balancer by editing /etc/haproxy/haproxy.cfg and replace with below content
```
global
    log /dev/log local0
    log /dev/log local1 notice
    daemon
    maxconn 2048

defaults
    log     global
    mode    tcp
    option  tcplog
    timeout connect 10s
    timeout client  1m
    timeout server  1m

# Frontend for Kubernetes API
frontend k8s_api
    bind *:6443
    default_backend k8s_masters

# Backend: Kubernetes Master Nodes
backend k8s_masters
    mode tcp
    balance roundrobin
    option tcp-check
    default-server inter 5s fall 3 rise 2

    server master01 192.168.100.11:6443 check
    server master02 192.168.100.12:6443 check
    server master03 192.168.100.13:6443 check
```

We need to restart the haproxy
```
systemctl enable haproxy
systemctl start haproxy
systemctl status haproxy
```
