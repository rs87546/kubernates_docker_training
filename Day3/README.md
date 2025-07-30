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
