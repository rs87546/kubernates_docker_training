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

#### Create virtual machines

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

Let's create a folder
```
sudo su -
mkdir -p /root/kubernetes
cd /root/kubernetes
touch create-master1-vm.sh
touch create-master2-vm.sh
touch create-master3-vm.sh
touch create-worker1-vm.sh
touch create-worker2-vm.sh
touch create-worker3-vm.sh
touch create-haproxy-vm.sh
```


Let's create the Virtual machines
```
sudo su -
cd /root/kubernetes
vagrant up
```

```
sudo virt-builder -l

sudo virt-builder fedora-41  --format qcow2 \
  --size 20G -o /var/lib/libvirt/images/ocp-bastion-server.qcow2 \
  --root-password password:Root@123

sudo virt-install \
  --name ocp-bastion-server \
  --ram 4096 \
  --vcpus 2 \
  --disk path=/var/lib/libvirt/images/ocp-bastion-server.qcow2 \
  --os-variant rhel8.0 \
  --network bridge=openshift4 \
  --graphics none \
  --serial pty \
  --console pty \
  --boot hd \
  --import
```

Configuring the network
```
nmcli con add type ethernet con-name enp1s0 ifname enp1s0 \
  connection.autoconnect yes ipv4.method manual \
  ipv4.address 192.168.100.254/24 ipv4.gateway 192.168.100.1 \
  ipv4.dns 8.8.8.8

virsh net-list --all
virsh net-start default
virsh net-autostart default

ip link show
ip link
ifconfig -a
sudo ip link set <interface> up
sudo ip addr add 192.168.122.10/24 dev enp1s0
sudo ip route add default via 192.168.122.1
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
ping 8.8.8.8
ping google.com

nmcli con add type ethernet con-name enp1s0 ifname enp1s0 \
  connection.autoconnect yes ipv4.method manual \
  ipv4.address 192.168.100.254/24 ipv4.gateway 192.168.100.1 \
  ipv4.dns 8.8.8.8

ping -c 2 8.8.8.8
ping -c 2 google.com
```

### Let's setup a HA Kubernetes cluster with 3 masters and 3 worker nodes using Kubespray

Let's clone the kubespray project
```
sudo su -
cd /root/kubernetes
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kuberspray
cp -r inventory/sample inventory/mycluster
# We need to modify inventory/mycluster/inventory.ini, inventory/mycluster/group_vars/all.yml and inventory/mycluster/group_vars/k8s_cluster.yml

# we need to generate, key pair ( accept all defaults )
ssh-keygen

ansible-playbook -i inventory/mycluster/ cluster.yml -b -v \
  --private-key=~/.ssh/id_ed25519
```



