<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/e3c113ee-ed46-4301-82b2-1b178e20b641" /># Day 4

## Lab - Creating an external LoadBalancer service for nginx deployment

Create a namespace for your use, replace 'jegan' with your name
```
kubectl create namespace jegan
```

Deploy nginx web server in your namespace with 3 pods
```
kubectl create deployment nginx --image=nginx:latest --replicas=3 -n jegan
```

List your deployments,replicaset and pods
```
kubectl get deploy,rs,po
```

In case you wish to see your pods IP address and where they are running
```
kubectl get pods -o wide
```

Finding the Node IPs
```
kubectl get nodes -o wide
```

Let's create an external loadbalancer service for nginx deployment
```
kubectl expose deploy/nginx --type=LoadBalancer --port=80 -n jegan
```

List the service
```
kubectl get services
kubectl describe svc/nginx
```

Accessing the LoadBalancer external service (in the terminal)
```
curl http://<external-ip-of-your-loadbalancer-service>
curl http://192.168.100.50
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/f59b0f59-b9f4-4d5f-8a6a-3ee566986e69" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/2a097b01-078d-4b0c-b3c4-843bac82c548" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/701d50c4-6fc7-4fe7-abef-995b5ec83b4c" />

## Lab - Creating a NodePort external service for nginx deployment
You need to delete the existing service for nginx deployment
```
kubectl delete svc/nginx -n jegan
```

Create a nodeport service for nginx deployment
```
kubectl expose deploy/nginx --type=NodePort --port=80 -n jegan
```

List the service
```
kubectl get svc -n jegan
kubectl describe svc/nginx -n jegan
```

In order to access the NodePort external service, we need to find the IP address of our k8s cluster nodes
```
kubectl get nodes -o wide
```

Now you can access your nodeport service
```
curl http://<master1-ip>:<node-port-of-your-nginx-service>
curl http://<master2-ip>:<node-port-of-your-nginx-service>
curl http://<master3-ip>:<node-port-of-your-nginx-service>
curl http://<worker1-ip>:<node-port-of-your-nginx-service>
curl http://<worker2-ip>:<node-port-of-your-nginx-service>
curl http://<worker3-ip>:<node-port-of-your-nginx-service>
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/20198625-4e32-48e7-8467-eb869e685593" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/64115d9b-ef12-45ef-b190-ecd3cc14fd54" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/723a6f52-a6cf-4b77-9d79-c7feedd65d8d" />

## Lab - Declaratively deploying nginx using yaml manifest files

Delete your existing namespace to free-up resources
```
kubectl delete ns/jegan
```

Deploy nginx
```
kubectl create ns jegan
kubectl create deploy nginx --image=nginx:latest --replicas=3 -n jegan -o yaml --dry-run=client
kubectl create deploy nginx --image=nginx:latest --replicas=3 -n jegan -o yaml --dry-run=client > nginx-deploy.yml

```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/dcd03202-c0db-4936-87d8-db1c46dbee20" />

Declaratively deploy nginx, before apply ensure you updated the imagePullPolicy to IfNotPresent
```
cat nginx-deploy.yml
kubectl apply -f nginx-deploy.yml
kubectl get deploy,rs,po -n jegan
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/f2ed1462-a2cf-4280-b12f-62c38899c285" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/000dae65-5a0d-44f6-ad3b-ebc0e81648ec" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/40d1bbb2-4422-4399-bc1c-9faf7a0d3c25" />

## Lab - Declaratively creating a clusterip internal service
```
kubectl get deploy -n jegan
kubectl expose deploy/nginx --type=ClusterIP --port=80 -o yaml --dry-run=client -n jegan
kubectl expose deploy/nginx --type=ClusterIP --port=80 -o yaml --dry-run=client -n jegan > nginx-clusterip-svc.yml
kubectl apply -f nginx-clusterip-svc.yml
kubectl get svc
```

## Lab - Declaratively creating a loadbalancer external service
```
kubectl get deploy -n jegan
kubectl expose deploy/nginx --type=LoadBalancer --port=80 -o yaml --dry-run=client -n jegan
kubectl expose deploy/nginx --type=LoadBalancer --port=80 -o yaml --dry-run=client -n jegan > nginx-lb-svc.yml
kubectl apply -f nginx-lb-svc.yml
kubectl get svc
```
## Lab - Declaratively creating a nodeport external service
```
kubectl get deploy -n jegan
kubectl expose deploy/nginx --type=NodePort --port=80 -o yaml --dry-run=client -n jegan
kubectl expose deploy/nginx --type=NodePort --port=80 -o yaml --dry-run=client -n jegan > nginx-nodeport-svc.yml

