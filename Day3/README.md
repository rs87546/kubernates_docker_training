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

Let's create a folder
```
sudo su -
mkdir -p /root/kubernetes
cd /root/kubernetes
touch Vagrantfile
```

Create a Vagrantfile at /root/kubernetes folder
<pre>

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/ubuntu-22.04"

  # HAProxy Load Balancer
  config.vm.define "haproxy" do |haproxy|
    haproxy.vm.hostname = "haproxy.k8s.rps.com"
    haproxy.vm.network "private_network", ip: "192.168.56.10"
    haproxy.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
    haproxy.vm.provider "libvirt" do |lv|
      lv.memory = 2048
      lv.cpus = 2
    end
  end

  # Define Master Nodes
  (1..3).each do |i|
    config.vm.define "master0#{i}" do |master|
      master.vm.hostname = "master0#{i}.k8s.rps.com"
      master.vm.network "private_network", ip: "192.168.56.1#{i}"
      master.vm.provider "virtualbox" do |vb|
        vb.memory = 131072
        vb.cpus = 10
      end
      master.vm.provider "libvirt" do |lv|
        lv.memory = 131072
        lv.cpus = 10
      end
    end
  end

  # Define Worker Nodes
  (1..3).each do |i|
    config.vm.define "worker0#{i}" do |worker|
      worker.vm.hostname = "worker0#{i}.k8s.rps.com"
      worker.vm.network "private_network", ip: "192.168.56.2#{i}"
      worker.vm.provider "virtualbox" do |vb|
        vb.memory = 131072
        vb.cpus = 10
      end
      worker.vm.provider "libvirt" do |lv|
        lv.memory = 131072
        lv.cpus = 10
      end
    end
  end
end  
</pre>


Let's create the Virtual machines
```
sudo su -
cd /root/kubernetes
vagrant up
```

### Let's setup a HA Kubernetes cluster with 3 masters and 3 worker nodes using Kubespray

Let's clone the kubespray project
```
sudo su -
cd /root/kubernetes
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kuberspray

```

