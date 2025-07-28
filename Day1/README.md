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
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/c998a11a-85e7-42af-b0f8-57beb21e52e6" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/e53fd840-d2c8-4439-9548-2db079783ba9" />

## Lab - Deleting a docker image from your local docker registry
```
docker images | grep hello
docker rmi hello-world:latest
docker images | grep hello
```

Expected output
<img width="1774" height="633" alt="image" src="https://github.com/user-attachments/assets/2178d8c8-9238-49bc-8d44-4f712ac91dd0" />

In case there are containers that were created using hello-world:latest, then we must first delete the containers before deleting the docker image
```
docker rmi hello-world:latest
docker rm hello-jegan
docker rmi hello-world:latest
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/6e69f885-41ba-45f0-955d-d1bbf6275699" />


## Lab - Creating a container in interactive/foreground mode
List the hello-world:latest docker image
```
docker images | grep hello-world
```

Create a hello container in interactive/foreground mode
```
docker run --name hello --hostname hello hello-world:latest
```
Note
<pre>
- In case, your local docker registry doesn't have the hello-world:latest docker image, docker server will
  download that for your automatically from the hub.docker.com remote docker registry
- the downloaded image is cached in your local docker registry ( i.e /var/lib/docker folder )
- using the local hello-world:latest image docker engine will then create the container
- name and hostname arguments aren't mandatory
- run commnd will create a new container and then starts running the container
</pre>


Listing all running containers
```
docker ps
```

Listing all containers irrespective of their runtime state
```
docker ps -a
```

Expected output
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/fbbfb7bb-b255-4615-a6fa-cd745b898082" />

## Lab - Renaming a container
```
docker rename hello hello-jegan
```


## Lab - Creating a container in background(daemon) mode
```
docker run -d --name nginx --hostname nginx nginx:latest
docker ps
```

Finding the IP Address of the container
```
docker ps
docker inspect nginx | grep IPA
docker inspect -f {{.NetworkSettings.IPAddress}} nginx
```

Check if you are able to access the web using the IP Address of the contianer
```
ping 172.17.0.2
curl http://172.17.0.2:80
```

Expected output
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/760e2203-7728-4332-9122-897ab5c24826" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/77a4d4a1-f9bf-44c4-a1e1-42bb68c24aee" />

## Lab - Troublesshooting using container logs
```
docker ps
docker logs nginx
```

Expected output
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/4165da25-37d3-41c5-97fa-01e0ebf42809" />

## Lab - Searching images from Remote Docker Registry
```
docker search nginx
```

Expected output
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/5801cb7c-0924-44c7-8b52-4b98a9ee4597" />

## Lab - Setting up a loadbalancer with 3 nginx web server backends
Let's create 3 nginx web server containers
```
docker run -d --name nginx1 --hostname nginx1 nginx:latest
docker run -d --name nginx2 --hostname nginx2 nginx:latest
docker run -d --name nginx3 --hostname nginx3 nginx:latest
```

List and see if the 3 web server containers you created are running
```
docker ps
```

Let's create a lb container
```
docker run -d --name lb --hostname lb -p 80:80 nginx:latest
docker ps
```

Expected output
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/a14e7f3d-5deb-4a4b-93a9-6ece7cb13026" />

In order to configure the lb container as a load balancer, we must configure accordingly otherwise by default nginx containers runs as a web server.


Let's try to locate the nginx configuratio file, for that we need to get inside the container shell
```
docker exec -it lb bash
hostname
hostname -i
cd /etc/nginx
ls
more nginx.conf
exit
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/f56b2346-098e-4ee0-b4e5-6b9defdc4ca6" />

Let's copy the nginx.conf file from the lb container to local machine
```
docker cp lb:/etc/nginx/nginx.conf .
cat nginx.conf
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/764ccb8d-00a5-475f-aa07-f31fd7f659b0" />

Find the IP addresses of your nginx1, nginx2 and nginx3 web server containers
```
docker inspect -f {{.NetworkSettings.IPAddress}} nginx1
docker inspect nginx2 | grep IPA
docker inspect nginx3 | grep IPA
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/76563a5f-09ad-4d96-9fb4-576d88f60510" />

Let's modify the nginx.conf we copied from the lb container on our local machine as shown below
```

user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /run/nginx.pid;


events {
    worker_connections  1024;
}

http {
    upstream backend {
        server 172.17.0.2:80; 
        server 172.17.0.3:80;
        server 172.17.0.4:80;
    }

    server {
        location / {
            proxy_pass http://backend;
        }
    }
}
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/032a2faa-6421-4c57-a30f-76fe73806d8f" />

This update nginx.conf file we need to copy from the local machine back into the lb container
```
docker cp nginx.conf lb:/etc/nginx/nginx.conf
```

In order to apply the config changes we did to the lb container, we need to restart it
```
docker restart lb
```

Let's verify if lb container is running after our config changes
```
docker ps
```

In order to customize the html page response from each nginx web server containers, we need to figure out from where nginx web server is serving its html pages.  For this we need to get inside one of the nginx webserver containers
```
docker exec -it nginx1 bash
cd /etc/nginx/
cat nginx.conf
cd conf.d
cat default.conf
```

The default.conf files tells the location from where the nginx web server is searching the web pages
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/549d9b56-b15e-4a74-ad10-383390c8c233" />
