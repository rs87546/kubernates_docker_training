# Day 1 (Docker)

## Info - What is dual/multi-booting?
<pre>
- When we boot our laptop/desktop, the firmware(BIOS) runs the Power On Self Test(POST)
- Once the BIOS POST completes, BIOS will instruct the CPU to run the Boot Loader utility
- the Bootloader utility searches your hard disk(s) looking for Operating Systems, if it finds more than
  one OS, then it prepares a menu and then presents you the menu for you to choose the OS you wish to boot into
- in this way, we can support 2-3 OS in our laptop/desktop
- the limitation is, only one OS can be active at anypoint of time
- examples
  - LILO ( opensource, legacy bootloader used by most older linux distributions, almost dead now )
  - GRUB 2 -opensource, this is used by almost all linux distributions (replaces LILO)
  - Macbooks - BootCamp (Paid)
</pre>  

## Info - Hypervisor Overview
<pre>
- Hypervisor is a generic term used to refer to the virtualization software/technology
- using virtualization, we can run more than OS in the same laptop/desktop/workstation/server
- more than one OS can be active at the same time
- each OS that we install on top the base OS (Host OS) is referred as Guest OS
- the Guest OS is installed on top of Virtual Machine
- each Virtual Machine must be allocated with dedicated hardware resources
  - CPU cores
  - RAM
  - Storage (HDD/SDD)
- hence, this type of Virtualization is called Heavy-weight Virtualization  
- the OS that runs within the Virtual Machine, is a fully functional Operating System
- the OS has its own OS Kernel, Guest OS will not share Hardware resources with other Guest OS or Host OS
- There are 2 types of Hypervisors
  1. Type 1
     - are used in Workstations & Servers
     - bare-metal hypervisors
     - Examples
       - KVM
       - VMWare vSphere/vCenter
  2. Type 2
     - are used in Laptops/Dekstops & Workstations
     - Examples
       - Oracle VirtualBox ( Windows, Linux and Mac OS-X )
       - VMWare Workstation ( Windows & Linux )
       - VMWare Fusion ( Mac OS-X )
       - Parallels
       - Microsoft Hyper-V
</pre>

## Info - Linux Kernel Features that makes containerization possible
<pre>
1. Namespace and
   - are used to isolate one container from the other
2. Control Groups (CGroups)
</pre>  

## Info - Containerization
<pre>
- light-weight application virtualization technology
- unlike the Virtualization, in case of containers, they don't get their own dedicated hardware resources
- all containers running on the same OS, shares the Hardwares resources on the underlying OS
- Similarities between VM & Containers
  - every container gets its own IP Address ( usually private IPs )
  - every container gets its own Network Stack ( 7 OSI Layers )
  - every container gets its own software-defined virtual network card
  - every container gets its own filesystem
- containers will never be able to replace Virtual Machines, they are complementing technology not competing technologies
- hence, containers and hypervisors are generally used in combination, they can co-exist
- each container represents an application process not an OS
- Examples
  - Docker, Podman, Containerd
</pre>

## Info - Container Runtime Overview
<pre>
- Container Runtime is a low-level software that helps us manage containers & images
- they are not so user-friendly, hence normally end-users like us never use the container runtimes directly
- examples
  - runC, cRun, CRI-O
</pre>

## Info - Container Engine Overview
<pre>
- Container Engines are high-level softwares that helps us manage containers & images
- they are highly user-friendly
- container engines internally depends on container runtimes to manage containers & images
- Examples
  - Docker
  - Podman
</pre>  

## Info - Container Images
<pre>
- is a blueprint of container
- whatever applications/tools we need in a container, we can build/prepare a container image with those tools pre-installed
- when we create containers using the container image, all the tools we installed on the image are readily available in each containers
- using a single container image, we can create any number of containers
- container images are similar to windows OS ISO 
</pre>  
![image](DockerLayers.png)
  
## Info - Container
<pre>
- is a running instance of a Container Image
- containers holds
  - an application executable
  - and its dependencies
  - it may the package manager, for instance in case of ubuntu image, it comes with apt(apt-get) package manager
  - it comes with maybe sh/bash terminal
</pre>

## Info - Container Registries
<pre>
- Container Registries helps us manage multiple container images
- there are 3 types of Container Registries supported by Docker
  1. Docker Local Registry ( this is folder /var/lib/docker in Linux )
  2. Private Docker Registry ( This can be setup using JFrog Artifactory or Sonatype Nexus )
  3. Remote Docker Registry ( this is website hub.docker.com )
</pre>

## Info - Docker High-Level Architecture
![architecture](DockerHighLevelArchitecture.png)

## Info - Docker Overview
<pre>
- Docker is developed in Google's Go language
- Docker comes in 2 flavours
  1. Docker Community Edition - Docker CE ( Opensource, functionally same as Docker EE )
  2. Docker Enterprise Edition - Docker EE ( Paid software used by most software companies )
</pre>

## Info - Installing Docker CE in Ubuntu
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker

sudo usermod -aG docker $USER
```

## Lab - Checking the docker version
```
docker --version
docker info
```
Expected output
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/a8f9ad93-40bd-4935-8ed2-a9d60188cd20" />

<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/2c65bff8-a11f-405e-abb4-38f6b0cdf36e" />

## Lab - Listing the docker images from your Local Docker Registry
```
docker images
```

Expected output
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/2eadf5f4-076d-4429-9bdd-18089878e9eb" />

## Lab - Downloading mysql container image from Docker Hub Remote Registry to Docker Local Registry
```
docker pull mysql:latest
docker images 
```

Expected output
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/767acab5-88dd-4649-be26-a9aa141c6c6b" />

## Lab - Finding more details about mysql docker image
```
docker image inspect mysql:latest
```

Expected output
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/cf047899-b837-494a-bade-41e9e07785b2" />
