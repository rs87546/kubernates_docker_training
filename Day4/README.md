# Day 4

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