kubectl delete -f nginx-clusterip-svc.yml

kubectl apply -f nginx-nodeport-svc.yml
kubectl get svc
```

## Lab - Scale up/down in declarative style
```
kubectl get pods -n jegan
cat nginx-deploy.yml  # Edit this file and change the replicas from 3 to 5 and save it
kubectl apply -f nginx-deploy.yml
kubectl get pods -n jegan
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/842e0d65-a995-4920-958e-8fcaf5a808ba" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/7beaefd4-f766-4207-8be6-f7c67ff1becc" />


## Lab - Ingress
Make sure you have two deployments and two services created for those 2 deployments
```
kubectl get deploy -n jegan
kubectl get svc -n jegan
```

Let's create an ingress for the above two services
```
apiVersion: networking.k8s.io/v1 
kind: Ingress
metadata:
  name: tektutor
  annotations:
    haproxy.router.openshift.io/rewrite-target: /
spec:
  rules:
  - host: tektutor.k8s.rps.com
    http:
      paths:
      - path: /nginx
        pathType: Prefix
        backend:
          service:
            name: nginx
            port:
              number: 80
      - path: /hello
        pathType: Prefix
        backend:
          service:
            name: hello
            port:
              number: 8080
```

## Lab - Deploying multi-pod application ( Wordpress with Mariadb DB - Do this in minikube )
In case you are doing the exercise in minikube, in the deploy.sh and undeploy.sh comment the mariadb-pv.yml wordpress-pv.yml

```
cd ~/kubernetes-july-2025
git pull
cd Day4/wordpress
ls
./deploy.sh
```

Expected output
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/2a68d106-c5f9-49e1-bf89-651bc61ef896" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/393df17b-7168-48c8-b13b-f46b29183544" />

## Lab - Deploying multi-pod application ( Wordpress with Mariadb DB - Do this in minikube )
```
cd ~/kubernetes-july-2025
git pull
cd Day4/wordpress-with-configmaps-and-secrets
ls
./deploy.sh

kubectl get po
kubectl get svc
```
Expected output
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/20894b7c-2703-4011-9f46-2f5ecb71a68d" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/fd72adfb-f65c-4538-9631-ca2941cc1fcf" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/5d077986-9531-4883-abfe-1937b0aaf0fd" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/b0a906f5-975d-4caf-8319-67d5d46e7b61" />

## Lab - Ingress
First make sure ingress is enabled in your minikube

```
minikube addons enable ingress
minikube addons list
```

<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/4598fa5b-c948-4050-8e7f-c424feeac92b" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/d238d6e9-e1ee-4fc6-b8e1-46b37f210852" />

To enable LoadBalancer service, we need enable metallb 
```
minikube addons enable metallb
minikube addons configure metallb
# Enter Load Balancer Start IP: 192.168.49.100
# Enter Load Balancer Start IP: 192.168.49.150
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/cf921df2-a7ee-4e3c-bf31-ed71ebcd0174" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/a5a417ff-ded0-43a6-9546-e0cf94164936" />

Let's deploy two applications
```
kubectl create deploy nginx --image=nginx:latest --replicas=3
kubectl create deploy nginx --image=tektutor/hello-ms:1.0 --replicas=3

kubectl expose deploy/nginx --type=LoadBalancer --port=80
kubectl expose deploy/hello --type=LoadBalancer --port=8080

kubectl get svc
kubectl get svc
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/d28d6e94-fc33-4f6f-9d24-825bfbb40829" />

Let's create the ingress, ingress.yml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tektutor
  namespace: jegan
  annotations:
    kubernetes.io/ingress.class: haproxy 
spec:
  rules:
  - host: nginx.tektutor.org
    http:
      paths:
      - path: /nginx
        pathType: Prefix
        backend:
          service:
            name: nginx
            port:
              number: 80
      - path: /hello
        pathType: Prefix
        backend:
          service:
            name: hello 
            port:
              number: 8080
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/c5cc2fc6-6f04-424a-8d17-2da84d4b4b52" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/f2a6b13c-3f53-40f9-9107-5b4717284bf5" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/0cb16d35-a72b-4dde-ba10-85b4541e989f" />
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/763a7f6a-4ac7-4a92-8139-fa121beeb609" />


Let's apply
```
kubectl apply -f ingress.yml
```
<img width="1920" height="1168" alt="image" src="https://github.com/user-attachments/assets/7bcd884b-b0d1-46c6-9b3f-466b0e6a8223" />
