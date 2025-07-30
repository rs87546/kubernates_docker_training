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
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"

  # Use password instead of SSH key for authentication
  config.ssh.password = "root"
  config.ssh.insert_key = false

  # Provision all VMs: set vagrant and root user password, enable password auth
  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    echo 'vagrant:root' | chpasswd
    echo 'root:root' | chpasswd
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    systemctl restart sshd
  SHELL

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

  # Master Nodes
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

  # Worker Nodes
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
cp -r inventory/sample inventory/mycluster
# We need to modify inventory/mycluster/inventory.ini, inventory/mycluster/group_vars/all.yml and inventory/mycluster/group_vars/k8s_cluster.yml

# we need to generate, key pair ( accept all defaults )
ssh-keygen

ansible-playbook -i inventory/mycluster/ cluster.yml -b -v \
  --private-key=~/.ssh/id_ed25519
```

